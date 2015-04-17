//
//  WTMasterViewController.m
//  WTExtensionDemo
//
//  Created by Water Lou on 8/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import "WTMasterViewController.h"
#import "WTTestImageViewController.h"
#import "WTTestAnimViewController.h"

#import "UIImage+WTExtension.h"
#import "WTGlyphFontSet.h"
#import "UIView+WTLayer.h"

#import "UIImage+WTFilter.h"
#import "UIBezierPath+WTExtension.h"

@implementation WTMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"WTExtension Demo", @"Master");
    }
    return self;
}

- (UIImage*) demoImage
{
    UIImage *image = [UIImage imageNamed:@"screenshot"];
    return [image wt_resizeFillIn:CGSizeMake(128, 128) roundCorner:64.0f quality:kCGInterpolationDefault];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        default:
            switch (indexPath.row) {
                case 0:
                {
                    // demo image resize with crop
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    UIImage *image = [UIImage imageNamed:@"screenshot"];
                    UIImage *resultImage = [image wt_resizeFillIn:CGSizeMake(128, 128) roundCorner:8.0f quality:kCGInterpolationDefault];
                    [vc setImage:resultImage];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 1:
                {
                    // demo gradient overlay
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    UIImage *image = [self demoImage];
                    UIImage *resultImage = [image wt_imageWithLinearGradient:-90.0 intensity:0.4f];
                    [vc setImage:resultImage];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 2:
                {
                    // demo gradient mask
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    UIImage *image = [UIImage imageNamed:@"screenshot"];
                    UIImage *mask = [UIImage imageGlyphNamed:@"fontawesome##group" height:200 color:[UIColor whiteColor]];
                    UIImage *resultImage = [image wt_imageWithMask:mask];
                    //resultImage = [resultImage wt_imageWithLinearGradient:-90.0f intensity:0.2];    // add gradient
                    [vc setImage:resultImage];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 3:
                {
                    // spot
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    UIImage *image = [UIImage imageNamed:@"screenshot"];
                    UIImage *mask = [UIImage wt_spotMask:image.size center:CGPointMake(150, 150) startRadius:5 endRadius:100 inverted:YES];
                    UIImage *resultImage = [image wt_applyBlurWithRadius:8.0f tintColor:[UIColor colorWithWhite:0.0 alpha:0.5] saturationDeltaFactor:1.8 maskImage:mask];
                    [vc setImage:resultImage];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 4:
                {
                    // spot blur
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    UIImage *image = [UIImage imageNamed:@"screenshot"];
                    UIImage *mask = [UIImage wt_spotMask:image.size center:CGPointMake(120, 200) startRadius:40 endRadius:100 inverted:NO];
                    UIImage *resultImage = [image wt_applyBlurWithRadius:8.0f tintColor:nil saturationDeltaFactor:1.0 maskImage:mask];
                    [vc setImage:resultImage];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 5:
                {
                    // demo image blur
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    UIImage *image = [UIImage imageNamed:@"screenshot"];
                    UIImage *resultImage = [image wt_fastBlur:8.0f];
                    [vc setImage:resultImage];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 6:
                {
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    UIImage *image = [UIImage imageNamed:@"screenshot"];
                    UIImage *resultImage = [image wt_blur:8.0f];
                    [vc setImage:resultImage];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 7:
                {
                    // snapshot
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    [vc setImage:[[self.view wt_snapshot] wt_fastBlur:8.0f]];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 8:
                {
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    [vc setImage:[[self.view wt_snapshot] wt_blur:8.0f]];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    // Picture Shadow Middle Down
                    WTTestAnimViewController *vc = [[WTTestAnimViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                    [[vc imageView] wt_setPictureShadow:WTViewShadowCurveTypePictureStyleMiddleDown opacity:0.3];
                } break;
                case 1:
                {
                    // Picture Shadow Middle Up
                    WTTestAnimViewController *vc = [[WTTestAnimViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                    [[vc imageView] wt_setPictureShadow:WTViewShadowCurveTypePictureStyleMiddleUp opacity:0.3];
                } break;
                case 2:
                {
                    // Picture Shadow Drop Shadow
                    WTTestAnimViewController *vc = [[WTTestAnimViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                    [[vc imageView] wt_setPictureShadow:WTViewShadowCurveTypePictureStyleDropShadow opacity:0.3];
                } break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    // Inner Shadow
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 300), NO, 0);
                    UIBezierPath *path;
                    path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 80, 80) cornerRadius:10];
                    [path stroke]; [path wt_drawInnerShadow:CGSizeMake(2, 2) width:16 color:nil];
                    
                    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 100, 80, 80)];
                    [path stroke]; [path wt_drawInnerShadow:CGSizeMake(16, 16) width:30 color:nil];
                    [path wt_drawShadow:CGSizeMake(0, 10) width:20 color:[UIColor whiteColor]];
                    
                    path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 10, 80, 80)];
                    [path stroke]; [path wt_drawInnerShadow:CGSizeZero width:40 color:nil];
                    
                    path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 80, 80)];
                    [path stroke]; [path wt_drawInnerShadow:CGSizeZero width:10 color:[UIColor purpleColor]];
                    
                    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    [vc setImage: image];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 1:
                {
                    // Emboss
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 300), NO, 0);
                    UIBezierPath *path;
                    path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 80, 80) cornerRadius:10];
                    [path stroke];
                    [path wt_drawInnerShadow:CGSizeMake(-2, -2) width:4 color:[UIColor colorWithWhite:0.0 alpha:0.3]];
                    [path wt_drawInnerShadow:CGSizeMake(2, 2) width:4 color:[UIColor colorWithWhite:1.0 alpha:0.3]];
                    
                    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 100, 80, 80)];
                    [path stroke];
                    [path wt_drawInnerShadow:CGSizeMake(2, 2) width:4 color:[UIColor colorWithWhite:0.0 alpha:0.3]];
                    [path wt_drawInnerShadow:CGSizeMake(-2, -2) width:4 color:[UIColor colorWithWhite:1.0 alpha:0.3]];
                    
                    path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 10, 80, 80)];
                    [path wt_drawInnerShadow:CGSizeMake(-2, -2) width:10 color:[UIColor colorWithWhite:0.0 alpha:0.3]];
                    [path wt_drawInnerShadow:CGSizeMake(2, 2) width:10 color:[UIColor colorWithWhite:1.0 alpha:0.3]];
                    
                    path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 80, 80)];
                    [path wt_drawInnerShadow:CGSizeMake(-2, -2) width:4 color:[UIColor colorWithWhite:0.0 alpha:0.3]];
                    [path wt_drawInnerShadow:CGSizeMake(2, 2) width:4 color:[UIColor colorWithWhite:1.0 alpha:0.3]];
                    
                    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
                    [vc setImage: image];
                    [self.navigationController pushViewController:vc animated:YES];
                } break;
                case 2:
                {
                    // Picture Shadow Drop Shadow
                    WTTestAnimViewController *vc = [[WTTestAnimViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                    [[vc imageView] wt_setPictureShadow:WTViewShadowCurveTypePictureStyleDropShadow opacity:0.3];
                } break;
                default:
                    break;
            }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
