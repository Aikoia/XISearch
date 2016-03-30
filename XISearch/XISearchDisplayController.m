//
//  XISearchDisplayController.m
//  XISearch
//
//  Created by xi on 16/3/29.
//  Copyright © 2016年 xi. All rights reserved.
//

#import "XISearchDisplayController.h"
#import "XHRealTimeBlur.h"
#import "XISearchModel.h"

@interface XISearchDisplayController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic , strong) UIView         *contentView;
@property (nonatomic , strong) XHRealTimeBlur *backgroundView;
@property (nonatomic , strong) UILabel        *headerLabel;
@property (nonatomic , strong) UITableView    *tableView;
@property (nonatomic , strong) NSMutableArray *data;
@property (nonatomic , strong) UIScrollView   *historyView;
@property (nonatomic , assign) double          historyHeight;

@end

@implementation XISearchDisplayController

- (void)setActive:(BOOL)visible animated:(BOOL)animated {
    if (!visible) {
        [_tableView      removeFromSuperview];
        [_contentView    removeFromSuperview];
        [_backgroundView removeFromSuperview];
        _tableView   = nil;
        _contentView = nil;
        _historyView = nil;
        _backgroundView = nil;
        [super setActive:visible animated:animated];
    } else {
        [super setActive:visible animated:animated];
        NSArray *subviews = self.searchContentsController.view.subviews;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            for (UIView *view in subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchDisplayControolerContainerView")]) {
                    NSArray *views = view.subviews;
                    ((UIView *)views[2]).hidden = YES;
                }
            }
        } else {
            [[subviews lastObject] removeFromSuperview];
        }
        
        if (!_contentView) {
            _contentView = ({
                UIView *view = [UIView new];
                view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60);
                view.backgroundColor = [UIColor clearColor];
                view.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
                [view addGestureRecognizer:tapGestureRecognizer];
                view;
            });
            
            if (!_backgroundView) {
                _backgroundView = ({
                    XHRealTimeBlur *blur = [[XHRealTimeBlur alloc] initWithFrame:_contentView.frame];
                    blur.blurStyle = XHBlurStyleTranslucentWhite;
                    blur;
                });
            }
            _backgroundView.userInteractionEnabled = NO;
            [self initSearchHistoryView];
        }
        [self.parentViewController.view addSubview:_backgroundView];
        [self.parentViewController.view addSubview:_contentView];
        [self.parentViewController.view bringSubviewToFront:_contentView];
        self.searchBar.delegate = self;
    }
}

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

- (void)initSearchHistoryView {
    if (!_historyView) {
        _historyView = [UIScrollView new];
        _historyView.backgroundColor = [UIColor yellowColor];
        _historyView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_contentView addSubview:_historyView];
        self.searchBar.delegate = self;
    }
    [[_historyView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        view.backgroundColor = [UIColor greenColor];
        [_historyView addSubview:view];
    }
    NSArray *array = [XISearchModel getSearchHistory];
    CGFloat imageLeft = 12.0f;
    CGFloat textLeft  = 34.0f;
    CGFloat height    = 44.0f;
    _historyHeight = height * (array.count + 1);
    
    _historyView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _historyHeight);
    _historyView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _historyHeight);
    
    for (int i = 0; i < array.count; i ++) {
        UILabel *lblHistory = [[UILabel alloc] initWithFrame:CGRectMake(textLeft, i * height, [UIScreen mainScreen].bounds.size.width - textLeft, height)];
        lblHistory.userInteractionEnabled = YES;
        lblHistory.font = [UIFont systemFontOfSize:14];
        lblHistory.textColor = [UIColor blueColor];
        lblHistory.text = array[i];
        
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(12, lblHistory.frame.origin.y, 15, 15)];
        leftView.image = [UIImage imageNamed:@"icon_search_clock"];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 12, lblHistory.frame.origin.y, 14, 14)];
        rightImageView.image = [UIImage imageNamed:@"icon_arrow_searchHistory"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageLeft, (i + 1) * height, [UIScreen mainScreen].bounds.size.width - imageLeft, 0.5)];
        view.backgroundColor = [UIColor orangeColor];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHistoryView:)];
        [lblHistory addGestureRecognizer:tapGestureRecognizer];
        
        [_historyView addSubview:lblHistory];
        [_historyView addSubview:leftView];
        [_historyView addSubview:rightImageView];
        [_historyView addSubview:view];
    }
    
    if (array.count) {
        UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cleanButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [cleanButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        [cleanButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [cleanButton setFrame:CGRectMake(0, array.count * height, [UIScreen mainScreen].bounds.size.width , height)];
        [_historyView addSubview:cleanButton];
        [cleanButton addTarget:self action:@selector(tapCleanSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageLeft, (array.count + 1) * height, [UIScreen mainScreen].bounds.size.width  - imageLeft, 0.5)];
            view.backgroundColor = [UIColor purpleColor];
            [_historyView addSubview:view];
        }
    }
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

- (void)reloadDataOfSearchDisplayController {
    
    NSArray *array = @[@"大木",@"苍老师",@"呵呵",@"掏粪男孩"];
    
    [self.data removeAllObjects];
    switch (_searchType) {
        case XISearchTypeAll:
            [self.data addObjectsFromArray:array];
            break;
        case XISearchTypeArticle:
            [self.data addObjectsFromArray:array];
            break;
        case XISearchTypeVideo:
            [self.data addObjectsFromArray:array];
            break;
        case XISearchTypeMusic:
            [self.data addObjectsFromArray:array];
            break;
        default:
            break;
    }
    
    [self refreshTableHeader];
    [self.tableView reloadData];
}

#pragma mark -
- (void)tapContentView:(UIGestureRecognizer *)tap {
    [self.searchBar resignFirstResponder];
}

- (void)tapHistoryView:(UIGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    self.searchBar.text = label.text;
    [XISearchModel addSearchHistory:self.searchBar.text];
    [self initSearchHistoryView];
    [self.searchBar resignFirstResponder];
    [self initSearchResultsTableView];
}

- (void)tapCleanSearchHistory:(UIGestureRecognizer *)tap {
    [XISearchModel cleanAllSearchHistory];
    [self initSearchHistoryView];
}


#pragma mark - ⭐️tableViewDelegate/DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

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
    [XISearchModel addSearchHistory:searchBar.text];
    [self initSearchHistoryView];
    [self.searchBar resignFirstResponder];
    [self initSearchHistoryView];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

@end
