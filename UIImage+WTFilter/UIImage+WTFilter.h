//
//  UIImage+WTFilter.h
//
//  Created by Water Lou on 15/2/13.
//  Copyright (c) 2013 First Water Tech Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WTFilter)

// fast blur that only approx the blur using convolution, radius 2 to 40
// if you want to fastblur a screen capture, call wt_normalize first
// otherwise, the color will not be the same as the orientation screen capture
// for iOS 5 or above
- (UIImage*) wt_fastBlur:(CGFloat)blurRadius;

// slower blur that use CIFilter, iOS 6 or above only
- (UIImage*) wt_blur : (CGFloat) blurRadius;

@end
