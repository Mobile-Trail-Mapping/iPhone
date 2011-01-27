#import <UIKit/UIKit.h>

#import "TrailPointInfoModalDelegate.h"

@class TrailPoint;

@interface TrailPointInfoViewController : UIViewController {
@private
    id<TrailPointInfoModalDelegate> _delegate;
    TrailPoint * _trailPoint;
}

/**
 * The delegate for action messages from this TrailPointInfoViewController.
 * An instance of TrailPointInfoModalDelegate.
 */
@property (nonatomic, assign) id<TrailPointInfoModalDelegate> delegate;

/**
 * The TrailPoint for which this view controller shows information. This
 * property is key-value observed, so it may be changed while the controller
 * is being displayed and will update information as necessary.
 */
@property (nonatomic, retain) TrailPoint * trailPoint;

/**
 * Dismiss the modal controller being displayed, if any. Primarily used to
 * hide instances of TrailPointInfoViewController.
 */
- (IBAction)dismiss:(id)sender;

@end