//
//  SRRecordViewController.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/21.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRRecordViewController.h"
#import "SRRecordCell.h"
#import "SRRecordM.h"

@interface SRRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SRRecordViewController
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    RegisterNib(_tableView, @"SRRecordCell");
    _tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self queryProduct];
}

-(void)queryProduct{
    AVQuery *query = [AVQuery queryWithClassName:@"pickcoin"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.dataArr removeAllObjects];

            for (NSDictionary *object in objects) {
                NSDictionary *dic = object[@"localData"];
                SRRecordM *model = [SRRecordM mj_objectWithKeyValues:dic];
                if (self.isFinish) {
                    if ( [model.pickstate isEqualToString:@"2"]) {
                        [self.dataArr addObject:model];
                    }
                }else {
                    if([model.pickstate isEqualToString:@"1"]){
                        [self.dataArr addObject:model];
                    }
                }
            }
        }
        [self.tableView reloadData];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SRRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SRRecordCell" forIndexPath:indexPath];
    [cell setCellValue:self.dataArr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

@end
