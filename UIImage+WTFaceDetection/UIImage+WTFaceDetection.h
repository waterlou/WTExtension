//
//  UIImage+WTFaceDetection.h
//  WTExtensionDemo
//
//  Created by Water Lou on 15/1/14.
//  Copyright (c) 2014 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WTFaceDetection)

// detect face location, if multiple faces will return union rect, return CGRectZero if not found
- (CGRect) wt_rectWithFaces;

@end
