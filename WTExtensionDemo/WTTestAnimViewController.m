//
//  WTTestAnimViewController.m
//  WTExtensionDemo
//
//  Created by Water Lou on 9/6/13.
//  Copyright (c) 2013 Water Lou. All rights reserved.
//

#import "WTTestAnimViewController.h"
#import "UIImage+WTExtension.h"

@interface WTTestAnimViewController ()

@end

@implementation WTTestAnimViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIImageView*) imageView
{
    if (_imageView==nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"screenshot"] wt_resizeFillIn:CGSizeMake(128.0, 128.0) roundCorner:0 quality:kCGInterpolationDefault]];
        _imageView = imageView;
        _imageView.center = CGPointMake(160.0, 160.0);
        [self.view addSubview: _imageView];
    }
    return _imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

	// Do any additional setup after loading the view.
    [self imageView];   // load image if not loaded
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
