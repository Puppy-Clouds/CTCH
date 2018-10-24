//
//  SRRecordCell.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/22.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRRecordCell.h"

@implementation SRRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellValue:(SRRecordM *)model{
    _numlb.text = [NSString stringWithFormat:@"数量:%@",model.pickCount];
    _addresslb.text = [NSString stringWithFormat:@"提币地址:%@",model.etadress];
    _datelb.text = model.picktime;
}
@end
