//
//  LarvaJoltAudio.h
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

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import <MediaPlayer/MediaPlayer.h>


@class LarvaJoltAudio;

@protocol LarvaJoltAudioDelegate
- (void)pulseIsPlaying;
- (void)pulseIsStopped;
@end


@interface LarvaJoltAudio : NSObject {
    
@public					// req'd by render function
    double _dutyCycle;
	double _frequency;
	double _amplitude; 
    double _pulseTime;
    double _trainDelay;
    BOOL _isSquarePulse;
	
	double _sampleRate;
	double _pulseProgress;
    double _theta;
    double _outputFreq;
    double _ledFreq;
    
    double _calibA, _calibB, _calibC;
	
    BOOL _songSelected;
}

@property (assign) id <LarvaJoltAudioDelegate> delegate;

@property AudioComponentInstance toneUnit;

@property double dutyCycle;
@property double frequency;
@property double amplitude;
@property double pulseTime;
@property double trainDelay;
@property BOOL isSquarePulse;

@property double sampleRate;
@property double pulseProgress;
@property double theta;
@property double outputFreq;
@property double ledFreq;

@property BOOL playing;
@property BOOL songSelected;
@property (nonatomic,retain) MPMediaItemCollection *playlist;
@property int songNowPlaying;

@property double calibA, calibB, calibC;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) MPMusicPlayerController* appMusicPlayer;


- (void)createToneUnit;

- (void)playPulse;
- (void)stopPulse;

@end
