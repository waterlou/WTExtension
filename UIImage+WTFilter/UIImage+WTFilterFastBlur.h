//
//  UIImage+WTFilterFasterBlur.h
//  WTExtensionDemo
//
//  Created by Water Lou on 9/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WTFilterFastBlur)

// fast blur that only approx the blur using convolution, radius 2 to 40
// if you want to fastblur a screen capture, call wt_normalize first
// otherwise, the color will not be the same as the orientation screen capture
// for iOS 5 or above
- (UIImage*) wt_fastBlur:(CGFloat)blurRadius;

/* https://developer.apple.com/library/prerelease/ios/samplecode/UIImageEffects/Introduction/Intro.html */
- (UIImage *)wt_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
