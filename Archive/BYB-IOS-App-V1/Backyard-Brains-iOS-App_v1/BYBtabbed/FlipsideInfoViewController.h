//
//  FlipsideInfoView.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/26/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstTimeSpikersViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@protocol FlipsideInfoViewDelegate
- (void)flipsideIsDone;
@end

@interface FlipsideInfoViewController : UIViewController <FirstTimeSpikersDelegate, MFMailComposeViewControllerDelegate> {

	id <FlipsideInfoViewDelegate> delegate;
	IBOutlet UIButton *firstSpikeButton;
}

@property (nonatomic, retain) id <FlipsideInfoViewDelegate> delegate;

- (IBAction)firstSpikeButtonClicked:(UIButton *)sender;
- (IBAction)done:(UIBarButtonItem *)sender;
- (IBAction)launchWebsite;
- (IBAction)sendEmail;

@end