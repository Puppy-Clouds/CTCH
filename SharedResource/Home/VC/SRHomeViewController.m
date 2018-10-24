//
//  SRHomeViewController.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 SHANG TOM. All rights reserved.
//

#import "SRHomeViewController.h"
#import "SRHomeFirCell.h"
#import "SRHomeSecCell.h"
#import "SRHomeHeadView.h"

@interface SRHomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资产";
    self.navigationController.navigationBar.barTintColor = RGBA(50, 50, 51, 1);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    RegisterNib(_tableView, @"SRHomeSecCell");
    self.tableView.tableFooterView = [UIView new];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resresh) name:@"refreshHome" object:nil];
}

- (void)resresh{
    [_tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SRHomeSecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SRHomeSecCell" forIndexPath:indexPath];
    [cell setcellValue];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SRHomeHeadView *headView = [[SRHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    headView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 130;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (_tableView.contentOffset.y <= 0) {
        _tableView.bounces = NO;
    }
    else if (_tableView.contentOffset.y >= 0){
        _tableView.bounces = YES;
    }
}




@end
