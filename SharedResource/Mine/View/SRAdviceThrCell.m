//
//  SRAdviceThrCell.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRAdviceThrCell.h"

@implementation SRAdviceThrCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_submitBtn setBackgroundColor:MainNaviColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitBtn:(id)sender {
    if (self.sendValueBlock) {
        self.sendValueBlock();
    }
}
@end
