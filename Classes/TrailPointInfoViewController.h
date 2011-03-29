#import <UIKit/UIKit.h>

#import "TrailPointInfoModalDelegate.h"

@class TrailPoint;

/**
 * Displays information about a particular TrailPoint object. Generally
 * shown modally or on a navigation stack called from the primary MapView.
 * Responsible for loading and showing both images and text data about its
 * trail point.
 */
@interface TrailPointInfoViewController : UIViewController {
@private
    id<TrailPointInfoModalDelegate> _delegate;
    TrailPoint * _trailPoint;
    
    UIView * _bgView;
    UIImageView * _imageView;
    UIImageView * _transitionImageView;
    UILabel * _conditionLabel;
    UILabel * _descLabel;
    UIActivityIndicatorView * _activityIndicatorView;
    
    NSTimer * _imageAnimationTimer;
    
    BOOL _performedFailAnimation;
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
 * The background view that provides shading and framing to trail point
 * images.
 */
@property (nonatomic, retain) UIView * bgView;

/**
 * The on-screen view which displays images associated with this controller's
 * TrailPoint.
 * @see TrailPointInfoViewController#trailPoint
 */
@property (nonatomic, retain) IBOutlet UIImageView * imageView;

/**
 * The on-screen view which displays the condition of this
 * controller's TrailPoint.
 * @see TrailPointInfoViewController#trailPoint
 */
@property (nonatomic, retain) IBOutlet UILabel * conditionLabel;

/**
 * The on-screen view which displays the description of this
 * controller's TrailPoint.
 * @see TrailPointInfoViewController#trailPoint
 */
@property (nonatomic, retain) IBOutlet UILabel * descLabel;

/**
 * A basic activity indicator to show image load progress.
 * @see TrailPointInfoViewController#imageView
 */
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * activityIndicatorView;

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

/**
 * Display the "failure" image shown when there are no images available for
 * this controller's TrailPoint.
 */
- (void)showFailureImage;

/**
 * Notification method that informs this controller a new image has been
 * downloaded from the MTM server and is ready for display in association
 * with this controller's TrailPoint.
 */
- (void)registerImage:(UIImage *)image;

/**
 * Begin the process of animating through this controller's TrailPoint's
 * images on a regular basis.
 */
- (void)startImageAnimations;

@end