//
//  FirstTimeSpikersViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/27/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstTimeSpikersDelegate

- (void)firstTimeSpikeViewIsDone;

@end


@interface FirstTimeSpikersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *theTableView;

	NSArray *formLabels;
	NSArray *formFields;
	id <FirstTimeSpikersDelegate> delegate;
	
}

- (IBAction)submit;
- (IBAction)cancel;


@property (nonatomic,retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSArray *formLabels;
@property (nonatomic, retain) NSArray *formFields;
@property (nonatomic, retain) id <FirstTimeSpikersDelegate> delegate;

@end
