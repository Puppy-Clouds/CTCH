//
//  SRSideBarViewController.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRSideBarViewController.h"
#import "REFrostedViewController.h"
#import "REFrostedContainerViewController.h"
#import "SRAdviceViewController.h"
#import "SRAboutMeVC.h"

@interface SRSideBarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSArray *iconArray;
@property (nonatomic ,strong) NSArray *titleArray;
@property (nonatomic ,strong) NSArray *deTitleArray;
@end

@implementation SRSideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@"关于我们",@"意见反馈",@"清除缓存",@"APP版本号"];
    _iconArray = @[aboutImg,adviceImg,cacheImg,versionImg];
    _deTitleArray = @[@"",@"",@"",[NSString stringWithFormat:@"v%@",APPVersion]];
    [self sr_setTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)sr_setTableView{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    head.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = head;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _iconArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.backgroundColor = RGBA(36, 36, 36, 1);
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_iconArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.detailTextLabel.text = _deTitleArray[indexPath.row];
    cell.detailTextLabel.textColor = MainNaviColor;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            SRAboutMeVC *mineVC = [[SRAboutMeVC alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mineVC];
            [self presentViewController:navi animated:YES completion:nil];
            
        }
            break;
            
        case 1:
        {
            SRAdviceViewController *adviceVC = [[SRAdviceViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:adviceVC];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
            
        case 2:
            [self sr_clearCache];
            break;
        case 3:
            
            break;
            
        default:
            [self.frostedViewController hideMenuViewController];
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark - 清除缓存
- (void)sr_clearCache{
    [self sr_clearCache:[self sr_filePath]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"清理完毕" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:acceptAction];
    //最后弹出提示框
    [self presentViewController:alertController animated:YES completion:nil];
}
//获取路径
-(NSString *)sr_filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory ,NSUserDomainMask ,YES ) firstObject ];
    
    return cachPath;
}

//计算单个文件的大小
-(float)sr_fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path])
    {
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
//遍历获取文件夹大小 返回M
-(float)sr_folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]){
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self sr_fileSizeAtPath:absolutePath];
        }
        return folderSize;
    }
    
    return 0;
}

//清理缓存
-(void)sr_clearCache:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles){
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    //    [[SDImageCache sharedImageCache] clearMemory];
}
@end
