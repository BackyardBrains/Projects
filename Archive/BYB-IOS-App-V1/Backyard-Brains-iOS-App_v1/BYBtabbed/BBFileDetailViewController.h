//
//  BBFileDetailViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/9/10.
//  Modified by Zachary King:
//      8/1/2011 Added support for editing multiple files
//  Copyright 2010 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFile.h"
#import "BBFileTitleEditorViewController.h"
#import "BBFileCommentEditorViewController.h"
@protocol BBFileDetailViewDelegate
	@required
		@property (nonatomic, retain) NSArray *files;

	@optional
		// NONE ARE OPTIONAL ALL ARE REQUIRED ZER VILL BE DISCIPLINE
@end





@interface BBFileDetailViewController : UIViewController <BBFileTitleEditorViewDelegate> {
	id <BBFileDetailViewDelegate> delegate;
	
	IBOutlet UIButton *titleButton;
	IBOutlet UILabel *durationLabel;
	IBOutlet UILabel *recordedInfoLabel;
	IBOutlet UILabel *samplingRateLabel;
	IBOutlet UILabel *gainLabel;
	IBOutlet UIButton *commentButton;
	IBOutlet UILabel *stimLabel;
	
	NSArray *files;
}

@property (assign) id <BBFileDetailViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIButton *titleButton;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *recordedInfoLabel;
@property (nonatomic, retain) IBOutlet UILabel *samplingRateLabel;
@property (nonatomic, retain) IBOutlet UILabel *gainLabel;
@property (nonatomic, retain) IBOutlet UIButton *commentButton;
@property (nonatomic, retain) NSArray *files;
@property (nonatomic, retain) IBOutlet UILabel *stimLabel; //tk


- (void)setButton:(UIButton *)button titleForAllStates:(NSString *)aTitle;
- (IBAction)pushTitleEditorView:(UIButton *)sender;
- (IBAction)pushCommentEditorView:(UIButton *)sender;
- (NSString *)stringWithFileLengthFromBBFile:(BBFile *)thisFile;

@end
