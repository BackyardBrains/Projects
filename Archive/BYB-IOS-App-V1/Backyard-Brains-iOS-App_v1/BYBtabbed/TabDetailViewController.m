// Creates a tab view programmatically, and connects up all the delegates.

#import "TabDetailViewController.h"


@implementation TabDetailViewController


@synthesize tabBarController        = _tabBarController;
@synthesize drawingDataManager      = _drawingDataManager;

@synthesize splitViewController     = _splitViewController;
@synthesize fileController          = _fileController;
@synthesize delegate                = _delegate;

#pragma mark - View lifecycle

- (void)dealloc {
    [_tabBarController release];
    [_drawingDataManager release];
    
    [super dealloc];
}	


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tabBarController.view];
    
    self.drawingDataManager = self.delegate.drawingDataManager;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
    self.tabBarController = nil;
}


@end
