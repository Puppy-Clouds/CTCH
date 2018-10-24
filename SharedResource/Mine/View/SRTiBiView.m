//
//  SRTiBiView.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/19.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRTiBiView.h"
@interface SRTiBiView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) SRTiBiM *dataM;
@end
@implementation SRTiBiView

- (SRTiBiM *)dataM{
    if (!_dataM) {
        _dataM = [[SRTiBiM alloc] init];
    }
    return  _dataM;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    _addressTF.layer.cornerRadius = 5;
    _numTF.layer.cornerRadius = 5;
    _addressTF.layer.cornerRadius = 5;
    _submitBtn.layer.cornerRadius = 5;
    self.addressTF.delegate = self;
    self.numTF.delegate = self;
    self.passwordTF.delegate = self;
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)submitAction:(id)sender {
    [self endEditing:YES];

    if (_addressTF.text.length < 1 || _numTF.text.length < 1 || _passwordTF.text.length < 1) {
        [UIToastView makeText:@"请将信息填写完整" duration:2];
        return;
    }
    self.dataM.address = _addressTF.text;
    self.dataM.num = _numTF.text;
    self.dataM.password = _passwordTF.text;

    NSDictionary *dic = [SRUD objectForKey:SRSaveAVUser];
    NSString *pw = dic[@"localData"][@"tradePwd"];
    if (![pw isEqualToString:[SRVerifyModel MD5:self.dataM.password]]) {
        [UIToastView makeText:@"支付密码错误" duration:2];
        return;
    }
    self.dataM.username = dic[@"username"];
    if (self.sendValueBlock) {
        self.sendValueBlock(self.dataM);
    }
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = LoadFromNib(@"SRTiBiView");
        self.frame = frame;
    }
    return self;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

@end
