//
//  UIView+WTLayer.m
//  WTExtensionDemo
//
//  Created by Water Lou on 8/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import "UIView+WTLayer.h"

@implementation UIView (WTLayer)

- (UIImage*)wt_snapshot
{
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (UIImage*)wt_snapshotWithBounds:(CGRect)bounds
{
	UIGraphicsBeginImageContextWithOptions(bounds.size, self.opaque, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Translate it, to the desired position
	CGContextTranslateCTM(context, -bounds.origin.x, -bounds.origin.y);
    // Render the view as image
    [self.layer renderInContext:context];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
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
