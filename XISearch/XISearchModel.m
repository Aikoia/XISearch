//
//  XISearchModel.m
//  XISearch
//
//  Created by xi on 16/3/30.
//  Copyright © 2016年 xi. All rights reserved.
//

#import "XISearchModel.h"

#define kHasSearchBadgeShown @"com.xi.search.hasShown"
#define kSearchHistory       @"com.xi.search.history"
#define kNewFeature          @"com.xi.search.newFeature"

#define kUserDefaults        [NSUserDefaults standardUserDefaults]

@implementation XISearchModel

+ (NSArray *)getSearchHistory {
    if (![kUserDefaults objectForKey:kSearchHistory]) {
        NSMutableArray *history = [[NSMutableArray alloc] initWithCapacity:3];
        [kUserDefaults setObject:history forKey:kSearchHistory];
        [kUserDefaults synchronize];
    }
    return [kUserDefaults objectForKey:kSearchHistory];
}

+ (void)addSearchHistory:(NSString *)searchText {
    NSMutableArray *history = [NSMutableArray arrayWithArray:[XISearchModel getSearchHistory]];
    if (![history containsObject:searchText]) {
        if (history.count >= 8) {
            [history removeLastObject];
            [history insertObject:searchText atIndex:0];
            [kUserDefaults setObject:history forKey:kSearchHistory];
            [kUserDefaults synchronize];
        }
    }
}

+ (void)cleanAllSearchHistory {
    NSMutableArray *history = [NSMutableArray arrayWithArray:[XISearchModel getSearchHistory]];
    [history removeAllObjects];
    [kUserDefaults setObject:history forKey:kSearchHistory];
    [kUserDefaults synchronize];
}

@end
