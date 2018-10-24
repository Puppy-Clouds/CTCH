//
//  SRHomeSecCell.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/19.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRHomeSecCell.h"

@implementation SRHomeSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imgView.layer.cornerRadius = _imgView.frame.size.height/2;
    _imgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setcellValue{
    NSDictionary *dic = [SRUD objectForKey:SRSaveAVUser];
    SRUserM *user = [SRUserM mj_objectWithKeyValues:dic[@"localData"]];
    user.createdAt = dic[@"createdAt"];

    _useNum.text = @"CTCH";
    _useNum.text = [NSString stringWithFormat:@"可提数量: %@",user.unlockCount];
    _lockNum.text = [NSString stringWithFormat:@"锁仓数量: %@",user.lockcount];


}
@end
