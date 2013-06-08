//
//  UIView+WTExtension.h
//  fwTimeLapseVideo
//
//  Created by Water Lou on 20/5/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WTExtension)

// extra geometry
@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize  size;
@property(nonatomic) CGFloat width, height; // normal rect properties
@property(nonatomic) CGFloat left, top, right, bottom; // will not stretch bounds
@property(nonatomic) CGFloat centerX, centerY;  // center x, y

// will stretch bounds
- (void) setLeftStretched:(CGFloat)left;
- (void) setRightStretched:(CGFloat)right;
- (void) setTopStretched:(CGFloat)top;
- (void) setBottomStretched:(CGFloat)bottom;

@end
