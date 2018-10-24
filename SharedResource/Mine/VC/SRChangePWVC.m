//
//  SRChangePWVC.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/22.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRChangePWVC.h"
#import <ReactiveObjC.h>

@interface SRChangePWVC ()
@property (weak, nonatomic) IBOutlet UITextField *pasTF;
@property (weak, nonatomic) IBOutlet UITextField *pasaTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldPasTF;

@end

@implementation SRChangePWVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"交易密码";
    @weakify(self)
//    [[self.oldPasTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        @strongify(self)
//        if (x.length < 6) {
//            return ;
//        }
//        NSInteger length = self.oldPasTF.text.length;
//        NSInteger lec = length < 16 ? length : 16;
//        x = [x substringWithRange:NSMakeRange(0, lec)];
//        self.oldPasTF.text = [x substringWithRange:NSMakeRange(0, lec)];
//
//    }];
//    [_oldPasTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    //验证密码
    [[self.pasTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x.length < 6) {
            return ;
        }
        NSInteger length = self.pasTF.text.length;
        NSInteger lec = length < 16 ? length : 16;
        x = [x substringWithRange:NSMakeRange(0, lec)];
        self.pasTF.text = [x substringWithRange:NSMakeRange(0, lec)];

    }];
    [_pasTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];


    //验证密码
    [[self.pasaTF rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x.length < 6) {
            return ;
        }
        NSInteger length = self.pasaTF.text.length;
        NSInteger lec = length < 16 ? length : 16;
        x = [x substringWithRange:NSMakeRange(0, lec)];
        self.pasaTF.text = [x substringWithRange:NSMakeRange(0, lec)];
    }];

    [_pasaTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    RAC(_submitBtn, backgroundColor) = [RACSignal combineLatest:@[_pasTF.rac_textSignal,_pasaTF.rac_textSignal] reduce:^id _Nullable(NSString * pas,NSString *pasa){
        BOOL isbol = pas.length > 5 && pasa.length > 5 && [SRVerifyModel judgeTwoPassWordIsEqualWithFirstPW:pas secPW:pasa];
        return isbol ? RGBA(157, 101, 252 ,1) : RGBA(157, 101, 252 ,0.5);
    }];

    RAC(_submitBtn, enabled) = [RACSignal combineLatest:@[_pasTF.rac_textSignal,_pasaTF.rac_textSignal] reduce:^id _Nullable(NSString * pas,NSString *pasa){
        return @(pas.length > 5 && pasa.length > 5 && [SRVerifyModel judgeTwoPassWordIsEqualWithFirstPW:pas secPW:pasa]);
    }];
}

- (IBAction)submitAction:(id)sender {

    NSString *password = self.pasaTF.text;
    NSDictionary *dic = [SRUD objectForKey:SRSaveAVUser];
    AVUser *user = [AVUser mj_objectWithKeyValues:dic];
    AVObject *product =[AVObject objectWithClassName:@"_User" objectId:user.objectId];
    [product setObject:[SRVerifyModel MD5:password] forKey:@"tradePwd"];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [UIToastView makeText:@"交易密码设置成功" duration:2];
            [self sr_loginAgain:user];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [UIToastView makeText:@"交易密码设置失败" duration:2];
        }
    }];
}
-(void)sr_loginAgain:(AVUser *)user{
    [AVUser logInWithUsernameInBackground:user.username password:user.password block:^(AVUser *user, NSError *error){
        if (user) {
            NSDictionary *dic = user.mj_keyValues;
            [SRUD setObject:dic forKey:SRSaveAVUser];
        } else {
        }
    }];

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
