//
//  ToneStimViewController.m
//  Controls optical & tone views.
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 Backyard Brains.
//

#define kDistanceToBottomOfScreen 440

#import "ToneStimViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ToneStimViewController () //private properties


@property (nonatomic,retain) IBOutlet UISlider *frequencySlider;
@property (nonatomic,retain) IBOutlet UISlider *dutyCycleSlider;
@property (nonatomic,retain) IBOutlet UISlider *pulseTimeSlider;
@property (nonatomic,retain) IBOutlet UITextField *frequencyField;
@property (nonatomic,retain) IBOutlet UITextField *periodField;
@property (nonatomic,retain) IBOutlet UITextField *pulseWidthField;
@property (nonatomic,retain) IBOutlet UITextField *pulseTimeField;
@property (nonatomic,retain) IBOutlet UITextField *nPulsesField;

@property (nonatomic,retain) IBOutlet UISlider *toneFreqSlider;
@property (nonatomic,retain) IBOutlet UITextField *toneFreqField;
@property (nonatomic,retain) IBOutlet UITextField *calibAField, *calibBField, *calibCField;

@property (nonatomic,retain) NSNumberFormatter *numberFormatter;

@property (nonatomic,retain) NSArray *frequencyStops, *dutyCycleStops, *pulseTimeStops;
@property int lastMoveUpValue;
@property CGRect keyboardFrame;
@property CGRect originalRect;

@end


@implementation ToneStimViewController

@synthesize delegate            = _delegate;
@synthesize ljController        = _ljController;
@synthesize viewTypeString      = _viewTypeString;
@synthesize ljCalibrationVC     = _ljCalibrationVC;

@synthesize frequencySlider     = _frequencySlider;
@synthesize dutyCycleSlider     = _dutyCycleSlider; 
@synthesize pulseTimeSlider     = _pulseTimeSlider;
@synthesize frequencyField      = _frequencyField; 
@synthesize periodField         = _periodField;
@synthesize pulseWidthField     = _pulseWidthField; 
@synthesize pulseTimeField      = _pulseTimeField;
@synthesize nPulsesField        = _nPulsesField;
@synthesize toneFreqField       = _toneFreqField;
@synthesize toneFreqSlider      = _toneFreqSlider;
@synthesize calibAField         = _calibAField;
@synthesize calibBField         = _calibBField;
@synthesize calibCField         = _calibCField;

@synthesize numberFormatter     = _numberFormatter;

@synthesize frequencyStops      = _frequencyStops;
@synthesize dutyCycleStops      = _dutyCycleStops;
@synthesize pulseTimeStops      = _pulseTimeStops;
@synthesize lastMoveUpValue     = _lastMoveUpValue;
@synthesize keyboardFrame       = _keyboardFrame;
@synthesize originalRect        = _originalRect;

#pragma mark - Initiation methods and messages from the system

- (void)dealloc
{
	//release outlets
    [_viewTypeString release];
    [_ljCalibrationVC release];
    
	[_frequencySlider release];
	[_dutyCycleSlider release];
	[_pulseTimeSlider release];
	[_frequencyField release];
    [_periodField release];
	[_pulseWidthField release];
	[_pulseTimeField release];
    [_nPulsesField release];
    [_toneFreqField release];
    [_toneFreqSlider release];
    [_calibAField release];
    [_calibBField release];
    [_calibCField release];
    
    [_numberFormatter release];
    
    [_frequencyStops release];
    [_dutyCycleStops release];
    [_pulseTimeStops release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.numberFormatter = [[NSNumberFormatter alloc] init];
	[self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //[self.numberFormatter setMinimumIntegerDigits:1];
    [self.numberFormatter setMaximumFractionDigits:3];
    
    if ([self.viewTypeString isEqualToString:@"Tone"]
        || [self.viewTypeString isEqualToString:@"Optical"])
    {
        //assign delegates of text fields to control keyboard behavior
        self.frequencyField.returnKeyType = UIReturnKeyDone;
        self.frequencyField.delegate = self;
        self.periodField.returnKeyType = UIReturnKeyDone;
        self.periodField.delegate = self;
        self.pulseWidthField.returnKeyType = UIReturnKeyDone;
        self.pulseWidthField.delegate = self;
        self.pulseTimeField.returnKeyType = UIReturnKeyDone;
        self.pulseTimeField.delegate = self;
        self.nPulsesField.returnKeyType = UIReturnKeyDone;
        self.nPulsesField.delegate = self;
    }
    else if ([self.viewTypeString isEqualToString:@"Calibration"]) 
    {
        //assign delegates of text fields to control keyboard behavior
        self.toneFreqField.returnKeyType = UIReturnKeyDone;
        self.toneFreqField.delegate = self;
        self.calibAField.returnKeyType = UIReturnKeyDone;
        self.calibAField.delegate = self;
        self.calibBField.returnKeyType = UIReturnKeyDone;
        self.calibBField.delegate = self;
        self.calibCField.returnKeyType = UIReturnKeyDone;
        self.calibCField.delegate = self;
    }
    
    //set up stops
    if ([self.viewTypeString isEqualToString:@"Tone"])
        self.frequencyStops = [[NSArray alloc] 
                               initWithObjects:[NSNumber numberWithDouble:200],
                               [NSNumber numberWithDouble:400],
                               [NSNumber numberWithDouble:600],
                               [NSNumber numberWithDouble:800],
                               [NSNumber numberWithDouble:1000],
                               [NSNumber numberWithDouble:1500],
                               [NSNumber numberWithDouble:2000],
                               [NSNumber numberWithDouble:2500],
                               [NSNumber numberWithDouble:3000],
                               [NSNumber numberWithDouble:3500],
                               [NSNumber numberWithDouble:4000],
                               [NSNumber numberWithDouble:5000],
                               [NSNumber numberWithDouble:7500],
                               [NSNumber numberWithDouble:10000],
                               [NSNumber numberWithDouble:15000], nil]; //Hz
    else if ([self.viewTypeString isEqualToString:@"Pulse"])
        self.frequencyStops = [[NSArray alloc] 
                               initWithObjects:
                               [NSNumber numberWithDouble:1],
                               [NSNumber numberWithDouble:5],
                               [NSNumber numberWithDouble:10],
                               [NSNumber numberWithDouble:20],
                               [NSNumber numberWithDouble:50],
                               [NSNumber numberWithDouble:100],
                               [NSNumber numberWithDouble:200],
                               [NSNumber numberWithDouble:500],
                               [NSNumber numberWithDouble:1000], nil]; //Hz
    else if ([self.viewTypeString isEqualToString:@"Optical"])
        self.frequencyStops = [[NSArray alloc] 
                               initWithObjects:[NSNumber numberWithInt:20],
                               [NSNumber numberWithInt:50],
                               [NSNumber numberWithInt:100],
                               [NSNumber numberWithInt:200],
                               [NSNumber numberWithInt:300],
                               [NSNumber numberWithInt:400],
                               [NSNumber numberWithInt:500], nil]; //Hz
    
    self.dutyCycleStops = [[NSArray alloc]
                           initWithObjects:[NSNumber numberWithDouble:0.1f],
                           [NSNumber numberWithDouble:0.2f],
                           [NSNumber numberWithDouble:0.3f],
                           [NSNumber numberWithDouble:0.4f],
                           [NSNumber numberWithDouble:0.5f],
                           [NSNumber numberWithDouble:0.6f],
                           [NSNumber numberWithDouble:0.7f],
                           [NSNumber numberWithDouble:0.8f],
                           [NSNumber numberWithDouble:0.9f],
                           [NSNumber numberWithDouble:1.0f], nil];
    self.pulseTimeStops = [[NSArray alloc]
                            initWithObjects:[NSNumber numberWithDouble:0.1f],
                            [NSNumber numberWithDouble:0.5f],
                            [NSNumber numberWithDouble:1.0f],
                            [NSNumber numberWithDouble:5.0f],
                            [NSNumber numberWithDouble:10.0f],
                            [NSNumber numberWithDouble:50.0f],
                            [NSNumber numberWithDouble:100.0f], nil]; //s

    //make it pretty on ios < 5.0
    if (![self.pulseTimeField respondsToSelector:@selector(setBackgroundColor:)]) {
        self.frequencyField.textColor = [UIColor blackColor];
        self.periodField.textColor = [UIColor blackColor];
        self.pulseTimeField.textColor = [UIColor blackColor];
        self.nPulsesField.textColor = [UIColor blackColor];
        self.pulseWidthField.textColor = [UIColor blackColor];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.originalRect = self.view.frame;
    
    // register for keyboard notifications
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window]; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    }
    
    self.delegate.pulse.songSelected = NO;
    
    if ([self.viewTypeString isEqualToString:@"Tone"])
        self.delegate.pulse.frequency = 0;
    
    if ([self.viewTypeString isEqualToString:@"Pulse"])
    {
        self.delegate.pulse.isSquarePulse = FALSE; // change to true if we decide on square pulse
        self.delegate.pulse.frequency = 1000;
    }
    else
        self.delegate.pulse.isSquarePulse = FALSE;
    
    if ([self.viewTypeString isEqualToString:@"Optical"])
        self.delegate.pulse.outputFreq = self.delegate.pulse.ledFreq;

    

    [self updateViewFrom:@"Slider" fromView:self.viewTypeString];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{
    if ([self.viewTypeString isEqualToString:@"Tone"]
        || [self.viewTypeString isEqualToString:@"Optical"]
        || [self.viewTypeString isEqualToString:@"Pulse"])
    {
        self.pulseTimeField.enabled = NO;
        self.pulseTimeSlider.enabled = NO;
    }
    
}
- (void)pulseIsStopped
{
    if ([self.viewTypeString isEqualToString:@"Tone"]
        || [self.viewTypeString isEqualToString:@"Optical"]
        || [self.viewTypeString isEqualToString:@"Pulse"])
    {
        self.pulseTimeField.enabled = YES;
        self.pulseTimeSlider.enabled = YES;
    }
}



#pragma mark - Implementation of UITextField delegate protocol.


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    int moveUp = self.keyboardFrame.size.height + 
        (textField.frame.origin.y + textField.frame.size.height)
        - kDistanceToBottomOfScreen;
    
    if (moveUp > 0)
        [self setViewMovedUp:YES byDist:moveUp];
    
    self.lastMoveUpValue = (textField.frame.origin.y + textField.frame.size.height)
                                - kDistanceToBottomOfScreen;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

// this helps dismiss the keyboard when the "done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - keyboard control

- (void)keyboardWillShow:(NSNotification *)notif
{ 
    NSValue *value = [notif.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    self.keyboardFrame = [value CGRectValue];
    
    int moveUp = (self.keyboardFrame.size.height + self.lastMoveUpValue);
    if (moveUp > 0)
        [self setViewMovedUp:YES byDist:moveUp];

}

- (void)keyboardWillHide:(NSNotification *)notif
{
    [self setViewMovedUp:NO byDist:0];
}


-(void)setViewMovedUp:(BOOL)movedUp byDist:(UInt32)dist
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= (dist + rect.origin.y);
        rect.size.height += (dist + rect.origin.y);
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y = self.originalRect.origin.y;
        rect.size.height = self.originalRect.size.height;
    }
    NSLog(@"Did move up = %@\n", (movedUp ? @"YES" : @"NO"));
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}




# pragma mark - Update methods


- (void)updateViewFrom:(NSString *)source fromView:(NSString *)view
{	
    
    //---------------------------- TONE ----------------------------------------
    if ([view isEqualToString:@"Tone"])
    {
        if (source==@"Slider")
        {
            self.delegate.pulse.pulseTime =
                [self checkSliderValue:self.pulseTimeSlider.value withArray:self.pulseTimeStops];
            
            self.delegate.pulse.outputFreq = 
                [self checkSliderValue:self.frequencySlider.value withArray:self.frequencyStops];
            
            NSLog(@"Updated from Slider");
        }
        else if (source==@"Field")
        {
            
            if ([self.frequencyField isFirstResponder]) {
                
                self.delegate.pulse.outputFreq =
                    [self checkValue:[self.frequencyField.text doubleValue]
                              forMin:[[self.frequencyStops objectAtIndex:0] doubleValue]
                              andMax:[[self.frequencyStops objectAtIndex:self.frequencyStops.count-1] doubleValue] ];
            }
            else if ([self.pulseTimeField isFirstResponder])
            {
                self.delegate.pulse.pulseTime = 
                    [self checkValue:([self.pulseTimeField.text doubleValue])
                              forMin:[[self.pulseTimeStops objectAtIndex:0] doubleValue]
                              andMax:[[self.pulseTimeStops objectAtIndex:self.pulseTimeStops.count-1] doubleValue] ];
                
            }
            else if ([self.nPulsesField isFirstResponder])
            {
                self.delegate.pulse.pulseTime = 
                    [self checkValue:([self.nPulsesField.text doubleValue]/self.delegate.pulse.frequency)
                              forMin:[[self.pulseTimeStops objectAtIndex:0] doubleValue]
                              andMax:[[self.pulseTimeStops objectAtIndex:self.pulseTimeStops.count-1] doubleValue] ];
            }
            
            
            NSLog(@"Updated from Field");
        }
        
        self.frequencySlider.value = 
            [self checkFieldValue:self.delegate.pulse.outputFreq 
                        withArray:self.frequencyStops];
        
        NSNumber *num1 = [NSNumber numberWithDouble:self.delegate.pulse.outputFreq];
        self.frequencyField.text = [self.numberFormatter stringFromNumber:num1];
        
        self.pulseTimeSlider.value = [self checkFieldValue:self.delegate.pulse.pulseTime
                                                 withArray:self.pulseTimeStops];
        
        NSNumber *num3 = [NSNumber numberWithDouble:(self.delegate.pulse.pulseTime)];
        self.pulseTimeField.text = [self.numberFormatter stringFromNumber:num3];
        NSNumber *num4 = 
            [NSNumber numberWithDouble:(self.delegate.pulse.pulseTime*self.delegate.pulse.outputFreq)];
        self.nPulsesField.text = [self.numberFormatter stringFromNumber:num4];
    }
    //---------------------------- PULSE ----------------------------------------
    else if ([view isEqualToString:@"Pulse"]) 
    {
        if (source==@"Slider")
        {
            self.delegate.pulse.pulseTime =
                [self checkSliderValue:self.pulseTimeSlider.value withArray:self.pulseTimeStops];
            
            self.delegate.pulse.frequency =
                [self checkSliderValue:self.frequencySlider.value withArray:self.frequencyStops];
            
            self.delegate.pulse.dutyCycle = 0.001f * self.delegate.pulse.frequency;
            
            NSLog(@"Updated from Slider");
        }
        else if (source==@"Field")
        {
            if ([self.periodField isFirstResponder])
            {
                self.delegate.pulse.frequency =
                    [self checkValue:[self.frequencyField.text doubleValue]
                              forMin:[[self.frequencyStops objectAtIndex:0] doubleValue]
                              andMax:[[self.frequencyStops objectAtIndex:self.frequencyStops.count-1] doubleValue] ];        
            }
            else if ([self.pulseTimeField isFirstResponder])
            {
                self.delegate.pulse.pulseTime = 
                [self checkValue:([self.pulseTimeField.text doubleValue])
                          forMin:[[self.pulseTimeStops objectAtIndex:0] doubleValue]
                          andMax:[[self.pulseTimeStops objectAtIndex:self.pulseTimeStops.count-1] doubleValue] ];
                
            }            
            else if ([self.nPulsesField isFirstResponder])
            {
                self.delegate.pulse.pulseTime = 
                [self checkValue:([self.nPulsesField.text doubleValue]/self.delegate.pulse.frequency)
                          forMin:[[self.pulseTimeStops objectAtIndex:0] doubleValue]
                          andMax:[[self.pulseTimeStops objectAtIndex:self.pulseTimeStops.count-1] doubleValue] ];
            }

            
            NSLog(@"Updated from Field");
        }
        
        self.frequencySlider.value = 
            [self checkFieldValue:self.delegate.pulse.frequency withArray:self.frequencyStops];
        
        NSNumber *num5 = [NSNumber numberWithDouble:(1.0f/self.delegate.pulse.frequency)];
        self.periodField.text = [self.numberFormatter stringFromNumber:num5];
        
        self.pulseTimeSlider.value =
            [self checkFieldValue:self.delegate.pulse.pulseTime
                        withArray:self.pulseTimeStops];
        
        NSNumber *num3 = [NSNumber numberWithDouble:(self.delegate.pulse.pulseTime)];
        self.pulseTimeField.text = [self.numberFormatter stringFromNumber:num3];
        
        NSNumber *num4 = 
            [NSNumber numberWithDouble:(self.delegate.pulse.pulseTime*self.delegate.pulse.frequency)];
        self.nPulsesField.text = [self.numberFormatter stringFromNumber:num4];
    }
    //---------------------------- OPTICAL -------------------------------------
    else if ([view isEqualToString:@"Optical"])
    {
        if (source==@"Slider")
        {
            self.delegate.pulse.pulseTime =
                [self checkSliderValue:self.pulseTimeSlider.value withArray:self.pulseTimeStops];
            
            self.delegate.pulse.frequency = 
                [self checkSliderValue:self.frequencySlider.value withArray:self.frequencyStops];
            
            self.delegate.pulse.dutyCycle = 
                [self checkSliderValue:self.dutyCycleSlider.value withArray:self.dutyCycleStops];
        
            NSLog(@"Updated from Slider");
        }
        else if (source==@"Field")
        {
            
            if ([self.frequencyField isFirstResponder]) {
                
                self.delegate.pulse.frequency =
                    [self checkValue:[self.frequencyField.text doubleValue]
                              forMin:[[self.frequencyStops objectAtIndex:0] doubleValue]
                              andMax:[[self.frequencyStops objectAtIndex:self.frequencyStops.count-1] doubleValue] ];
                        
            }
            else if ([self.pulseWidthField isFirstResponder])
            {
                self.delegate.pulse.dutyCycle =
                [self checkValue:([self.pulseWidthField.text doubleValue] * self.delegate.pulse.frequency)
                          forMin:[[self.dutyCycleStops objectAtIndex:0] doubleValue]
                          andMax:[[self.dutyCycleStops objectAtIndex:self.dutyCycleStops.count-1] doubleValue] ];            
            }
            else if ([self.pulseTimeField isFirstResponder])
            {
                self.delegate.pulse.pulseTime = 
                [self checkValue:([self.pulseTimeField.text doubleValue])
                          forMin:[[self.pulseTimeStops objectAtIndex:0] doubleValue]
                          andMax:[[self.pulseTimeStops objectAtIndex:self.pulseTimeStops.count-1] doubleValue] ];
                
            }
                    
            NSLog(@"Updated from Field");
        }
    
        self.frequencySlider.value = 
            [self checkFieldValue:self.delegate.pulse.frequency 
                        withArray:self.frequencyStops];
        
        NSNumber *num1 = [NSNumber numberWithDouble:self.delegate.pulse.frequency];
        self.frequencyField.text = [self.numberFormatter stringFromNumber:num1];
        
        self.dutyCycleSlider.value = 
            [self checkFieldValue:self.delegate.pulse.dutyCycle
                        withArray:self.dutyCycleStops];
        
        NSNumber *num2 = [NSNumber numberWithDouble:(self.delegate.pulse.dutyCycle/self.delegate.pulse.frequency)];
        self.pulseWidthField.text = [self.numberFormatter stringFromNumber:num2];
    
        
        self.pulseTimeSlider.value =
            [self checkFieldValue:self.delegate.pulse.pulseTime
                        withArray:self.pulseTimeStops];
        
        NSNumber *num3 = [NSNumber numberWithDouble:(self.delegate.pulse.pulseTime)];
        self.pulseTimeField.text = [self.numberFormatter stringFromNumber:num3];
        
    }
    //---------------------------- CALIBRATION ---------------------------------
    else if ([view isEqualToString:@"Calibration"])
    {
        
        if (source==@"Slider")
        {
            self.delegate.pulse.ledFreq = self.toneFreqSlider.value;      
            self.delegate.pulse.outputFreq = self.delegate.pulse.ledFreq;
        }
        else if (source==@"Field")
        {
            self.delegate.pulse.ledFreq = 
                [self checkValue:[[self.toneFreqField.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]
                           forMin: self.toneFreqSlider.minimumValue 
                           andMax: self.toneFreqSlider.maximumValue ];
            self.delegate.pulse.outputFreq = self.delegate.pulse.outputFreq;
            
            self.delegate.pulse.calibA = [self.calibAField.text doubleValue];
            self.delegate.pulse.calibB = [self.calibBField.text doubleValue];
            self.delegate.pulse.calibC = [self.calibCField.text doubleValue];
            NSLog(@"calibA: %f calibB: %f calibC: %f", self.delegate.pulse.calibA,
                  self.delegate.pulse.calibB, self.delegate.pulse.calibC);
            NSLog(@"Updated from Field");
        }
        
        self.toneFreqSlider.value = self.delegate.pulse.ledFreq;
        NSNumber *num = [NSNumber numberWithDouble:self.delegate.pulse.ledFreq];
        self.toneFreqField.text = [self.numberFormatter stringFromNumber:num];
    }
}


- (double)checkValue:(double)value forMin:(double)min andMax:(double)max
{
    if (value >= min && value <= max)   { return value; }
    else if (value < min)               { return min;   }
    else                                { return max;   }
}

- (double)checkSliderValue:(double)value withArray:(NSArray *)array
{
    double numStops = array.count;
    double dif = 1;
    int theI = 0;
    for (double i = 0.0f; i < numStops; ++i) {
        
        double thisDif = fabs(value - i/(numStops - 1.0f));
        if (thisDif < dif) {
            dif = thisDif;
            theI = i;
        }
        
    }
    
    return [[array objectAtIndex:theI] doubleValue];
}

- (double)checkFieldValue:(double)value withArray:(NSArray *)array
{
    double dif = value;
    double theI = 0;
    for (int i = 0; i < array.count; ++i) {
        
        double thisDif = fabs(value - [[array objectAtIndex:i] doubleValue]);
        if (thisDif < dif) {
            dif = thisDif;
            theI = i;
        }
        
    }
    
    return (double)(theI/(array.count-1));
}


- (IBAction)sliderMoved:(UISlider *)sender {
	[self updateViewFrom:@"Slider" fromView:self.viewTypeString];
}
- (IBAction)textFieldUpdated:(UITextField *)sender {
    [self updateViewFrom:@"Field" fromView:self.viewTypeString];
}


- (IBAction)toggleConstantTone:(UISwitch *)sender
{
    [self updateViewFrom:@"Slider" fromView:self.viewTypeString];
}

#pragma mark - actions

- (IBAction)showSetup:(id)sender
{
    //Called from Optical ViewController

    [self.ljController  switchToController:self.ljController.calibrationVC];
    
}

- (IBAction)hideSetup:(id)sender
{
    //Called from Calibration ViewController
    
    [self.ljController switchToController:self.ljController.opticalVC];

}

@end
