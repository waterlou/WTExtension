//
//  UIImage+WTFilterBlur.m
//  WTExtensionDemo
//
//  Created by Water Lou on 9/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "UIImage+WTFilterBlur.h"

@implementation UIImage (WTFilterBlur)

- (CIImage *) createCIFilterForBlur:(CIContext*)context blurRadius:(CGFloat)blurRadius
{
    CIImage *sourceImage = [CIImage imageWithCGImage:self.CGImage];
    
    // Apply clamp filter:
    // this is needed because the CIGaussianBlur when applied makes
    // a trasparent border around the image
    CIFilter *clamp = [CIFilter filterWithName:@"CIAffineClamp"];
    
    if (!clamp) {
        NSLog(@"failed to create filter CIAffineClamp");
        return nil;
    }
    
    [clamp setValue:sourceImage forKey:kCIInputImageKey];
    CIImage *clampResult = [clamp valueForKey:kCIOutputImageKey];
    
    // Apply Gaussian Blur filter
    CIFilter *gaussianBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    if (!gaussianBlur) {
        NSLog(@"failed to create filter CIGaussianBlur");
        return nil;
    }
    
    [gaussianBlur setValue:clampResult forKey:kCIInputImageKey];
    [gaussianBlur setValue:[NSNumber numberWithFloat:blurRadius] forKey:@"inputRadius"];
    
    return [gaussianBlur valueForKey:kCIOutputImageKey];
}

- (UIImage*) wt_blur : (CGFloat) blurRadius
{
#if _DEBUG
    NSAssert([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0, @"wt_blur need iOS 6.0");
#endif
    CIContext *context   = [CIContext contextWithOptions:nil];
    CIImage *resultImage = [self createCIFilterForBlur:context blurRadius:blurRadius];
    CGFloat width = CGImageGetWidth(self.CGImage), height = CGImageGetHeight(self.CGImage);
    CGImageRef cgImage = [context createCGImage:resultImage
                                       fromRect:(CGRect){.origin=CGPointZero, .size.width=width, .size.height=height}];
    UIImage *blurredImage = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cgImage);
    return blurredImage;
}

@end
