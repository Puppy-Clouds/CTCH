//
//  SRMineHeadView.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/19.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRMineHeadView.h"

@implementation SRMineHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    _imgV.layer.cornerRadius = _imgV.frame.size.height / 2;
    _imgV.layer.masksToBounds = YES;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = LoadFromNib(@"SRMineHeadView");
        self.frame = frame;
    }
    return self;
}
- (void)sr_setViewValue{
    NSDictionary *dic = [SRUD objectForKey:SRSaveAVUser];
    AVUser *user = [AVUser mj_objectWithKeyValues:dic];
    _userName.text = user.username;
}
@end
