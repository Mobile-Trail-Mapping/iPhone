//
//  AboutViewController.h
//  MTM
//
//  Created by Tim Ekl on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A simple settings screen that scrolls through information about the
 * MTM application.
 */
@interface AboutViewController : UIViewController {
@private
    UITextView * _textView;
    
    CGFloat _textFrameHeight;
    NSTimeInterval _scrollTime;
}

/**
 * The text view used to display information in the About screen.
 */
@property (nonatomic, retain) IBOutlet UITextView * textView;

/**
 * Begin scrolling the current about view. The scroll loop happens as follows:
 *  1. Pauses for a short time
 *  2. Scrolls the text upward slowly until it is entirely offscreen
 *  3. Pauses for a short time
 *  4. Restarts from step 2, scrolling upwards from the bottom of the view.
 */
- (void)beginScrollLoop;

@end
