//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/6/2011 Added delegate and methods to automatically set the viewing frame.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "TriggerViewController.h"

@implementation TriggerViewController

@synthesize triggerValueLabel;
@synthesize numAveragesButton;
@synthesize numAveragesSlider;
@synthesize numAveragesLabel;
@synthesize audioSignalManager;

@synthesize triggerView;
@synthesize toolbar;


- (void)dealloc {	
		
	[triggerValueLabel release];
	[numAveragesButton release];
	[numAveragesSlider release];
	[numAveragesLabel release];
	[audioSignalManager release];
    [toolbar release];
	
	[super dealloc];

}



- (IBAction)toggleSliderVisiblity:(UIButton *)sender {
	BOOL isHidden = self.numAveragesSlider.hidden;
	self.numAveragesSlider.hidden = !isHidden;
}

- (IBAction)updateNumTriggerAverages:(UISlider *)sender {
	self.numAveragesLabel.text = [NSString stringWithFormat:@"%dx avg", (int)sender.value];
    [self resetNumTriggerAveragesTo:(int)sender.value];
}

- (void)resetNumTriggerAveragesTo:(int)num
{
    
	triggeredSegmentHistory *th = self.audioSignalManager.triggerSegmentData;
	// Zero out all the old segments
	memset(th, 0, sizeof(th));
	for (int i=0; i < kNumPointsInVertexBuffer; ++i) {
		self.audioSignalManager.vertexBuffer[i].y = 0.0f;
	}
	
    if (num)
        th->sizeOfMovingAverage = num;
    // if num is 0, keep the same moving average
    
    th->movingAverageIncrement = 1;
    
}


-(void)awakeFromNib {
	[super awakeFromNib];
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"TriggerView.plist"];
	self.preferences = [NSDictionary dictionaryWithContentsOfFile:finalPath];
//	self.audioSignalManager = [[AudioSignalManager alloc] initWithCallbackType:kAudioCallbackSingleShotTrigger];
}


- (void)viewDidLoad {
	[super viewDidLoad];
    
    //Keep both of these around. DDM for the superclass, ASM for self
    self.drawingDataManager = self.delegate.drawingDataManager;
	self.audioSignalManager = (AudioSignalManager *)self.drawingDataManager;
    
	NSLog(@"View did load");
	self.triggerView = (TriggerView *)[self view];
	
	[self dispersePreferences];	
}

- (void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
	
	[self.audioSignalManager changeCallbackTo:kAudioCallbackAverageTrigger];
	
	self.triggerView.audioSignalManager = self.audioSignalManager;
    self.audioSignalManager.delegate = self;
	[self.triggerView.audioSignalManager setVertexBufferXRangeFrom:self.triggerView.xMin to:self.triggerView.xMax];
	self.audioSignalManager.triggering = YES;
	[self.audioSignalManager play];
	
    //Reset wait frames so the view will automatically set the viewing frame
    self.audioSignalManager.nWaitFrames = 0;
    self.audioSignalManager.nTrigWaitFrames = 0;
	
	[self updateDataLabels];
	
	UInt32 numDashes = kNumDashesInVerticalTriggerLine;
	self.triggerView.gridVertexBuffer = (struct wave_s *)malloc(2*(self.triggerView.numHorizontalGridLines+self.triggerView.numVerticalGridLines)*sizeof(struct wave_s));
	self.triggerView.thresholdLine = (struct wave_s *)malloc( (2+numDashes) * sizeof(struct wave_s));
	

	float centerViewValue = (triggerView.xEnd + triggerView.xBegin)/2.0;
	float shiftViewAmount = (triggerView.xMin - triggerView.xMax)/2.0f - centerViewValue;
	
	triggerView.xBegin += shiftViewAmount;
	triggerView.xEnd += shiftViewAmount;
	
	[self.triggerView startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self collectPreferences];
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"TriggerView.plist"];
	BOOL err = [self.preferences writeToFile:finalPath atomically:YES];
	NSLog(@"Wrote prefernces to file. Successful? %d", err);
	[self.triggerView stopAnimation];
    
    //NOTE: ContinuousWaveView viewWillAppear is called BEFORE viewWillDissappear
    //SO...cover all exits. pause if a view is requested that is not CW.
    if (self.audioSignalManager.delegate == self) //only true is CW was not opened
        [self.audioSignalManager pause];
}

- (void)dispersePreferences {
	// Set the line color
	linecolor_s tmpLineColor;
	NSDictionary *tmpLineColorDict = [NSDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"lineColor"]];
	tmpLineColor.R = (GLfloat)[[tmpLineColorDict valueForKey:@"R"] floatValue];
	tmpLineColor.G = (GLfloat)[[tmpLineColorDict valueForKey:@"G"] floatValue];
	tmpLineColor.B = (GLfloat)[[tmpLineColorDict valueForKey:@"B"] floatValue];
	tmpLineColor.A = (GLfloat)[[tmpLineColorDict valueForKey:@"A"] floatValue];
	self.triggerView.lineColor = tmpLineColor;
	
	// Set the grid color
	linecolor_s tmpGridColor;
    tmpLineColorDict = [self.preferences valueForKey:@"gridColor"];
	tmpGridColor.R = (GLfloat)[[tmpLineColorDict valueForKey:@"R"] floatValue];
	tmpGridColor.G = (GLfloat)[[tmpLineColorDict valueForKey:@"G"] floatValue];
	tmpGridColor.B = (GLfloat)[[tmpLineColorDict valueForKey:@"B"] floatValue];
	tmpGridColor.A = (GLfloat)[[tmpLineColorDict valueForKey:@"A"] floatValue];
	self.triggerView.gridColor = tmpGridColor;
	
	// Set the limits on what we're drawing
	self.triggerView.xMin = -1000*kNumPointsInVertexBuffer/self.audioSignalManager.samplingRate;
	self.triggerView.xMax = [[self.preferences valueForKey:@"xMax"] floatValue];
	self.triggerView.xBegin = [[self.preferences valueForKey:@"xBegin"] floatValue];
	self.triggerView.xEnd = [[self.preferences valueForKey:@"xEnd"] floatValue];
	
	self.triggerView.yMin = [[self.preferences valueForKey:@"yMin"] floatValue];
	self.triggerView.yMax = [[self.preferences valueForKey:@"yMax"] floatValue];	
	self.triggerView.yBegin = [[self.preferences valueForKey:@"yBegin"] floatValue];
	self.triggerView.yEnd = [[self.preferences valueForKey:@"yEnd"] floatValue];
	
	self.triggerView.numHorizontalGridLines = [[self.preferences valueForKey:@"numHorizontalGridLines"] intValue];
	self.triggerView.numVerticalGridLines = [[self.preferences valueForKey:@"numVerticalGridLines"] intValue];
	
	self.triggerView.showGrid = [[self.preferences valueForKey:@"showGrid"] boolValue];
	
	self.triggerView.middleOfWave = (self.triggerView.xMin-self.triggerView.xMax)/2.0f;
	
}

- (void)collectPreferences {
	
	NSMutableDictionary *preferencesToWrite = [NSMutableDictionary dictionaryWithDictionary:self.preferences];
	
	linecolor_s lineColor = self.triggerView.lineColor;
	NSMutableDictionary *tmpLineColorDict = [NSMutableDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"lineColor"]];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.R] forKey:@"R"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.G] forKey:@"G"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.B] forKey:@"B"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.A] forKey:@"A"];
	[preferencesToWrite setValue:tmpLineColorDict forKey:@"lineColor"];
	
	linecolor_s tmpGridColor = self.triggerView.gridColor;
	NSMutableDictionary *tmpGridColorDict = [NSMutableDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"gridColor"]];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.R] forKey:@"R"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.G] forKey:@"G"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.B] forKey:@"B"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.A] forKey:@"A"];
	[preferencesToWrite setValue:tmpGridColorDict forKey:@"gridColor"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.xMax] forKey:@"xMax"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.xMin] forKey:@"xMin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.xBegin] forKey:@"xBegin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.xEnd] forKey:@"xEnd"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.yMax] forKey:@"YMax"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.yMin] forKey:@"yMin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.yBegin] forKey:@"yBegin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.yEnd] forKey:@"yEnd"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.numHorizontalGridLines] forKey:@"numHorizontalGridLines"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.triggerView.numVerticalGridLines] forKey:@"numVerticalGridLines"];
	
	[preferencesToWrite setValue:[NSNumber numberWithBool:self.triggerView.showGrid] forKey:@"showGrid"];
	
	self.preferences = [NSDictionary dictionaryWithDictionary:preferencesToWrite];
	
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"FUUUUUUUUUUUUUCK");
	// Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;	
}



- (void)updateDataLabels {
	// Spin through all the UILabels that we have control of, and make 'em better.
	float xPerDiv = (self.triggerView.xEnd - self.triggerView.xBegin)/3.0f;
	float yPerDiv = (self.triggerView.yEnd - self.triggerView.yBegin)/(4.0f*self.audioSignalManager.gain*kVoltScaleFactor);
    
	NSLog(@"yEnd: %f, yBegin: %f, gain %f, yPerDiv: %f", self.triggerView.yEnd, self.triggerView.yBegin, self.audioSignalManager.gain, yPerDiv);
	
	self.xUnitsPerDivLabel.text = [NSString stringWithFormat:@"%3.1f ms", xPerDiv];
	self.yUnitsPerDivLabel.text = [NSString stringWithFormat:@"%3.2f mV", yPerDiv];
	
}



#pragma mark - DrawingDataManagerDelegate

- (void)shouldAutoSetFrame
{
    
    //get a frame
    ringBuffer *secondStageBuffer = self.audioSignalManager.secondStageBuffer;
    
    float theMax = 0, theMin = 0;
    
    //find limits
    for (int i=0; i<secondStageBuffer->sizeOfBuffer; i++) {
        
        if (secondStageBuffer->data[i] > theMax)
            theMax = secondStageBuffer->data[i];
        else if (secondStageBuffer->data[i] < theMin)
            theMin = secondStageBuffer->data[i];
        
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
        
        if ( -newyMax > self.triggerView.yMin & -newyMax < 200) {
            self.triggerView.yBegin = -newyMax;
            self.triggerView.yEnd   = newyMax;
            
            audioSignalManager.thresholdValue = newyMax * 0.7f;
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
	
	if ([self.currentTouches count] == 1) {
		[self handleSingleTouchForTriggerView];
	}
	else if ([self.currentTouches count] == 2) {
		[self handlePinchingForTriggerView];
	}
	
    [self updateDataLabels];

	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event];
}

#pragma mark - Specialty Touch-handling functions

- (void)handleSingleTouchForTriggerView {
	
	float minDistanceToControlTrigger = 0.1;
	
	// Gather up information about the current and previous touch locations, 
	// in GL coordinates and normalized ( range = (0,1), origin = bottom left) coordinates
	CGPoint pointOne = [self getXYCoordinatesOfTouch:0];
	CGPoint initialGLPoint = [self translateScreenCoordinatesToOpenGLCoordinates:self.lastPointOne];
	CGPoint thisGLPoint = [self translateScreenCoordinatesToOpenGLCoordinates:pointOne];
	CGPoint initialNormalizedPoint = [self translateScreenCoordinatesToNormalizedCoordinates:self.lastPointOne];
	
	CGPoint triggerGLPoint;
	triggerGLPoint.x = self.triggerView.middleOfWave;
	triggerGLPoint.y = audioSignalManager.thresholdValue;
	CGPoint triggerNormalizedPoint = [self translateOpenGLCoordinatesToNormalizedCoordinates:triggerGLPoint];
	
	// If the touch is within some distance of the trigger line,
	// then we're controlling the trigger and x-axis
	if (fabs(triggerNormalizedPoint.y - initialNormalizedPoint.y) < minDistanceToControlTrigger) {
		audioSignalManager.thresholdValue = thisGLPoint.y;
		float deltaGLXCoord = initialGLPoint.x - thisGLPoint.x;
		if (triggerView.xBegin - deltaGLXCoord < self.triggerView.middleOfWave & triggerView.xEnd - deltaGLXCoord > self.triggerView.middleOfWave) {
			triggerView.xBegin -= deltaGLXCoord;
			triggerView.xEnd -= deltaGLXCoord;
		}
		
		self.lastPointOne = pointOne;
		
		//Now reset the averaging
        [self resetNumTriggerAveragesTo:0]; //0 to keep the current value
		
	}
	/*else { //Uncomment to enable side-to-side translation

		// Find the amount of pinching change relative to the screen size
		float viewWidth  = self.triggerView.bounds.size.width;
		float viewHeight = self.triggerView.bounds.size.height;
		
		self.changeInX /= viewWidth;
		self.changeInY /= viewHeight;
		
		if ( fabs(self.changeInX) > 0.1 ) {
			self.changeInX = 0.0;
		}
		
		if ( fabs(self.changeInY) > 0.1 ) {
			self.changeInY = 0.0;
		}
		
		// Find new locations
		float totalWidthDisplayed = (triggerView.xEnd - triggerView.xBegin);
		float deltaX = totalWidthDisplayed*self.changeInX;
		float newxBegin = self.triggerView.xBegin + deltaX;
		float newxEnd = self.triggerView.xEnd + deltaX;

		totalWidthDisplayed = (triggerView.yEnd - triggerView.yBegin);
		//float deltaY = totalWidthDisplayed*self.changeInY;
		//float newyBegin = self.triggerView.yBegin - deltaY;
		//float newyEnd = self.triggerView.yEnd - deltaY;
		
		// Make sure we can't scale the x-axis past the number of collected samples,
		// and also not less than 10 milliseconds
		BOOL beginIsGreaterThanMin = newxBegin > self.triggerView.xMin;
		BOOL endIsLessThanMax = newxEnd < self.triggerView.xMax;
		BOOL beginIsBeforeTrigger = newxBegin < self.triggerView.middleOfWave;
		BOOL endIsAftertrigger = newxEnd > self.triggerView.middleOfWave;
		
		if ( beginIsGreaterThanMin & endIsLessThanMax & beginIsBeforeTrigger & endIsAftertrigger ) {
			self.triggerView.xBegin = newxBegin;
			self.triggerView.xEnd = newxEnd;
		}
		
		//beginIsGreaterThanMin = newyBegin > self.triggerView.yMin;
		//endIsLessThanMax = newyEnd < self.triggerView.yMax;
		//beginIsBeforeTrigger = newyBegin < self.audioSignalManager.thresholdValue;
		//endIsAftertrigger = newyEnd > self.audioSignalManager.thresholdValue;
		
	}*/
}

- (void)handlePinchingForTriggerView {

	// Find the amount of pinching change relative to the screen size
	float viewWidth  = self.triggerView.bounds.size.width;
	float viewHeight = self.triggerView.bounds.size.height;
	
	self.pinchChangeInX /= viewWidth;
	self.pinchChangeInY /= viewHeight;
	self.pinchChangeInX *= 2.2f; // scale it. feels slow otherwise.
	self.pinchChangeInY *= 2.2f;
	
	// Find the center location of the pinching fingers in (0,1) coordinates
	// (We're going to scale the screen relative to the pinch center)
	
	// Find new locations
	float distFromMiddleBegin = (triggerView.middleOfWave - triggerView.xBegin);
	float distFromMiddleEnd = (triggerView.middleOfWave - triggerView.xEnd);
	float deltaXBegin = distFromMiddleBegin*self.pinchChangeInX;
	float deltaXEnd = distFromMiddleEnd*self.pinchChangeInX;
	float newxBegin = self.triggerView.xBegin + deltaXBegin;
	float newxEnd = self.triggerView.xEnd + deltaXEnd;
	
	
	float newyBegin = self.triggerView.yBegin - self.triggerView.yBegin*self.pinchChangeInY;
	float newyEnd = self.triggerView.yEnd - self.triggerView.yEnd*self.pinchChangeInY;
	float newTrigger = self.audioSignalManager.thresholdValue - self.audioSignalManager.thresholdValue*self.pinchChangeInY;
	
	// Make sure we can't scale the x-axis past the number of collected samples,
	// and also not less than 10 milliseconds
	BOOL beginIsGreaterThanMin = newxBegin > self.triggerView.xMin;
	BOOL endIsLessThanMax = newxEnd < self.triggerView.xMax;
	BOOL beginIsBeforeTrigger = newxBegin < self.triggerView.middleOfWave;
	BOOL endIsAftertrigger = newxEnd > self.triggerView.middleOfWave;
	
	if ( beginIsGreaterThanMin & endIsLessThanMax & beginIsBeforeTrigger & endIsAftertrigger ) {
		self.triggerView.xBegin = newxBegin;
		self.triggerView.xEnd = newxEnd;
	}
	
	beginIsGreaterThanMin = newyBegin > self.triggerView.yMin;
	endIsLessThanMax = newyEnd < self.triggerView.yMax;
	beginIsBeforeTrigger = newyBegin < self.audioSignalManager.thresholdValue;
	endIsAftertrigger = newyEnd > self.audioSignalManager.thresholdValue;
		
	if ( beginIsGreaterThanMin & endIsLessThanMax & beginIsBeforeTrigger & endIsAftertrigger ) {
		self.triggerView.yBegin = newyBegin;
		self.triggerView.yEnd = newyEnd;
		self.audioSignalManager.thresholdValue = newTrigger;
	}	
	
}


#pragma mark Specialty Helper Functions 

- (CGPoint)getXYCoordinatesOfTouch:(int)touchID {
	NSAssert(touchID < 5, @"That's just stupid. Can't have more than 5 touches, dummy");
	UITouch *touch = [[self.currentTouches allObjects] objectAtIndex:touchID];
	return [touch locationInView:self.view];
}

// TODO: general multitouch handlers


- (CGPoint)translateOpenGLCoordinatesToNormalizedCoordinates:(CGPoint)point {
	float normalizedXCoord = (point.x - triggerView.xBegin)/(triggerView.xEnd - triggerView.xBegin);
	float normalizedYCoord = (point.y - triggerView.yBegin)/(triggerView.yEnd - triggerView.yBegin);
	CGPoint outpoint;
	outpoint.x = normalizedXCoord;
	outpoint.y = normalizedYCoord;
	return outpoint;
}

- (CGPoint)translateScreenCoordinatesToOpenGLCoordinates:(CGPoint)point {	
	float viewWidth = self.triggerView.bounds.size.width;
	float normalizedXCoord = 1 - point.x/viewWidth; // coordinate mapped to (0,1) in x-range
	float GLXCoord = normalizedXCoord*(triggerView.xEnd - triggerView.xBegin) + triggerView.xBegin;
	
	
	float viewHeight = self.triggerView.bounds.size.height;
	float normalizedYCoord = 1 - point.y/viewHeight; // coordinate mapped to (0,1) in y-range
	float GLYCoord = normalizedYCoord*(triggerView.yEnd - triggerView.yBegin) + triggerView.yBegin;
	
	CGPoint outpoint;
	outpoint.x = GLXCoord;
	outpoint.y = GLYCoord;
	
	return outpoint;
}

- (CGPoint)translateScreenCoordinatesToNormalizedCoordinates:(CGPoint)point {
	float viewWidth = self.triggerView.bounds.size.width;
	float normalizedXCoord = point.x/viewWidth; // coordinate mapped to (0,1) in x-range, left = 0
	
	
	float viewHeight = self.triggerView.bounds.size.height;
	float normalizedYCoord = 1 - point.y/viewHeight; // coordinate mapped to (0,1) in y-range, bottom = 0
	
	CGPoint outpoint;
	outpoint.x = normalizedXCoord;
	outpoint.y = normalizedYCoord;
	
	return outpoint;
}



- (void)showAllLabels {
	[self.xUnitsPerDivLabel setAlpha:1.0];
	[self.yUnitsPerDivLabel setAlpha:1.0];
	triggerView.showGrid = YES;
}

- (void)hideAllLabels {
	[self.xUnitsPerDivLabel setAlpha:0.0];
	[self.yUnitsPerDivLabel setAlpha:0.0];
	triggerView.showGrid = NO;
}

- (void)toggleVisibilityOfLabelsAndGrid {
	if (triggerView.showGrid == YES) {
		[self hideAllLabels];
	}
	
	else {
		[self showAllLabels];
	}
}



#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
    NSMutableArray *itemsArray = [self.toolbar.items mutableCopy];
    [itemsArray insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    NSMutableArray *itemsArray = [self.toolbar.items mutableCopy];
    [itemsArray removeObject:barButtonItem];
    [self.toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}



@end
