//
//  SRMineViewController.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 SHANG TOM. All rights reserved.
//

#import "SRMineViewController.h"
#import "SRAboutMeVC.h"
#import "SRAdviceViewController.h"
#import "SRSettingViewController.h"
#import "SRMineHeadView.h"
#import "SRTiBiView.h"
#import "SRChangePWVC.h"
#import "AppDelegate.h"

@interface SRMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *iconArray ;
@property (nonatomic, strong) NSArray *deTitleArray;

@end

@implementation SRMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = RGBA(50, 50, 51, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"我的";

    _titleArr = @[@"交易密码",@"提币",@"提币记录"];
    _iconArray = @[@"password",@"click",@"record"];
    _deTitleArray = @[@"去设置",@"",@""];
    _tableView.tableFooterView = [UIView new];

    SRMineHeadView *headView = [[SRMineHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    headView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headView sr_setViewValue];
    self.tableView.tableHeaderView = headView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }

    cell.backgroundColor = RGBA(36, 36, 36, 1);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_iconArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.detailTextLabel.text = _deTitleArray[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            SRChangePWVC *vc = [[SRChangePWVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            SRTiBiView *view = [[SRTiBiView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - TabbarHeight)];
            __weak typeof(self) wself = self;
            view.sendValueBlock = ^(SRTiBiM * _Nonnull value) {
                [wself publishBtn:value];
            };
            [self.view addSubview:view];
            break;
        }
        case 2:{
            SRSettingViewController *vc = [[SRSettingViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
            
        }
        default:
            break;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [btn setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [btn setBackgroundColor:RGBA(157, 101, 252, 1)];
    [btn addTarget:self action:@selector(userLogout) forControlEvents:(UIControlEventTouchUpInside)];
    return btn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (_tableView.contentOffset.y <= 0) {
        _tableView.bounces = NO;
    }
    else if (_tableView.contentOffset.y >= 0){
        _tableView.bounces = YES;
    }
}

- (void)userLogout{
    [AVUser logOut];
    [UIToastView makeText:@"退出成功" duration:2];
    AppDelegate *AD =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [SRUD setObject:nil forKey:SRSaveAVUser];

    [AD showLoginVC];
}


- (void)publishBtn:(SRTiBiM *)model {
    AVObject *product = [AVObject objectWithClassName:@"pickcoin"];
    [product setObject:model.address forKey:@"etadress"];
    [product setObject:model.num forKey:@"pickCount"];
    [product setObject:[NSNumber numberWithInteger:1] forKey:@"pickstate"];
    [product setObject:[SRVerifyModel getTheSameDayWithFormat:@"YYYY-MM-dd HH:mm:ss"] forKey:@"picktime"];
    [product setObject:model.username forKey:@"username"];

    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [UIToastView makeText:@"提币成功" duration:2];
        } else {
            [UIToastView makeText:@"提币失败,请稍后再试.." duration:2];
        }
    }];
}
@end
