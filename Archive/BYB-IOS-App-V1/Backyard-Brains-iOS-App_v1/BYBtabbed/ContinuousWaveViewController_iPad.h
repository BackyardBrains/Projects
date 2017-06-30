//
//  ContinuousWaveView_iPad.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/27/2011 Added LarvaJolt stimulation controller.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "ContinuousWaveViewController.h"
#import "BBFileViewControllerTBV.h"
#import "FlipsideInfoViewController.h"


@interface ContinuousWaveViewController_iPad : ContinuousWaveViewController 
    <UIPopoverControllerDelegate, FlipsideInfoViewDelegate>


@property (nonatomic, retain) IBOutlet UIButton *fileButton;
@property (nonatomic, retain) IBOutlet UIButton *stimSetupButton;
@property (nonatomic, retain) UIPopoverController *currentPopover;

- (IBAction)displayInfoPopover:(UIButton *)sender;
- (IBAction)displayFilePopover:(UIButton *)sender;
- (IBAction)displayStimSetupPopover:(UIButton *)sender;

//for FlipsideInfoViewDelegate
- (void)flipsideIsDone;


- (void)updateStimShadowAlpha;

@end
