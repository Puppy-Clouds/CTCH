//
//  SRAboutMeVC.m
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRAboutMeVC.h"

@interface SRAboutMeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImgV;
@property (weak, nonatomic) IBOutlet UILabel *AppName;
@property (weak, nonatomic) IBOutlet UILabel *AppVersion;

@end

@implementation SRAboutMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sr_backBtnTitle:@"" img:@"" isPush:YES];

    _logoImgV.image = [UIImage imageNamed:app_lodo];
    _AppName.text = APPName;
    _AppVersion.text = [NSString stringWithFormat:@"版本号:%@",APPVersion];
    
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
