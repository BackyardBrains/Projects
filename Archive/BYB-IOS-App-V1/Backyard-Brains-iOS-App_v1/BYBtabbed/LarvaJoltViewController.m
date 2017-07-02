//
//  LarvaJoltViewController.m
//  LarvaJolt
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 Zachary King.
//

#import "LarvaJoltViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface LarvaJoltViewController () //private properties

@property (nonatomic,retain) NSNumberFormatter *numberFormatter;
@property (nonatomic,retain) NSTimer *backgroundTimer;
@property double backgroundBlue;

@property (nonatomic,retain) IBOutlet UISlider *frequencySlider;
@property (nonatomic,retain) IBOutlet UISlider *dutyCycleSlider;
@property (nonatomic,retain) IBOutlet UISlider *pulseTimeSlider;
@property (nonatomic,retain) IBOutlet UITextField *frequencyField;
@property (nonatomic,retain) IBOutlet UITextField *pulseWidthField;
@property (nonatomic,retain) IBOutlet UITextField *pulseTimeField;
@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) IBOutlet UIButton *stopButton;

@end


@implementation LarvaJoltViewController

@synthesize delegate;
@synthesize pulse;
@synthesize numberFormatter, backgroundTimer, backgroundBlue;
@synthesize frequencySlider, dutyCycleSlider, pulseTimeSlider;
@synthesize frequencyField, pulseWidthField, pulseTimeField;
@synthesize playButton, stopButton;




// -------------------------------------------------
// Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{
    self.pulseTimeField.enabled = NO;
    self.pulseTimeSlider.enabled = NO;
    self.playButton.enabled = NO;
    self.stopButton.enabled = YES;
    
    self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateBackgroundColor) userInfo:nil repeats:YES];
}
- (void)pulseIsStopped
{
    self.pulseTimeField.enabled = YES;
    self.pulseTimeSlider.enabled = YES;
    self.playButton.enabled = YES;
    self.stopButton.enabled = NO;
    [self.backgroundTimer invalidate];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}

- (void)updateBackgroundColor
{
    double blue = self.backgroundBlue;
    if (blue > 0.0)  
    { 
        blue = fabs(blue) + 0.02;
        self.backgroundBlue = blue;
    }
    else      
    { 
        blue = fabs(blue) - 0.02;
        self.backgroundBlue = blue * -1;
    }
    
    if (blue > 0.5)
    {    
        blue = 0.5;     
        self.backgroundBlue = blue * -1;
    }
    else if (blue < 0.2)    
    {    
        blue = 0.2;   
        self.backgroundBlue = blue;
    }

    self.view.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:blue alpha:1];  
}


// -------------------------------------------------
// Implementation of UITextField delegate protocol.


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.pulseTimeField])
    {
        [self setViewMovedUp:NO];
    }
}


// this helps dismiss the keyboard when the "done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}






// ----------
// Methods


//method to move the view up/down whenever the keyboard is shown/dismissed
#define kOFFSET_FOR_KEYBOARD 110.0

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    NSLog(@"Did move up = %@\n", (movedUp ? @"YES" : @"NO"));
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



- (void)updateViewFrom:(NSString *)source
{	
    if (source==@"Slider")
    {
        self.pulse.frequency = self.frequencySlider.value;
        self.pulse.dutyCycle = self.dutyCycleSlider.value;
        self.pulse.pulseTime = self.pulseTimeSlider.value;
        NSLog(@"Updated from Slider");
    }
    else
    {
        self.pulse.frequency = [self checkValue:[self.frequencyField.text doubleValue]
                                         forMin:self.frequencySlider.minimumValue
                                         andMax:self.frequencySlider.maximumValue ];
        
        self.pulse.dutyCycle =
          [self checkValue:[self.pulseWidthField.text doubleValue] / 1000 * self.pulse.frequency
                         forMin: self.dutyCycleSlider.minimumValue
                         andMax: self.dutyCycleSlider.maximumValue ];
        
        self.pulse.pulseTime = [self checkValue:[self.pulseTimeField.text doubleValue] * 1000
                                             forMin: self.pulseTimeSlider.minimumValue
                                             andMax: self.pulseTimeSlider.maximumValue ];
        
        NSLog(@"Updated from Field");
    }
    
    self.frequencySlider.value = self.pulse.frequency;
	NSNumber *num1 = [NSNumber numberWithDouble:self.pulse.frequency];
	self.frequencyField.text = [self.numberFormatter stringFromNumber:num1];
    
    self.dutyCycleSlider.value = self.pulse.dutyCycle;
    NSNumber *num2 = [NSNumber numberWithDouble:(self.pulse.dutyCycle/self.pulse.frequency*1000)];
	self.pulseWidthField.text = [self.numberFormatter stringFromNumber:num2];
    
    self.pulseTimeSlider.value = self.pulse.pulseTime;
    NSNumber *num3 = [NSNumber numberWithDouble:(self.pulse.pulseTime/1000)];
    self.pulseTimeField.text = [self.numberFormatter stringFromNumber:num3];

}


- (double)checkValue:(double)value forMin:(double)min andMax:(double)max
{
    if (value >= min && value <= max)   { return value; }
    else if (value < min)               { return min; }
    else                                { return max; }
}


- (IBAction)sliderMoved:(UISlider *)sender
{
	[self updateViewFrom:@"Slider"];
}


- (IBAction)textFieldUpdated:(UITextField *)sender
{
    [self updateViewFrom:@"Field"];
}

- (IBAction)playPulse:(id)sender 
{
	[self.pulse playPulse];
}

- (IBAction)stopPulse:(id)sender 
{
	[self.pulse stopPulse];
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate hideLarvaJolt];
}


// ------------------------------------------------------------------------------------------------------------
// Initiation methods and messages from the system
//

- (void)setup
{
	// Initialize and set objects
	self.pulse = [[LarvaJoltAudio alloc] init];
    self.pulse.delegate = self;
    
	self.numberFormatter = [[NSNumberFormatter alloc] init];
	[self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //[self.numberFormatter setMinimumIntegerDigits:1];
    [self.numberFormatter setMaximumFractionDigits:1];
    
    self.backgroundBlue = 0.05;
    
    [self updateViewFrom:@"Slider"];
    NSLog(@"View updated.");
        
	NSLog(@"Setup successful.");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil])) {
		NSLog(@"View initialized.");
		[self setup];
	}
	return self;
}

- (void)awakeFromNib
{
	
	NSLog(@"Awoke from Nib.");
	[super awakeFromNib];
}



-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.pulseTimeField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}



- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
    if ([self.pulseTimeField isFirstResponder] && self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (![self.pulseTimeField isFirstResponder] && self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    //assign delegates of text fields to control keyboard behavior
    self.frequencyField.returnKeyType = UIReturnKeyDone;
    self.frequencyField.delegate = self;
    self.pulseWidthField.returnKeyType = UIReturnKeyDone;
    self.pulseWidthField.delegate = self;
    self.pulseTimeField.returnKeyType = UIReturnKeyDone;
    self.pulseTimeField.delegate = self;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window]; 
    
    //update the output frequency from the settings menu
    [self.pulse updateOutputFreq];
    
    NSLog(@"View will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}






- (void)releaseOutletsAndInstances
{
	//release outlets
	[frequencyField release];
	[pulseWidthField release];
	[pulseTimeField release];
	[frequencySlider release];
	[dutyCycleSlider release];
	[pulseTimeSlider release];
	
	//release instances
	[pulse release];
	[numberFormatter release];
}

- (void)viewDidUnload
{
	[self releaseOutletsAndInstances];
}

- (void)dealloc
{
	[self releaseOutletsAndInstances];
    [super dealloc];
}

@end
