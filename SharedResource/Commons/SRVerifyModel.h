//
//  SRVerifyModel.h
//  SharedResource
//
//  Created by FollowMe on 2018/10/22.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRVerifyModel : NSObject
+ (SRVerifyModel *)shareInstance;
//发送验证码倒计时
- (void)creatCountDownTimerWithBtn:(UIButton *)sender;

+ (BOOL)isMobilePhoneNum:(NSString *)phoneNum;

//身份证号
+ (BOOL)isIdentityCardNum:(NSString *)IDCard;
//判断两密码是否相等
+ (BOOL)judgeTwoPassWordIsEqualWithFirstPW:(NSString *)fir secPW:(NSString *)sec;

//判断字符串是否是空
+ (BOOL) isBlankString:(NSString *)string;
//邮箱
+ (BOOL)isEmailAddress:(NSString *)email;

+ (NSString *)MD5:(NSString *)str;
+ (NSString *)getTheSameDayWithFormat:(NSString *)format;
@end

NS_ASSUME_NONNULL_END
