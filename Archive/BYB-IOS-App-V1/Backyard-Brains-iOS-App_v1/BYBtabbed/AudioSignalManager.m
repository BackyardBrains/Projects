//
//  AudioSignalManager.m
//
//  Created by Alex Wiltschko on 9/26/09.
//  Modified by Zachary King:
//      6/6/2011 Added delegate and methods to automatically set the viewing frame.
//               Fixed a logic error in the moving average calculation.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "AudioSignalManager.h"
#import "math.h"
#import "Constants.h"
#define kOutputBus 0
#define kInputBus 1
#define eps 0.00001
#define PI 3.14159265359
#define kNumWaitFrames 5

void sessionPropertyListener(void *                  inClientData,
							 AudioSessionPropertyID  inID,
							 UInt32                  inDataSize,
							 const void *            inData){
	
	AudioSignalManager *asm = (AudioSignalManager *)inClientData;

	
	if (inID == kAudioSessionProperty_AudioRouteChange){
		UInt32 propertySize = sizeof(CFStringRef);
		CFStringRef route;
		AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
		
		// Uncomment if you want to force an override of the audio output route.
		// Not particularly recommended.
        //		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        //		AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
        //								 sizeof (audioRouteOverride),
        //								 &audioRouteOverride);
        
        //because play and record plays back through the top speaker to avoid
        //feedback from the mic! See checks below.
        
		NSString* routeStr = (NSString*)route;
		NSLog(@"AudioRoute: %@", routeStr);

        /* Known values of route:
         * "Headset"
         * "Headphone"
         * "Speaker"
         * "SpeakerAndMicrophone"
         * "HeadphonesAndMicrophone"
         * "HeadsetInOut"
         * "ReceiverAndMicrophone"
         * "Lineout"
         */
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        NSRange receiverRange = [routeStr rangeOfString : @"Receiver"];
        NSRange speakerRange = [routeStr rangeOfString : @"Speaker"];
        NSRange lineoutRange = [routeStr rangeOfString : @"Lineout"];
        
        if (headphoneRange.location != NSNotFound) {
            // Don't change the route if the headphone is plugged in.
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                     sizeof (audioRouteOverride),
                                     &audioRouteOverride);
            
        } else if(headsetRange.location != NSNotFound) {
            // Don't change the route if the headset is plugged in.
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                     sizeof (audioRouteOverride),
                                     &audioRouteOverride);
            
        } else if (receiverRange.location != NSNotFound) {
            // Change to play on the speaker
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                     sizeof (audioRouteOverride),
                                     &audioRouteOverride);
            
        } else if (speakerRange.location != NSNotFound) {
            // Make sure it's the speaker
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                     sizeof (audioRouteOverride),
                                     &audioRouteOverride);
            
        } else if (lineoutRange.location != NSNotFound) {
            // Don't change the route if the lineout is plugged in.
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                     sizeof (audioRouteOverride),
                                     &audioRouteOverride);
        } else {
            NSLog(@"Unknown audio route.");
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                     sizeof (audioRouteOverride),
                                     &audioRouteOverride);
        }
        

        
		UInt32 inputAvailable=0;
		UInt32 size = sizeof(inputAvailable);
		AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, 
								&size, 
								&inputAvailable);
		NSLog(@"Input available? %lu", inputAvailable);
		if ( inputAvailable ) {
			// Set the audio session category for simultaneous play and record
			if (asm.paused) {
				NSLog(@"YARRRRR ME MATEYYYYSSSS");
				NSLog(@"My callback: %lu", asm.myCallbackType);
				[asm ifAudioInputIsAvailableThenSetupAudioSessionWithCallbackType:asm.myCallbackType];
				//[asm play]; 
			}
		} else {
			// Just playback
			NSLog(@"PAUSE THIS SHIP");
			[asm pause];
		}

	}

}



//this listens to interuptions to the audio session, possible interuptions could be the phone ringing, the phone getting locked
//and im sure there are a few more
void sessionInterruptionListener(void *inClientData, UInt32 inInterruption) {

	//AudioSignalManager *asm = (AudioSignalManager *)inClientData;
	
	if (inInterruption == kAudioSessionBeginInterruption) {
		NSLog(@"begin interuption");		
    }
	else if (inInterruption == kAudioSessionEndInterruption) {
		NSLog(@"end interuption");	
	}	
}

UInt64 getTimeinNanoseconds() {
	mach_timebase_info_data_t info;
	mach_timebase_info(&info);
	return mach_absolute_time()*info.numer/info.denom;
}

# pragma mark - Detection functions
int findThresholdCrossing(SInt16 *firstStageBuffer, UInt32 inNumberFrames, float thresholdValue, BOOL triggerType)  {
	// If we're looking for an upward threshold crossing
	if (triggerType == YES) {
		for (int i=1; i < inNumberFrames; ++i) {
			// if a sample is above the threshold
			if (firstStageBuffer[i] > thresholdValue) {
				// and the last sample isn't...
				if (firstStageBuffer[i-1] < thresholdValue){
					// then we've found an upwards threshold crossing.
					return i;
				}
			}
		}
	}
	// If we're looking for a downwards threshold crossing
	else if (triggerType == NO) {
		for (int i=1; i < inNumberFrames; ++i) {
			// if a sample is below the threshold...
			if (firstStageBuffer[i] < thresholdValue) {
				// and the previous sample is...
				if (firstStageBuffer[i-1] > thresholdValue){
					// then we've found a downward threshold crossing.
					return i;
				}
			}
		}
	}
	// If we haven't returned anything by now, we haven't found anything.
	// So, we return -1.
	return -1;
	
}

#pragma mark Callbacks from Mic	

static OSStatus continuousDisplayOutputCallback(void *inRefCon, 
												AudioUnitRenderActionFlags *ioActionFlags, 
												const AudioTimeStamp *inTimeStamp, 
												UInt32 inBusNumber, 
												UInt32 inNumberFrames, 
												AudioBufferList *ioData) { 
	
	AudioSignalManager *asm			= (AudioSignalManager *)inRefCon;
	ringBuffer *secondStageBuffer	= asm.secondStageBuffer; // secondStageBuffer, our ringBuffer which will hold the audio samples
	AudioUnit au					= asm.outputAudioUnit; // the audio unit, which we'll use to grab samples

	AudioUnitRender(au, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
	SInt16 *incomingAudio = ioData->mBuffers[0].mData;
	
	UInt32 buffLen = secondStageBuffer->sizeOfBuffer - 1;
	UInt32 lastWrittenSample = secondStageBuffer->lastWrittenIndex;

	for (int i=0; i < inNumberFrames; ++i) {
		secondStageBuffer->data[(i + lastWrittenSample) & buffLen] = (GLfloat)incomingAudio[i];
	}
	
	secondStageBuffer->lastWrittenIndex += inNumberFrames;
	secondStageBuffer->lastWrittenIndex &= secondStageBuffer->sizeOfBuffer - 1;	

	return -1;
	
}


static OSStatus averageTriggerDisplayOutputCallback(void *inRefCon, 
											 AudioUnitRenderActionFlags *ioActionFlags, 
											 const AudioTimeStamp *inTimeStamp, 
											 UInt32 inBusNumber, 
											 UInt32 inNumberFrames, 
											 AudioBufferList *ioData) { 
	
	static int middlePoint = kNumPointsInTriggerBuffer/2;
	static BOOL haveAllAudio = YES;

	averageTriggerCallbackData *cd			= (averageTriggerCallbackData *)inRefCon;
	// Unpack the callback data
	AudioUnit au					= cd->au; // the audio unit, which we'll use to grab samples
	ringBuffer *secondStageBuffer	= cd->ssb; // secondStageBuffer, our ringBuffer which will hold the audio samples
	AudioSignalManager *asm			= cd->asm;
	triggeredSegmentHistory *th		= [asm triggerSegmentData];
	
//	UInt32 lastFreshSample = [asm lastFreshSample];
	UInt32 lastFreshSample;
	BOOL isTriggered = [asm triggered];
	
//	NSLog(@"Num segments in average %d, current segments %d, num total available segments %d", th->sizeOfMovingAverage, th->currentSegment, kNumSegmentsInTriggerAverage);
	
	
	// ******************************************************
	// ** Acquire audio
	// ******************************************************
	AudioUnitRender(au, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
	SInt16 *incomingAudio = ioData->mBuffers[0].mData;
	
	
	// ******************************************************
	// ** Keep a record of all previous audio
	// ******************************************************
	
	UInt32 buffLen = secondStageBuffer->sizeOfBuffer - 1;
	UInt32 lastWrittenSample = secondStageBuffer->lastWrittenIndex;
	
	for (int i=0; i < inNumberFrames; ++i) {
		secondStageBuffer->data[(i + lastWrittenSample) & buffLen] = (GLfloat)incomingAudio[i];
	}
	
	secondStageBuffer->lastWrittenIndex += inNumberFrames;
	secondStageBuffer->lastWrittenIndex &= secondStageBuffer->sizeOfBuffer - 1;
	

	// ******************************************************
	// ** Check for a threshold crossing in the new audio
	// ******************************************************
	if ( !isTriggered ) {
		
		int indexThresholdCrossing = findThresholdCrossing(incomingAudio, inNumberFrames, [asm thresholdValue], [asm triggerType]);
		
		if (indexThresholdCrossing != -1) { 
			NSLog(@"Crossing at %d... adding to %lu averages", indexThresholdCrossing, th->movingAverageIncrement);

			isTriggered = YES;
			haveAllAudio = NO;
			
			lastFreshSample = middlePoint - indexThresholdCrossing; // + inNumberFrames;
			UInt32 firstSampleRequested = secondStageBuffer->lastWrittenIndex - lastFreshSample - inNumberFrames;
			UInt32 buffLen = secondStageBuffer->sizeOfBuffer - 1;
			
			// Increment the current trigger segment ...
			th->currentSegment = (th->currentSegment+1) % kNumSegmentsInTriggerAverage;
			
//			NSLog(@"Segment ID: %d, lastFreshSample: %d, numTotalSamples %d", (th->currentSegment+1) % kNumSegmentsInTriggerAverage, lastFreshSample, kNumPointsInTriggerBuffer);
			
			// ... and fill it up with the triggered audio
			for (int i=0; i < lastFreshSample; ++i) {
				th->triggeredSegments[th->currentSegment][i] = secondStageBuffer->data[(i + firstSampleRequested) & buffLen];
			}
			
			th->lastReadSample[th->currentSegment] = lastFreshSample;
			th->lastWrittenSample[th->currentSegment] = 0;
            
            //increment the moving average until it reaches the desired number
            if (th->movingAverageIncrement < th->sizeOfMovingAverage)
                ++th->movingAverageIncrement;
		}
		
	}

	// ******************************************************
	// ** Fill in the audio for the triggered segments
	// ******************************************************
	if (!haveAllAudio) {
		BOOL needMoreAudio;
		UInt32 i, numSamplesLeft, numSamplesNeeded, idx;
		for (i=0; i<kNumSegmentsInTriggerAverage; ++i) { // for every saved triggered segment
			
			idx = (th->currentSegment+i) % kNumSegmentsInTriggerAverage;
			needMoreAudio = th->lastReadSample[idx] < (kNumPointsInTriggerBuffer-1); // check if it's a full buffer
			
			if (needMoreAudio) {
				numSamplesLeft = kNumPointsInTriggerBuffer - th->lastReadSample[idx];
				numSamplesNeeded = (numSamplesLeft < inNumberFrames)?numSamplesLeft:inNumberFrames;
				
				memcpy(&th->triggeredSegments[idx][th->lastReadSample[idx]], incomingAudio, numSamplesNeeded*sizeof(SInt16));
				
				th->lastReadSample[idx] += numSamplesNeeded;
				
			}
		}
		
		// Check specifically the current segment if it's full of audio. If it's full, then we can release the trigger.
		if (th->lastReadSample[th->currentSegment] > (kNumPointsInTriggerBuffer-1)) {
			haveAllAudio = YES;
			isTriggered = NO; // this should be reset within [triggerView drawView] well beforehand.	
		}
		
	}
	
	
	
	// the property lastFreshSample is used by [triggerView drawView] to release
	// the trigger if all _displayed_ audio has been acquired. 
	// If all we had was lastFreshSample, we'd never acquire audio that was offscreen.
	// This is why we also have haveAllAudio, so that we can release the trigger and
	// also continue to fill up our buffers
	asm.lastFreshSample = th->lastReadSample[th->currentSegment]; 
	asm.triggered = isTriggered;
	
	return -1;
	
}


static OSStatus singleShotTriggerCallback(void *inRefCon, 
										  AudioUnitRenderActionFlags *ioActionFlags, 
										  const AudioTimeStamp *inTimeStamp, 
										  UInt32 inBusNumber, 
										  UInt32 inNumberFrames, 
										  AudioBufferList *ioData) {  
	

	
	static int middlePoint = kNumPointsInTriggerBuffer/2;
	static BOOL haveAllAudio = NO;
	
	singleShotTriggerCallbackData *cd	= (singleShotTriggerCallbackData *)inRefCon;
	// Unpack the callback data
	AudioUnit au					= cd->au; // the audio unit, which we'll use to grab samples
	ringBuffer *secondStageBuffer	= cd->ssb; // secondStageBuffer, our ringBuffer which will hold the audio samples
	AudioSignalManager *asm			= cd->asm;
	struct wave_s *vertexBuffer		= [asm vertexBuffer]; //cd->vb;
	
	UInt32 lastFreshSample = [asm lastFreshSample];
	BOOL isTriggered = [asm triggered];
		
	
	// ******************************************************
	// ** Acquire audio
	// ******************************************************
	AudioUnitRender(au, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
	SInt16 *incomingAudio = ioData->mBuffers[0].mData;
	
	
	// ******************************************************
	// ** Keep a record of all previous audio
	// ******************************************************
	
	UInt32 buffLen = secondStageBuffer->sizeOfBuffer - 1;
	UInt32 lastWrittenSample = secondStageBuffer->lastWrittenIndex;
	
	for (int i=0; i < inNumberFrames; ++i) {
		secondStageBuffer->data[(i + lastWrittenSample) & buffLen] = (GLfloat)incomingAudio[i];
	}
	
	secondStageBuffer->lastWrittenIndex += inNumberFrames;
	secondStageBuffer->lastWrittenIndex &= secondStageBuffer->sizeOfBuffer - 1;
	
	
	// ******************************************************
	// ** Check for a threshold crossing in the new audio
	// ******************************************************
	if ( !isTriggered ) {
		
		int indexThresholdCrossing = findThresholdCrossing(incomingAudio, inNumberFrames, [asm thresholdValue], [asm triggerType]);
		if (indexThresholdCrossing != -1) { 
			NSLog(@"Crossing at %d", indexThresholdCrossing);
			
			isTriggered = YES;
			haveAllAudio = NO;
			
			lastFreshSample = middlePoint - indexThresholdCrossing + inNumberFrames;
			UInt32 firstSampleRequested = secondStageBuffer->lastWrittenIndex - lastFreshSample;
			UInt32 buffLen = secondStageBuffer->sizeOfBuffer - 1;
						
			for (int i=0; i < lastFreshSample; ++i) {
				vertexBuffer[i].y = secondStageBuffer->data[(i + firstSampleRequested) & buffLen];
			}
			
			asm.lastFreshSample = lastFreshSample;
			asm.triggered = isTriggered;		
			return noErr;
		}
	}
	
	// ******************************************************
	// ** If we've already triggered, fill in more audio
	// ******************************************************
	if (!haveAllAudio) {
					
		BOOL needMoreAudio = lastFreshSample < (kNumPointsInVertexBuffer-1); // check if the vertex buffer is full
		
		if (needMoreAudio) {
			
			UInt32 numSamplesLeft = kNumPointsInVertexBuffer - lastFreshSample;
			UInt32 numSamplesNeeded = (numSamplesLeft < inNumberFrames)?numSamplesLeft:inNumberFrames;
			
			for (int i=0; i<numSamplesNeeded; ++i) {
				vertexBuffer[lastFreshSample+i].y = incomingAudio[i];
			}
			
			lastFreshSample += numSamplesNeeded;
			
		}
		
		if (lastFreshSample > (kNumPointsInVertexBuffer - 1)) {
			haveAllAudio = YES;
			isTriggered = YES;
		}
		
	}
	
		
	// the property lastFreshSample is used by [triggerView drawView] to release
	// the trigger if all _displayed_ audio has been acquired. 
	// If all we had was lastFreshSample, we'd never acquire audio that was offscreen.
	// This is why we also have haveAllAudio, so that we can release the trigger and
	// also continue to fill up our buffers
	asm.lastFreshSample = lastFreshSample;
	asm.triggered = isTriggered;
	
	NSLog(@"Playing thru? %d", asm.playThroughEnabled);
	
	if (!asm.playThroughEnabled) {
		for (int i=0; i < ioData->mNumberBuffers; ++i) {
			memset(ioData->mBuffers[i].mData, 0, ioData->mBuffers[i].mDataByteSize);
		}
	}
	
	
	return noErr;

}


# pragma mark - Obj-C Meatyness

@implementation AudioSignalManager

@synthesize outputAudioUnit;

@synthesize firstStageBuffer;
@synthesize secondStageBuffer;
@synthesize triggerSegmentData;

@synthesize auBufferList;
@synthesize lastTime;

@synthesize triggering;
@synthesize triggered;
@synthesize triggerType;
@synthesize thresholdValue;
@synthesize lastFreshSample;
@synthesize numSamplesJustAcquired;

@synthesize firstSampleBeingViewed;
@synthesize numSamplesBeingViewed;

@synthesize playThroughEnabled;


@synthesize hasAudioInput;
@synthesize myCallbackType;

@synthesize nTrigWaitFrames;

@synthesize isStimulating;
@synthesize uninitialized;

# pragma mark - Initialization

- (id)init {
	
	self = [super init];
	if (self != nil) {
		NSLog(@"Initializing the audio unit with the default callbackType, for continuous readout");
		[self initWithCallbackType:kAudioCallbackContinuous];		
	}
	
	return self;
}

- (id) initWithCallbackType:(UInt32)callbackType
{
	
	hasAudioInput = NO; // we'll assume we don't have audio at first.
	self.myCallbackType = callbackType;
		
	self = [super init];
	if (self != nil) {
		//first of all setup the adusio session, has nothing to do with understanding the audio graph,
		//but does set the latency and the listeners.
		
		self.firstStageBuffer	= (SInt16 *)malloc(kNumPointsInFirstBuffer*sizeof(SInt16));
		self.secondStageBuffer	= (ringBuffer *)calloc(1, sizeof(ringBuffer));
		self.secondStageBuffer->sizeOfBuffer = kNumPointsInWave;
		self.secondStageBuffer->lastWrittenIndex = 0;
		self.vertexBuffer		= (struct wave_s *)malloc(kNumPointsInVertexBuffer*sizeof(struct wave_s));

		self.triggerSegmentData = (triggeredSegmentHistory *)calloc(1, sizeof(triggeredSegmentHistory));
		self.triggerSegmentData->sizeOfMovingAverage = 1;
        self.triggerSegmentData->movingAverageIncrement = 1;
		self.triggerSegmentData->currentSegment = 0; // let's just be explicit.
		
		self.triggering = NO;
		self.triggerType = YES;

		self.thresholdValue = 250;
		
        self.nWaitFrames = 0;
        self.nTrigWaitFrames = 0;
        
        self.isStimulating = NO;
        self.uninitialized = YES;;
		
		// Grab the gain from the NSUserDefaults THINGYYY
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		NSNumber *gainValue;
		if ((gainValue = [defaults valueForKey:@"gain"])) {
			self.gain = [gainValue floatValue];
		}
		else {
			self.gain = 1.0f;
		}
        
		
		NSNumber *samplingRateValue;
		NSLog(@"==== DEFAULT SAMPLINGRATE: %@", [defaults valueForKey:@"samplerate"]);
		NSLog(@"==== DEFAULT GAIN: %@", [defaults valueForKey:@"gain"]);
        NSLog(@"==== GAIN IN USE: %f", self.gain);
		
		
		if ((samplingRateValue = [defaults valueForKey:@"samplerate"])) {
			self.samplingRate = (Float64)[samplingRateValue floatValue];
			NSLog(@"Samplingrate = %f", self.samplingRate);
		}
		else {
			self.samplingRate = 44100.0f;	
		}

		// Grab the sampling rate from NSUserDefaults
		NSLog(@"==== DEFAULT SAMPLINGRATE NOW: %f", samplingRate);
		
		playThroughEnabled = NO;
		
		
		[self ifAudioInputIsAvailableThenSetupAudioSessionWithCallbackType:self.myCallbackType];
		

		
	}
	return self;
}



- (void)ifAudioInputIsAvailableThenSetupAudioSessionWithCallbackType:(UInt32)callbackType {
	
    self.uninitialized = NO;
    
	// Initialize and configure the audio session, and add an interuption listener
    AudioSessionInitialize(NULL, NULL, sessionInterruptionListener, self);
	
	// is audio input available?
	UInt32 ui32PropertySize = sizeof (UInt32);
	UInt32 inputAvailable;
	OSStatus setupErr = 	AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable,
													&ui32PropertySize,
													&inputAvailable);
	NSLog(@"setupErr: %ld", setupErr);
	NSAssert(setupErr == noErr, @"Could not ask if there was audio input available");
	
	
	 NSLog (@"audio input is %@", (inputAvailable ? @"available" : @"not available"));
	if (!inputAvailable) {
		
		hasAudioInput = NO;
		
		UIAlertView *noInputAlert =
		[[UIAlertView alloc] initWithTitle:@"No Audio Input"
								   message:@"Couldn't find any audio input. Plug in your Apple headphones or another microphone."
								  delegate:self
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		
		[noInputAlert show];
		[noInputAlert release];
		
	}
	else {
		hasAudioInput = YES;
		[self setupAudioSession:callbackType];
		//[self play];
	}
	
}

-(void)setupAudioSession:(UInt32)callbackType {
	
	OSStatus err = noErr;
	
	// Initialize and configure the audio session, and add an interuption listener
    AudioSessionInitialize(NULL, NULL, sessionInterruptionListener, self);

	
	UInt32 inputAvailable=0;
	UInt32 size = sizeof(inputAvailable);
	AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, 
							&size, 
							&inputAvailable);
	UInt32 sessionCategory;
	if ( inputAvailable ) {
		// Set the audio session category for simultaneous play and record
		sessionCategory = kAudioSessionCategory_PlayAndRecord;
	} else {
		// Just playback
		sessionCategory = kAudioSessionCategory_MediaPlayback;
	}
	
	err = AudioSessionSetProperty (kAudioSessionProperty_AudioCategory,
									  sizeof (sessionCategory),
									  &sessionCategory);    
	NSLog(@"Set audio category. Err: %ld", err);
	

	// Allow iPod audio to continue to play while the app is active.
//	UInt32 flag = 1;
//	AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(flag), &flag);
	
	//add a property listener, to listen to changes to the session
	AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, sessionPropertyListener, self);
	
	//set the buffer size, this will affect the number of samples that get rendered every time the audio callback is fired
	//a small number will get you lower latency audio, but will make your processor work harder
	Float32 preferredBufferSize = 0.005;
	AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(preferredBufferSize), &preferredBufferSize);
	
//	UInt32 doChangeDefaultRoute = 1;
//	AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
//							 sizeof(doChangeDefaultRoute),
//							 &doChangeDefaultRoute);
	
	
	// For iPhone OS 3.1!
	/*
	UInt32 allowBluetoothInput = 1;
	AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryEnableBluetoothInput,
							 sizeof(allowBluetoothInput),
							 &allowBluetoothInput);
	*/
	
	//set the audio session active
	AudioSessionSetActive(YES);
	

	//first describe the node, graphs are made up of nodes connected together, in this graph there is only one node.
	//the descriptions for the components
	AudioComponentDescription outputDescription;	
	
	//describe the node, this is our output node it is of type remoteIO
	outputDescription.componentFlags = 0;
	outputDescription.componentFlagsMask = 0;
	outputDescription.componentType = kAudioUnitType_Output;
	outputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	outputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;

	// Get component
	AudioComponent outputComponent = AudioComponentFindNext(NULL, &outputDescription);
	// Get audio units
	err = AudioComponentInstanceNew(outputComponent, &outputAudioUnit);
	NSAssert(err == noErr, @"Could not create audio unit");
		
		/*
                         -------------------------
                         | i                   o |
-- BUS 1 -- from mic --> | n    REMOTE I/O     u | -- BUS 1 -- to app -->
                         | p      AUDIO        t |
-- BUS 0 -- from app --> | u       UNIT        p | -- BUS 0 -- to speaker -->	
                         | t                   u |	
                         |                     t |
                         -------------------------
	*/

	// Enable IO
	UInt32 one = 1;
	err = AudioUnitSetProperty(self.outputAudioUnit, 
							   kAudioOutputUnitProperty_EnableIO, 
							   kAudioUnitScope_Input, 
							   kInputBus, 
							   &one, 
							   sizeof(one));
	NSAssert(err == noErr, @"Could not enable the Input Scope of Bus 1");
	
//	err = AudioUnitSetProperty(outputAudioUnit, 
//							   kAudioOutputUnitProperty_EnableIO, 
//							   kAudioUnitScope_Output, 
//							   kOutputBus, 
//							   &one, 
//							   sizeof(one));
	NSAssert(err == noErr, @"Could not enable the Output Scope of Bus 0");

	
	
	
	//lets actually set the audio format
	AudioStreamBasicDescription audioFormat;
	memset (&audioFormat, 0, sizeof(audioFormat));
	
	// Describe format
	audioFormat.mSampleRate			= (Float64)self.samplingRate;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagsCanonical;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 1;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 2;
	audioFormat.mBytesPerFrame		= 2;
	
	err = AudioUnitSetProperty(self.outputAudioUnit, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Output, 
							   kInputBus, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting Output Scope for Bus 1 (from microphone to app)");
	
	err = AudioUnitSetProperty(self.outputAudioUnit, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   kOutputBus, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting Input Scope for Bus 0 (from app to mic)");
		

	// Check that we properly set the sampling rate
	Float64 outSampleRate = 0.0;
	size = sizeof(Float64);
	AudioUnitGetProperty (self.outputAudioUnit,
						  kAudioUnitProperty_SampleRate,
						  kAudioUnitScope_Output,
						  kInputBus,
						  &outSampleRate,
						  &size);
	NSLog(@"===== Output sample rate is now at %f Hz, originally wanted %f", outSampleRate, (Float64)samplingRate);
	
	
	
	
	// Now set up the input callback
	AURenderCallbackStruct playbackCallbackStruct;
	switch (callbackType) {
		case kAudioCallbackContinuous:
			playbackCallbackStruct.inputProc = continuousDisplayOutputCallback;
			playbackCallbackStruct.inputProcRefCon = self;
			break;
		case kAudioCallbackSingleShotTrigger:
			playbackCallbackStruct.inputProc = singleShotTriggerCallback;
			singleShotTriggerCallbackData *sd = (singleShotTriggerCallbackData *)malloc(sizeof(singleShotTriggerCallbackData));
			sd->au = self.outputAudioUnit;
			sd->ssb = self.secondStageBuffer;
			sd->vb = self.vertexBuffer;
			sd->asm = self;
			playbackCallbackStruct.inputProcRefCon = sd;
			break;
		case kAudioCallbackAverageTrigger:
			playbackCallbackStruct.inputProc = averageTriggerDisplayOutputCallback;
			averageTriggerCallbackData *td = (averageTriggerCallbackData *)malloc(sizeof(averageTriggerCallbackData));
			td->au = self.outputAudioUnit;
			td->ssb = self.secondStageBuffer;
			td->vb = self.vertexBuffer;
			td->asm = self;
			td->th = self.triggerSegmentData;
			playbackCallbackStruct.inputProcRefCon = td;
			break;
		default: // default to continuous readout
			break;
	}
	
//	err = AudioUnitSetProperty(outputAudioUnit, 
//							   kAudioOutputUnitProperty_SetInputCallback, 
//							   kAudioUnitScope_Global,
//							   kInputBus, 
//							   &playbackCallbackStruct, 
//							   sizeof(playbackCallbackStruct));
//	NSAssert(err == noErr, @"Setting input callback failed");

	err = AudioUnitSetProperty(outputAudioUnit, 
							   kAudioUnitProperty_SetRenderCallback, 
							   kAudioUnitScope_Output,
							   kOutputBus, 
							   &playbackCallbackStruct, 
							   sizeof(playbackCallbackStruct));
	NSAssert(err == noErr, @"Setting input callback failed");
		
	
	// Set up the play-through callback
	// CANT GET THIS TO WORK PROPERLY
//	AURenderCallbackStruct playThruCallbackStruct;
//	playThruCallbackStruct.inputProc = playThruRenderCallback;
//	playThruCallbackData *pd = (playThruCallbackData *)malloc(sizeof(playThruCallbackData));
//	pd->asm = self;
//
//	playThruCallbackStruct.inputProcRefCon = pd;
//	
//	err = AudioUnitSetProperty(outputAudioUnit, 
//							  kAudioUnitProperty_SetRenderCallback, 
//							  kAudioUnitScope_Global, 
//							  kOutputBus,
//							  &playThruCallbackStruct,   
//							  sizeof(playThruCallbackStruct));

	
	

	err = AudioUnitInitialize(outputAudioUnit);
	

	NSLog(@"err = %ld", err);

	
//	
//	NSAssert(err == noErr, @"Could not initialize audio unit");
	
	paused = YES;
	playThroughEnabled = NO;
	
	
	NSLog(@"Audio Unit initialized");
}

- (void)changeCallbackTo:(int)callbackType {
	
	if (!hasAudioInput) {
		return;
	}
	
	[self pause];
	
	// Zero out the vertexBuffer
	for (int i=0; i < kNumPointsInVertexBuffer; ++i) {
		vertexBuffer[i].y = 0.0;
	}
	
	// Now set up the input callback
	AURenderCallbackStruct playbackCallbackStruct;
	switch (callbackType) {
		case kAudioCallbackContinuous:
			playbackCallbackStruct.inputProc = continuousDisplayOutputCallback;
			playbackCallbackStruct.inputProcRefCon = self;
			break;
		case kAudioCallbackSingleShotTrigger:
			playbackCallbackStruct.inputProc = singleShotTriggerCallback;
			singleShotTriggerCallbackData *sd = (singleShotTriggerCallbackData *)malloc(sizeof(singleShotTriggerCallbackData));
			sd->au = outputAudioUnit;
			sd->ssb = secondStageBuffer;
			sd->vb = vertexBuffer;
			sd->asm = self;
			playbackCallbackStruct.inputProcRefCon = sd;
			break;
		case kAudioCallbackAverageTrigger:
			playbackCallbackStruct.inputProc = averageTriggerDisplayOutputCallback;
			averageTriggerCallbackData *td = (averageTriggerCallbackData *)malloc(sizeof(averageTriggerCallbackData));
			td->au = outputAudioUnit;
			td->ssb = secondStageBuffer;
			td->vb = vertexBuffer;
			td->asm = self;
			td->th = triggerSegmentData;
			playbackCallbackStruct.inputProcRefCon = td;		
			break;
		default: // default to continuous readout
			break;
	}
	
//	OSStatus err = AudioUnitSetProperty(outputAudioUnit, 
//							   kAudioOutputUnitProperty_SetInputCallback, 
//							   kAudioUnitScope_Global,
//							   kInputBus, 
//							   &playbackCallbackStruct, 
//							   sizeof(playbackCallbackStruct));
//	NSAssert(err == noErr, @"Setting input callback failed");
	
	OSStatus err = AudioUnitSetProperty(outputAudioUnit, 
							   kAudioUnitProperty_SetRenderCallback, 
							   kAudioUnitScope_Output,
							   kOutputBus, 
							   &playbackCallbackStruct, 
							   sizeof(playbackCallbackStruct));
    NSAssert(err == noErr, @"Setting render callback failed");

	self.myCallbackType = callbackType;
	//[self play];
	

	
}

- (void)togglePlaythru {
	playThroughEnabled = !playThroughEnabled;
	return;
}


#pragma mark - Newer, fancier ring buffer filling functions

- (void)fillVertexBufferWithAverageTriggeredSegments {
	
//	static GLfloat normfactor = 0.0;
	

	 
	triggeredSegmentHistory *th = self.triggerSegmentData;
//		normfactor += (normfactor < th->sizeOfMovingAverage)?1.0f:0.0f;
	int normfactor = th->movingAverageIncrement; //sizeOfMovingAverage;
	
	UInt32 newestIdx = (th->currentSegment);
	UInt32 oldestIdx = (th->currentSegment - th->movingAverageIncrement) % kNumSegmentsInTriggerAverage;
		
	UInt32 idx;
	UInt32 lastWrit;
	UInt32 lastRead;
	
	// Tqke out the oldest stuff
	for (int i=0; i < th->lastWrittenSample[oldestIdx]; ++i) {
		vertexBuffer[i].y -= (GLfloat)th->triggeredSegments[oldestIdx][i]/normfactor;
	}
	th->lastWrittenSample[oldestIdx] = 0;
	th->lastReadSample[oldestIdx] = 0; 
	
	
	// Add in the newest stuff
	for (int i=0; i < th->movingAverageIncrement; ++i) {
		idx = (newestIdx - i) % kNumSegmentsInTriggerAverage;
		lastWrit = th->lastWrittenSample[idx];
		lastRead = th->lastReadSample[idx];
		if (lastWrit < lastRead) {
			for (int j = lastWrit; j < lastRead; ++j) {
				vertexBuffer[j].y += (GLfloat)th->triggeredSegments[idx][j]/normfactor;
			}
			th->lastWrittenSample[idx] = lastRead;

		}
		
	}
    
	
    //After kNumWaitFrames (5) buffers are filled, tell view controller to autoset its frame 
    if (self.nTrigWaitFrames < kNumWaitFrames)
    {
        self.nTrigWaitFrames += 1;
    }
    else if (self.nTrigWaitFrames == kNumWaitFrames)
    {
        [self.delegate shouldAutoSetFrame];
        self.nTrigWaitFrames += 1;
    }
}

- (void)fillVertexBufferWithAudioData {
	if (![self paused] & ![self triggering]) {
		
		UInt32 firstSampleRequested = secondStageBuffer->lastWrittenIndex - kNumPointsInVertexBuffer;
		UInt32 buffLen = secondStageBuffer->sizeOfBuffer - 1;
		
        //int numNonzeroSamples = 0;
        //BOOL didSetFrameRequest = NO;
		for (int i=0; i < kNumPointsInVertexBuffer; ++i) {
			vertexBuffer[i].y = secondStageBuffer->data[(i + firstSampleRequested) & buffLen];
		}
        
        
        //After kNumWaitFrames (5) buffers are filled, tell view controller to autoset its frame 
        if (self.nWaitFrames < kNumWaitFrames)
        {
            self.nWaitFrames += 1;
        }
        else if (self.nWaitFrames == kNumWaitFrames)
        {
            [self.delegate shouldAutoSetFrame];
            self.nWaitFrames += 1;
        }
        
	}
}

# pragma mark - Play & Pause controls

- (void)pause {
	
	if (!paused) {
		OSStatus err = AudioOutputUnitStop(self.outputAudioUnit);
        NSLog(@"err = %ld", err);
		paused = YES;
	}

}

- (void)play {
	NSLog(@"Paused? %d", self.paused);
	
    if (self.uninitialized) {
        [self ifAudioInputIsAvailableThenSetupAudioSessionWithCallbackType:self.myCallbackType];
    }
    
	UInt32 inputAvailable=0;
	UInt32 size = sizeof(inputAvailable);
	AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, 
							&size, 
							&inputAvailable);
	if ( inputAvailable ) {
		// Set the audio session category for simultaneous play and record
		if (paused) {
			OSStatus err = AudioOutputUnitStart(self.outputAudioUnit);
			NSLog(@"err = %ld", err);			
			paused = NO;
		}
	}
}

- (void)stopAudioUnit
{
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, sessionPropertyListener, self);
    self.uninitialized = YES;
}


- (void)pauseplay {
	// Convenience function to toggle pausing
	if (paused) { 
		[self play];
		return;
	}
	else if (!paused) { 
		[self pause]; 
		return;
	}
	
}




#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self ifAudioInputIsAvailableThenSetupAudioSessionWithCallbackType:myCallbackType];
}


#pragma mark - The End
- (void)dealloc {
	//i am not sure if all of these steps are neccessary. or if you just call DisposeAUGraph
	// TODO: stop audio unit and deallocate it in the dealloc method...
    [super dealloc];
    //tk have we released the asm properties?
}


@end