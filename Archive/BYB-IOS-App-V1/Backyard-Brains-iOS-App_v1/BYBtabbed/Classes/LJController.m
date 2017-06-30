//
//  LJController.m
//  Backyard Brains
//
//  Created by Zachary King on 12/9/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import "LJController.h"
#import "ToneStimViewController.h"
#import "iPodStimViewController.h"


@implementation LJController

@synthesize delegate            = _delegate;

@synthesize backgroundBlue      = _backgroundBlue;

@synthesize backgroundTimer     = _backgroundTimer;
@synthesize playButton          = _playButton;
@synthesize stopButton          = _stopButton;
@synthesize segmentedControl    = _segmentedControl;
@synthesize pleaseRotateLabel   = _pleaseRotateLabel;
@synthesize rotateLeftView      = _rotateLeftView;
@synthesize rotateRightView     = _rotateRightView;
@synthesize toneVC              = _toneVC;
@synthesize pulseVC             = _pulseVC;
@synthesize iPodVC              = _iPodVC;
@synthesize opticalVC           = _opticalVC;
@synthesize calibrationVC       = _calibrationVC;
@synthesize currentController   = _currentController;

@synthesize theContainerView    = _theContainerView;


#pragma mark - view lifecycle

- (void)dealloc
{
    [super dealloc];
    
    [_playButton release];
    [_stopButton release];
    [_backgroundTimer release];
    [_toneVC release];
    [_pulseVC release];
    [_iPodVC release];
    [_opticalVC release];
    [_calibrationVC release];
    [_currentController release];
    [_theContainerView release];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self setup];
    }
    return self;
}

- (id)init
{
    if (self=[super init])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // Initialize and set objects
    if (self.toneVC==nil)
    {
        self.toneVC = [[ToneStimViewController alloc]
                       initWithNibName:@"ToneStimView" bundle:nil];
        self.toneVC.viewTypeString = @"Tone";        
    }
    if (self.pulseVC==nil)
    {
        self.pulseVC = [[ToneStimViewController alloc] initWithNibName:@"PulseStimView" bundle:nil];
        self.pulseVC.viewTypeString = @"Pulse";
    }
    if (self.opticalVC==nil)
    {
        self.opticalVC = [[ToneStimViewController alloc]
                          initWithNibName:@"OpticalStimView" bundle:nil];
        self.opticalVC.viewTypeString = @"Optical";
    }
    if (self.iPodVC==nil)
    {
        self.iPodVC = [[iPodStimViewController alloc]
                       initWithNibName:@"iPodStimView" bundle:nil];        
    }
    if (self.calibrationVC==nil)
    {
        self.calibrationVC = [[ToneStimViewController alloc]
                              initWithNibName:@"LJCalibrationView" bundle:nil];
        self.calibrationVC.viewTypeString = @"Calibration";        
    }
    
    
    
    self.backgroundBlue = 0.05;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

    self.delegate.pulse.delegate = self;
    
    if ([self.delegate.pulse playing])
        [self pulseIsPlaying];
    else
        [self pulseIsStopped];
    
    [self.currentController viewWillAppear:animated];
    
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    [self willRotateToInterfaceOrientation:orientation duration:0];
    
    NSLog(@"View will appear");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.toneVC.delegate        = self.delegate;
    self.toneVC.ljController    = self;
    self.pulseVC.delegate       = self.delegate;
    self.pulseVC.ljController   = self;
    self.opticalVC.delegate     = self.delegate;
    self.opticalVC.ljController = self;
    self.iPodVC.delegate        = self.delegate;
    self.iPodVC.ljController    = self;
    self.calibrationVC.delegate = self.delegate;
    self.calibrationVC.ljController    = self;




    [self switchToController:self.toneVC];
    
}


#pragma mark - Implementation of LarvaJoltAudio delegate protocol.


- (void)pulseIsPlaying
{    
    if (![self.backgroundTimer isValid])
        self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateBackgroundColor) userInfo:nil repeats:YES];
    
    self.playButton.enabled = NO;
    self.stopButton.enabled = YES;
    
    [(id <LarvaJoltAudioDelegate>)self.currentController pulseIsPlaying];
}

- (void)pulseIsStopped
{
    if ([self.backgroundTimer isValid])
        [self.backgroundTimer invalidate];
    UIColor *thisBlack =  [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.view.backgroundColor = thisBlack;
    self.currentController.view.backgroundColor = thisBlack;
    
    self.playButton.enabled = YES;
    self.stopButton.enabled = NO;
    
    [(id <LarvaJoltAudioDelegate>)self.currentController pulseIsStopped];
}

#pragma mark - segmented control

- (IBAction)selectorSelected:(UISegmentedControl *)segmentedControl
{
    NSString *selectedOption =
        [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    if ([selectedOption isEqualToString:@"Tone"])
        [self switchToController:(UIViewController *)self.toneVC];
    else if ([selectedOption isEqualToString:@"Pulse"])
        [self switchToController:(UIViewController *)self.pulseVC];
    else if ([selectedOption isEqualToString:@"iPod"])
        [self switchToController:(UIViewController *)self.iPodVC];
    else if ([selectedOption isEqualToString:@"Optical"])
        [self switchToController:(UIViewController *)self.opticalVC];
    else if ([selectedOption isEqualToString:@"Setup"])
        [self switchToController:(UIViewController *)self.calibrationVC];
    else if ([selectedOption isEqualToString:@"Pulse"])
        return;
}

- (void)switchToController:(UIViewController *)newCtl
{
    if(newCtl == self.currentController)
        return;
    
    if([self.currentController isViewLoaded])
        [self.currentController.view removeFromSuperview];
    
    if(newCtl != nil)
    {
        [self.theContainerView addSubview:newCtl.view];
        [self.theContainerView bringSubviewToFront:newCtl.view];
    }
    
    self.currentController = newCtl;
    
    [newCtl viewWillAppear:YES];
}

#pragma mark - methods

- (IBAction)playPulse:(id)sender 
{
	[self.delegate.pulse playPulse];
}

- (IBAction)stopPulse:(id)sender 
{
	[self.delegate.pulse stopPulse];
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
    
    UIColor *thisBlue = [UIColor colorWithRed:0.05 green:0.05 blue:blue alpha:1];  
    self.view.backgroundColor = thisBlue;
    self.currentController.view.backgroundColor = thisBlue;
}

#pragma mark - rotation


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // on iPhone, must be in portrait to edit stim options
    
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait) 
        {
            if (self.currentController ==nil)
                [self switchToController:self.toneVC];
            
            self.segmentedControl.enabled = YES;
            self.pleaseRotateLabel.hidden = YES;
            
        }
        else 
        {
            [self switchToController:nil];
            
            self.segmentedControl.enabled = NO;
            if (self.pleaseRotateLabel == nil)
            {
                CGRect frame = CGRectMake(0, 0, 0, 0);
                CGRect screenFrame = [[UIScreen mainScreen] bounds];
                frame.size.width = screenFrame.size.height;
                frame.size.height = screenFrame.size.width;
                self.pleaseRotateLabel = [[UILabel alloc] initWithFrame:frame];
                [self.pleaseRotateLabel setText:@"Rotate to access stim settings"];
                [self.pleaseRotateLabel setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.2 alpha:0.9]];
                [self.pleaseRotateLabel setFont:[UIFont systemFontOfSize:30.0f]];
                [self.pleaseRotateLabel setTextColor:[UIColor whiteColor]];
                [self.pleaseRotateLabel setTextAlignment:UITextAlignmentCenter];
                [self.view addSubview:self.pleaseRotateLabel];
            }
            self.pleaseRotateLabel.hidden = NO;
            
            if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                if (self.rotateRightView == nil)
                {
                    self.rotateRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rotate-left.png"]];
                    CGRect imgFrame = CGRectMake(self.pleaseRotateLabel.frame.size.width/2 - 32, 50, 64, 64);
                    [self.rotateRightView setFrame:imgFrame];
                    [self.pleaseRotateLabel addSubview:self.rotateRightView];
                }
                self.rotateRightView.hidden = NO;
                self.rotateLeftView.hidden = YES;
            }
            else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                if (self.rotateLeftView == nil)
                {
                    self.rotateLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rotate-right.png"]];
                    CGRect imgFrame = CGRectMake(self.pleaseRotateLabel.frame.size.width/2 - 32, 50, 64, 64);
                    [self.rotateLeftView setFrame:imgFrame];
                    [self.pleaseRotateLabel addSubview:self.rotateLeftView];
                }
                self.rotateLeftView.hidden = NO;
                self.rotateRightView.hidden = YES;
            }
        }
    }
    
    
}

@end
