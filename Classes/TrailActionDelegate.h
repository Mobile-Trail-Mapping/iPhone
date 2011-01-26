@class TrailPoint;
@class TrailPointAnnotation;

@protocol TrailActionDelegate

- (UIView *)calloutViewForTrailPointAnnotation:(MKAnnotationView *)annotation;

- (void)showInformationForTrailPoint:(TrailPoint *)trailPoint sender:(id)sender;

@end