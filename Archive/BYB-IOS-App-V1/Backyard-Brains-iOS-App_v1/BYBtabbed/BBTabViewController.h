//
//  BBTabViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/6/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioSignalManager.h"
#import "DrawingViewController.h"
#import "BBFileViewController.h"

@interface BBTabViewController : UITabBarController <DrawingViewControllerDelegate> {
	
	// So the App Delegate can receive tab-change events
	IBOutlet id <UITabBarDelegate> delegate;
	
	// For the GainViewControllerDelegate protocol
	float gain;
	
	// For the DrawingViewControllerDelegate protocol
	AudioSignalManager *audioSignalManager;

}


@property (nonatomic, retain) AudioSignalManager *audioSignalManager;
@property float gain;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

// gvcdelegate protocol
- (float) gain;
- (void) setGain:(float)newGain;
@end