//
//  BBTabViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/6/10.
//  Modified by Zachary King
//      9-15-2011 Most of the code here was moved elsewhere.
//  Copyright 2010 Backyard Brains. All rights reserved.
//

#import "BBTabViewController.h"


@implementation BBTabViewController

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
		return NO;
	}
	
	return NO;
}

@end
