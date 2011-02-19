//
//  AboutViewController.m
//  MTM
//
//  Created by Tim Ekl on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize textView = _textView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _textFrameHeight = self.textView.contentSize.height;
    _scrollTime = 30.0;
    
    [self beginScrollLoop];
}

- (void)beginScrollLoop {
    [self performSelector:@selector(commitScrollAction) withObject:nil afterDelay:(_scrollTime / 10)];
}

- (void)commitScrollAction {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:_scrollTime];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.textView.contentOffset = CGPointMake(0.0, _textFrameHeight);
    [UIView commitAnimations];
    
    [self performSelector:@selector(resetScrollView) withObject:nil afterDelay:_scrollTime];
}

- (void)resetScrollView {
    self.textView.contentOffset = CGPointMake(0.0, -1 * self.textView.frame.size.height);
    [self beginScrollLoop];
}

@end
