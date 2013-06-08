//
//  UIView+WTLayer.h
//  WTExtensionDemo
//
//  Created by Water Lou on 8/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (WTLayer)

// take a snapshot of current view to image
- (UIImage*)wt_snapshot;
- (UIImage*)wt_snapshotWithBounds:(CGRect)bounds;
// create layer of the snapshot
- (CALayer*)wt_layerFromSnapShot;

@end
