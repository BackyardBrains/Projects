//
//  AudioRecorder.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/17/10.
//  Copyright 2010 Backyard Brains. All rights reserved.
//

#import "AudioRecorder.h"

UInt32 writeSingleChannelRingBufferDataToFileAsSInt16(AudioFileID audioFileID, AudioConverterRef audioConverter, ringBuffer *rb, SInt16 *holdingBuffer, UInt32 bytePosition) {
	UInt32 lastFreshSample = rb->lastWrittenIndex;
	OSStatus status;
	int numSamplesToWrite;
	UInt32 numBytesToWrite;

	
	if (lastFreshSample < rb->lastReadIndex) {
		numSamplesToWrite = kNumPointsInWave + lastFreshSample - rb->lastReadIndex - 1;
	}
	else {
		numSamplesToWrite = lastFreshSample - rb->lastReadIndex;
	}
		
	numBytesToWrite = numSamplesToWrite*sizeof(SInt16);
	
	
	// copy bytes from the ring buffer into a holding buffer
	SInt16 *tempBuffer = (SInt16 *)calloc(sizeof(SInt16), numSamplesToWrite);
	UInt32 buffLen = rb->sizeOfBuffer - 1;
	for (int i=0; i < numSamplesToWrite; ++i) {
		// We've gotta swap each sample's byte order to big endian...
		// Took me FOREVER to figure that out. 
		tempBuffer[i] = CFSwapInt16HostToBig( (SInt16)rb->data[(i + rb->lastReadIndex) & buffLen] );
	}
	
	// Write the audio to file now
	status = AudioFileWriteBytes( audioFileID, NO, bytePosition, &numBytesToWrite, tempBuffer );		
	rb->lastReadIndex = lastFreshSample;
	bytePosition += numBytesToWrite;
	
	free(tempBuffer);
	return bytePosition;
	
	
	// Two scenarios:
	// 1. We can write contiguously within the ring buffer
	// 2. We need two separate writes, one until the linear end of the buffer, and then another for the remainder
	// 
	// 1. |---B==========E---| B = beginning, E = ending
	// 2. |=====E------B=====|
	//

	
}

@implementation AudioRecorder

@synthesize bbFile;
@synthesize asm;
@synthesize fileHandle;
@synthesize timerThread;
@synthesize isRecording;
@synthesize aTimer;

- (void)dealloc {
	
//	[bbFile release]; //released in stopRecording
	[asm release];
    [aTimer release];
	
	[super dealloc];

}

- (id)initWithAudioSignalManager:(AudioSignalManager *)thisAsm 
{
	if ((self = [super init])) {
		self.asm = thisAsm;
		isRecording = NO;
		UInt32 numBytes = kRecordingTimerIntervalInSeconds*thisAsm.samplingRate*sizeof(SInt16)*4;
		outBuffer = (SInt16 *)malloc(numBytes); // multiply by 2 because we want some wiggle room
	}
	
	return self;
}

- (void)startRecording {
	ringBuffer *rb = asm.secondStageBuffer;
	rb->lastReadIndex = rb->lastWrittenIndex; // bring things up to speed.
	isRecording = YES;
	
	self.bbFile = [[BBFile alloc] initWithRecordingFile];
	
	if (self.asm.isStimulating)
	{
		self.bbFile.stimLog = 0;
	};//tk
	
	AudioStreamBasicDescription destFormat;
	AudioStreamBasicDescription sourceFormat;
	memset( &destFormat, 0, sizeof(AudioStreamBasicDescription) );
	memset( &sourceFormat, 0, sizeof(AudioStreamBasicDescription) );
	
	sourceFormat.mSampleRate = asm.samplingRate;
    sourceFormat.mFormatID = kAudioFormatLinearPCM;
    sourceFormat.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked; // | kAudioFormatFlagIsBigEndian;
    sourceFormat.mBytesPerFrame = sizeof(float);
    sourceFormat.mFramesPerPacket = 1;
    sourceFormat.mBytesPerPacket = sizeof(float);
    sourceFormat.mChannelsPerFrame = 1;
    sourceFormat.mBitsPerChannel = sizeof(float)*8;
	
	destFormat.mSampleRate = asm.samplingRate;
    destFormat.mFormatID = kAudioFormatLinearPCM;
    destFormat.mFormatFlags = ( kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked | kAudioFormatFlagIsBigEndian );
    destFormat.mBytesPerPacket = 2;
    destFormat.mFramesPerPacket = 1;
    destFormat.mBytesPerFrame = 2;
    destFormat.mChannelsPerFrame = 1;
    destFormat.mBitsPerChannel = 16;
	

	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:bbFile.filename]];
	
	NSLog(@"Full file path: %@", [docPath stringByAppendingPathComponent:bbFile.filename]);
	// Open the audio file, type = AIFF
	AudioFileID newFileID;

	OSStatus status = AudioFileCreateWithURL((CFURLRef)fileURL, kAudioFileAIFFType, &destFormat, kAudioFileFlags_EraseFile, &newFileID);
	self.fileHandle = newFileID;
    
    [fileURL release];
		
    if ( noErr != status ) {
        [NSException raise:@"AudioConverterFailure" format:@"AudioFileCreate failed (status=%s)", status];
    }
	
//	AudioConverterRef audioConverter;
//	status = AudioConverterNew( &sourceFormat, &destFormat, &audioConverter );
	
	
    if ( noErr != status ) {
        [NSException raise:@"AudioConverterFailure" format:@"AudioConverterNew failed (status=%4c)", status];
    }
	
	
    [self.bbFile save];

	[self startTimer];
	
}

- (void)stopRecording {
	[self.timerThread cancel];
	isRecording = NO;
	
	//Get file length
	NSTimeInterval seconds;
	UInt32 propertySize = sizeof(seconds);
	AudioFileGetProperty(self.fileHandle, kAudioFilePropertyEstimatedDuration, &propertySize, &seconds);
	bbFile.filelength = (float)seconds;
    
	AudioFileClose(self.fileHandle);
	AudioConverterDispose( audioConverter );
	
	NSLog(@" Audio file finished");
	
	[bbFile updateMetadata];
	
	[bbFile release];
	
}

# pragma mark - Timer/Thread Handling

- (void)startTimer {
	self.timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(newTimerThread) object:nil]; //Create a new thread
	[self.timerThread start]; //start the thread
	self.asm.secondStageBuffer->lastWrittenIndex = self.asm.secondStageBuffer->lastReadIndex; 
	bytePosition = 0;
}

//the thread starts by sending this message
- (void)newTimerThread {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
	self.aTimer = [[NSTimer scheduledTimerWithTimeInterval: kRecordingTimerIntervalInSeconds
									  target: self
									selector: @selector(timerTick)
									userInfo: nil
									 repeats: YES] retain];
	
	[runLoop run];
	[pool release];
}

- (void)timerTick {
	
	if ([self.timerThread isCancelled]) {
		[aTimer invalidate];
		[timerThread release];
		return;
	}
	bytePosition = writeSingleChannelRingBufferDataToFileAsSInt16(self.fileHandle, audioConverter, self.asm.secondStageBuffer, outBuffer, bytePosition);
}




@end
