//
//  ContinuousWaveView.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/6/2011 Added delegate and methods to automatically set the viewing frame.
//  Copyright 2009 Backyard Brains. All rights reserved.
//


#import "DrawingViewController.h"
@class PlaybackView;
@class AudioPlaybackManager;


@interface PlaybackViewController : DrawingViewController <DrawingDataManagerDelegate>
{
	// Data labels
	IBOutlet UIButton *playPauseButton;
    IBOutlet UISlider *scrubBar;
    IBOutlet UILabel  *elapsedTimeLabel;
    IBOutlet UILabel  *remainingTimeLabel;
    
    
	BBFile *file;
    
	PlaybackView *pbView;
	
	AudioPlaybackManager *apm;
}

@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UISlider *scrubBar;
@property (nonatomic, retain) IBOutlet UILabel  *elapsedTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel  *remainingTimeLabel;


@property (nonatomic, retain) PlaybackView *pbView;

@property (nonatomic, retain) AudioPlaybackManager *apm;

- (void)updateDataLabels;
- (void)showAllLabels;
- (void)hideAllLabels;

- (IBAction)playPause:(UIButton *)sender;

- (void)pushTrigger;

//for DrawingDataManagerDelegate
@property (nonatomic, retain) BBFile *file;
- (void)shouldAutoSetFrame;

@end
