

#import <UIKit/UIKit.h>
#import "BBFileActionViewControllerTBV.h"

@class DrawingDataManager;

@interface TabDetailViewController : UIViewController <DrawingViewControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) DrawingDataManager *drawingDataManager;

@property (nonatomic,assign) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,assign) IBOutlet BBFileViewControllerTBV *fileController;
@property (nonatomic,assign) IBOutlet id <DrawingViewControllerDelegate> delegate;


@end
