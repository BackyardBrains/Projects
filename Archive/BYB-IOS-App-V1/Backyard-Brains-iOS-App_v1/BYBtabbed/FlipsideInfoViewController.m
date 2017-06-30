//
//  FlipsideInfoView.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/26/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "FlipsideInfoViewController.h"


@implementation FlipsideInfoViewController

@synthesize delegate;

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)firstSpikeButtonClicked:(UIButton *)sender {
	FirstTimeSpikersViewController *ctrl = [[FirstTimeSpikersViewController alloc] initWithNibName:@"FirstTimeSpikersView" bundle:nil];
	ctrl.delegate = self;
	ctrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:ctrl animated:YES];
	[ctrl release];
}

- (IBAction)done:(UIBarButtonItem *)sender {
	[delegate flipsideIsDone];
}

- (IBAction)launchWebsite {
	NSURL *target = [[NSURL alloc] initWithString:@"http://www.backyardbrains.com"];
	[[UIApplication sharedApplication] openURL:target];
    [target release];
}

- (IBAction)sendEmail {

	// UNCOMMENT THIS
	// If you want to do nothing when the device can't send mail. 
//	if (![MFMailComposeViewController canSendMail]) {		
//		return;
//	}
	
	MFMailComposeViewController *message = [[MFMailComposeViewController alloc] init];
	message.mailComposeDelegate = self;
	[message setToRecipients:[NSArray arrayWithObject:@"info@backyardbrains.com"]];
	[message setSubject:@"A question about Backyard Brains"];
	[self presentModalViewController:message animated:YES];
	[message release];
	
	
}




- (void)firstTimeSpikeViewIsDone { // delegate method
	[self dismissModalViewControllerAnimated:YES];
}


// delegate for the email view
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc {
    [super dealloc];
}


@end
