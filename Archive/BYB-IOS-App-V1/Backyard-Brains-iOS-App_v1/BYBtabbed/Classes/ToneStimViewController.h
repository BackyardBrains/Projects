//
//  ToneStimViewController.h
//  Controls optical, tone, & calibration views.
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>
#import "LJController.h"
#import "LarvaJoltAudio.h"

@interface ToneStimViewController : UIViewController <LarvaJoltAudioDelegate, UITextFieldDelegate>

@property (nonatomic,assign) id <LarvaJoltViewDelegate> delegate;
@property (nonatomic,assign) LJController *ljController;
@property (nonatomic,retain) NSString *viewTypeString;
@property (nonatomic,retain) ToneStimViewController *ljCalibrationVC;

- (IBAction)toggleConstantTone:(UISwitch *)sender;

- (void)keyboardWillShow:(NSNotification *)notif;
- (void)keyboardWillHide:(NSNotification *)notif;

- (void)setViewMovedUp:(BOOL)movedUp byDist:(UInt32)dist;

- (double)checkValue:(double)value forMin:(double)min andMax:(double)max;
- (double)checkSliderValue:(double)value withArray:(NSArray *)array;
- (double)checkFieldValue:(double)value withArray:(NSArray *)array;

- (void)updateViewFrom:(NSString *)source fromView:(NSString *)view;
- (IBAction)sliderMoved:(UISlider *)sender;
- (IBAction)textFieldUpdated:(UITextField *)sender;

- (IBAction)showSetup:(id)sender;
- (IBAction)hideSetup:(id)sender;

@end

