//
//  Backyard_BrainsAppDelegate.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/6/10.
//  Copyright University of Michigan 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DrawingViewController.h"
#import "LJController.h"

@class BBTabViewController;
@class AudioSignalManager;
@class BBFileViewControllerTBV;
@class TabDetailViewController;
@class DrawingDataManager;
@class LarvaJoltAudio;

@interface Backyard_BrainsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UISplitViewControllerDelegate, DrawingViewControllerDelegate, LarvaJoltViewDelegate> {
    
    UIWindow *window;
    
    BBTabViewController *tabBarController;
    
    UISplitViewController *splitViewController;
    BBFileViewControllerTBV *rootVC;
    TabDetailViewController *detailVC;
    
    DrawingDataManager *drawingDataManager;
    
	LarvaJoltAudio *pulse;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet BBTabViewController *tabBarController;

@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet BBFileViewControllerTBV *rootVC;
@property (nonatomic, retain) IBOutlet TabDetailViewController *detailVC;

@property (nonatomic, retain) IBOutlet DrawingDataManager *drawingDataManager;
@property (nonatomic, retain) LarvaJoltAudio *pulse;

@end
