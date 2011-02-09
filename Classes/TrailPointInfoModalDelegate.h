
/**
 * The protocol for objects which handle modally displayed trail point info
 * views. Objects implementing this protocol generate instances of 
 * TrailPointInfoViewController and receive messages from those instances
 * related to display action callbacks.
 */
@protocol TrailPointInfoModalDelegate

/**
 * Dismiss the modal controller being shown, if any. Used in the iPad
 * implementation to hide a TrailPointInfoViewController being presented
 * modally as a form sheet.
 */
- (void)dismissModalController;

@end