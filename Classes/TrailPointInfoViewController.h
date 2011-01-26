#import <UIKit/UIKit.h>

#import "TrailPointInfoModalDelegate.h"

@interface TrailPointInfoViewController : UIViewController {
@private
    UIButton * _dismissButton;
    id<TrailPointInfoModalDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIButton * dismissButton;
@property (nonatomic, assign) id<TrailPointInfoModalDelegate> delegate;

- (IBAction)dismiss:(id)sender;

@end