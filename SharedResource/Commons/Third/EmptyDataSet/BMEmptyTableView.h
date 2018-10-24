//
//  LETableView.h
//  EmptyTableview
//
//  Created by lwp on 2016/12/6.
//  Copyright © 2016年 LE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface BMEmptyTableView : UITableView <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 展示的数据
 */
@property(nonatomic, strong) NSMutableArray *dataSources;

/**
 无数据点击回调
 */
@property(nonatomic, copy) void(^bBMEmptyDidTap)(UITableView *tableViwe);

@end
