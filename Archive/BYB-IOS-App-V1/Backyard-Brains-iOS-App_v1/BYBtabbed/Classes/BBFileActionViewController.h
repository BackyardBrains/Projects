//
//  BBFileActionViewController.h
//  Backyard Brains
//
//  Created by Zachary King on 7/13/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFileViewController.h"

@protocol BBFileActionViewControllerDelegate
@required
- (NSArray *)returnSelectedFiles;
@end


@interface BBFileActionViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *theTableView;
    
    id <BBFileActionViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;

@property (nonatomic, assign) id <BBFileActionViewControllerDelegate> delegate;

@end
