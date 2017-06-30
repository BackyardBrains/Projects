//
//  BBFileDownloadViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/20/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFileDownloadViewController.h"


@implementation BBFileDownloadViewController
@synthesize delegate;
@synthesize bottomButton        = _bottomButton;
@synthesize scrollView          = _scrollView;

- (void)viewWillAppear:(BOOL)animated {
    
    Class cls = NSClassFromString(@"UIPopoverController");
	if (cls != nil)
	{
		CGSize size = {320, 460}; // size of view in popover, if we're on the iPad
		self.contentSizeForViewInPopover = size;
	}
    
	[super viewWillAppear:animated];

	[self setupServer];
	[self startServer];
	
    NSString *theNames = [NSString string];
	for (int i = 0; i < [delegate.fileNamesToShare count]; i++)
    {
        theNames = [theNames stringByAppendingFormat:@"%@\n", [delegate.fileNamesToShare objectAtIndex:i]];
    }
    
    //fileNameLabel.lineBreakMode = UILineBreakModeCharacterWrap; 
    //fileNameLabel.numberOfLines = 0;
	fileNameLabel.text = theNames;

    [self updateContentSize];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self stopServer];
}

- (void)setupServer {
	NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];
	
}

- (void)startServer {
	[httpServer setPort:8080];
	
	NSError *error;
	if(![httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
	
}

- (void)stopServer {
	[httpServer stop];
}

- (void)displayInfoUpdate:(NSNotification *) notification {
	
	if(notification)
	{
		[addresses release];
		addresses = [[notification object] copy];
	}
	
	if(addresses == nil)
	{
		return;
	}
	
	UInt16 port = [httpServer port];
	
	NSString *localIP = nil;
	
	localIP = [addresses objectForKey:@"en0"];
	
	if (!localIP)
	{
		localIP = [addresses objectForKey:@"en1"];
	}
	
	if (!localIP)
		ipLabel.text = @"Wifi: No Connection!\n";
	
	else
		ipLabel.text = [NSString stringWithFormat:@"http://%@:%d\n", localIP, port];

	// NOTE: is this for connecting over the internet if there's a cell connection?
//	NSString *wwwIP = [addresses objectForKey:@"www"];
//	
//	if (wwwIP)
//		info = [info stringByAppendingFormat:@"Web: %@:%d\n", wwwIP, port];
//	else
//		info = [info stringByAppendingString:@"Web: Unable to determine external IP\n"];
	
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


- (void)dealloc {
    [super dealloc];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    [self updateContentSize];
}

- (void)updateContentSize
{
    CGSize size = self.scrollView.contentSize;
    size.height = self.bottomButton.frame.size.height + self.bottomButton.frame.origin.y;
    [self.scrollView setContentSize:size];
}

@end
