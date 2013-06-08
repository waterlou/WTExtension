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
#import "UIImage+WTFilter.h"
#import "UIImage+WTExtension.h"
#import "WTGlyphFontSet.h"
#import "UIView+WTLayer.h"

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
        cell.textLabel.text = @"Resize aspect";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        UIImage *image = [UIImage imageNamed:@"screenshot"];
        UIImage *resultImage = [image resizeFillIn:CGSizeMake(128, 128) roundCorner:4.0f quality:kCGInterpolationDefault];
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
        [vc setImage:[[[self.view wt_snapshot] wt_normalize] wt_fastBlur:8.0f]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [_dataSource appendCellAtSection:0 identifier:nil onSetupCell:^(UITableViewCell*cell) {
        cell.textLabel.text = @"Snapshot then slow blur";
    } onSelect:^(UITableView *tableView, NSIndexPath *indexPath) {
        WTTestImageViewController *vc = [[WTTestImageViewController alloc] initWithNibName:nil bundle:nil];
        [vc setImage:[[self.view wt_snapshot] wt_blur:8.0f]];
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
