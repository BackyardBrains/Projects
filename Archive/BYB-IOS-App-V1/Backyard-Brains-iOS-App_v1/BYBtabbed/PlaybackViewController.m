//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/6/2011 Added delegate and methods to automatically set the viewing frame.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "PlaybackView.h"
#import "AudioSignalManager.h"
#import "AudioPlaybackManager.h"
#import "math.h"

#import "PlaybackViewController.h"

#define kNumPointsInPlaybackVertexBuffer 32768

@implementation PlaybackViewController

@synthesize playPauseButton;
@synthesize scrubBar, elapsedTimeLabel, remainingTimeLabel;
@synthesize file;
@synthesize pbView;
@synthesize apm;


- (void)dealloc
{
    [super dealloc];
	
	[playPauseButton release];
	[scrubBar release];
    [elapsedTimeLabel release];
    [remainingTimeLabel release];
    
    [pbView release];
    [apm release];

}


# pragma mark - View Controller Events

- (void)viewDidLoad {
	[super viewDidLoad];

	self.pbView = (PlaybackView *)[self view];
    
    self.file = [self.delegate.files objectAtIndex:0];
    
    //grab preferences
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"PlaybackView.plist"];
	self.preferences = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	[self dispersePreferences];		
    
}

- (void)viewWillAppear:(BOOL)animated { //tk move all this to DrawingViewConroller
	[super viewWillAppear:animated];
    

    
    if (self.apm == nil)
        self.apm = [[AudioPlaybackManager alloc] initWithBBFile:self.file];
    self.apm.delegate = self;
    [self.apm grabNewFile];
    
    
    self.pbView.apm = self.apm;
    
    //set x values of vertex buffer
	[self.apm setVertexBufferXRangeFrom:self.pbView.xMin to:self.pbView.xMax];
    
    //Reset wait frames so the view will automatically set the viewing frame
    self.apm.nWaitFrames = 0;
        
	
	[self.pbView startAnimation];
    
	[self updateDataLabels];
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
	[self collectPreferences];
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"ContinuousWaveView.plist"];
	[self.preferences writeToFile:finalPath atomically:YES];
	[self.pbView stopAnimation];
	//[self.apm pausePlayback];
	
	/*if (audioRecorder != nil) {
		if (audioRecorder.isRecording == YES) {
			[self stopRecording:stopButton];
			

		}
	}*/
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self playPause:nil];
}

# pragma mark - IBActions

/*- (IBAction)startPlaying:(UIButton *)sender {
 
 self.apm = [[AudioPlaybackManager alloc] initWithBBFile:self.file];
 [self.apm startPlayback];
 
 }
 
 
 - (IBAction)stopPlaying:(UIButton *)sender {
 [self.apm stopPlayback];
 }
 
 */
- (IBAction)playPause:(UIButton *)sender
{
    [self.apm playPause];
}


- (IBAction)positionInFileChanged:(UISlider *)sender {
	NSLog(@"Position in file changed!");
	[self.apm updateCurrentTimeTo:sender.value];
}


- (void)pushTrigger
{
    
}


# pragma mark - Preference Handling

- (void)dispersePreferences {
	
	// Set the line color
	linecolor_s tmpLineColor;
	NSDictionary *tmpLineColorDict = [NSDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"lineColor"]];
	tmpLineColor.R = (GLfloat)[[tmpLineColorDict valueForKey:@"R"] floatValue];
	tmpLineColor.G = (GLfloat)[[tmpLineColorDict valueForKey:@"G"] floatValue];
	tmpLineColor.B = (GLfloat)[[tmpLineColorDict valueForKey:@"B"] floatValue];
	tmpLineColor.A = (GLfloat)[[tmpLineColorDict valueForKey:@"A"] floatValue];
	self.pbView.lineColor = tmpLineColor;
	
	// Set the grid color
	linecolor_s tmpGridColor;
    tmpLineColorDict = [self.preferences valueForKey:@"gridColor"];
	tmpGridColor.R = (GLfloat)[[tmpLineColorDict valueForKey:@"R"] floatValue];
	tmpGridColor.G = (GLfloat)[[tmpLineColorDict valueForKey:@"G"] floatValue];
	tmpGridColor.B = (GLfloat)[[tmpLineColorDict valueForKey:@"B"] floatValue];
	tmpGridColor.A = (GLfloat)[[tmpLineColorDict valueForKey:@"A"] floatValue];
	self.pbView.gridColor = tmpGridColor;
	
	// Set the limits on what we're drawing
	self.pbView.xMin = -1000*kNumPointsInPlaybackVertexBuffer/self.file.samplingrate;	
	self.pbView.xMax = [[self.preferences valueForKey:@"xMax"] floatValue];
	self.pbView.xBegin = [[self.preferences valueForKey:@"xBegin"] floatValue];
	self.pbView.xEnd = [[self.preferences valueForKey:@"xEnd"] floatValue];
		
	self.pbView.yMin = [[self.preferences valueForKey:@"yMin"] floatValue];    //-5 000 000
	self.pbView.yMax = [[self.preferences valueForKey:@"yMax"] floatValue];    // 5 000 000
	self.pbView.yBegin = [[self.preferences valueForKey:@"yBegin"] floatValue];//-5 000
	self.pbView.yEnd = [[self.preferences valueForKey:@"yEnd"] floatValue];    // 5 000
	
	self.pbView.numHorizontalGridLines = [[self.preferences valueForKey:@"numHorizontalGridLines"] intValue];
	self.pbView.numVerticalGridLines = [[self.preferences valueForKey:@"numVerticalGridLines"] intValue];
	
	self.pbView.showGrid = [[self.preferences valueForKey:@"showGrid"] boolValue];
	
}

- (void)collectPreferences {
	
	
	NSMutableDictionary *preferencesToWrite = [NSMutableDictionary dictionaryWithDictionary:self.preferences];
	
	linecolor_s lineColor = self.pbView.lineColor;
	NSMutableDictionary *tmpLineColorDict = [NSMutableDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"lineColor"]];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.R] forKey:@"R"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.G] forKey:@"G"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.B] forKey:@"B"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.A] forKey:@"A"];
	[preferencesToWrite setValue:tmpLineColorDict forKey:@"lineColor"];
	
	linecolor_s tmpGridColor = self.pbView.gridColor;
	NSMutableDictionary *tmpGridColorDict = [NSMutableDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"gridColor"]];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.R] forKey:@"R"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.G] forKey:@"G"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.B] forKey:@"B"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.A] forKey:@"A"];
	[preferencesToWrite setValue:tmpGridColorDict forKey:@"gridColor"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.xMax] forKey:@"xMax"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.xMin] forKey:@"xMin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.xBegin] forKey:@"xBegin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.xEnd] forKey:@"xEnd"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.yMax] forKey:@"YMax"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.yMin] forKey:@"yMin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.yBegin] forKey:@"yBegin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.yEnd] forKey:@"yEnd"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.numHorizontalGridLines] forKey:@"numHorizontalGridLines"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.pbView.numVerticalGridLines] forKey:@"numVerticalGridLines"];
	
	[preferencesToWrite setValue:[NSNumber numberWithBool:self.pbView.showGrid] forKey:@"showGrid"];
	
	self.preferences = [NSDictionary dictionaryWithDictionary:preferencesToWrite];
	
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;	
}



- (void)updateDataLabels {
	
	NSLog(@"yLabel x: %f, y: %f", self.yUnitsPerDivLabel.frame.origin.x, self.yUnitsPerDivLabel.frame.origin.y);
	// Spin through all the UILabels that we have control of, and make em better.

	float xPerDiv = (self.pbView.xEnd - self.pbView.xBegin)/3.0f;
	float yPerDiv = (self.pbView.yEnd - self.pbView.yBegin)/(4.0f*self.file.gain*kVoltScaleFactor);
	
	self.xUnitsPerDivLabel.text = [NSString stringWithFormat:@"%3.1f ms", xPerDiv];
	self.yUnitsPerDivLabel.text = [NSString stringWithFormat:@"%3.2f mV", yPerDiv];
	
}

#pragma mark - DrawingDataManagerDelegate

- (void)shouldAutoSetFrame
{
     
    //get a frame
    struct wave_s *playbackBuffer = self.apm.vertexBuffer;
    
    float theMax = 0, theMin = 0;
    
    //find limits
    for (int i=0; i<kNumPointsInPlaybackVertexBuffer; i++) {
        
        if (playbackBuffer[i].y > theMax)
            theMax = playbackBuffer[i].y;
        else if (playbackBuffer[i].y < theMin)
            theMin = playbackBuffer[i].y;
        
    }
    
    //Check for zero values
    if (theMax && theMin)
    {
        float newyMax;
        //set the window to 120% of the largest value
        if (fabs(theMax) >= fabs(theMin))
            newyMax = fabs(theMax) * 1.5f;
        else
            newyMax = fabs(theMin) * 1.5f;
    
        if ( -newyMax > self.pbView.yMin & -newyMax < 200) {
            self.pbView.yBegin = -newyMax;
            self.pbView.yEnd   = newyMax;
        }
        
        [self updateDataLabels];

    }
}

#pragma mark - Multitouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event];
	
	float viewWidth  = self.pbView.bounds.size.width;
	float viewHeight = self.pbView.bounds.size.height;
		
	self.pinchChangeInX /= viewWidth;
	self.pinchChangeInY /= viewHeight;
	self.pinchChangeInX *= 2.2f;
	self.pinchChangeInY *= 2.2f;
	
	
	float newxBegin = self.pbView.xBegin - self.pbView.xBegin*self.pinchChangeInX;
	float newyBegin = self.pbView.yBegin - self.pbView.yBegin*self.pinchChangeInY;
	

	
	if ( newyBegin > self.pbView.yMin & newyBegin < 200) {
		self.pbView.yBegin = newyBegin;
		self.pbView.yEnd = -newyBegin;
	}
	
	// Make sure we can't scale the x-axis past the number of collected samples,
	// and also not less than 10 milliseconds
	if ( newxBegin > self.pbView.xMin & newxBegin <= -10) {
		self.pbView.xBegin = newxBegin;
	}
	
	[self updateDataLabels];

	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event];
	//[self.pbView updateMinorGridLines];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event];
}

- (void)showAllLabels {
	[self.xUnitsPerDivLabel setAlpha:1.0];
	[self.yUnitsPerDivLabel setAlpha:1.0];
	pbView.showGrid = YES;
}

- (void)hideAllLabels {
	[self.xUnitsPerDivLabel setAlpha:0.0];
	[self.yUnitsPerDivLabel setAlpha:0.0];
	pbView.showGrid = NO;
}

- (void)toggleVisibilityOfLabelsAndGrid {
	if (pbView.showGrid == YES) {
		[self hideAllLabels];
	}
	
	else {
		[self showAllLabels];
	}
}





@end
