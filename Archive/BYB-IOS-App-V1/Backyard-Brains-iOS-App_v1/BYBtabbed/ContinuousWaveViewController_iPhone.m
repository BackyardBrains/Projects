//
//  ContinuousWaveView.m
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/27/2011 Added LarvaJolt stimulation controller.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "ContinuousWaveViewController_iPhone.h"

@implementation ContinuousWaveViewController_iPhone


- (void)dealloc {	
	
    [super dealloc];
	

}

# pragma mark - Delegate method

- (void)flipsideIsDone {
	
	[self dismissModalViewControllerAnimated:YES];
}

# pragma mark - IBActions

- (IBAction)displayInfoFlipside:(UIButton *)sender {
	
	FlipsideInfoViewController *flipController = [[FlipsideInfoViewController alloc] initWithNibName:@"FlipsideInfoView" bundle:nil];
	flipController.delegate = self;
	flipController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:flipController animated:YES];
	[flipController release];	
	
}


@end
