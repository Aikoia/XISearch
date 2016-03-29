//
//  XISearchBar.m
//  XISearch
//
//  Created by xi on 16/3/28.
//  Copyright © 2016年 xi. All rights reserved.
//

#import "XISearchBar.h"

@implementation XISearchBar

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanButton.frame = CGRectMake(self.frame.size.width - 60, 0, 60, 31);
        _scanButton.backgroundColor = [UIColor redColor];
        [self addSubview:_scanButton];
    }
    return _scanButton;
}

- (void)layoutSubviews {
    [self setBackgroundImage:[UIImage new]];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 115, self.frame.size.height);
    self.autoresizesSubviews = YES;
    
    NSPredicate *finalPredicate = [NSPredicate predicateWithBlock:^BOOL(UIView *candidateView, NSDictionary *bindings) {
        return [candidateView isMemberOfClass:NSClassFromString(@"UISearchBarTextField")];
    }];
    
    UITextField *searchField = [[[[[self subviews] firstObject] subviews] filteredArrayUsingPredicate:finalPredicate] lastObject];
    searchField.textAlignment = NSTextAlignmentLeft;
    [searchField setFrame:CGRectMake(-40, 4, CGRectGetWidth(self.frame), 22)];
    
    UIImageView *fieldLeftView = (UIImageView *)searchField.leftView;
    CGRect frame = fieldLeftView.frame;
    frame.size = CGSizeMake(13, 13);
    fieldLeftView.frame = frame;
}

@end
