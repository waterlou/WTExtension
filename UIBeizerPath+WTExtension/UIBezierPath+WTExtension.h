//
//  UIBezierPath+WTExtension.h
//  WTExtensionDemo
//
//  Created by Water Lou on 21/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>

/* all path is fill using even-odd rule */
void CGContextDrawShadow(CGContextRef ctx, CGPathRef path, CGSize offset, CGFloat size, CGColorRef color);
void CGContextDrawInnerShadow(CGContextRef ctx, CGPathRef path, CGSize offset, CGFloat size, CGColorRef color);

@interface UIBezierPath (WTExtension)

// draw shadow without fill
- (void) wt_drawShadow:(CGSize)offset width:(CGFloat)size color:(UIColor*)color;
// draw inner shadow
- (void) wt_drawInnerShadow:(CGSize)offset width:(CGFloat)size color:(UIColor*)color;

@end
