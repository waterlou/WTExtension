//
//  UIImage+WTFilterBlur.h
//  WTExtensionDemo
//
//  Created by Water Lou on 9/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WTFilterBlur)

// slower blur that use CIFilter, iOS 6 or above only
- (UIImage*) wt_blur : (CGFloat) blurRadius;

@end
