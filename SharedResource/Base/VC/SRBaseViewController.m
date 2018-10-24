//
//  SRBaseViewController.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/17.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRBaseViewController.h"

@interface SRBaseViewController ()
@property (nonatomic, assign) BOOL isPush;
@end

@implementation SRBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = MainNaviColor;
}

- (void)sr_backBtnTitle:(NSString *)title img:(NSString *)imgName isPush:(BOOL)isbol{
    _isPush = isbol;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    if (title.length < 1) {
        NSString *img = imgName.length < 1 ? @"back" : imgName;
        [backBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    }else{
        [backBtn setTitle:title forState:(UIControlStateNormal)];
        
    }
    [backBtn addTarget:self action:@selector(sr_backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)sr_backItemClick{
    _isPush ? [self.navigationController popViewControllerAnimated:YES] : [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sr_leftBtnTitle:(NSString *)title img:(NSString *)imgName{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    if (title.length < 1) {
        NSString *img = imgName.length < 1 ? @"back" : imgName;
        [leftBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    }else{
        [leftBtn setTitle:title forState:(UIControlStateNormal)];
    }
    [leftBtn addTarget:self action:@selector(sr_leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)sr_leftItemClick{
    
}

- (void)sr_rightBtnTitle:(NSString *)title img:(NSString *)imgName{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    if (title.length < 1) {
        NSString *img = imgName.length < 1 ? @"back" : imgName;
        [rightBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    }else{
        [rightBtn setTitle:title forState:(UIControlStateNormal)];
        
    }
    [rightBtn setTitle:title forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:RGBA(0, 199, 132, 1) forState:(UIControlStateNormal)];
    [rightBtn addTarget:self action:@selector(sr_rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)sr_rightItemClick{
    
}
@end
