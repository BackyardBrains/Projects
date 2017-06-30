//
//  PlaybackViewController_iPad.m
//  Backyard Brains
//
//  Created by Zachary King on 8/26/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import "Backyard_BrainsAppDelegate.h"
#import "PlaybackViewController_iPad.h"

@implementation PlaybackViewController_iPad

@synthesize navItem = _navItem;

- (void)dealloc
{
    [_navItem release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
    
    self.navItem.title = self.file.subname;
    
   /* 
    //stop the main audio signal manager
    Backyard_BrainsAppDelegate *appDelegate = (Backyard_BrainsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawingDataManager pause];*/
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  /*  
    //start the main audio signal manager
    Backyard_BrainsAppDelegate *appDelegate = (Backyard_BrainsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.drawingDataManager play];*/
}


- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
