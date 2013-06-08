//
//  UIImage+WTFilter.m
//
//  Created by Water Lou on 15/2/13.
//  Copyright (c) 2013 First Water Tech Ltd. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>
#import "UIImage+WTFilter.h"

@implementation UIImage (WTFilter)

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

- (UIImage*) wt_fastBlur:(CGFloat)blurRadius
{
    if (blurRadius < 2.0) return self;  // no need to blur
    if (blurRadius > 40.0f) blurRadius = 40.0f;
    
    int boxSize = (int)blurRadius;
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    //create vImage_Buffer with data from CGImageRef    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    size_t   imgWidth = CGImageGetWidth(img),
            imgHeight = CGImageGetHeight(img),
       imgBytesPerRow = CGImageGetBytesPerRow(img);
    
    vImage_Buffer inBuffer;
    inBuffer.width = imgWidth;
    inBuffer.height = imgHeight;
    inBuffer.rowBytes = imgBytesPerRow;
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    void *pixelBuffer = malloc(imgBytesPerRow * imgHeight);
    void *pixelBuffer2 = malloc(imgBytesPerRow * imgHeight);
    if(pixelBuffer == NULL || pixelBuffer2==NULL) {
        NSLog(@"No pixelbuffer");
        CFRelease(inBitmapData);
        if (pixelBuffer) free(pixelBuffer);
        if (pixelBuffer2) free(pixelBuffer2);
        return nil;
    }
    vImage_Buffer outBuffer;
    outBuffer.data = pixelBuffer;
    outBuffer.width = imgWidth;
    outBuffer.height = imgHeight;
    outBuffer.rowBytes = imgBytesPerRow;

    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = imgWidth;
    outBuffer2.height = imgHeight;
    outBuffer2.rowBytes = imgBytesPerRow;

    //perform convolution
    vImage_Error error;
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) NSLog(@"error from convolution %ld", error);
    error = vImageBoxConvolve_ARGB8888(&outBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) NSLog(@"error from convolution %ld", error);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) NSLog(@"error from convolution %ld", error);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(img);
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    
    //clean up
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    return returnImage;
}

@end
