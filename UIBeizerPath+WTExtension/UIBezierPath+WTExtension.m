//
//  UIBezierPath+WTExtension.m
//  WTExtensionDemo
//
//  Created by Water Lou on 21/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import "UIBezierPath+WTExtension.h"

void CGContextDrawInnerShadow(CGContextRef ctx, CGPathRef path, CGSize offset, CGFloat size, CGColorRef color)
{
    CGRect bounds = CGPathGetBoundingBox(path);
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    CGContextSetShadowWithColor(ctx, offset, size, color);
    CGContextAddPath(ctx, path);
    CGContextAddRect(ctx, CGRectInset(bounds, -size, -size));
    CGContextEOFillPath(ctx);
    CGContextRestoreGState(ctx);
}

void CGContextDrawShadow(CGContextRef ctx, CGPathRef path, CGSize offset, CGFloat size, CGColorRef color)
{
    CGRect bounds = CGPathGetBoundingBox(path);
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path);
    CGContextAddRect(ctx, CGRectInset(bounds, -size * 2.0, -size * 2.0));
    CGContextEOClip(ctx);
    CGContextSetShadowWithColor(ctx, offset, size, color);
    CGContextAddPath(ctx, path);
    CGContextEOFillPath(ctx);
    CGContextRestoreGState(ctx);
}

@implementation UIBezierPath (WTExtension)

- (void) wt_drawShadow:(CGSize)offset width:(CGFloat)size color:(UIColor*)color
{
    if (color==nil) color = [UIColor darkGrayColor];
    CGContextDrawShadow(UIGraphicsGetCurrentContext(), self.CGPath, offset, size, color.CGColor);
}

- (void) wt_drawInnerShadow:(CGSize)offset width:(CGFloat)size color:(UIColor*)color
{
    if (color==nil) color = [UIColor darkGrayColor];
    CGContextDrawInnerShadow(UIGraphicsGetCurrentContext(), self.CGPath, offset, size, color.CGColor);
}


@end
