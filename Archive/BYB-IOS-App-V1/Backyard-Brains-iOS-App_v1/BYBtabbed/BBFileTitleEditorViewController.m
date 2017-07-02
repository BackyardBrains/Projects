//
//  BBFileTitleEditorViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/10/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileTitleEditorViewController.h"


@implementation BBFileTitleEditorViewController

@synthesize titleTextField;
@synthesize files;
@synthesize ogString;
@synthesize delegate;


- (void)dealloc {
	[titleTextField release];
	
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

    
	self.files = delegate.files;
	
	if ([self.files count] == 1)
	{
		BBFile *file = [self.files objectAtIndex:0];
        self.ogString = [file shortname];
	}
	else
	{
		self.ogString = [NSString stringWithFormat:@"Name and number %u Files", [self.files count]];
	}
    [self.titleTextField setText:self.ogString];

    
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];    

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                    style: UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(done)] autorelease];
    self.navigationItem.leftBarButtonItem.title = @"Cancel";
	
	[self.titleTextField becomeFirstResponder];
	
	self.navigationItem.title = @"Filename";
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (IBAction)done
{

    //check that the title label has been edited and is not empty
    if (![self.titleTextField.text isEqualToString:self.ogString] && ![self.titleTextField.text isEqualToString:@""])
    {
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
       
        // Create file manager
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        // For error information
        NSError *error;
        //BOOL didRename = NO;
     
        for (int i = 0; i < [self.files count]; ++i)
        {
            NSString *newShortname = self.titleTextField.text;
            if (i > 0) //multiple files
            {
                newShortname = [newShortname stringByAppendingFormat:@"-%u", (i+1)];
            }
            NSString *newFilename = [newShortname stringByAppendingString:@".aif"];
            
            //rename file
            BBFile *file = [self.files objectAtIndex:i];
            NSString *oldFilePath = [docPath stringByAppendingPathComponent:file.filename];
        
            //Create a new path
            NSString *newFilePath = [docPath stringByAppendingPathComponent:newFilename];
        
            // Attempt the move
            if ([fileMgr moveItemAtPath:oldFilePath toPath:newFilePath error:&error] == YES)
            {
                //change title and filename in BBFile
                file.shortname = newShortname;
                file.filename = newFilename;
                NSLog(@"New file path: %@", newFilePath);
            }
            else //single file
            {
                NSLog(@"Unable to move file: %@", [error localizedDescription]);
                //Create UIAlertView alert
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"File already exists with this name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
                [alert show];
                break;
            }
        
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
