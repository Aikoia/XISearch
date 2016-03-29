//
//  XISearchDisplayController.h
//  XISearch
//
//  Created by xi on 16/3/29.
//  Copyright © 2016年 xi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XISearchType) {
    XISearchTypeAll = 0,
    XISearchTypeArticle,
    XISearchTypeVideo,
    XISearchTypeMusic
};

@interface XISearchDisplayController : UISearchDisplayController
@property (nonatomic , assign) XISearchType      searchType;
@property (nonatomic ,  weak ) UIViewController *parentViewController;
- (void)reloadDataOfSearchDisplayController;
@end
