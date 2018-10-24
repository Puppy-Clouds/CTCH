//
//  SRBaseTableView.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/17.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRBaseTableView.h"
#import "NSMutableAttributedString+Attributes.h"

@implementation SRBaseTableView

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *tipStr = _hintStr ? _hintStr : @"暂无信息";
    NSMutableAttributedString *tip = [[NSMutableAttributedString alloc] initWithString:tipStr];
    [tip addFont:[UIFont systemFontOfSize:13] substring:tipStr];
    return tip;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *imgName = _hintImgName ? _hintImgName : @"nodata";
    return [UIImage imageNamed:imgName];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

@end
