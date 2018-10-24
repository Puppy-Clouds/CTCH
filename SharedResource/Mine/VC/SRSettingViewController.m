//
//  SRSettingViewController.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRSettingViewController.h"
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
#import "SRRecordViewController.h"
#import "LEPageViewController.h"
#import "BMSegmentView.h"
#import <Masonry.h>
#import "UIView+AutoLayout.h"

#define SegmentH 60
#define NavHeight (IS_IPHONE_X ? 88 : 64)
#define TabHeight (IS_IPHONE_X ? 70 : 49)

@interface SRSettingViewController ()

@property (nonatomic, strong) SRRecordViewController *firstVC;
@property (nonatomic, strong) SRRecordViewController *secondVC;
@property (nonatomic ,strong) LEPageViewController *pageVC;
@property(nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) BMSegmentView *segmentView;
@end

@implementation SRSettingViewController

- (BMSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[BMSegmentView alloc]initWithFrame:CGRectMake(0, NavHeight, kScreenWidth, SegmentH)];
        [self.view addSubview:_segmentView];
        _segmentView.backgroundColor = RGBA(35, 36, 37, 1);
        __weak typeof(self) wself = self;
        _segmentView.scrollToPageBlock = ^(NSInteger page) {
            wself.pageVC.selectedIndex = (int)page;
        };
    }
    return _segmentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sr_backBtnTitle:@"" img:@"" isPush:YES];
    [self sr_initPageVC];
    self.navigationItem.title = @"提币记录";
    [self.segmentView commonTitleArr:@[@"待处理",@"已完成"]];
    self.view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"242424"];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//.初始化page控制器
- (void)sr_initPageVC {
    __weak typeof(self) wself = self;
    SRRecordViewController *firstVC = [[SRRecordViewController alloc]init];
    _firstVC = firstVC;

    SRRecordViewController *secondVC = [[SRRecordViewController alloc] init];
    _secondVC = secondVC;
    _secondVC.isFinish = YES;
    
    LEPageViewController *pageVC = [[LEPageViewController alloc] initWithControllers:@[ self.firstVC,self.secondVC] controllerChanged:^(NSInteger selectedIndex) {
    }];

    self.pageVC = pageVC;
    pageVC.bLEPageVCDidScroll = ^(CGPoint contentOffset) {
        [wself.segmentView moveToOffsetX:contentOffset.x];
    };
    [pageVC setSelectedIndex:(int)self.selectedIndex];

    [pageVC willMoveToParentViewController:self];
    [self addChildViewController:pageVC];
    [self.view addSubview:pageVC.view];
    [pageVC didMoveToParentViewController:self];

    [pageVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, - TabHeight, 0) excludingEdge:ALEdgeTop];
    [pageVC.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segmentView];
    pageVC.view.backgroundColor = [UIColor clearColor];
}

@end
