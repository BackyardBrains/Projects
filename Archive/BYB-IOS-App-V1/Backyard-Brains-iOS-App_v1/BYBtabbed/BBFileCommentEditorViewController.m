//
//  BBFileCommentEditorViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/10/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileCommentEditorViewController.h"


@implementation BBFileCommentEditorViewController

@synthesize commentTextView;
@synthesize files;
@synthesize ogComment;
@synthesize delegate;

- (void)dealloc {
	[commentTextView release];
	
	[super dealloc];

}


- (void)viewWillAppear:(BOOL)animated
{
	Class cls = NSClassFromString(@"UIPopoverController");
	if (cls != nil)
	{
		CGSize size = {320, 480}; // size of view in popover, if we're on the iPad
		self.contentSizeForViewInPopover = size;
	}
	
	
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                        style: UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(done)] autorelease];
    self.navigationItem.leftBarButtonItem.title = @"Cancel";
    
	self.navigationItem.title = @"Comment";

    
    self.files = delegate.files;
    
	if ([files count] == 1)
	{
		BBFile *file = [self.files objectAtIndex:0];
		self.ogComment = file.comment;
	}
	else
	{
		self.ogComment = [NSString stringWithFormat:@"Edit comments for %u files.", [self.files count]];
	}
	[self.commentTextView setText:self.ogComment];
	
	[super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.commentTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
	
- (IBAction)done
{
    //check that changes have been made
    if (![self.commentTextView.text isEqualToString:self.ogComment] && ![self.commentTextView.text isEqualToString:@""])
    {
        for (BBFile *file in self.files)
        {
            file.comment = self.commentTextView.text;
            [file updateMetadata];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




@end
