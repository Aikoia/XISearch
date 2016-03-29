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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    _selectIndex = 0;
    _items = @[@"全部",@"小说",@"视频",@"音乐",@"视频"].mutableCopy;
    _searchBar = ({
        XIResultSearchBar *searchBar = [[XIResultSearchBar alloc] initWithFrame:CGRectMake(20, 27, [UIScreen mainScreen].bounds.size.width - 100, 31)];
        searchBar.placeholder = _items[0];
        [searchBar sizeToFit];
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
    [_searchBar itemsAndIconButtonSelectedBlock:^{
        if ([KxMenu isShowingInView:[UIApplication sharedApplication].keyWindow]) {
            [KxMenu dismissMenu:YES];
            [weakSelf.searchBar becomeFirstResponder];
        } else {
            [weakSelf.searchBar resignFirstResponder];
            [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
            [KxMenu setTintColor:[UIColor yellowColor]];
            [KxMenu setOverlayColor:[UIColor redColor]];
        }
    }];
    
}

- (void)menuItemClicked:(KxMenuItem *)menu {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
