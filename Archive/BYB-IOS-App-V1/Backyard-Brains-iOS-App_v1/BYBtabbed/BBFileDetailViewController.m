//
//  BBFileDetailViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/9/10.
//  Modified by Zachary King:
//      8/1/2011 Added support for editing multiple files
//  Copyright 2010 Backyard Brains. All rights reserved.
//

#import "BBFileDetailViewController.h"


@implementation BBFileDetailViewController

@synthesize delegate;

@synthesize titleButton;
@synthesize durationLabel;
@synthesize recordedInfoLabel;
@synthesize samplingRateLabel;
@synthesize gainLabel;
@synthesize commentButton;
@synthesize files;
@synthesize stimLabel;

- (void)dealloc {
	[titleButton release];
	[durationLabel release];
	[recordedInfoLabel release];
	[samplingRateLabel release];
	[gainLabel release];
	[commentButton release];
	[files release];
	[stimLabel release];
	
	[super dealloc];

}


- (void)viewWillAppear:(BOOL)animated {

	
	Class cls = NSClassFromString(@"UIPopoverController");
	if (cls != nil)
	{
		CGSize size = {320, 480}; // size of view in popover, if we're on the iPad
		self.contentSizeForViewInPopover = size;
	}

    [super viewWillAppear:animated];
	self.navigationItem.title = @"Details";
	
	self.files = delegate.files;
	
	// Load up the views!
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"'Recorded on' EEEE',' MMM d',' YYYY 'at' h':'mm a"];

	if ([self.files count] == 1) {
        
		BBFile *file = [self.files objectAtIndex:0];
		[self setButton:titleButton titleForAllStates:file.shortname];
		durationLabel.text = [self stringWithFileLengthFromBBFile:file];
		recordedInfoLabel.text = [inputFormatter stringFromDate:file.date];
		samplingRateLabel.text = [NSString stringWithFormat:@"%0.0f Hz", file.samplingrate];
		gainLabel.text = [NSString stringWithFormat:@"%0.0f x", file.gain];
		NSString *commentText = @"You haven't made a comment on this file yet! Tap to enter a comment for your file.";
        NSString *fileComment = file.comment;
        
        self.stimLabel.text = [NSString stringWithFormat:@"%u", file.hasStim];
		
		//[fileComment retain];
		if (fileComment != nil) {
			if (![fileComment isEqualToString:@""]) {
				commentText = fileComment;
			}
		}
        
        [self setButton:commentButton titleForAllStates:commentText];
        
	} else {

		[self setButton:titleButton titleForAllStates:[NSString stringWithFormat:@"%u Files", [self.files count]]];
		durationLabel.hidden = YES;
		recordedInfoLabel.hidden = YES;
		samplingRateLabel.hidden = YES;
		gainLabel.hidden = YES;
		stimLabel.hidden =YES;
		NSString *commentText = [NSString stringWithFormat:@"Edit comment for %u files", [self.files count]];
        [self setButton:commentButton titleForAllStates:commentText];
	}
	
    [inputFormatter release];
	//[fileComment release];
	
	
}

- (NSString *)stringWithFileLengthFromBBFile:(BBFile *)thisFile {
	int minutes = (int)floor(thisFile.filelength / 60.0);
	int seconds = (int)(thisFile.filelength - minutes*60.0);
	
	if (minutes > 0) {
		return [NSString stringWithFormat:@"%dm %ds", minutes, seconds];
	}
	else {
		return [NSString stringWithFormat:@"%ds", seconds];		
	}

	
}

- (IBAction)pushTitleEditorView:(UIButton *)sender {
	BBFileTitleEditorViewController *titleViewController = [[BBFileTitleEditorViewController alloc] initWithNibName:@"BBFileTitleEditorView" bundle:nil];
	titleViewController.delegate = self;
	
	[self.navigationController pushViewController:titleViewController animated:YES];
	
	[titleViewController release];
}

- (IBAction)pushCommentEditorView:(UIButton *)sender {
	BBFileCommentEditorViewController *commentViewController = [[BBFileCommentEditorViewController alloc] initWithNibName:@"BBFileCommentEditorView" bundle:nil];
	self.files = delegate.files;
	commentViewController.delegate = self;
	
	[self.navigationController pushViewController:commentViewController animated:YES];
	
	[commentViewController release];
}

-(void)setButton:(UIButton *)button titleForAllStates:(NSString *)aTitle
{
	[button setTitle:aTitle forState:UIControlStateNormal];
	[button setTitle:aTitle forState:UIControlStateHighlighted];
	[button setTitle:aTitle forState:UIControlStateDisabled];
	[button setTitle:aTitle forState:UIControlStateSelected];
}



@end
