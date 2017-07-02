//
//  LJController.h
//  Backyard Brains
//
//  Created by Zachary King on 12/9/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LarvaJoltAudio.h"

@protocol LarvaJoltViewDelegate
@required
@property (nonatomic, retain) LarvaJoltAudio *pulse;
@end

@class ToneStimViewController, iPodStimViewController;


@interface LJController : UIViewController <LarvaJoltAudioDelegate>


@property (assign) IBOutlet id <LarvaJoltViewDelegate> delegate;

@property (nonatomic,retain) NSTimer *backgroundTimer;
@property double backgroundBlue;

@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) IBOutlet UIButton *stopButton;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,retain) UILabel *pleaseRotateLabel;
@property (nonatomic,retain) UIImageView *rotateRightView;
@property (nonatomic,retain) UIImageView *rotateLeftView;

@property (nonatomic, retain) ToneStimViewController *opticalVC;
@property (nonatomic, retain) ToneStimViewController *toneVC;
@property (nonatomic, retain) ToneStimViewController *pulseVC;
@property (nonatomic, retain) iPodStimViewController *iPodVC;
@property (nonatomic, retain) ToneStimViewController *calibrationVC;
@property (nonatomic, retain) UIViewController *currentController;

@property (nonatomic, retain) IBOutlet UIView *theContainerView;

- (void)setup;

- (IBAction)selectorSelected:(UISegmentedControl *)segmentedControl;
- (void)switchToController:(UIViewController *)newCtl;


- (IBAction)playPulse:(id)sender;
- (IBAction)stopPulse:(id)sender;

- (void)updateBackgroundColor;

@end
