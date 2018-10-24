//
//  AppDelegate.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/16.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "AppDelegate.h"
#import "SRMineViewController.h"
#import "SRHomeViewController.h"
#import "REFrostedViewController.h"
#import "SRSideBarViewController.h"
#import <IQKeyboardManager.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SRLoginViewController.h"
#import "SRUserM.h"

#define APP_ID @"0wIfaoloEsWP85XiIEze8rTt-gzGzoHsz"
#define APP_KEY @"duygpqjzY9xmCWUt91WYA0jf"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化 SDK
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY];
    //开启调试日志
//    [AVOSCloud setAllLogsEnabled:YES];

    [self sr_creatKeyBoard];

    NSDictionary *dic = [SRUD objectForKey:SRSaveAVUser];;

    if (dic == nil) {
        [self showLoginVC];
    }else{
        [self sr_creatTab];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showLoginVC{
    SRLoginViewController *vc = [[SRLoginViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.navigationBar.barTintColor = RGBA(50, 50, 51, 1);
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
}
- (void)sr_creatTab{

    [self updateUserData];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tb=[[UITabBarController alloc]init];
    tb.tabBar.backgroundColor = [UIColor blackColor];

    tb.tabBar.barTintColor = RGBA(50, 50, 51, 1);
    tb.tabBar.translucent = NO;


    self.window.rootViewController = tb;

    
    SRHomeViewController *first =[[SRHomeViewController alloc]init];
    first.tabBarItem.title = homeTitle;
    first.tabBarItem.image = [[UIImage imageNamed:homeTab_unsel]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    first.tabBarItem.selectedImage = [[UIImage imageNamed:homeTab_sel] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [first.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainNaviColor} forState:UIControlStateSelected];
    
    UINavigationController *firstNavi = [[UINavigationController alloc] initWithRootViewController:first];

//    UIViewController *sec = [[UIViewController alloc]init];
//    sec.tabBarItem.title = middleTitle;
//    sec.tabBarItem.image = [UIImage imageNamed:middleTab_unsel];
//    sec.tabBarItem.selectedImage = [[UIImage imageNamed:middleTab_sel] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [sec.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainNaviColor} forState:UIControlStateSelected];
//
//    UINavigationController *secNavi = [[UINavigationController alloc] initWithRootViewController:sec];
//    secNavi.navigationBar.backgroundColor = MainNaviColor;

    SRMineViewController *thr =[[SRMineViewController alloc]init];
    thr.tabBarItem.title = mineTitle;
    thr.tabBarItem.image = [[UIImage imageNamed:mineTab_unsel]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thr.tabBarItem.selectedImage = [[UIImage imageNamed:mineTab_sel] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [thr.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainNaviColor} forState:UIControlStateSelected];
    
    UINavigationController *thrNavi = [[UINavigationController alloc] initWithRootViewController:thr];

    tb.viewControllers=@[firstNavi,thrNavi];
    [self.window makeKeyAndVisible];


}

- (void)sr_creatSide{
    SRHomeViewController *homeVC = [[SRHomeViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    SRSideBarViewController *menuVC = [[SRSideBarViewController alloc] init];

    REFrostedViewController *frostedVC = [[REFrostedViewController alloc] initWithContentViewController:navi menuViewController:menuVC];
    frostedVC.direction = REFrostedViewControllerDirectionLeft;
    frostedVC.liveBlur = YES;
    frostedVC.limitMenuViewSize = YES;
    frostedVC.menuViewSize = CGSizeMake(kScreeSize.width * 3/5, kScreeSize.height);
    self.window.rootViewController = frostedVC;
    [self.window makeKeyAndVisible];
    
}

- (void)sr_creatKeyBoard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarByPosition;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.shouldShowToolbarPlaceholder = YES;
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:12];
    keyboardManager.keyboardDistanceFromTextField = 10;
}



- (void)updateUserData{

    NSDictionary *dic = [SRUD objectForKey:SRSaveAVUser];
    AVUser *user = [AVUser mj_objectWithKeyValues:dic];

    SRUserM *userM = [SRUserM mj_objectWithKeyValues:dic[@"localData"]];

    NSInteger dayNum = [self getDifferenceByDate:userM.tradetime];
    CGFloat count = dayNum * [self grade:userM.vipLevel.integerValue];
    CGFloat lockcount = userM.originalAssets.floatValue + count * userM.originalAssets.floatValue;

    BOOL isOver = dayNum == 365;

    AVObject *product =[AVObject objectWithClassName:@"_User" objectId:user.objectId];
    if (isOver) {
        [product setObject:[NSNumber numberWithFloat:0.00] forKey:@"lockcount"];
        [product setObject:[NSNumber numberWithFloat:lockcount] forKey:@"unlockcount"];
    }else{
        [product setObject:[NSNumber numberWithFloat:lockcount] forKey:@"lockcount"];
    }

    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self loginAgain:user];
        }
    }];
}
-(void)loginAgain:(AVUser *)user{
    [AVUser logInWithUsernameInBackground:user.username password:user.password block:^(AVUser *user, NSError *error){
        if (user) {
            NSDictionary *dic = user.mj_keyValues;
            [SRUD setObject:dic forKey:SRSaveAVUser];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHome" object:nil];
        } else {
        }
    }];

}

- (CGFloat)grade:(NSInteger)index{
    CGFloat grade = 0.0;
    switch (index) {
        case 1:
            grade = 0.0;
            break;
        case 2:
            grade = 0.1;
            break;
        case 3:
            grade = 0.3;
            break;
        case 4:
            grade = 0.7;
            break;
        case 5:
            grade = 1.1;
            break;
        case 6:
            grade = 1.6;
            break;
        default:
            grade = 0.0;
            break;
    }

    return grade/365;
}


- (NSInteger)getDifferenceByDate:(NSString *)date {

    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:now  options:0];
    return [comps day];
}
@end
