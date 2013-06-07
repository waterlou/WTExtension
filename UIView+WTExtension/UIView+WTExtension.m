//
//  UIView+WTExtension.m
//  fwTimeLapseVideo
//
//  Created by Water Lou on 20/5/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+WTExtension.h"

@implementation UIView (WTExtension)

- (CGPoint)origin { return self.frame.origin; }
- (void)setOrigin:(CGPoint)origin { self.frame = (CGRect){ .origin=origin, .size=self.frame.size }; }

- (CGSize)size { return self.frame.size; }
- (void)setSize:(CGSize)size { self.frame = (CGRect){ .origin=self.frame.origin, .size=size }; }

- (CGFloat)width { return self.frame.size.width; }
- (void)setWidth:(CGFloat)width { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=width, .size.height=self.frame.size.height }; }

- (CGFloat)height { return self.frame.size.height; }
- (void)setHeight:(CGFloat)height { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=height }; }

- (CGFloat)left { return self.frame.origin.x; }
- (void)setLeft:(CGFloat)left { self.frame = (CGRect){ .origin.x=left, .origin.y=self.frame.origin.y, .size=self.frame.size }; }
- (void)setLeftX:(CGFloat)left { self.frame = (CGRect){ .origin.x=left, .origin.y=self.frame.origin.y, .size.width=fmaxf(self.frame.origin.x+self.frame.size.width-left,0), .size.height=self.frame.size.height }; }

- (CGFloat)top { return self.frame.origin.y; }
- (void)setTop:(CGFloat)top { self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=top, .size=self.frame.size }; }
- (void)setTopX:(CGFloat)top { self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=top, .size.width=self.frame.size.width, .size.height=fmaxf(self.frame.origin.y+self.frame.size.height-top,0) }; }

- (CGFloat)right { return self.frame.origin.x + self.frame.size.width; }
- (void)setRight:(CGFloat)right { self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=self.frame.origin.y, .size=self.frame.size }; }
- (void)setRightX:(CGFloat)right { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=fmaxf(right-self.frame.origin.x,0), .size.height=self.frame.size.height }; }

- (CGFloat)bottom { return self.frame.origin.y + self.frame.size.height; }
- (void)setBottom:(CGFloat)bottom { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=fmaxf(bottom-self.frame.origin.y,0) }; }
- (void)setBottomX:(CGFloat)bottom { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=fmaxf(bottom-self.frame.origin.y,0) }; }

#pragma mark center

- (CGFloat)centerX {return self.center.x;}
- (void)setCenterX:(CGFloat)centerX {self.center = CGPointMake(centerX, self.center.y);}
- (CGFloat)centerY {return self.center.y;}
- (void)setCenterY:(CGFloat)centerY {self.center = CGPointMake(self.center.x, centerY);}


- (UIImage*) wt_snapshot
{
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (CALayer*) wt_layerFromSnapShot
{
    CALayer* imageLayer = [CALayer layer];
    imageLayer.anchorPoint = CGPointMake(1, 1);
    imageLayer.frame = self.bounds;
    imageLayer.contents = (__bridge id) [[self wt_snapshot] CGImage];
    return imageLayer;
}

@end
