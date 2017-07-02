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

@interface ContinuousWaveView : EAGLView

@property (nonatomic, retain) AudioSignalManager *audioSignalManager;

- (void)drawWave;
- (id)initWithCoder:(NSCoder *)coder;
- (void)updateMinorGridLines;

@end
