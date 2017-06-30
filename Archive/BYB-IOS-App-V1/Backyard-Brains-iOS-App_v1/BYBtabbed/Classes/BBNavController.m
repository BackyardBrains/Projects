//
//  BBNavController.m
//  Backyard Brains
//
//  Created by Zachary King on 3/13/12.
//  Copyright (c) 2012 Backyard Brains. All rights reserved.
//

#import "BBNavController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BBNavController


// Must implement a custom transition to ensure that 
//  popped controllers exit with a transistion from the left.

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    [self.view.layer 
     addAnimation:transition forKey:kCATransition];
    
    UIViewController *vc = [super popViewControllerAnimated:NO];
    
    
    return vc;
}

@end
