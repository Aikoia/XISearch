//
//  ViewController.m
//  XISearch
//
//  Created by xi on 16/3/28.
//  Copyright © 2016年 xi. All rights reserved.
//

#import "ViewController.h"
#import "XISearchBar.h"


@interface ViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic , strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic , strong) XISearchBar *searchBar;

@end

@implementation ViewController

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
    _searchBar = ({
        XISearchBar *searchBar = [XISearchBar new];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        searchBar.frame = CGRectMake(60, 27, width - 115, 31);
        [searchBar setContentMode:UIViewContentModeLeft];
        [searchBar setPlaceholder:@"Search Google or you like"];
        searchBar.delegate = self;
        searchBar.layer.cornerRadius = 15;
        searchBar.layer.masksToBounds = YES;
        searchBar.layer.borderWidth = 8;
        searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
        [searchBar sizeToFit];
        searchBar.frame = CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, 30);
        [searchBar.scanButton addTarget:self action:@selector(goToScanVC:) forControlEvents:UIControlEventTouchUpInside];
        searchBar;
    });
    
}

#pragma mark scan QR-Code
- (void)goToScanVC:(UIButton *)sender {
    //二维码扫描
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
