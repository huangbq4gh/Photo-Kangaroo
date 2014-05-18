//
//  bingqingDismissDetailTransition.m
//  Photo Kangaroo
//
//  Created by Bingqing Huang on 5/17/14.
//  Copyright (c) 2014 Bingqing Huang. All rights reserved.
//

#import "bingqingDismissDetailTransition.h"

@implementation bingqingDismissDetailTransition


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    [UIView animateWithDuration:0.3 animations:^{
        detail.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [detail.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}



@end
