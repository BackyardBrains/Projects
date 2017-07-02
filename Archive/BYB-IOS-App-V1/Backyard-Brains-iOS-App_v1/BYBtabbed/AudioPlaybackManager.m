//
//  AudioPlaybackManager.m
//  
//
//  Created by Zachary King on July 31, 2011.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import "AudioPlaybackManager.h"
#import "Constants.h"

#define kBarUpdateInterval 0.5f
#define kNumPointsInPlaybackVertexBuffer 32768
#define kNumWaitFrames 5


SInt16 * readSingleChannelRingBufferDataAsSInt16( AudioPlaybackManager *THIS, Float64 seconds) {

    
    SInt32 halfBufferSize = kNumPointsInPlaybackVertexBuffer*sizeof(SInt16)/2;
    
    AudioFileID audioFileID = THIS->_fileHandle;
    SInt32 frameStartByte = (SInt32)(seconds * THIS->_bitRate + THIS->_dataOffset) - halfBufferSize;
    UInt32 frameSize = kNumPointsInPlaybackVertexBuffer*sizeof(SInt16);
    UInt32 audioFileByteCount = THIS->_byteCount;
    
    UInt32 ioNumBytes;
    UInt32 zeroOutFirstBytes = 0;
    UInt32 zeroOutEndBytes = 0;
    
    
    // Case 0: file is shorter than 1/2 buffer
    if (audioFileByteCount < (frameSize/2))
    {
        ioNumBytes = audioFileByteCount;
        zeroOutFirstBytes = abs(frameStartByte);
        zeroOutEndBytes = frameSize - ioNumBytes - zeroOutFirstBytes;
        NSLog(@"Case 0");
    }
    // Case 1: part blank, part audio
    else if (frameStartByte < 0) {
        ioNumBytes = frameSize - abs(frameStartByte);
        zeroOutFirstBytes = frameSize - ioNumBytes;
        NSLog(@"Case 1");
    }
    // Case 2: all audio
    else if (   frameStartByte >= 0
             && frameStartByte <= (audioFileByteCount - frameSize) )
    {
        ioNumBytes = frameSize;
        NSLog(@"Case 2");
    }
    // Case 3: part audio, part blank
    else if (  frameStartByte > (audioFileByteCount - frameSize)
             && frameStartByte < audioFileByteCount )
    {
        ioNumBytes = audioFileByteCount - frameStartByte;
        zeroOutEndBytes = frameSize - ioNumBytes;
        NSLog(@"Case 3");
    }
    else
    {
        ioNumBytes = 0;
        zeroOutFirstBytes = frameSize;
    }

    
    // if we're aren't going to read any bytes
    if (ioNumBytes <= 0)
    {
        THIS->_numBytesRead = 0;
        return nil;
    }
    
    void *tempBuffer = malloc(ioNumBytes);
    UInt32 startReadByte;
    if (frameStartByte < 0)
        startReadByte = 0;
    else
        startReadByte = frameStartByte;
    
    NSLog(@"Starting byte is %lu and num of bytes is %lu", startReadByte, ioNumBytes);
    
    
	// Read from audio to file now
	OSStatus status = AudioFileReadBytes(audioFileID, YES, startReadByte, &ioNumBytes, tempBuffer);
    THIS->_numBytesRead = ioNumBytes;
    
	if (status)
    {
		NSLog(@"AudioFileReadBytes failed: %ld, with ioNumBytes: %lu", status, ioNumBytes);
        return nil;
    }
    else
    {
        
		NSLog(@"AudioFileReadBytes succeeded with ioNumBytes: %lu", ioNumBytes);

        if (ioNumBytes > 0) {
            
            NSLog(@"Zero out %lu, ioNumBytes %lu, zero out %lu",zeroOutFirstBytes, ioNumBytes, zeroOutEndBytes);
            
            SInt16 *temp2Buffer = (SInt16 *)tempBuffer;
            SInt16 *outBuffer = malloc(frameSize);
            
            for (int i = 0; i < zeroOutFirstBytes/sizeof(SInt16); ++i) {
                outBuffer[i] = 0;
            }
            
            for (int i = 0; i < ioNumBytes/sizeof(SInt16); ++i) {
                // We've gotta swap each sample's byte order from big endian to host format...
                outBuffer[zeroOutFirstBytes/sizeof(SInt16) + i] = 
                                    CFSwapInt16BigToHost(temp2Buffer[i]);
            }
            
            for (int i = 0; i < zeroOutEndBytes/sizeof(SInt16); ++i) {
                outBuffer[(i + (zeroOutFirstBytes + ioNumBytes)/sizeof(SInt16))] = 0;
            }
            
            return outBuffer;
            
        }
        else 
        {
            // stop
            NSLog(@"But zero bytes were read");
            return nil;
        }
    }
    
}


@implementation AudioPlaybackManager

@synthesize file            = _file;
@synthesize playImage       = _playImage;
@synthesize pauseImage      = _pauseImage;

@synthesize lastTime        = _lastTime;
@synthesize playing         = _playing;


#pragma mark - life cycle

- (void)dealloc
{
    [super dealloc];
    
    [_file release];
    [_playImage release];
    [_pauseImage release];
    
    AudioFileClose(_fileHandle);
    _fileHandle = nil;
}

- (id)initWithBBFile:(BBFile *)theFile
{
    if ((self = [super init]))
    {
        self.file = theFile; 
        
		self.vertexBuffer = (struct wave_s *)malloc(kNumPointsInPlaybackVertexBuffer*sizeof(struct wave_s));
        NSLog(@"Num points in vertex buffer: %d", kNumPointsInPlaybackVertexBuffer);
        
        self.nWaitFrames = 0;
        
        self.playing = NO;
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:self.file.filename]];
        //do i have the file yet?
        
        NSLog(@"Full file path: %@", [docPath stringByAppendingPathComponent:self.file.filename]);
        // Open the audio file, type = AIFF
        
        AudioFileID id;
        OSStatus status = AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadPermission, kAudioFileAIFFType, &id);
        _fileHandle = id;
        NSLog(@"Open Audio File status: %@", status);
        [fileURL release];
        
        
        //Get byte count
        UInt64 outData = 0;
        UInt32 outDataSize = sizeof(UInt64);
        AudioFileGetProperty (  _fileHandle,
                                kAudioFilePropertyAudioDataByteCount,
                              &outDataSize,
                              &outData
                              );
        NSLog(@"Byte count: %llu", outData);
        _byteCount = outData;
        
        
        //should be 44100:
        _bitRate = self.file.samplingrate*2;
        NSLog(@"bit rate: %llu", _bitRate);
        
        //set data offset to zero
        _dataOffset = 0;
        
        //Just read out all the audio data
        
        
        // audioPlayer will remain nil as long as nothing is playing
        _audioPlayer = nil;

        
        self.playImage =    [UIImage imageNamed:@"play.png"];
        self.pauseImage =   [UIImage imageNamed:@"pause.png"];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)grabNewFile
{
    self.file = self.delegate.file;
}

- (void)updateCurrentTimeTo:(float)time
{
    _audioPlayer.currentTime = time;
    if (self.playing)
        [self pause];
}


# pragma mark - Visual playback methods



- (void)fillVertexBufferWithAudioData
{
    
    if (self.playing && _audioPlayer != nil)
    {
        
        //get the current time
        Float64 tNow = _audioPlayer.currentTime;
        if (tNow != self.lastTime && tNow >= 0)
        {
            NSLog(@"Time now is %f", tNow);
            
            
            SInt16 *outBuffer = readSingleChannelRingBufferDataAsSInt16(self, tNow);

            NSLog(@"bytes read out: %llu", _numBytesRead);
   
            if (outBuffer!=nil)
            {
                
                for (int i = 0; i < kNumPointsInPlaybackVertexBuffer; ++i)
                {
                    if (outBuffer[i])
                        self.vertexBuffer[i].y = outBuffer[i];
                    else
                        self.vertexBuffer[i].y = 0;
                }
            }
            
            self.lastTime = tNow;
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
    else // not playing
    {
        for (int i = 0; i < kNumPointsInPlaybackVertexBuffer; ++i)
        {
            self.vertexBuffer[i].y = 0;
        }
    }
}


- (void)setVertexBufferXRangeFrom:(GLfloat)xBegin to:(GLfloat)xEnd {
	for (int i=0; i < kNumPointsInPlaybackVertexBuffer; ++i) {
		vertexBuffer[i].x = xBegin + i*(xEnd - xBegin)/kNumPointsInPlaybackVertexBuffer;
	}
}


# pragma mark - Audio playback methods

- (BOOL)playPause
{
    
    if (_audioPlayer == nil)  //if you haven't played anything yet
    {
        [self play];
        return YES;
    }
    else 
    {
        //make sure everything is paused
        if (self.playing)
        {
            [self pause];
            return NO;
        } 
        else //audioPlayer not playing
        {
            [self play];
            return YES;
        }
        
    }
}

- (void)play
{
    
	NSLog(@"Starting play!");
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:self.file.filename]];
    
    // ----------------------------- Audio -----------------------------------
    
    if (_audioPlayer == nil) {
		// Make a URL to the BBFile's audio file

		// Fire up an audio player
		_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        _audioPlayer.volume = 1.0; // 0.0 - no volume; 1.0 full volume
        
        NSLog(@"File path %@", [docPath stringByAppendingPathComponent:self.file.filename]);
		NSLog(@"File duration: %f", _audioPlayer.duration);
        
        
		NSLog(@"Starting the playing");
		
        self.delegate.scrubBar.minimumValue = 0;
		self.delegate.scrubBar.maximumValue = _audioPlayer.duration;
		[self startUpdateTimer];
        
	}	
    
	[_audioPlayer play];
    
  
    
    // --other stuff--
    
    [fileURL release];
        
    self.playing = YES;

    [self.delegate.playPauseButton setImage:self.pauseImage forState:UIControlStateNormal];
    
}

- (void)pause
{
	NSLog(@"Pausing play!");
    
    //Audio
    [_audioPlayer pause];
    self.playing = NO;
        
    [self.delegate.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
}

- (void)stop
{
	NSLog(@"Stopping play!");
    
    //Audio
    
	self.delegate.elapsedTimeLabel.text = @"0:00";
	self.delegate.remainingTimeLabel.text = @"-0:00";
	self.delegate.scrubBar.value = 0.0f;
	
	[_timerThread invalidate];
	[_audioPlayer stop];
	[_audioPlayer release];
	_audioPlayer = nil;
    
    self.playing = NO;
    
    [self.delegate.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
}

#pragma mark - A Useful Timer
- (void)startUpdateTimer {
	_timerThread = [[NSTimer scheduledTimerWithTimeInterval:kBarUpdateInterval target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES] retain];
}

/*//the thread starts by sending this message
 - (NSTimer *)newTimerThread {
 NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
 NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
 NSTimer *thisTimer = [[NSTimer scheduledTimerWithTimeInterval: 0.5f
 target: self
 selector: @selector(updateCurrentTime)
 userInfo: nil
 repeats: YES] retain];
 
 [runLoop run];
 [pool release];
 
 return thisTimer;
 }*/

- (void)updateCurrentTime {
	self.delegate.scrubBar.value = _audioPlayer.currentTime;
	
    
	int minutesElapsed = (int)floor(_audioPlayer.currentTime / 60.0);
	int secondsElapsed = (int)(_audioPlayer.currentTime - minutesElapsed*60.0);
	
	int totalSecondsLeft = (int)(_audioPlayer.duration - _audioPlayer.currentTime);
	int minutesLeft = (int)floor(totalSecondsLeft / 60.0);
	int secondsLeft = (int)(totalSecondsLeft - minutesLeft*60.0);
	
	NSString *tmpElapsedString = [[NSString alloc] initWithFormat:@"%d:%02d", minutesElapsed, secondsElapsed];
	NSString *tmpLeftString = [[NSString alloc] initWithFormat:@"-%d:%02d", minutesLeft, secondsLeft];
	
	self.delegate.elapsedTimeLabel.text = tmpElapsedString;
	[tmpElapsedString release];
    
	self.delegate.remainingTimeLabel.text = tmpLeftString;
	[tmpLeftString release];
	
	if (totalSecondsLeft == 0) {
		[self stop];
        NSLog(@"timer stopped playing");
		[_timerThread invalidate];
	}
	
	/*if (audioPlayer.playing == NO) {
     NSLog(@"timer stopped playing");
     [self stopPlaying];
     [timerThread invalidate];
     }*/
	
    //************************************
    //Now grab this audio data and present to screen
	
}


#pragma mark- Helper Functions

- (UInt32)CalculateBytesForTime:(Float64)inSeconds
{
    UInt32 startByte = inSeconds * _bitRate + _dataOffset;
    
    return startByte;
}



@end