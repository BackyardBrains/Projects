//NOTE:
// This has been replaced by BBFileViewControllerTBV, a subclass of UITableViewController




//
//  BBFileTableViewController.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Modified by Zachary King
//      7/12/11 Set up everything for new tabbed interface. Removed audio player.
//  Copyright 2010 Backyard Brains. All rights reserved.
//

#import "BBFileViewController.h"

#define kSyncWaitTime 10 //seconds

@interface BBFileViewController()

- (void)populateSelectedArray;
- (void)populateSelectedArrayWithSelectionAt:(int)num;

- (void)pushActionView;

- (NSString *)stringWithFileLengthFromBBFile:(BBFile *)thisFile;

- (void)dbButtonPressed;
- (void)pushDropboxSettings;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)dbDisconnect;
- (void)dbUpdate;
- (void)dbUpdateTimedOut;
- (void)clearStatus;
- (void)compareBBFilesToNewFilePaths:(NSArray *)newPaths;


@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unselectedImage;

@property (nonatomic, retain) NSDictionary *preferences;

@property (nonatomic, retain) DBRestClient *restClient;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSTimer *syncTimer;
@property (nonatomic, retain) NSArray *lastFilePaths;
@property (nonatomic, retain) NSString *docPath;

@end


@implementation BBFileViewController


@synthesize theTableView, dbStatusBar, allFiles;

@synthesize selectedArray;
@synthesize selectedImage, unselectedImage;

@synthesize inPseudoEditMode;
@synthesize filesSelectedForAction;
@synthesize preferences;
@synthesize restClient;
@synthesize status, syncTimer, lastFilePaths, docPath;


- (void)dealloc {
    [super dealloc];
    [theTableView release];
    [dbStatusBar release];
	[allFiles release];
    [filesSelectedForAction release];
	[selectedArray release];
	[selectedImage release];
	[unselectedImage release];
    [preferences release];
    [restClient release];
    [status release];
    [syncTimer release];
    [lastFilePaths release];
}



/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

		
    }
    return self;
	
}*/

- (void)viewWillAppear:(BOOL)animated 
{	
	[super viewWillAppear:animated];
    
    self.selectedImage =    [UIImage imageNamed:@"selected.png"];
    self.unselectedImage =  [UIImage imageNamed:@"unselected.png"];
    
    self.navigationItem.leftBarButtonItem.action = @selector(togglePseudoEditMode);
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;

    UIImage *dbImage = [UIImage imageNamed:@"dropbox.png"];
    /*UIButton *dbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dbButton.bounds = CGRectMake( 0, 0, dbImage.size.width, dbImage.size.height );
    [dbButton setImage:dbImage forState:UIControlStateNormal];
    dbButton.style = UIBarButtonItemStylePlain;
    dbButton.target = self;
    dbButton.action = @selector(pushDropboxSettings);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:dbButton] autorelease];*/
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:dbImage style:UIBarButtonItemStylePlain target:self action:@selector(dbButtonPressed)] autorelease];
    self.navigationItem.rightBarButtonItem.width = dbImage.size.width;
    
	self.allFiles = [NSMutableArray arrayWithArray:[BBFile allObjects]];
    self.inPseudoEditMode = NO;
    
    [self populateSelectedArray];
	
	[theTableView reloadData];
    
    //grab preferences
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"BBFileViewController.plist"];
	self.preferences = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	//[self dispersePreferences];		
    if ([[self.preferences valueForKey:@"isDBLinked"] boolValue])
        [self dbUpdate];
    
    self.docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


- (void)viewWillDisappear:(BOOL)animated {
	//[self collectPreferences];
	NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:@"BBFileViewController.plist"];
	[preferences writeToFile:finalPath atomically:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods


//UITableViewDelegate
 - (void)tableView:(UITableView *)tableView willDisplayCell:(BBFileTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath indexAtPosition:0] == 0) //section # is 0
    {
        cell.delegate = self;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) //tk or is it 1?
	{
		return [allFiles count];
	} else if (section == 1) {
        
        if ([self.selectedArray containsObject:[NSNumber numberWithBool:YES]])
            return 1; //for multiple edit
        else
            return 0;
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


	if (indexPath.section == 0)
	{
		static int numcellsmade = 0;
		numcellsmade += 1;
		
		static NSString *CellIdentifier = @"BBFileTableCell";    
		BBFileTableCell *cell = (BBFileTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
		
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BBFileTableCell" owner:nil options:nil];
			
			for(id currentObject in topLevelObjects)
			{
				if([currentObject isKindOfClass:[BBFileTableCell class]])
				{
					cell = (BBFileTableCell *)currentObject;
					break;
				}
			}
		
		}
		
		BBFile *thisFile = [allFiles objectAtIndex:indexPath.row];
		
		if (thisFile.filelength > 0) {
			cell.lengthname.text = [self stringWithFileLengthFromBBFile:thisFile];
		} else {
			cell.lengthname.text = @"";
		}
		
		cell.shortname.text = thisFile.shortname; //[[allFiles objectAtIndex:indexPath.row] shortname];
		cell.subname.text = thisFile.subname; //[[allFiles objectAtIndex:indexPath.row] subname];
        
        if (self.inPseudoEditMode)
        {
            CGRect labelRect =  CGRectMake(36, 11, 216, 21);
            CGRect subRect =    CGRectMake(36, 29, 216, 15);
            
            
            cell.actionButton.hidden = NO;
            if ([[self.selectedArray objectAtIndex:[indexPath row]] boolValue])
                [cell.actionButton setImage:self.selectedImage forState:normal];
            else
                [cell.actionButton setImage:self.unselectedImage forState:normal];
                 
            [cell.shortname setFrame:labelRect];
            [cell.subname setFrame:subRect];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
	}
	else if (indexPath.section == 1)
	{
		static NSString *CellIdentifier = @"editMultipleCell";    
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editMultipleCell"] autorelease];

            cell.textLabel.text = @"Edit multiple files";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
	}
	
    return NULL;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 
	 NSLog(@"=== Cell selected! === ");
     
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
     
     [self cellActionTriggeredFrom:(BBFileTableCell *)[tableView cellForRowAtIndexPath:indexPath]];
	 	 
 }



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	if ([indexPath indexAtPosition:0] == 0)
    {
		// Note the BBFile for the particular row that's selected.
        [self populateSelectedArrayWithSelectionAt:indexPath.row];
        [self pushActionView];
    }
}

- (void)pushActionView
{
    // Create the action view controller, load it with the delegate, and push it up onto the stack.
    NSMutableArray *theFiles = [[NSMutableArray alloc] initWithObjects:nil];
    
    for (int i = 0; i < [self.selectedArray count]; i++)
    {
        if ([[self.selectedArray objectAtIndex:i] boolValue])
        {
            BBFile *file = [self.allFiles objectAtIndex:i];
            [theFiles addObject:file];
        }
    }
    self.filesSelectedForAction = (NSArray *)theFiles;
    [theFiles release];
    
    BBFileActionViewControllerTBV *actionViewController = [[BBFileActionViewControllerTBV alloc] initWithNibName:@"BBFileActionView" bundle:nil];
    actionViewController.delegate = self;
    
    [self.navigationController pushViewController:actionViewController animated:YES];
    [actionViewController release];
}




#pragma mark - Select multiple functions


- (IBAction)togglePseudoEditMode
{
    //toggle the mode
    self.inPseudoEditMode = !inPseudoEditMode;

    //reset the selected array
    [self populateSelectedArray];
    
    //set up animations
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    //set new frames
    if(inPseudoEditMode) {
                
        self.navigationItem.leftBarButtonItem.title = @"Select";
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
        
        for (NSIndexPath *path in self.theTableView.indexPathsForVisibleRows)
        {
            if ([path indexAtPosition:0] == 0) //section # is 0
            {
                BBFileTableCell *cell = (BBFileTableCell *)[self.theTableView cellForRowAtIndexPath:path];

                
                CGRect labelRect =  CGRectMake(36, 11, 216, 21);
                CGRect subRect =    CGRectMake(36, 29, 216, 15);
                
                
                cell.actionButton.hidden = NO;
                [cell.actionButton setImage:self.unselectedImage forState:normal];
                [cell.shortname setFrame:labelRect];
                [cell.subname setFrame:subRect];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
        }
        
    } else { //not in pseudo edit mode
        
        self.navigationItem.leftBarButtonItem.title = @"Select";
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
        
        for (NSIndexPath *path in self.theTableView.indexPathsForVisibleRows)
        {
            if ([path indexAtPosition:0] == 0) //section # is 0
            {
                BBFileTableCell *cell = (BBFileTableCell *)[self.theTableView cellForRowAtIndexPath:path];
                
                
                CGRect labelRect =  CGRectMake(13, 11, 216, 21);
                CGRect subRect =    CGRectMake(13, 29, 216, 15);
                
                cell.actionButton.hidden = YES;
                [cell.shortname setFrame:labelRect];
                [cell.subname setFrame:subRect];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    
    //do the animation
    [UIView commitAnimations];
    
	[self.theTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}



- (void)populateSelectedArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[allFiles count]];
	for (int i=0; i < [allFiles count]; i++)
		[array addObject:[NSNumber numberWithBool:NO]];
	self.selectedArray = array;
	[array release];
}

- (void)populateSelectedArrayWithSelectionAt:(int)num
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[allFiles count]];
	for (int i=0; i < [allFiles count]; i++)
    if (num == i)
        [array addObject:[NSNumber numberWithBool:YES]];
    else
        [array addObject:[NSNumber numberWithBool:NO]];
	self.selectedArray = array;
	[array release];
}


- (void)cellActionTriggeredFrom:(BBFileTableCell *) cell
{
    NSUInteger theRow = [[theTableView indexPathForCell:cell] row];
    NSLog(@"Cell at row %u", theRow);
    
    if ([[self.theTableView indexPathForCell:cell] section] == 0)
    {
        //Check for pseudo edit mode
        if (inPseudoEditMode)
        {
            
            BOOL selected = ![[selectedArray objectAtIndex:theRow] boolValue];
            [selectedArray replaceObjectAtIndex:theRow withObject:[NSNumber numberWithBool:selected]];
             
            NSLog(@"Cell is selected: %i", selected);
            
            if (selected)
            {
                [cell.actionButton setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
                
                NSLog(@"Swapped image for selectedImage ");
            } else {
                [cell.actionButton setImage:self.unselectedImage forState:UIControlStateNormal];
            }
            
            [self.theTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            
            [self populateSelectedArrayWithSelectionAt:theRow];
            [self pushActionView];
        }
    } else {
        //Select Multiple Button. selectedArray already set.
        [self pushActionView];
    }
}



#pragma mark - DropBox methods

- (void)dbButtonPressed
{
    if ([[self.preferences valueForKey:@"isDBLinked"] boolValue])
    {
        //push action sheet
        UIActionSheet *mySheet = [[UIActionSheet alloc] initWithTitle:@"Dropbox" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Disconnect from Dropbox" otherButtonTitles:@"Change login settings", @"Sync with Dropbox", nil];
        
        mySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [mySheet showFromTabBar:self.tabBarController.tabBar];
        [mySheet release];
        
    }
    else
        [self pushDropboxSettings];
}

- (void)pushDropboxSettings
{
    DBLoginController* controller = [[DBLoginController new] autorelease];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"Dropbox"])
    {
        switch (buttonIndex) {
            case 0:
                [self dbDisconnect];
                break;
            case 1:
                [self pushDropboxSettings];
                break;
            case 2:
                [self dbUpdate];
                break;
            default:
                break;
        }
    }
}

- (void)dbDisconnect
{
    self.preferences = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"isDBLinked"];
    [self setStatus:@"Disconnected from Dropbox"];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dbUpdate) userInfo:nil repeats:NO];
}

- (void)dbUpdate
{
    if ([[self.preferences valueForKey:@"isDBLinked"] boolValue])
    {
        [self setStatus:@"Syncing with dropbox..."];
        
        [self.restClient loadMetadata:@"/BYB files" withHash:filesHash];
        
        //create a timer here that restClient:(DBRestClient*)client loadedMetadata: can invalidate
        //timer will call status=@"sync failed"
        self.syncTimer = [NSTimer scheduledTimerWithTimeInterval:kSyncWaitTime
                                                          target:self
                                                        selector:@selector(dbUpdateTimedOut)
                                                        userInfo:nil
                                                         repeats:NO];

    } else {
        [self setStatus:@""];
    }
}

- (void)dbUpdateTimedOut
{
    [self setStatus:@"Sync failed"];
    [self.syncTimer invalidate];
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(clearStatus)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)dbStopUpdate
{
    
    [self setStatus:@""];
    
}


- (void)setStatus:(NSString *)theStatus { //setter

    status = theStatus;
    [self.dbStatusBar setTitle:theStatus forState:UIControlStateNormal];
    if ([theStatus isEqualToString:@""])
    {
        CGRect dbBarRect = CGRectMake(self.dbStatusBar.frame.origin.x,
                                      self.dbStatusBar.frame.origin.x,
                                      320, 0);    
        CGRect tableViewRect = CGRectMake(self.theTableView.frame.origin.x,
                                          0,
                                          self.theTableView.frame.size.width,
                                          self.view.window.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.dbStatusBar setFrame:dbBarRect];	
        [self.theTableView setFrame:tableViewRect];
        [UIView commitAnimations];
    }
    else
    {
        if (self.dbStatusBar.frame.size.height < 20) {
            CGRect dbBarRect = CGRectMake(self.dbStatusBar.frame.origin.x,
                                          self.dbStatusBar.frame.origin.x,
                                          320, 20);    
            CGRect tableViewRect = CGRectMake(self.theTableView.frame.origin.x,
                                              20,
                                              self.theTableView.frame.size.width,
                                              self.view.window.frame.size.height-20);
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:.25];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self.dbStatusBar setFrame:dbBarRect];	
            [self.theTableView setFrame:tableViewRect];
            [UIView commitAnimations];
        }
    }
}


- (void)clearStatus
{
    [self setStatus:@""];
}

- (void)compareBBFilesToNewFilePaths:(NSArray *)newPaths
{
    
    NSMutableArray *pathsNeedingDownload = [NSMutableArray arrayWithCapacity:[newPaths count]];
    NSMutableArray *filesNeedingUpload   = [NSMutableArray arrayWithCapacity:[self.allFiles count]];
    for (int i = 0; i < [newPaths count]; ++i)
        [pathsNeedingDownload addObject:[NSNumber numberWithBool:NO]]; //assume no downloads
    for (int i = 0; i < [self.allFiles count]; ++i)
        [filesNeedingUpload addObject:[NSNumber numberWithBool:YES]];  //assume all uploads
    
    //for each path
    for (int l = 0; l < [newPaths count]; ++l)
    {
        BOOL match = FALSE;
        //for each file
        for (int m = 0; m < [self.allFiles count]; ++m)
        {
            // if there is a match
            if ([[[self.allFiles objectAtIndex:m] filename] isEqualToString:[newPaths objectAtIndex:l]])
            {
                match = TRUE;
                [filesNeedingUpload replaceObjectAtIndex:m withObject:[NSNumber numberWithBool:NO]]; //don't upload that file
            }
        }
        
        // if no matches found
        if (!match)
            [pathsNeedingDownload replaceObjectAtIndex:l withObject:[NSNumber numberWithBool:YES]]; //download this path
    }
    
    
    for (int l = 0; l < [pathsNeedingDownload count]; ++l)
    {
        if ([[pathsNeedingDownload objectAtIndex:l] boolValue])
        {
            NSString *fileToLoad = [newPaths objectAtIndex:l];
            [self.restClient loadFile:fileToLoad intoPath:self.docPath];
            BBFile *theFile =
                [[BBFile alloc] initWithFilePath:
                    [fileToLoad stringByReplacingOccurrencesOfString:@"/BYB files/"
                                                          withString:@""]];
            //Get file length
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[self.docPath stringByAppendingPathComponent:fileToLoad]];
            AudioFileID fileHandle;
            OSStatus s = AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadWritePermission, kAudioFileAIFFType, &fileHandle); //inFileTypeHint?? just gonna pass 0
            NSLog(@"Open Audio File status: %@", s);
            NSTimeInterval seconds;
            UInt32 propertySize = sizeof(seconds);
            AudioFileGetProperty(fileHandle, kAudioFilePropertyEstimatedDuration, &propertySize, &seconds);
            theFile.filelength = (float)seconds;
            
            AudioFileClose(fileHandle);
            
            [theFile save];
            [theFile release];
        }
    }
    self.allFiles = [NSMutableArray arrayWithArray:[BBFile allObjects]];
    [self.theTableView reloadData];
    
    
    for (int m = 0; m < [filesNeedingUpload count]; ++m)
    {
        if ([[filesNeedingUpload objectAtIndex:m] boolValue])
        {
            NSString *theFilename = [[self.allFiles objectAtIndex:m] filename]; 
            NSString *dbPath = @"/BYB files";
            [self.restClient uploadFile:theFilename toPath:dbPath fromPath:self.docPath];
        }
    }
    
    [self setStatus:@"Sync complete"];
    [self.syncTimer invalidate];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(clearStatus) userInfo:nil repeats:NO];
}


#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
    [filesHash release];
    filesHash = [metadata.hash retain];
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"aif", @"aiff", nil];
    NSMutableArray* newFilePaths = [NSMutableArray new];
    for (DBMetadata* child in metadata.contents) {
    	NSString* extension = [[child.path pathExtension] lowercaseString];
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newFilePaths addObject:child.path];
        }
    }
    
    [self compareBBFilesToNewFilePaths:(NSArray *)newFilePaths];
    self.lastFilePaths = newFilePaths;
}


- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    [self compareBBFilesToNewFilePaths:self.lastFilePaths];
    NSLog(@"Metadata unchanged");
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    self.status = @"Load metadata failed";
}

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    self.status = @"Loaded thumbnail";
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error {
   self.status = @"Failed to load thumbnail";
}

- (DBRestClient*)restClient { //getter
    if (restClient == nil) {
    	restClient = [[DBRestClient alloc] initWithSession: [DBSession sharedSession]];
    	restClient.delegate = self;
    }
    return restClient;
}


#pragma mark - Helper functions

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

#pragma mark - for BBFileActionViewControllerDelegate
- (void)deleteTheFiles:(NSArray *)theseFiles
{
    for (BBFile *file in theseFiles)
    {
        int index = [self.allFiles indexOfObject:file];
        [[self.allFiles objectAtIndex:index] deleteObject];
        [self.allFiles removeObjectAtIndex:index];
        
        [theTableView reloadData];
    }
}


#pragma mark DBLoginControllerDelegate methods

- (void)loginControllerDidLogin:(DBLoginController*)controller {
    self.preferences = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"isDBLinked"];
    NSLog(@"Dropbox is linked!");
    [self dbUpdate];
}

- (void)loginControllerDidCancel:(DBLoginController*)controller {
    [self dbUpdate];
}



@end



