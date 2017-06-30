//
//  LarvaJoltViewController.h
//  LarvaJolt
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>
#import "LarvaJoltAudio.h"


@protocol LarvaJoltViewDelegate
@end

@interface LarvaJoltViewController : UIViewController <LarvaJoltAudioDelegate, UITextFieldDelegate>
{
	id <LarvaJoltViewDelegate> delegate;
    
	LarvaJoltAudio *pulse;
	
	NSNumberFormatter *numberFormatter;
    NSTimer *backgroundTimer;
    double backgroundBlue;
	
	IBOutlet UISlider *frequencySlider;
	IBOutlet UISlider *dutyCycleSlider;
    IBOutlet UISlider *pulseTimeSlider;
    IBOutlet UITextField *frequencyField;
    IBOutlet UITextField *pulseWidthField;
    IBOutlet UITextField *pulseTimeField;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *stopButton;
	
}


@property (assign) id <LarvaJoltViewDelegate> delegate;

@property (nonatomic,retain) LarvaJoltAudio *pulse;

- (void)updateBackgroundColor;

- (void)setViewMovedUp:(BOOL)movedUp;


- (void)updateViewFrom:(NSString *)source;

- (double)checkValue:(double)value forMin:(double)min andMax:(double)max;

- (IBAction)sliderMoved:(UISlider *)sender;
- (IBAction)textFieldUpdated:(UITextField *)sender;
- (IBAction)playPulse:(id)sender;
- (IBAction)stopPulse:(id)sender;
- (IBAction)done:(UIBarButtonItem *)sender;

- (void)setup;
- (void)releaseOutletsAndInstances;


@end

