//
//  UIView+WTExtension.h
//  fwTimeLapseVideo
//
//  Created by Water Lou on 20/5/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CALayer;

@interface UIView (WTExtension)

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize  size;
@property(nonatomic) CGFloat width, height; // normal rect properties
@property(nonatomic) CGFloat left, top, right, bottom; // will not stretch bounds
@property(nonatomic) CGFloat centerX, centerY;  // center x, y

// will stretch bounds
- (void) setLeftX:(CGFloat)left;
- (void) setRightX:(CGFloat)right;
- (void) setTopX:(CGFloat)top;
- (void) setBottomX:(CGFloat)bottom;

// take a snapshot of current view to image
- (UIImage*) wt_snapshot;
// create layer of the snapshot
- (CALayer*) wt_layerFromSnapShot;

@end
