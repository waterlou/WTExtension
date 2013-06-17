//
//  UIDevice+WTExtension.m
//  WTExtensionDemo
//
//  Created by Water Lou on 11/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import "UIDevice+WTExtension.h"

@implementation UIDevice (WTExtension)

+(NSUInteger) wt_deviceSystemMajorVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@end
