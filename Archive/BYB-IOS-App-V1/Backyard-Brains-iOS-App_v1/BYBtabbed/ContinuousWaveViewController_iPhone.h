//
//  ContinuousWaveView_iPhone.h
//  oScope
//
//  Created by Alex Wiltschko on 10/30/09.
//  Modified by Zachary King
//      6/27/2011 Added LarvaJolt stimulation controller.
//  Copyright 2009 Backyard Brains. All rights reserved.
//

#import "ContinuousWaveViewController.h"
#import "FlipsideInfoViewController.h"


@interface ContinuousWaveViewController_iPhone : ContinuousWaveViewController <FlipsideInfoViewDelegate> {
	
    
}


- (IBAction)displayInfoFlipside:(UIButton *)sender;

- (void)flipsideIsDone;


@end
