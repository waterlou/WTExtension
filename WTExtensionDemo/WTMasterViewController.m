//
//  WTMasterViewController.m
//  WTExtensionDemo
//
//  Created by Water Lou on 8/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import "WTMasterViewController.h"
#import "WTStaticTableDataSource.h"
#import "WTTestImageViewController.h"
#import "WTTestAnimViewController.h"

#import "UIImage+WTExtension.h"
#import "WTGlyphFontSet.h"
#import "UIView+WTLayer.h"

#import "UIImage+WTFilter.h"

@implementation WTMasterViewController {
    WTStaticTableDataSource *_dataSource;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"WTExtension Demo", @"Master");
        _dataSource = [[WTStaticTableDataSource alloc] init];
    }
    return self;
}

- (UIImage*) demoImage
{
    UIImage *image = [UIImage imageNamed:@"screenshot"];
    return [image resizeFillIn:CGSizeMake(128, 128) roundCorner:64.0f quality:kCGInterpolationDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = _dataSource;
    self.tableView.dataSource = _dataSource;

    [_dataSource setSection:0 header:@"UIImage"];
    
    // demo image resize with crop
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Fillin resize with round corner";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        UIImage *image = [UIImage imageNamed:@"screenshot"];
        UIImage *resultImage = [image resizeFillIn:CGSizeMake(128, 128) roundCorner:8.0f quality:kCGInterpolationDefault];
        [vc setImage:resultImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    // demo gradient overlay
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Gradient overlay";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        UIImage *image = [self demoImage];
        UIImage *resultImage = [image wt_imageWithLinearGradient:-90.0 intensity:0.4f];
        [vc setImage:resultImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // demo gradient mask
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Mask";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        UIImage *image = [UIImage imageNamed:@"screenshot"];
        UIImage *mask = [UIImage imageGlyphNamed:@"fontawesome##group" height:200 color:[UIColor whiteColor]];
        UIImage *resultImage = [image wt_imageWithMask:mask];
        //resultImage = [resultImage wt_imageWithLinearGradient:-90.0f intensity:0.2];    // add gradient
        [vc setImage:resultImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    // spot
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Spot Focus";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        UIImage *image = [UIImage imageNamed:@"screenshot"];
        UIImage *mask = [UIImage wt_spotMask:image.size center:CGPointMake(150, 150) startRadius:5 endRadius:100 inverted:YES];
        UIImage *resultImage = [image wt_applyBlurWithRadius:8.0f tintColor:[UIColor colorWithWhite:0.0 alpha:0.5] saturationDeltaFactor:1.8 maskImage:mask];
        [vc setImage:resultImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    // spot blur
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Spot Blur";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        UIImage *image = [UIImage imageNamed:@"screenshot"];
        UIImage *mask = [UIImage wt_spotMask:image.size center:CGPointMake(120, 200) startRadius:40 endRadius:100 inverted:NO];
        UIImage *resultImage = [image wt_applyBlurWithRadius:8.0f tintColor:nil saturationDeltaFactor:1.0 maskImage:mask];
        [vc setImage:resultImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // demo image blur
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Fast Blur Image";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        UIImage *image = [UIImage imageNamed:@"screenshot"];
        UIImage *resultImage = [image wt_fastBlur:8.0f];
        [vc setImage:resultImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Slow Blur Image";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        UIImage *image = [UIImage imageNamed:@"screenshot"];
        UIImage *resultImage = [image wt_blur:8.0f];
        [vc setImage:resultImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    // snapshot
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Snapshot then fast blur";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        [vc setImage:[[self.view wt_snapshot] wt_fastBlur:8.0f]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Snapshot then slow blur";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        [vc setImage:[[self.view wt_snapshot] wt_blur:8.0f]];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    [_dataSource setSection:1 header:@"Visual Effects"];
    [_dataSource appendCellAtSection:1 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Picture Shadow Middle Down";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestAnimViewController *vc = [[WTTestAnimViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [[vc imageView] wt_setPictureShadow:WTViewShadowCurveTypePictureStyleMiddleDown opacity:0.3];
    }];
    [_dataSource appendCellAtSection:1 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Picture Shadow Middle Up";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestAnimViewController *vc = [[WTTestAnimViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [[vc imageView] wt_setPictureShadow:WTViewShadowCurveTypePictureStyleMiddleUp opacity:0.3];
    }];
    [_dataSource appendCellAtSection:1 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Picture Shadow Drop Shadow";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestAnimViewController *vc = [[WTTestAnimViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [[vc imageView] wt_setPictureShadow:WTViewShadowCurveTypePictureStyleDropShadow opacity:0.3];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
