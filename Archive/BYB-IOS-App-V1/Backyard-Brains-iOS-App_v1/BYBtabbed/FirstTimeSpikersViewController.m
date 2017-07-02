//
//  FirstTimeSpikersViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/27/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "FirstTimeSpikersViewController.h"


@implementation FirstTimeSpikersViewController
@synthesize theTableView;
@synthesize formFields;
@synthesize formLabels;
@synthesize delegate;

- (void) dealloc {
	
	[theTableView release];
	[formFields release];
	[formLabels release];
	
	
	
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		theTableView.dataSource = self;
		theTableView.delegate = self;
		theTableView.sectionIndexMinimumDisplayRowCount=6;
		
		self.navigationItem.title = @"First time spikers!";
		
		
		CGRect rect = CGRectMake(130.0, 10.0, 200.0, 22.0);
		UITextField *eventTextField = [[UITextField alloc] initWithFrame:rect];
		eventTextField.keyboardType = UIKeyboardTypeAlphabet;
		UITextField *cityTextField = [[UITextField alloc] initWithFrame:rect];
		cityTextField.keyboardType = UIKeyboardTypeAlphabet;
		UITextField *numberTextField = [[UITextField alloc] initWithFrame:rect];
		numberTextField.keyboardType = UIKeyboardTypeNumberPad;
		UITextField *nameTextField = [[UITextField alloc] initWithFrame:rect];
		nameTextField.keyboardType = UIKeyboardTypeAlphabet;
		UITextField *emailTextField = [[UITextField alloc] initWithFrame:rect];
		emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
		
		self.formLabels = [[NSArray alloc] initWithObjects:@"Event:", @"City:", @"# People:", @"Your name:", @"Your email:", nil];
		
		self.formFields = [[NSArray alloc] initWithObjects:eventTextField,
														   cityTextField,
														   numberTextField,
														   nameTextField,
														   emailTextField, nil];
						
        [eventTextField release];
        [cityTextField release];
        [numberTextField release];
        [nameTextField release];
        [emailTextField release];
		
    }
    return self;
	
	
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[[self.formFields objectAtIndex:0] becomeFirstResponder];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Tell us about the first time spikers";
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formFields count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	UITextField *thisField = [self.formFields objectAtIndex:indexPath.row];
	
	for (UIView *view in cell.subviews) {
		if ([view class] == [thisField class]) {
			[view removeFromSuperview];
		}
	}

	cell.textLabel.text = [self.formLabels objectAtIndex:indexPath.row]; //[[self.formLabels objectAtIndex:indexPath.row] text];
	[cell addSubview:[self.formFields objectAtIndex:indexPath.row]];
	

    return cell;
}


- (IBAction)submit {


	// Verify all fields are filled in
	BOOL err = NO;
	for (UITextField *field in self.formFields) {
		if ([field.text length] == 0) {
			err = YES;
		}
	}
	
	// If they're not, raise an error and return
	if (err) {		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fields missing" message:@"Please fill in all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];    
		[alert release];
		return;
	}
	
	// Get the current date
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateStyle: NSDateFormatterShortStyle];
	NSString *dateString = [inputFormatter stringFromDate:[NSDate date]];
	
	[inputFormatter release];
    
	// Construct the URL string
	NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://www.backyardbrains.com/SpikeCounter.aspx?Event=%@&City=%@&Number=%@&Name=%@&Email=%@&Date=%@",
						   [[self.formFields objectAtIndex:0] text],
						   [[self.formFields objectAtIndex:1] text],
						   [[self.formFields objectAtIndex:2] text],
						   [[self.formFields objectAtIndex:3] text],
						   [[self.formFields objectAtIndex:4] text],
						   dateString];
	
	
	// Make sure the URL is encoded properly 
	[urlString replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [urlString length])];
	//NSString* escapedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	//NSURL *url = [NSURL URLWithString: escapedUrl];
	
	//NSData *data = [NSData dataWithContentsOfURL:url];
	
	[delegate firstTimeSpikeViewIsDone];
}

- (IBAction)cancel {
	[delegate firstTimeSpikeViewIsDone];
}



@end

