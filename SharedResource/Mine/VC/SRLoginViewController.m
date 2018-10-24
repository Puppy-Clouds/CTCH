//
//  SRLoginViewController.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/22.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRLoginViewController.h"
#import <ReactiveObjC.h>
#import "SRRegisterViewController.h"
#import "AppDelegate.h"

@interface SRLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation SRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:SRUserName];
    [self initARC];
}
- (void)initARC{
    @weakify(self)
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
    [_userName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    RAC(_submitBtn, backgroundColor) = [RACSignal combineLatest:@[_userName.rac_textSignal,_password.rac_textSignal] reduce:^id _Nullable(NSString * userName,NSString *password){
        BOOL isbol = ([SRVerifyModel isEmailAddress:userName] || [SRVerifyModel isMobilePhoneNum:userName]) && password.length > 5;
        return isbol ? RGBA(157, 101, 252 ,1) : RGBA(157, 101, 252 ,0.5);
    }];
    RAC(_submitBtn, enabled) = [RACSignal combineLatest:@[_userName.rac_textSignal,_password.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * password){
        return @(([SRVerifyModel isEmailAddress:username] || [SRVerifyModel isMobilePhoneNum:username])&& password.length > 5);
    }];
}

- (IBAction)loginAction:(id)sender {
    NSString *username = self.userName.text;
    NSString *password = self.password.text;
    if (username && password) {

        UIToastView *toast = [[UIToastView alloc] initWIthDetailText:@"正在登陆..." needLogo:YES];
        [toast show];

        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error){

            [toast hide];

            if (user) {
                NSDictionary *dic = user.mj_keyValues;

                [SRUD setObject:dic forKey:SRSaveAVUser];

                [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:SRUserName];

                AppDelegate *AD =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [AD sr_creatTab];
            } else {
                NSLog(@"登录失败：%@",error.localizedFailureReason);
            }
        }];
    }
}
- (IBAction)registerAction:(id)sender {
    SRRegisterViewController *vc = [[SRRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
