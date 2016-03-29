//
//  XISearchDisplayController.m
//  XISearch
//
//  Created by xi on 16/3/29.
//  Copyright © 2016年 xi. All rights reserved.
//

#import "XISearchDisplayController.h"

@interface XISearchDisplayController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic , strong) UIView         *contentView;
@property (nonatomic , strong) UILabel        *headerLabel;
@property (nonatomic , strong) UITableView    *tableView;
@property (nonatomic , strong) NSMutableArray *data;
@property (nonatomic , strong) UIScrollView   *historyView;

@end

@implementation XISearchDisplayController

- (void)initSearchResultsTableView {
    _data = [NSMutableArray array];
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:_contentView.frame style:UITableViewStylePlain];
            tableView.delegate   = self;
            tableView.dataSource = self;
            tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            [self.parentViewController.view addSubview:tableView];
            
            if (!_headerLabel) {
                _headerLabel = ({
                    UILabel *label = [[UILabel alloc]init];
                    label.frame = CGRectMake(0, 2, tableView.frame.size.width, 44);
                    label.backgroundColor = [UIColor redColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont systemFontOfSize:12];
                    label;
                });
            }
            
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
            headerView.backgroundColor = [UIColor whiteColor];
            [headerView addSubview:_headerLabel];
            
            tableView.tableHeaderView = headerView;
            tableView;
        });
    }
    
    [_tableView.superview bringSubviewToFront:_tableView];
    [_tableView reloadData];
}

- (void)refreshTableHeader {
    NSString *headerTitle = nil;
    
    switch (_searchType) {
        case XISearchTypeAll:
            headerTitle = [NSString stringWithFormat:@"共搜索到 %lu 个与\"%@\"相关",self.searchBar.text.length,self.searchBar.text];
            break;
        case XISearchTypeArticle:
            headerTitle = [NSString stringWithFormat:@"共搜索到 %lu 个与\"%@\"相关的文章",self.searchBar.text.length,self.searchBar.text];
            break;
        case XISearchTypeVideo:
            headerTitle = [NSString stringWithFormat:@"共搜索到 %lu 个与\"%@\"相关的视频",self.searchBar.text.length,self.searchBar.text];
            break;
        case XISearchTypeMusic:
            headerTitle = [NSString stringWithFormat:@"共搜索到 %lu 个与\"%@\"相关的音乐",self.searchBar.text.length,self.searchBar.text];
            break;
        default:
            break;
    }
    self.headerLabel.text = headerTitle;
}

#pragma mark - ⭐️tableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

static NSString *identifier = @"cell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *title = nil;
    switch (_searchType) {
        case XISearchTypeAll:
            title = @"全部";
            break;
        case XISearchTypeArticle:
            title = @"音乐";
            break;
        case XISearchTypeVideo:
            title = @"视频";
            break;
        case XISearchTypeMusic:
            title = @"音乐";
            break;
        default:
            return nil;
            break;
    }
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ⭐️UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

@end
