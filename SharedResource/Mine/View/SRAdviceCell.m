//
//  SRAdviceCell.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRAdviceCell.h"
@interface SRAdviceCell ()<UITextViewDelegate>

@end
@implementation SRAdviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTV.delegate = self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textViewDidChange:(UITextView *)textView{
    //空格解决方案
    NSString *string = textView.text;
    NSRange range = [string rangeOfString:@" "];
    if (range.location != NSNotFound) {
        self.contentTV.text = [NSString stringWithFormat:@"%@",[self.contentTV.text substringToIndex:self.contentTV.text.length - 1]];
    }
    if (textView.text.length > 0) {
        if (self.sendValueBlock) {
            self.sendValueBlock(textView.text);
        }
    }
}
@end
