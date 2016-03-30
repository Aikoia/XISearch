//
//  XISearchModel.h
//  XISearch
//
//  Created by xi on 16/3/30.
//  Copyright © 2016年 xi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XISearchModel : NSObject

+ (NSArray *)getSearchHistory;
+ (void)addSearchHistory:(NSString *)searchText;
+ (void)cleanAllSearchHistory;

@end
