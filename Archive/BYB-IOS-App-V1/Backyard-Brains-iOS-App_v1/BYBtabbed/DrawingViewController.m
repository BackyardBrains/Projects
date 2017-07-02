//	Abstract superclass defining basic functionality needed
//	to draw some data to the screen, under control of an EAGLView instance.
//
//

#import "DrawingDataManager.h"
#import "BBFileViewControllerTBV.h"

#import "DrawingViewController.h"

@implementation DrawingViewController


@synthesize lastPointOne            = _lastPointOne;
@synthesize lastPointTwo            = _lastPointTwo;
@synthesize firstPointOne           = _firstPointOne;
@synthesize firstPointTwo           = _firstPointTwo;
@synthesize pinchChangeInX          = _pinchChangeInX;
@synthesize pinchChangeInY          = _pinchChangeInY;
@synthesize changeInX               = _changeInX;
@synthesize changeInY               = _changeInY;
@synthesize showGrid                = _showGrid;   

@synthesize drawingDataManager      = _drawingDataManager;
@synthesize glView                  = _glView;
@synthesize currentTouches          = _currentTouches;
@synthesize tickMarks               = _tickMarks;
@synthesize infoButton              = _infoButton;
@synthesize xUnitsPerDivLabel       = _xUnitsPerDivLabel;
@synthesize yUnitsPerDivLabel       = _yUnitsPerDivLabel;
@synthesize msLegendImage           = _msLegendImage;
@synthesize preferences             = _preferences;

@synthesize thePopoverController    = _thePopoverController;

@synthesize delegate;



- (void)dealloc {
	[_drawingDataManager release];
	[_glView release];
	[_currentTouches release];
	[_tickMarks release];
	[_infoButton release];
	[_xUnitsPerDivLabel release];
	[_yUnitsPerDivLabel release];
	[_msLegendImage release];
	[_preferences release];
    
    [_thePopoverController release];
	
	[super dealloc];

}


- (void)viewDidLoad {
	[super viewDidLoad];
    
    //make sure tick marks and scale bars change size with rotation
	self.tickMarks.contentMode = UIViewContentModeScaleAspectFit;
	self.msLegendImage.contentMode = UIViewContentModeScaleAspectFit;
    
	/*
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didRotate:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];*/

	// Preallocate the NSMutableSet tracking touches
	self.currentTouches = [[NSMutableSet alloc] initWithCapacity:2];
	
}


/*-(void)didRotate:(NSNotification *)theNotification {
	[self fitViewToCurrentOrientation];
}


- (void)fitViewToCurrentOrientation {
	
	NSLog(@"=== Fitting view to current orienatation ===");
	UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
	
	if ( (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) | (interfaceOrientation == UIInterfaceOrientationLandscapeRight) ) {
		[self fitTickMarksToLandscape];
		
	}
	
	else if ( (interfaceOrientation == UIInterfaceOrientationPortrait) )  {
		[self fitTickMarksToPortrait];
	}
	
}*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return YES;
	}
	
	return NO;
}
/*
- (void)fitTickMarksToPortrait {
	NSLog(@"Fitting tick marks to portrait");
	
    int tickMarkHeight, msFrameWidth, mVLabelYPos;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // The device is an iPad running iOS 3.2 or later.
        //tickMarkHeight = kPortraitHeightWithTabBar_iPad;
        msFrameWidth = 262;
        mVLabelYPos = -63;// hand-coded location, this is what looks good
    }
    else {
        //tickMarkHeight = kPortraitHeightWithTabBar;
        msFrameWidth = 107;
        mVLabelYPos = -63;
    }
    
    //Interface builder takes care of this
	// Resize the tick marks
	CGRect frame = tickMarks.frame;
	frame.size.height = tickMarkHeight;
	tickMarks.frame = frame;
	
    //
	// Resize the millisecond frame
	CGRect frame = self.msLegendImage.frame;
    frame.size.width = msFrameWidth;
	self.msLegendImage.frame = frame;
	
	// Reposition the millivolt label
	CGRect frame = yUnitsPerDivLabel.frame;
	frame.origin.y = mVLabelYPos; 
	yUnitsPerDivLabel.frame = frame;
	
	[self.view setNeedsDisplay];
}


- (void)fitTickMarksToLandscape {
	NSLog(@"Fitting tick marks to landscape");
    
    //int tickMarkHeight;
    int msFrameWidth, mVLabelYPos;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // The device is an iPad running iOS 3.2 or later.
        //tickMarkHeight = kLandscapeHeightWithTabBar_iPad;
        msFrameWidth = 341;
        mVLabelYPos = -16;
    }
    else {
        //tickMarkHeight = kLandscapeHeightWithTabBar;
        msFrameWidth = 160;
        mVLabelYPos = -16;
    }
    
    //  Interface builder takes care of this
	// Resize the tick marks
	CGRect frame = tickMarks.frame;
	frame.size.height = tickMarkHeight;
	tickMarks.frame = frame;
    
    
	// Resize the millisecond frame
	CGRect frame = self.msLegendImage.frame;
    frame.size.width = msFrameWidth;
	self.msLegendImage.frame = frame;
	
	// Reposition the millivolt label
	CGRect frame = yUnitsPerDivLabel.frame;
	frame.origin.y = mVLabelYPos; 
	yUnitsPerDivLabel.frame = frame;	
	
	[self.view setNeedsDisplay];
}*/



- (void)dispersePreferences {
	
	// Set the line color
	linecolor_s tmpLineColor;
	NSDictionary *tmpLineColorDict = [NSDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"lineColor"]];
	tmpLineColor.R = (GLfloat)[[tmpLineColorDict valueForKey:@"R"] floatValue];
	tmpLineColor.G = (GLfloat)[[tmpLineColorDict valueForKey:@"G"] floatValue];
	tmpLineColor.B = (GLfloat)[[tmpLineColorDict valueForKey:@"B"] floatValue];
	tmpLineColor.A = (GLfloat)[[tmpLineColorDict valueForKey:@"A"] floatValue];
	self.glView.lineColor = tmpLineColor;
	
	// Set the grid color
	linecolor_s tmpGridColor;
	tmpLineColorDict = [self.preferences valueForKey:@"gridColor"];
	tmpGridColor.R = (GLfloat)[[tmpLineColorDict valueForKey:@"R"] floatValue];
	tmpGridColor.G = (GLfloat)[[tmpLineColorDict valueForKey:@"G"] floatValue];
	tmpGridColor.B = (GLfloat)[[tmpLineColorDict valueForKey:@"B"] floatValue];
	tmpGridColor.A = (GLfloat)[[tmpLineColorDict valueForKey:@"A"] floatValue];
	self.glView.gridColor = tmpGridColor;
	
	// Set the limits on what we're drawing
	self.glView.xMin = -1000*kNumPointsInVertexBuffer/self.drawingDataManager.samplingRate;
	self.glView.xMax = [[self.preferences valueForKey:@"xMax"] floatValue];
	self.glView.xBegin = [[self.preferences valueForKey:@"xBegin"] floatValue];
	self.glView.xEnd = [[self.preferences valueForKey:@"xEnd"] floatValue];
	
	self.glView.yMin = [[self.preferences valueForKey:@"yMin"] floatValue];
	self.glView.yMax = [[self.preferences valueForKey:@"yMax"] floatValue];	
	self.glView.yBegin = [[self.preferences valueForKey:@"yBegin"] floatValue];
	self.glView.yEnd = [[self.preferences valueForKey:@"yEnd"] floatValue];
	
	self.glView.numHorizontalGridLines = [[self.preferences valueForKey:@"numHorizontalGridLines"] intValue];
	self.glView.numVerticalGridLines = [[self.preferences valueForKey:@"numVerticalGridLines"] intValue];
	
	self.glView.showGrid = [[self.preferences valueForKey:@"showGrid"] boolValue];
	
}

- (void)collectPreferences {
	
	NSMutableDictionary *preferencesToWrite = [NSMutableDictionary dictionaryWithDictionary:self.preferences];
	
	linecolor_s lineColor = self.glView.lineColor;
	NSMutableDictionary *tmpLineColorDict = [NSMutableDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"lineColor"]];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.R] forKey:@"R"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.G] forKey:@"G"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.B] forKey:@"B"];
	[tmpLineColorDict setValue:[NSNumber numberWithFloat:lineColor.A] forKey:@"A"];
	[preferencesToWrite setValue:tmpLineColorDict forKey:@"lineColor"];
	
	linecolor_s tmpGridColor = self.glView.gridColor;
	NSMutableDictionary *tmpGridColorDict = [NSMutableDictionary dictionaryWithDictionary:[self.preferences valueForKey:@"gridColor"]];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.R] forKey:@"R"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.G] forKey:@"G"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.B] forKey:@"B"];
	[tmpGridColorDict setValue:[NSNumber numberWithFloat:tmpGridColor.A] forKey:@"A"];
	[preferencesToWrite setValue:tmpGridColorDict forKey:@"gridColor"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.xMax] forKey:@"xMax"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.xMin] forKey:@"xMin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.xBegin] forKey:@"xBegin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.xEnd] forKey:@"xEnd"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.yMax] forKey:@"YMax"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.yMin] forKey:@"yMin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.yBegin] forKey:@"yBegin"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.yEnd] forKey:@"yEnd"];
	
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.numHorizontalGridLines] forKey:@"numHorizontalGridLines"];
	[preferencesToWrite setValue:[NSNumber numberWithFloat:self.glView.numVerticalGridLines] forKey:@"numVerticalGridLines"];
	
	[preferencesToWrite setValue:[NSNumber numberWithBool:self.glView.showGrid] forKey:@"showGrid"];
	
	self.preferences = [NSDictionary dictionaryWithDictionary:preferencesToWrite];
	
}


#pragma mark - Multitouch events

- (CGPoint)getXYCoordinatesOfTouch:(int)touchID {
	NSAssert(touchID < 5, @"That's just stupid. Can't have more than 5 touches, dummy");
	UITouch *touch = [[self.currentTouches allObjects] objectAtIndex:touchID];
	return [touch locationInView:self.view];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self.currentTouches unionSet:touches];
	
	if ([self.currentTouches count] == 2) {
		// If two fingers are down, we're pinching and stretching
		// We record the most recent touches
		self.lastPointOne = [self getXYCoordinatesOfTouch:0];
		self.lastPointTwo = [self getXYCoordinatesOfTouch:1];
		
		// And also the very first touches
		self.firstPointOne = [self getXYCoordinatesOfTouch:0];
		self.firstPointTwo = [self getXYCoordinatesOfTouch:1];
	}
	
	
}

				 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
		
	if ([self.currentTouches count] == 1) {
		// And also the very first touches
		self.firstPointOne = [self getXYCoordinatesOfTouch:0];
		self.lastPointOne = [self getXYCoordinatesOfTouch:0];
		
//		UITouch *touch = [touches anyObject];
//		NSUInteger tapCount = [touch tapCount];
		
//		switch (tapCount) {
//			case 1:
//				// [self performSelector:@selector(showHideModeSelector) withObject:nil afterDelay:.3];
//				break;
//			case 2:
//				[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showHideModeSelector) object:nil];
//				// show/hide grid
//				[self.view performSelector:@selector(toggleVisibilityOfGridAndLabels) withObject:nil afterDelay:.3];
//				break;
//		}
	}
	
	[self.currentTouches removeAllObjects];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	if ([self.currentTouches count] == 2) {
		// We have two fingers down, so we're changing the x- and y-scale.
		CGPoint pointOne = [self getXYCoordinatesOfTouch:0];
		CGPoint pointTwo = [self getXYCoordinatesOfTouch:1];
		
		float lastxdiff = fabs(self.lastPointOne.x - self.lastPointTwo.x);
		float thisxdiff = fabs(pointOne.x - pointTwo.x);
		float lastydiff = fabs(self.lastPointOne.y - self.lastPointTwo.y);
		float thisydiff = fabs(pointOne.y - pointTwo.y);
				
		self.pinchChangeInX =  thisxdiff - lastxdiff;
		self.pinchChangeInY = thisydiff - lastydiff;
				
		self.lastPointOne = pointOne;
		self.lastPointTwo = pointTwo;
	}
	else if ([self.currentTouches count] == 1) {
		CGPoint pointOne = [self getXYCoordinatesOfTouch:0];
		
		self.changeInX = self.lastPointOne.x - pointOne.x;
		self.changeInY = self.lastPointOne.y - pointOne.y;
		
		self.lastPointOne = pointOne;
	}
	
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.currentTouches removeAllObjects];	
}




@end
