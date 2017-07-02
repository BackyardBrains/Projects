//NOTE:
// This has been replaced by BBFileViewControllerTBV, a subclass of UITableViewController
 



//
//  BBFileTableViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Modified by Zachary King
//      7/12/11 Set up everything for new tabbed interface. Removed audio player.
//  Copyright 2010 Backyard Brains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBFile.h"
#import "BBFileTableCell.h"
#import "BBFileActionViewControllerTBV.h"
#import "DropboxSDK.h"


@interface BBFileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, BBFileTableCellDelegate, BBFileActionViewControllerDelegate, DBLoginControllerDelegate, DBRestClientDelegate>
{
    IBOutlet UITableView *theTableView;
    IBOutlet UIButton *dbStatusBar;
	
	NSMutableArray *allFiles;
    NSArray *filesSelectedForAction;
    
	NSMutableArray *selectedArray;
	BOOL inPseudoEditMode;
	UIImage *selectedImage;
	UIImage *unselectedImage;
    NSUInteger lastRowSelected;
    
	NSDictionary *preferences;
    
    DBRestClient *restClient;
    NSString *status;
    
    NSArray* filePaths;
    NSString* filesHash;
    
    NSTimer *syncTimer;
    NSArray *lastFilePaths;
    
    NSString *docPath;
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UIButton *dbStatusBar;
@property (nonatomic, retain) NSMutableArray *allFiles;

@property (nonatomic, retain) NSMutableArray *selectedArray;
@property BOOL inPseudoEditMode;

- (IBAction)togglePseudoEditMode;


//For BBFileActionViewControllerDelegate
//@property (nonatomic, retain) NSArray *files;
//- (void)deleteTheFiles:(NSArray *)theseFiles;

//For DBLoginControllerDelegate
//- (void)loginControllerDidLogin:(DBLoginController*)controller;
//- (void)loginControllerDidCancel:(DBLoginController*)controller;
    

@end