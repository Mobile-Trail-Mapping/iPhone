#import <UIKit/UIKit.h>

#import "TrailPointInfoModalDelegate.h"

@class TrailPoint;

@interface TrailPointInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
@private
    id<TrailPointInfoModalDelegate> _delegate;
    TrailPoint * _trailPoint;
    
    UIImageView * _imageView;
    UITableView * _tableView;
    UIActivityIndicatorView * _activityIndicatorView;
    
    NSMutableArray * _images;
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
 * The on-screen view which displays images associated with this controller's
 * TrailPoint.
 * @see TrailPointInfoViewController#trailPoint
 */
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

/**
 * The on-screen view which displays detailed information about this
 * controller's TrailPoint.
 * @see TrailPointInfoViewController#trailPoint
 */
@property (nonatomic, retain) IBOutlet UITableView * tableView;

/**
 * A basic activity indicator to show image load progress.
 * @see TrailPointInfoViewController#imageView
 */
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityIndicatorView;

/**
 * The set of images associated with this controller's TrailPoint. Lazy-loaded
 * on each access to the controller. Caching is not implemented at this time.
 */
@property (nonatomic, retain) NSMutableArray * images;

/**
 * Dismiss the modal controller being displayed, if any. Primarily used to
 * hide instances of TrailPointInfoViewController.
 */
- (IBAction)dismiss:(id)sender;

/**
 * Load remote images for this controller's TrailPoint. This method is
 * intended for use as the launching point of a background thread; it
 * establishes an autorelease pool and dispatches calls to the main thread
 * for UI operations as necessary. Callers should be aware of the conventions
 * used by this method and subsequent load... methods.
 */
- (void)loadRemoteImage;

- (void)showFailureImage;

/**
 * Notification method that informs this controller a new image has been
 * downloaded from the MTM server and is ready for display in association
 * with this controller's TrailPoint.
 */
- (void)registerImage:(UIImage *)image;

@end