//
//  SRAdviceViewController.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRAdviceViewController.h"
#import "SRAdviceCell.h"
#import "SRAdviceThrCell.h"

@interface SRAdviceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSString *content;
@end

@implementation SRAdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self sr_backBtnTitle:@"" img:@"" isPush:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) wself = self;

    switch (indexPath.section) {
        case 0:{
            SRAdviceCell *firCell = [tableView dequeueReusableCellWithIdentifier:@"SRAdviceCell" forIndexPath:indexPath];

            firCell.sendValueBlock = ^(NSString *value) {
                wself.content = value;
            };
            return firCell;
        }
        case 1:{
            SRAdviceThrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SRAdviceThrCell" forIndexPath:indexPath];
            cell.sendValueBlock = ^{
                [wself sr_submitValue];
            };
            return cell;
        }
        default:
            return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            return 200;
        }
        case 1:{
            return 50;
        }
        default:
            return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return 10;
        case 2:
            return 20;
        default:
            return 0.001;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)sr_submitValue{
    [self.view endEditing:YES];
    
    if (self.content.length < 1) {
        [UIToastView makeText:@"请填写反馈内容" duration:2];
        return;
        
    }
    [UIToastView makeText:@"谢谢您的反馈，我们将第一时间帮你解决～" duration:2];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
