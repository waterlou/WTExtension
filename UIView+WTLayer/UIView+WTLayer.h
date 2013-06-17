//
//  UIView+WTLayer.h
//  WTExtensionDemo
//
//  Created by Water Lou on 8/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, WTViewShadowCurveType) {
    WTViewShadowCurveTypePictureStyleMiddleUp,
    WTViewShadowCurveTypePictureStyleMiddleDown,
    WTViewShadowCurveTypePictureStyleDropShadow,
};

@interface UIView (WTLayer)

#pragma mark - common layer operation

// set round corner
- (void) wt_setCornerRadius : (CGFloat) radius;
// set inner border
- (void) wt_setBorder : (UIColor *) color width : (CGFloat) width;
// set the shadow
// Example: [view setShadow:[UIColor blackColor] opacity:0.5 offset:CGSizeMake(1.0, 1.0) blueRadius:3.0];
- (void) wt_setShadow : (UIColor *)color opacity:(CGFloat)opacity offset:(CGSize) offset blurRadius:(CGFloat)blurRadius;
- (void) wt_setRectangularShadow : (UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius;

#pragma mark - snapshot

// take a snapshot of current view to image
- (UIImage*)wt_snapshot;
- (UIImage*)wt_snapshotWithBounds:(CGRect)bounds;
// create layer of the snapshot
- (CALayer*)wt_layerFromSnapShot;

#pragma mark - complicated visual effects
- (void) wt_setPictureShadow : (WTViewShadowCurveType)type opacity : (CGFloat) shadowOpacity;


/* Set the layer anchor without changing the position of the view, by reset the frame of the view */
- (void) wt_setLayerAnchor:(CGPoint) p;
- (CALayer *) wt_removeLayerByName:(NSString*)name;


@end
