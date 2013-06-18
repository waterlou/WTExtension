//
//  UIImage+ResizeExtension.m
//
//  Created by Water Lou on 15/2/13.
//  Copyright (c) 2013 First Water Tech Ltd. All rights reserved.
//

#import "UIImage+WTExtension.h"

static void CGContextMakeRoundCornerPath(CGContextRef c, CGRect rrect, float rad_tl, float rad_tr, float rad_br, float rad_bl) {
	CGContextBeginPath(c);
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	// Next, we will go around the rectangle in the order given by the figure below.
	//       minx    midx    maxx
	// miny    8       7       6
	// midy   1 9              5
	// maxy    2       3       4
	// Which gives us a coincident start and end point, which is incidental to this technique, but still doesn't
	// form a closed path, so we still need to close the path to connect the ends correctly.
	// Thus we start by moving to point 1, then adding arcs through each pair of points that follows.
	// You could use a similar tecgnique to create any shape with rounded corners.
	
	// Start at 1
	CGContextMoveToPoint(c, minx, midy);
	// Add an arc through 2 to 3
	CGContextAddArcToPoint(c, minx, miny, midx, miny, rad_bl);
	// Add an arc through 4 to 5
	CGContextAddArcToPoint(c, maxx, miny, maxx, midy, rad_br);
	// Add an arc through 6 to 7
	CGContextAddArcToPoint(c, maxx, maxy, midx, maxy, rad_tr);
	// Add an arc through 8 to 9
	CGContextAddArcToPoint(c, minx, maxy, minx, midy, rad_tl);
	// Close the path
	CGContextClosePath(c);
}


@implementation UIImage (WTExtension)

- (UIImage*) wt_resize : (CGSize)newSize roundCorner:(CGFloat)roundCorner quality:(CGInterpolationQuality)quality {
	return [self wt_resize:newSize fillType:UIImageResizeFillTypeIgnoreAspectRatio
          topLeftCorner:roundCorner topRightCorner:roundCorner bottomRightCorner:roundCorner bottomLeftCorner:roundCorner quality:quality];
}

- (UIImage*) wt_resizeFillIn : (CGSize)newSize roundCorner:(CGFloat)roundCorner quality:(CGInterpolationQuality)quality {
	return [self wt_resize:newSize fillType:UIImageResizeFillTypeFillIn
          topLeftCorner:roundCorner topRightCorner:roundCorner bottomRightCorner:roundCorner bottomLeftCorner:roundCorner quality:quality];
}

- (UIImage*) wt_resizeFitIn : (CGSize)newSize roundCorner:(CGFloat)roundCorner quality:(CGInterpolationQuality)quality {
	return [self wt_resize:newSize fillType:UIImageResizeFillTypeFitIn
          topLeftCorner:roundCorner topRightCorner:roundCorner bottomRightCorner:roundCorner bottomLeftCorner:roundCorner quality:quality];
}

- (UIImage*) wt_resize : (CGSize)newSize
           fillType : (UIImageResizeFillType) fillType
      topLeftCorner : (CGFloat)topLeftCorner
     topRightCorner : (CGFloat)topRightCorner
  bottomRightCorner : (CGFloat)bottomRightCorner
   bottomLeftCorner : (CGFloat)bottomLeftCorner quality:(CGInterpolationQuality)quality {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
	CGRect imageRect = CGRectMake(0, 0, newSize.width, newSize.height);
	if (topLeftCorner>0.0 || topRightCorner>0.0 || bottomLeftCorner>0.0 || bottomRightCorner>0.0) {
        CGContextRef c = UIGraphicsGetCurrentContext();
		CGContextMakeRoundCornerPath(c, imageRect, topLeftCorner, topRightCorner, bottomRightCorner, bottomLeftCorner);
		CGContextClip(c);
	}
	switch (fillType) {
        case UIImageResizeFillTypeFillIn:
        {
            CGSize oldSize = self.size;
            CGFloat r1 = oldSize.width/oldSize.height;
            CGFloat r2 = newSize.width/newSize.height;
            if (r1 > r2) {
                CGFloat w = oldSize.width * newSize.height / oldSize.height;
                CGFloat h = newSize.height;
                imageRect = CGRectMake((newSize.width-w)/2.0f, 0.0f, w, h);
            }
            else {
                CGFloat w = newSize.width;
                CGFloat h = oldSize.height * newSize.width / oldSize.width;
                imageRect = CGRectMake(0.0f, (newSize.height-h)/2.0f, w, h);
            }
        } break;
        case UIImageResizeFillTypeFitIn:
        {
            CGSize oldSize = self.size;
            CGFloat r1 = oldSize.width/oldSize.height;
            CGFloat r2 = newSize.width/newSize.height;
            if (r1 > r2) {
                imageRect.size.height = newSize.width * oldSize.height / oldSize.width;
                imageRect.origin.y = (newSize.height - imageRect.size.height ) / 2.0;
            }
            else {
                imageRect.size.width = newSize.height * oldSize.width / oldSize.height;
                imageRect.origin.x = (newSize.width - imageRect.size.width ) / 2.0;
            }
        }
            break;
        default:
            break;
	}
	[self drawInRect:imageRect];
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}

- (UIImage*) wt_crop : (CGRect) cropRect
{
    // if orientation not standard, rotate the rect
    CGFloat scale = self.scale;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
            cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI_2), 0, -cropRect.size.height));
            break;
        case UIImageOrientationRight:
            cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformTranslate(CGAffineTransformMakeRotation(-M_PI_2), -cropRect.size.width, 0));
            break;
        case UIImageOrientationDown:
            cropRect = CGRectApplyAffineTransform(cropRect, CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -cropRect.size.width, -cropRect.size.height));
            break;
        default:
            break;
    }
    // multiply cropRect with scale for retina image
    if (scale>1.0) {
        cropRect.origin.x *= scale;
        cropRect.origin.y *= scale;
        cropRect.size.width *= scale;
        cropRect.size.height *= scale;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    UIImage *ret = [UIImage imageWithCGImage: imageRef scale:scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return ret;
}

- (UIImage*) wt_normalizeOrientation
{
    if (self.imageOrientation==UIImageOrientationUp) return self;   // correct orientation
    // redraw image in context to create a new image
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
	[self drawInRect:rect];
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}

- (UIImage*) wt_normalize
{
    return [UIImage imageWithData:UIImageJPEGRepresentation(self, 1.0) scale:self.scale];
}

+ (UIImage*) wt_imageWithUIColor : (UIColor*) color size : (CGSize) size
{
    // redraw image in context to create a new image
    CGRect rect = (CGRect){.origin=CGPointZero, .size=size};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
    
}

+ (UIImage*) wt_spotMask:(CGSize)size center:(CGPoint)center startRadius:(CGFloat)startRadius endRadius:(CGFloat)endRadius inverted:(BOOL)inverted
{

    CGRect rect = (CGRect){.origin=CGPointZero, .size=size};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    if (inverted) {
        static CGGradientRef gradient = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            CGColorSpaceRef myColorspace=CGColorSpaceCreateDeviceGray();
            const CGFloat locations[5] = { 0.0, 0.35, 0.5, 0.65, 1.0 };
            const CGFloat components[10] = { 1.0, 0.0, 1.0, 0.25, 1.0, 0.5, 1.0, 0.75, 1.0, 1.0};
            size_t num_locations = sizeof(locations) / sizeof(locations[0]);
            gradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
            CGColorSpaceRelease(myColorspace);
        });
        CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), gradient, center, startRadius, center, endRadius, kCGGradientDrawsAfterEndLocation);
    }
    else {
        static CGGradientRef gradient = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            CGColorSpaceRef myColorspace=CGColorSpaceCreateDeviceGray();
            const CGFloat locations[5] = { 1.0, 0.65, 0.5, 0.35, 0.0 };
            const CGFloat components[10] = { 1.0, 0.0, 1.0, 0.25, 1.0, 0.5, 1.0, 0.75, 1.0, 1.0};
            size_t num_locations = sizeof(locations) / sizeof(locations[0]);
            gradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
            CGColorSpaceRelease(myColorspace);
        });
        CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), gradient, center, startRadius, center, endRadius, kCGGradientDrawsBeforeStartLocation);
    }
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
    
}

// private function to draw gradient according the size of the image
- (void) wt_applyLinearGradient:(CGFloat)direction components:(CGFloat*)components context:(CGContextRef)context
{
    CGSize size = self.size;
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    
    CGColorSpaceRef myColorspace=CGColorSpaceCreateDeviceGray();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);
    
    CGFloat angle = direction * M_PI / 180.0f;
    CGFloat width = fminf(size.height, size.width) / 2.0f;
    CGPoint myStartPoint, myEndPoint;
    myStartPoint.x = cosf(angle) * width + size.width / 2.0f;
    myStartPoint.y = -sinf(angle) * width + size.height / 2.0f;
    myEndPoint.x = cosf(angle+M_PI) * width + size.width / 2.0f;
    myEndPoint.y = -sinf(angle+M_PI) * width + size.height / 2.0f;
    CGContextDrawLinearGradient (context, myGradient, myStartPoint, myEndPoint, 0);
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
}

- (UIImage*) wt_imageWithLinearGradient:(CGFloat)direction intensity:(CGFloat)intensity
{
    CGFloat components[] = {0.0, intensity, 1.0, intensity};
    return [self wt_imageWithLinearGradient:direction components:components];
}

- (UIImage*) wt_imageWithLinearGradient:(CGFloat)direction components:(CGFloat*)components
{
    CGSize size = self.size;
    CGRect rect = (CGRect){.origin = CGPointZero, .size = size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	[self drawInRect:rect];

    // apply gradient
    [self wt_applyLinearGradient:direction components:components context:UIGraphicsGetCurrentContext()];
    
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}

- (UIImage*) wt_imageWithMask:(UIImage*)maskImage
{
    return [maskImage wt_imageWithOverlay:self blendMode:kCGBlendModeSourceIn alpha:1.0 scale:NO];
}

- (UIImage*) wt_imageWithOverlay:(UIImage*)topImage blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha scale:(BOOL)scale
{
    CGSize size = self.size;
    CGRect rect = (CGRect){.origin = CGPointZero, .size = size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	[self drawInRect:rect];
    
    if (scale)
        [topImage drawInRect:rect blendMode:blendMode alpha:alpha];
    else
        [topImage drawAtPoint:CGPointMake((size.width - topImage.size.width)/2.0f, (size.height - topImage.size.height)/2.0f) blendMode:blendMode alpha:alpha];
    
	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return ret;
}


@end
