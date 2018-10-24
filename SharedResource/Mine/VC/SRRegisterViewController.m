//
//  SRRegisterViewController.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/22.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRRegisterViewController.h"
#import <ReactiveObjC.h>

#define codeNum 0
@interface SRRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@end

@implementation SRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self initARC];
}
- (void)initARC{
    @weakify(self)
    [_userName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_code setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    //发送验证码
    RAC(self.codeBtn, enabled) = [RACSignal combineLatest:@[_userName.rac_textSignal] reduce:^id _Nullable(NSString * userName){
        return @([SRVerifyModel isEmailAddress:userName]);
    }];

    self.code.userInteractionEnabled = codeNum;
    //验证验证码
    [[self.code rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x.length < 6) {
            return ;
        }
        self.code.text = [x substringWithRange:NSMakeRange(0, 6)];
    }];

    //验证密码
    [[self.password rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x.length < 6) {
            return ;
        }
        NSInteger length = self.password.text.length;
        NSInteger lec = length < 16 ? length : 16;
        x = [x substringWithRange:NSMakeRange(0, lec)];
        self.password.text = [x substringWithRange:NSMakeRange(0, lec)];
    }];

    RAC(_registerBtn, backgroundColor) = [RACSignal combineLatest:@[_userName.rac_textSignal,_code.rac_textSignal,_password.rac_textSignal] reduce:^id _Nullable(NSString * username,NSString *code,NSString *password){
        BOOL isbol = ([SRVerifyModel isEmailAddress:username] || [SRVerifyModel isMobilePhoneNum:username]) && code.length == codeNum && password.length > 5;
        return isbol ? RGBA(157, 101, 252 ,1) : RGBA(157, 101, 252 ,0.5);
    }];

    RAC(_registerBtn, enabled) = [RACSignal combineLatest:@[_userName.rac_textSignal,_code.rac_textSignal,_password.rac_textSignal] reduce:^id _Nullable(NSString * username,NSString *code, NSString * password){
        return @(([SRVerifyModel isEmailAddress:username] || [SRVerifyModel isMobilePhoneNum:username]) && code.length == codeNum && password.length > 5);
    }];
}
- (IBAction)registerAction:(id)sender {

    AVUser *user = [AVUser user];
    user.username = self.userName.text;
    user.password = self.password.text;

    UIToastView *toast = [[UIToastView alloc] initWIthDetailText:@"正在注册..." needLogo:YES];
    [toast show];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [toast hide];
        if (succeeded) {
            [UIToastView makeText:@"注册成功" duration:2];
            [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:SRUserName];

            [self.navigationController popViewControllerAnimated:YES];
        }else if(error.code == 202){
            //注册失败的原因可能有多种，常见的是用户名已经存在。
            NSLog(@"注册失败，用户名已经存在");
        }else{
            NSLog(@"注册失败：%@",error.localizedFailureReason);
        }
    }];
}
- (IBAction)getCodeAction:(UIButton *)sender {
    [[SRVerifyModel shareInstance] creatCountDownTimerWithBtn:sender];

    if ([SRVerifyModel isEmailAddress:_userName.text]) {

    }else if ([SRVerifyModel isMobilePhoneNum:_userName.text]){

        [AVUser requestMobilePhoneVerify:self.userName.text withBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [UIToastView makeText:succeeded ? @"验证码发送成功" : @"验证码发送失败" duration:2];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
