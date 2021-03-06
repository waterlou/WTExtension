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

// set the size of the view with the center unchanged
- (void) setSizeCentered:(CGSize)size;



// try to get the viewController containing this view by using responder chain
- (UIViewController*)wt_viewController;

-(void) wt_resignAllFirstResponder; // resign all first responder for this view and it's children
-(UIView *) wt_childFirstResponder; // for any child in the view that is a first responder

@end
