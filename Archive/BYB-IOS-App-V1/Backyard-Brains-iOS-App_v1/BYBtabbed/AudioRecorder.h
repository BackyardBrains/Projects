//
//  AudioRecorder.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/17/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioSignalManager.h"
#import "BBFile.h"
#import "Constants.h"

// C-only callback

UInt32 writeSingleChannelRingBufferDataToFileAsSInt16(AudioFileID audioFileID, AudioConverterRef audioConverter, ringBuffer *rb, SInt16 *holdingBuffer, UInt32 bytePosition);

@interface AudioRecorder : NSObject {
	BBFile *bbFile;
	AudioSignalManager *asm;
	AudioFileID fileHandle; // should use pure-C for speed.
	AudioConverterRef audioConverter;
	NSThread *timerThread;
	void *outBuffer; // this is for storing audio data, it could be of any format/precision.
	BOOL isRecording;
	UInt32 bytePosition;
    NSTimer *aTimer;
}               


@property (nonatomic, retain) BBFile *bbFile;
@property (nonatomic, retain) AudioSignalManager *asm;
@property AudioFileID fileHandle;
@property (nonatomic, retain) NSThread *timerThread;
@property BOOL isRecording;
@property (nonatomic, retain) NSTimer *aTimer;

- (id)initWithAudioSignalManager:(AudioSignalManager *)asm;

- (void)startRecording;
- (void)stopRecording;

- (void)startTimer;
- (void)newTimerThread;
- (void)timerTick;


@end
