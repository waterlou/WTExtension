//
//  UIImage+ResizeExtension.h
//
//  Created by Water Lou on 15/2/13.
//  Copyright (c) 2013 First Water Tech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIImageResizeFillType) {
    UIImageResizeFillTypeIgnoreAspectRatio = 0,
    UIImageResizeFillTypeFillIn = 1,
    UIImageResizeFillTypeFitIn = 2,
};

@interface UIImage (WTExtension)

/*
 * resize image with options to keep aspect ratio using different method. And optionally round the corners
 */
- (UIImage*) resize : (CGSize)newSize
           fillType : (UIImageResizeFillType) fillType
      topLeftCorner : (CGFloat)topLeftCorner
     topRightCorner : (CGFloat)topRightCorner
  bottomRightCorner : (CGFloat)bottomRightCorner
   bottomLeftCorner : (CGFloat)bottomLeftCorner quality:(CGInterpolationQuality)quality;

// resize and not keep the aspect ratio
- (UIImage*) resize : (CGSize)newSize roundCorner:(CGFloat)roundCorner quality:(CGInterpolationQuality)quality;
// resize and keep the aspect ratio using fill in
- (UIImage*) resizeFillIn : (CGSize)newSize roundCorner:(CGFloat)roundCorner quality:(CGInterpolationQuality)quality;
// resize and keep the aspect ratio using fit in, not draw area will be in transparent color
- (UIImage*) resizeFitIn : (CGSize)newSize roundCorner:(CGFloat)roundCorner quality:(CGInterpolationQuality)quality;

// crop image, handled scale and orientation
- (UIImage*) crop : (CGRect) cropRect;


#pragma mark - above didn't add prefix for historic reason, functions below added prefix

// return an image that orientation always UIImageOrientationUp
- (UIImage*) wt_normalizeOrientation;

// normalize will convert image to jpeg and that load it back. It will normalize everything including colorspace and orientation
- (UIImage*) wt_normalize;

// generate plain image from color
+ (UIImage*) wt_imageWithUIColor : (UIColor*) color size : (CGSize) size;

// apply gradient shading on top of the image, grayscale only
- (UIImage*) wt_imageWithLinearGradient:(CGFloat)direction intensity:(CGFloat)intensity;
// components is a CGFloat[4], [lum1, alpha1, lum2, alpha2]
- (UIImage*) wt_imageWithLinearGradient:(CGFloat)direction components:(CGFloat*)components;

// return image mask with another image, useful for e.g. tab icons
- (UIImage*) wt_imageWithMask:(UIImage*)maskImage;
// generic function to overlap two images
- (UIImage*) wt_imageWithOverlay:(UIImage*)topImage blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha scale:(BOOL)scale;

@end
