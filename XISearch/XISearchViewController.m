//
//  XISearchViewController.m
//  XISearch
//
//  Created by xi on 16/3/29.
//  Copyright © 2016年 xi. All rights reserved.
//

#import "XISearchViewController.h"
#import "XISearchDisplayController.h"
#import "XISearchBar.h"
#import "KxMenu.h"

@interface XISearchViewController ()<UISearchDisplayDelegate>

@property (nonatomic , strong) UIView                    *searchView;
@property (nonatomic , strong) UITableView               *tableView;
@property (nonatomic , assign) NSInteger                  selectIndex;
@property (nonatomic , strong) NSMutableArray            *items;
@property (nonatomic , strong) NSMutableArray            *data;
@property (nonatomic , strong) XIResultSearchBar         *searchBar;
@property (nonatomic , strong) XISearchDisplayController *searchVC;

@end

@implementation XISearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.view addSubview:_searchBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _selectIndex = 0;
    _items = @[@"全部",@"小说",@"视频",@"音乐",@"视频"].mutableCopy;
    _searchBar = ({
        XIResultSearchBar *searchBar = [XIResultSearchBar new];
        searchBar.frame = CGRectMake(20,27, [UIScreen mainScreen].bounds.size.width - 75, 31);
        searchBar.barTintColor = [UIColor redColor];
        searchBar.layer.cornerRadius=15;
        searchBar.layer.masksToBounds=TRUE;
        [searchBar.layer setBorderWidth:8];
        [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
        [searchBar sizeToFit];
        [searchBar setTintColor:[UIColor whiteColor]];
        
        searchBar.frame = CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, 30);
        searchBar;
    });
    
    NSMutableArray *menus = [NSMutableArray array];
    for (NSString *item in _items) {
        KxMenuItem *menu = [KxMenuItem menuItem:item image:nil target:self action:@selector(menuItemClicked:)];
        menu.alignment = NSTextAlignmentCenter;
        menu.foreColor = [UIColor blackColor];
        [menus addObject:menu];
    }
    
    __weak typeof(self) weakSelf = self;
    [_searchBar menuItemsSelectedBlock:^{
        if ([KxMenu isShowingInView:[UIApplication sharedApplication].keyWindow]) {
            [KxMenu dismissMenu:YES];
            [weakSelf.searchBar becomeFirstResponder];
        } else {
            [weakSelf.searchBar resignFirstResponder];
            [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
            [KxMenu setTintColor:[UIColor yellowColor]];
            [KxMenu setOverlayColor:[UIColor redColor]];
            
            CGRect senderFrame = CGRectMake(weakSelf.searchView.frame.origin.x + 50, 64, 0, 0);
            [KxMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:senderFrame menuItems:menus];
        }
    }];
    
    if (!_searchVC) {
        _searchVC = ({
            XISearchDisplayController *searchVC = [[XISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
            searchVC.searchBar.frame = CGRectMake(20,27, [UIScreen mainScreen].bounds.size.width - 75, 31);
            searchVC.searchBar.layer.cornerRadius=15;
            searchVC.searchBar.layer.masksToBounds=TRUE;
            [searchVC.searchBar.layer setBorderWidth:8];
            [searchVC.searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
            searchVC.searchBar.placeholder = @"搜索";
            searchVC.searchBar.barTintColor = [UIColor cyanColor];
            [searchVC.searchBar sizeToFit];
            searchVC.searchBar.frame = CGRectMake(searchVC.searchBar.frame.origin.x, searchVC.searchBar.frame.origin.y, searchVC.searchBar.frame.size.width, 30);
            
            [searchVC.searchBar setShowsCancelButton:NO];
            searchVC.displaysSearchBarInNavigationBar = NO;
            searchVC.searchResultsTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
            searchVC.parentViewController = self;
            searchVC.delegate = self;
            searchVC;
        });
    }
    
}

- (void)menuItemClicked:(KxMenuItem *)menu {
    NSInteger selectIndex = [_items indexOfObject:menu.title];
    if (selectIndex == NSNotFound || selectIndex == _selectIndex) {
        return;
    }
    _selectIndex = selectIndex;
    //_searchVC.searchType = _selectIndex;
    [_searchBar refreshItemsButtonTitle:menu.title];
    if (_searchVC.active &&(_searchBar.text.length > 0)) {
        
    } else {
        [_searchBar becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
