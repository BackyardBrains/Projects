//
//  Backyard_BrainsAppDelegate.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/6/10.
//  Copyright University of Michigan 2010. All rights reserved.
//

#import "Backyard_BrainsAppDelegate.h"
#import "DropboxSDK.h"
#import "BBTabViewController.h"

@implementation Backyard_BrainsAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize splitViewController;
@synthesize rootVC, detailVC;
@synthesize drawingDataManager;
@synthesize pulse;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
        
    #define kGain 887.0f
    #define kSamplerate 22050.f
    
	//Register defaults. Necessary for proper initializaiton of preferences.
    NSDictionary *def = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"gain", [NSNumber numberWithFloat:kGain],
                         @"samplerate", [NSNumber numberWithFloat:kSamplerate],
                         nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:def];
    
	//Check current values
    NSNumber *gain = [[NSUserDefaults standardUserDefaults] objectForKey:@"gain"];
	NSNumber *samplerate = [[NSUserDefaults standardUserDefaults] objectForKey:@"samplerate"];
    if (!gain) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:kGain] forKey:@"gain"];
	}
	if (!samplerate) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:kSamplerate] forKey:@"samplerate"];
	}
    
    //Save changes
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSLog(@"gain = %@", gain);
	NSLog(@"sample rate = %@", samplerate);
    
    
    //Dropbox code:
    DBSession* dbSession = 
    [[[DBSession alloc]
      initWithConsumerKey:@"gko0ired85ogh0e"
      consumerSecret:@"vmxyfeju241zqpk"]
     autorelease];
    [DBSession setSharedSession:dbSession];
    
    
    
	self.drawingDataManager = [[AudioSignalManager alloc] 
                               initWithCallbackType:kAudioCallbackContinuous];
	//[self.drawingDataManager play];
    
    self.pulse = [[LarvaJoltAudio alloc] init];
    
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = YES;

	
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	
	// make the window visible
	[window makeKeyAndVisible];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		return NO;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return NO;
	}
	
	return NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
//	[self deleteAllDummyFiles];
	
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = NO;
	
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [splitViewController release];
    [rootVC release];
    [detailVC release];
    [super dealloc];
}

@end

