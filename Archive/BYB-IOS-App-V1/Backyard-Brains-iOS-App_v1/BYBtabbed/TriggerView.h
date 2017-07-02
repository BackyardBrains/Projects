//
//  oScope
//
//  Created by Alex Wiltschko on 11/15/09.
//  Modified by Zachary King
//      6/6/2011 Added delegate and methods to automatically set the viewing frame.
//      7/11/2011 Set NumDashes to 0 to quash mysterious red line
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import "AudioSignalManager.h"

#define kNumDashesInVerticalTriggerLine 0

@interface TriggerView : EAGLView {
	struct wave_s *thresholdLine;
	float middleOfWave;
    
    AudioSignalManager *audioSignalManager;

}

@property struct wave_s *thresholdLine;
@property float middleOfWave;

@property (nonatomic, retain) AudioSignalManager *audioSignalManager;

- (void)drawWave;
- (void)drawThresholdLine;
- (id)initWithCoder:(NSCoder *)coder;


@end
