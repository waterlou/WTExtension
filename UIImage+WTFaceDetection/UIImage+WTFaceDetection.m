//
//  UIImage+WTFaceDetection.m
//  WTExtensionDemo
//
//  Created by Water Lou on 15/1/14.
//  Copyright (c) 2014 Water Lou. All rights reserved.
//

#import "UIImage+WTFaceDetection.h"

@implementation UIImage (WTFaceDetection)

- (CGRect) wt_rectWithFaces {
    // Get a CIIImage
    CIImage* image = self.CIImage;
    
    // If now available we create one using the CGImage
    if (!image) {
        image = [CIImage imageWithCGImage:self.CGImage];
    }
    
    // create a face detector - since speed is not an issue we'll use a high accuracy detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyLow}];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    // we'll iterate through every detected face. CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.
    CGRect totalFaceRects = CGRectZero;
    
    if (features.count > 0) {
        //We get the CGRect of the first detected face
        totalFaceRects = ((CIFaceFeature*)[features objectAtIndex:0]).bounds;
        
        // Now we find the minimum CGRect that holds all the faces
        for (CIFaceFeature* faceFeature in features) {
            totalFaceRects = CGRectUnion(totalFaceRects, faceFeature.bounds);
        }
    }
    
    //So now we have either a CGRect holding the center of the image or all the faces.
    return totalFaceRects;
}

@end
