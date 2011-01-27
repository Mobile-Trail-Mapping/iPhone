@class TrailPoint;
@class TrailPointAnnotation;

@protocol TrailActionDelegate

/**
 * Get the callout disclosure view for the given TrailPointAnnotation. Used
 * to determine whether the disclosure icon should be the standard chevron
 * or another custom item (such as an info button or similar).
 */
- (UIView *)calloutViewForTrailPointAnnotation:(MKAnnotationView *)annotation;

/**
 * Display an instance of TrailPointInfoViewController to provide additional
 * information about the given TrailPoint. Implemented separately on iPad
 * and iPhone to handle differences in view navigation and modal presentation.
 */
- (void)showInformationForTrailPoint:(TrailPoint *)trailPoint sender:(id)sender;

@end