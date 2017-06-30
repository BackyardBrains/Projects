//
//  ContinuousWaveView.h
//  oScope
//
//  Created by Alex Wiltschko on 11/15/09.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import "AudioSignalManager.h"
#import "AudioPlaybackManager.h"

@interface PlaybackView : EAGLView {
    AudioPlaybackManager *apm;
}

@property (nonatomic, retain) AudioPlaybackManager *apm;

- (void)drawWave;
- (id)initWithCoder:(NSCoder *)coder;

@end
