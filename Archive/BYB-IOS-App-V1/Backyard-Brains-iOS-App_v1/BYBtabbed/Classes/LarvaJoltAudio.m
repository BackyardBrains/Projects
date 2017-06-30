//
//  LarvaJoltAudio.m
//  LarvaJolt
//
//  Created by Zachary King on 1/29/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//
//Adapted from:
//  Created by Matt Gallagher on 2010/10/20.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.


#import "LarvaJoltAudio.h"
#import "Backyard_BrainsAppDelegate.h"

// Audio Unit render callback function
static OSStatus RenderTone(
                           void						*inRefCon,		//programmatic context
                           AudioUnitRenderActionFlags 	*ioActionFlags, //can hint that there is no audio playing
                           const AudioTimeStamp 		*inTimeStamp,	//time at which callback was invoked
                           UInt32 						inBusNumber,	//audio unit bus that invoked callback
                           UInt32 						inNumberFrames, //number of audio frames being requested
                           AudioBufferList 			*ioData			//audio data buffers that must be filled
                           )

{
	// Get the tone parameters out of the view controller
	LarvaJoltAudio *lja = (LarvaJoltAudio *)inRefCon;
	
    
    // This is a mono tone generator so we only need the first buffer
    const int channel = 0;
    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
    
    
    double frequency = lja->_frequency;
    double outputFrequency = lja->_outputFreq;
    double amplitude = lja->_amplitude;
    double sampleRate = lja->_sampleRate;
    double theta = lja->_theta;
    double calibA = lja->_calibA;
    double calibB = lja->_calibB;
    double calibC = lja->_calibC;
    
    if (lja->_isSquarePulse) //PULSE -- 1ms sine wave 
    {
        
        double pulseProgress = lja->_pulseProgress;	//progress in pulse from 0.0 - 1.0
        double dutyCycleInput = lja->_dutyCycle;
        
        // Generate the samples
        for (UInt32 frame = 0; frame < inNumberFrames; frame++)
        {
            // Model a biphasic pulse with first, positive pulse at pulseProgress = 0.0 and interpulse gap = 0
            if ( (pulseProgress >= 0) && (pulseProgress < dutyCycleInput) ) {
                buffer[frame] = sin(theta)*amplitude;
            } else {
                buffer[frame] = 0;
            }
            
            pulseProgress += (1 / sampleRate * frequency);
            if (pulseProgress > 1.0)
            {
                pulseProgress -= 1.0;
            }
            
            theta += (2 * M_PI / sampleRate * outputFrequency);
            if (theta > 2 * M_PI)
            {
                theta -= 2 * M_PI;
            }
            
            
            // Store the theta back in the view controller
            lja->_pulseProgress = pulseProgress;
            lja->_theta = theta;
        }

    }
    else if (frequency==0) //TONE -- sine wave
    {
        // Generate the samples
        for (UInt32 frame = 0; frame < inNumberFrames; frame++)
        {
            buffer[frame] = sin(theta)*amplitude;
            
            theta += (2 * M_PI / sampleRate * outputFrequency);
            if (theta > 2 * M_PI)
            {
                theta -= 2 * M_PI;
            }
            
            // Store the theta back in the view controller
            lja->_theta = theta;
            
        }
    }
    else //OPTICAL -- sine wave pulses
    {
        
        double pulseProgress = lja->_pulseProgress;	//progress in pulse from 0.0 - 1.0
        double dutyCycleInput = lja->_dutyCycle;
        
        //6.12 optimization parameters
        //#define c1 1.88
        //#define c2 0.387
        //#define c3 0.00532
        // Adjustment for circuit-specific delay:
        double pwi = dutyCycleInput/frequency;
        double pwo = calibA*pow(pwi,2) + calibB*pwi + calibC;
        double dutyCycle = pwo*frequency;
        //NSLog(@"Duty cycle in: %f, duty cycle out: %f", dutyCycleInput, dutyCycle);
        
        // Generate the samples
        for (UInt32 frame = 0; frame < inNumberFrames; frame++)
        {
            // Model a biphasic pulse with first, positive pulse at pulseProgress = 0.0 and interpulse gap = 0
            if ( (pulseProgress >= 0) && (pulseProgress < dutyCycle) ) {
                buffer[frame] = sin(theta)*amplitude;
            } else {
                buffer[frame] = 0;
            }
            
            pulseProgress += (1 / sampleRate * frequency);
            if (pulseProgress > 1.0)
            {
                pulseProgress -= 1.0;
            }
            
            theta += (2 * M_PI / sampleRate * outputFrequency);
            if (theta > 2 * M_PI)
            {
                theta -= 2 * M_PI;
            }
            
            
            // Store the theta back in the view controller
            lja->_pulseProgress = pulseProgress;
            lja->_theta = theta;
            
        }
    }
    
    
	return noErr;
    
}



void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	LarvaJoltAudio *lja = (LarvaJoltAudio *)inClientData;
	
	[lja stopPulse];
}





@implementation LarvaJoltAudio

@synthesize delegate        = _delegate;
@synthesize toneUnit        = _toneUnit;
@synthesize dutyCycle       = _dutyCycle;
@synthesize frequency       = _frequency;
@synthesize amplitude       = _amplitude;
@synthesize pulseTime       = _pulseTime;
@synthesize sampleRate      = _sampleRate;
@synthesize pulseProgress   = _pulseProgress;
@synthesize trainDelay      = _trainDelay;
@synthesize isSquarePulse   = _isSquarePulse;
@synthesize theta           = _theta;
@synthesize outputFreq      = _outputFreq;
@synthesize ledFreq         = _ledFreq;
@synthesize playing         = _playing;
@dynamic songSelected;
@synthesize timer           = _timer;
@synthesize calibA          = _calibA;
@synthesize calibB          = _calibB;
@synthesize calibC          = _calibC;
@synthesize playlist        = _playlist;
@synthesize songNowPlaying  = _songNowPlaying;
@synthesize appMusicPlayer  = _appMusicPlayer;


#define defaultSampleRate 44100.0 //Hz
#define defaultDutyCycle 0.5
#define defaultFrequency 1000 //Hz. Period = 1ms
#define defaultAmplitude 1.00 //units?
#define defaultOutputFreq 1000 //Hz
#define defaultLedFreq 10000 //Hz
#define defaultPulseTime 100 //s
#define defaultCalibA 0
#define defaultCalibB 1
#define defaultCalibC 0

// Designated initializer to set critical parameters
- (id)init //WithDictionary:(NSDictionary *)dictionary
{
    
	if ((self = [super init])) {
		self.sampleRate = defaultSampleRate; // Hertz
		
		//look for values in the dictionary for pulse parameters
		//if they can't be found, use defaults:
		self.dutyCycle		= defaultDutyCycle;  //ON if dutyCycle = 1
		self.frequency		= defaultFrequency; 
		self.amplitude		= defaultAmplitude;		
        self.pulseTime      = defaultPulseTime;
        self.pulseProgress = 0;
        self.theta = 0;
        self.outputFreq = defaultOutputFreq;
        self.ledFreq = defaultLedFreq;
        self.calibA = defaultCalibA;
        self.calibB = defaultCalibB;
        self.calibC = defaultCalibC;
        self.isSquarePulse = NO;
        self.appMusicPlayer = nil;
        NSLog(@"pulse initialized.");
        
	}
	return self;
}



- (void)playPulse
{
    if (self.songSelected) {
        
        if (self.playlist.count==0) {
            return;
        }
        
        if (self.appMusicPlayer==nil) {
            self.appMusicPlayer =
                [MPMusicPlayerController applicationMusicPlayer];
        }
        
        //make sure audiosignalmanager is stopped
        Backyard_BrainsAppDelegate *app = (Backyard_BrainsAppDelegate *)[[UIApplication sharedApplication] delegate];
        AudioSignalManager *theAsm = (AudioSignalManager *)app.drawingDataManager;
        if ([theAsm respondsToSelector:@selector(stopAudioUnit)])
            [theAsm stopAudioUnit];
            
        [self.appMusicPlayer setShuffleMode: MPMusicShuffleModeOff];
        [self.appMusicPlayer setRepeatMode: MPMusicRepeatModeNone];
        [self.appMusicPlayer setQueueWithItemCollection:self.playlist];
        [self.appMusicPlayer setNowPlayingItem:[self.playlist.items objectAtIndex:self.songNowPlaying]];
        [self.appMusicPlayer play];
        
        self.playing = YES;
        [self.delegate pulseIsPlaying];
    }
    else
    {
        if (!self.toneUnit)
        {
            //create timer
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pulseTime
                                                          target:self
                                                        selector:@selector(stopPulse)
                                                        userInfo:nil
                                                         repeats:NO];
            
            [self createToneUnit];
            
            self.pulseProgress = 0;
            self.theta = 0;
            
            // Stop changing parameters on the unit
            OSErr err = AudioUnitInitialize(self.toneUnit);
            NSAssert1(err == noErr, @"Error initializing unit: %ld", err);
            
            // Start playback
            err = AudioOutputUnitStart(self.toneUnit);
            NSAssert1(err == noErr, @"Error starting unit: %ld", err);
            
            
            self.playing = YES;
            [self.delegate pulseIsPlaying];
        }
    }
}

- (void)stopPulse
{
    NSLog(@"Stopping pulse");
    
    if (self.songSelected) 
    {
        [self.appMusicPlayer pause];
    }
    else if (self.toneUnit)
    {
            AudioOutputUnitStop(self.toneUnit);
            AudioUnitUninitialize(self.toneUnit);
            AudioComponentInstanceDispose(self.toneUnit);
            self.toneUnit = nil;
    }
        
    self.playing = NO;
    [self.delegate pulseIsStopped];
    [self.timer invalidate];
    
    
}

- (void)setSongSelected:(BOOL)theSong
{
    _songSelected = theSong;
    if (self.playing)
        [self stopPulse];
}

- (BOOL)songSelected
{
    return _songSelected;
}



- (void)createToneUnit
{
	NSLog(@"creating tone unit");
	// Configure the search parameters to find the default playback output unit
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(
                                                          NULL, 
                                                          &defaultOutputDescription
                                                          );
	NSAssert(defaultOutput, @"Can't find default output");
    
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(
                                          defaultOutput, 
                                          &_toneUnit);
	NSAssert1(self.toneUnit, @"Error creating unit: %ld", err);
	
    
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = self;
	err = AudioUnitSetProperty(self.toneUnit, 
							   kAudioUnitProperty_SetRenderCallback, 
							   kAudioUnitScope_Input,
							   0, 
							   &input, 
							   sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %ld", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat = {0};		//ASBD
	streamFormat.mSampleRate = self.sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =	//maybe use kAudioFormatFlagsAudioUnitCanonical when switching to stereo
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;	
	streamFormat.mBytesPerFrame = four_bytes_per_float;		
	streamFormat.mChannelsPerFrame = 1;	//2 for stereo
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (self.toneUnit,
								kAudioUnitProperty_StreamFormat,
								kAudioUnitScope_Input,
								0,
								&streamFormat,
								sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %ld", err);
}

@end
