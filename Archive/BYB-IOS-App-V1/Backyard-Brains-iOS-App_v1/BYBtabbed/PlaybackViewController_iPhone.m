//
//  PlaybackViewController_iPhone.m
//  Backyard Brains
//
//  Created by Zachary King on 8/26/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import "PlaybackViewController_iPhone.h"

@implementation PlaybackViewController_iPhone

- (void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
    
	
    self.navigationItem.title = self.file.subname;
    
}

@end
