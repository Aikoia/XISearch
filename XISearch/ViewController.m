//
//  ViewController.m
//  XISearch
//
//  Created by xi on 16/3/28.
//  Copyright © 2016年 xi. All rights reserved.
//

#import "ViewController.h"

#import "XISearchViewController.h"
#import "XISearchBar.h"

@interface ViewController ()<UISearchBarDelegate>
@property (nonatomic , strong) XISearchBar *searchBar;

@end

@implementation ViewController

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.view addSubview:_searchBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchBar removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self findHairlineImageViewUnder:self.navigationController.navigationBar] removeFromSuperview];
    _searchBar = ({
        XISearchBar *searchBar = [XISearchBar new];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        searchBar.placeholder = @"Google";
        searchBar.delegate = self;
        searchBar.layer.cornerRadius = 15;
        searchBar.layer.masksToBounds = YES;
        searchBar.layer.borderWidth = 8;
        searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
        searchBar.frame = CGRectMake(60, 27, width - 115, 31);
        [searchBar.scanButton addTarget:self action:@selector(goToScanVC:) forControlEvents:UIControlEventTouchUpInside];
        searchBar;
    });
    
}

#pragma mark scan QR-Code
- (void)goToScanVC:(UIButton *)sender {
    //二维码扫描
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    XISearchViewController *searchViewController = [XISearchViewController new];
    UINavigationController *searchNavi = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self.navigationController presentViewController:searchNavi animated:NO completion:nil];
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
