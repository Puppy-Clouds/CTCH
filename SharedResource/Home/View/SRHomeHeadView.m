//
//  SRHomeHeadView.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/19.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRHomeHeadView.h"

@implementation SRHomeHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = LoadFromNib(@"SRHomeHeadView");
        AVUser *user = [AVUser mj_objectWithKeyValues:[SRUD objectForKey:SRSaveAVUser]];
        NSDate * date = user.createdAt;
        NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.createTime.text = [formatter stringFromDate:date];

    }
    return self;
}

@end
