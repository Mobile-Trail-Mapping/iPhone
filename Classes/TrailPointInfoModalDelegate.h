@protocol TrailPointInfoModalDelegate

/**
 * Dismiss the modal controller being shown, if any. Used in the iPad
 * implementation to hide a TrailPointInfoViewController being presented
 * modally as a form sheet.
 */
- (void)dismissModalController;

@end