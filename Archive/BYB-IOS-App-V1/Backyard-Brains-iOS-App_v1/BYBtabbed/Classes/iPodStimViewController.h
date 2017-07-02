//
//  iPodStimViewController.h
//  Backyard Brains
//
//  Created by Zachary King on 12/16/11.
//  Copyright (c) 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LarvaJoltAudio.h"
#import "LJController.h"


@interface iPodStimViewController : UIViewController <LarvaJoltAudioDelegate, MPMediaPickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,assign) id <LarvaJoltViewDelegate> delegate;
@property (nonatomic,assign) LJController *ljController;
@property (nonatomic,retain) IBOutlet UITableView *theTableView;
@property (nonatomic,retain) NSArray *songNames;
@property (nonatomic,retain) NSArray *songArtists;

- (IBAction)presentTheMediaPicker:(id)sender;
- (void)updateTableWithCollection:(MPMediaItemCollection *)collection;



@end
