//
//  UIDevice+WTExtension.h
//  WTExtensionDemo
//
//  Created by Water Lou on 11/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (WTExtension)

// major version number, i.e. iOS 7.1 will return 7
+(NSUInteger) wt_deviceSystemMajorVersion;

// check if the device is an iPad
+ (BOOL) wt_isPad;

@end
