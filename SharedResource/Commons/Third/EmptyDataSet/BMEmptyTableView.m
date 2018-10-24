//
//  LETableView.m
//  EmptyTableview
//
//  Created by lwp on 2016/12/6.
//  Copyright © 2016年 LE. All rights reserved.
//

#import "BMEmptyTableView.h"

@implementation BMEmptyTableView

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

#pragma mark - Super
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        
        // A little trick for removing the cell separators
        self.tableFooterView = [UIView new];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.tableFooterView = [UIView new];
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"没有数据"];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.dataSources == nil || self.dataSources.count == 0);
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
    return CGPointMake(0, -(self.contentInset.top - self.contentInset.bottom) / 2);
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (self.bBMEmptyDidTap) {
        self.bBMEmptyDidTap(self);
    }
}

@end
