//
//  SRMacro.h
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/16.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#ifndef SRMacro_h
#define SRMacro_h

/*屏幕宽*/
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

/*屏幕高*/
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreeSize [UIScreen mainScreen].bounds.size

/*随机颜色*/
#define RandomColor  [UIColor colorWithRed:arc4random() % 256/255. green:arc4random() % 256/255. blue:arc4random() % 256/255. alpha:1]

#define RGBA(r, g, b ,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define MainNaviColor RGBA(157, 101, 252 ,1)


//#define HEX_COLOR(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

#define HEX_COLOR(color) [UIColor hx_colorWithHexRGBAString:color]

#define STR(str) [NSString stringWithFormat:@"%@",str]
/**将int转成字符串*/
#define StrInt(int) [NSString stringWithFormat:@"%ld",(long)int]

/**注册ViewXib*/
#define LoadFromNib(xibName) [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil].lastObject
/**注册Cell*/
#define RegisterNib(tableView,cellID) [tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID]

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IOS_11  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)
/**判断是否为IPhoneX*/
#define IS_IPHONE_X (IS_IOS_11 && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))


// app名称
#define APPName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// app版本
#define APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// app build版本
#define APPbuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define TabbarHeight (IS_IPHONE_X ? 83 : 49)

#define SRUD [NSUserDefaults standardUserDefaults]
#endif /* SRMacro_h */
