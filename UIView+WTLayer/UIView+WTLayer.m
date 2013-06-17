//
//  UIView+WTLayer.m
//  WTExtensionDemo
//
//  Created by Water Lou on 8/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import "UIView+WTLayer.h"

CGGradientRef dropShadowGradient()
{
    static CGGradientRef shadowGradient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray();
        CGFloat colors[] =
        {
            0.0, 0.5,
            0.0, 0.1,
            0.0, 0.0
        };
        shadowGradient = CGGradientCreateWithColorComponents(graySpace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*2));
        CGColorSpaceRelease(graySpace);
    });
    return shadowGradient;
}


@implementation UIView (WTLayer)

#pragma mark - common operation on layer

/* simple setting using the layer */
- (void) wt_setCornerRadius : (CGFloat) radius {
	self.layer.cornerRadius = radius;
}

- (void) wt_setBorder : (UIColor *) color width : (CGFloat) width  {
	self.layer.borderColor = [color CGColor];
	self.layer.borderWidth = width;
}

- (void) wt_setShadow : (UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius {
	CALayer *l = self.layer;
	l.shadowColor = [color CGColor];
	l.shadowOpacity = opacity;
	l.shadowOffset = offset;
	l.shadowRadius = blurRadius;
    
}

- (void) wt_setRectangularShadow : (UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius {
    [self wt_setShadow:color opacity:opacity offset:offset blurRadius:blurRadius];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

#pragma mark - snapshot

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

#pragma mark - helpers for setting layers
-(void) wt_setLayerAnchor : (CGPoint) p
{
	CALayer *l = [self layer];
	if (!CGPointEqualToPoint(p, l.anchorPoint)) {
		CGRect f = self.frame;
		l.anchorPoint = p;
		self.frame = f;
	}
}

- (CALayer *) wt_removeLayerByName : (NSString*) name
{
	for (CALayer *l in self.layer.sublayers) {
		if ([l.name isEqualToString: name]) {
			[l removeFromSuperlayer];
			return l;
		}
	}
	return nil;
}


/** Make picture like shadow **/
// This method taken verbatim from Joe Ricciopo's Shadow Demo:
// https://github.com/joericioppo/ShadowDemo

- (UIBezierPath*)wt_bezierPathWithCurvedShadowForRect:(CGRect)rect type: (WTViewShadowCurveType) type {
    
    if (type==WTViewShadowCurveTypePictureStyleDropShadow) {
        CGRect outerRect = CGRectOffset(CGRectInset(rect, -2.0f, -2.0f), 0.0f, 1.0f);
        return [UIBezierPath bezierPathWithRoundedRect:outerRect cornerRadius : 1.0f];
    }
    static const CGFloat offset = 10.0;
    static const CGFloat curve = 5.0;
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	
    CGPoint bottomLeft, bottomMiddle,bottomRight;
    CGPoint topLeft, topRight;
    
    switch (type) {
        default:
        case WTViewShadowCurveTypePictureStyleMiddleUp:
            topLeft		 = rect.origin;
            topRight	 = CGPointMake(CGRectGetWidth(rect), 0.0);
            bottomLeft	 = CGPointMake(0.0, CGRectGetHeight(rect) + offset);
            bottomMiddle = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect) - curve);
            bottomRight	 = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) + offset);
            break;
        case WTViewShadowCurveTypePictureStyleMiddleDown:
            topLeft		 = rect.origin;
            topRight	 = CGPointMake(CGRectGetWidth(rect), 0.0);
            bottomLeft	 = CGPointMake(0.0, CGRectGetHeight(rect));
            bottomMiddle = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect) + offset);
            bottomRight	 = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
            break;
    }
	
	[path moveToPoint:topLeft];
	[path addLineToPoint:bottomLeft];
	[path addQuadCurveToPoint:bottomRight controlPoint:bottomMiddle];
	[path addLineToPoint:topRight];
	[path addLineToPoint:topLeft];
	[path closePath];
	
	return path;
}

- (void) wt_setPictureShadow : (WTViewShadowCurveType)type opacity : (CGFloat) shadowOpacity {
	self.layer.shadowOpacity = shadowOpacity;
	self.layer.shadowOffset = CGSizeMake(0, 2);
	self.layer.shadowPath = [self wt_bezierPathWithCurvedShadowForRect:self.layer.bounds type:type].CGPath;
    
}


@end
