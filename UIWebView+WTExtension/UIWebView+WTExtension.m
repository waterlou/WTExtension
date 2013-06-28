//
//  UIWebView+WTExtension.m
//  WTExtensionDemo
//
//  Created by Water Lou on 28/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import "UIWebView+WTExtension.h"

@implementation UIWebView (WTExtension)

- (void) setSolidBackground:(UIColor *)backgroundColor
{
    self.backgroundColor = backgroundColor;
    // hide all shadow view
    for (UIView* subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in subView.subviews)
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
}

@end
