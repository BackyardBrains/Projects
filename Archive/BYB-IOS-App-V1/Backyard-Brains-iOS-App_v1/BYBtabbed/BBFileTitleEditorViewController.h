//
//  BBFileTitleEditorViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/10/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFile.h"

@protocol BBFileTitleEditorViewDelegate
	@required
		@property (nonatomic, retain) NSArray *files;

	@optional
	// nothing optional
@end


@interface BBFileTitleEditorViewController : UIViewController {
	IBOutlet UITextField *titleTextField;
	NSArray *files;
    NSString *ogString;
	id <BBFileTitleEditorViewDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) NSArray *files;
@property (nonatomic, retain) NSString *ogString;
@property (assign) id <BBFileTitleEditorViewDelegate> delegate;

- (IBAction)done;

@end