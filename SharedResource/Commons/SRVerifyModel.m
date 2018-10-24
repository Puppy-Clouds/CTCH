//
//  SRVerifyModel.m
//  SharedResource
//
//  Created by FollowMe on 2018/10/22.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import "SRVerifyModel.h"
#import <ReactiveObjC.h>
#import <CommonCrypto/CommonDigest.h>

@interface SRVerifyModel()
@property (nonatomic, strong) RACDisposable *disposable;
@property (nonatomic, assign) NSInteger time;
@end

@implementation SRVerifyModel
static SRVerifyModel * _instance = nil;

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[SRVerifyModel alloc] init] ;
    }) ;

    return _instance ;
}
- (void)creatCountDownTimerWithBtn:(UIButton *)sender{
    self.time = 60;
    @weakify(self)
    self.disposable = [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        @strongify(self)
        self.time = self.time - 1;
        NSString *btnTitle;
        if (self.time == 0) {
            btnTitle = @"发送验证码";
            [self.disposable dispose];
        }else{
            btnTitle = [NSString stringWithFormat:@"%ld",(long)self.time];
        }
        sender.titleLabel.text = btnTitle;
        [sender setTitle:btnTitle forState:(UIControlStateNormal)];
    }];
}


//手机号有效性
+ (BOOL)isMobilePhoneNum:(NSString *)phoneNum{
    if (phoneNum.length < 11) {
        return NO;
    }
    NSString *phoneRegex = @"^1(3|5|6|7|8|9|4)\\d{9}";

    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
    //    return  [MQVerifyModel isPhone:phoneNum];
}

+ (BOOL)isIdentityCardNum:(NSString *)IDCard{
    //    if (IDCard.length < 18) {
    //        return NO;
    //    }
    //    NSString *IDCardRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    //    NSPredicate *IDCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IDCardRegex];
    //    return [IDCardTest evaluateWithObject:IDCard];
    return [self validateIDCardNumber:IDCard];
}

+ (BOOL)validateIDCardNumber:(NSString *)value {

    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];

    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }

    if (!areaFlag) {
        return NO;
    }

    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;

    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;

            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];

            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];


            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。

                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;

                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
                //4：检测ID的校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;
                }else {
                    return NO;
                }

            }else {
                return NO;
            }
        default:
            return NO;
    }
}

//判断两密码是否相等
+ (BOOL)judgeTwoPassWordIsEqualWithFirstPW:(NSString *)fir secPW:(NSString *)sec{
    if (fir.length != 0 && sec.length != 0) {
        return [fir isEqualToString:sec];
    }
    return NO;
}

//判断字符串是否是空
+ (BOOL) isBlankString:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@",string];
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str containsString:@"null"]) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([str length] == 0) {
        return YES;
    }
    return NO;
}
//邮箱
+ (BOOL)isEmailAddress:(NSString *)email{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:email];
}
/*!
 *  MD5加密
 */
+ (NSString *)MD5:(NSString *)str {
    if (str && ![str isEqualToString:@""]) {
        const char *cStr = [str UTF8String];
        unsigned char result[16];
        CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
        return [[NSString stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15]
                 ] uppercaseString];
    }
    return nil;
}

//获取当天日期
+ (NSString *)getTheSameDayWithFormat:(NSString *)format{
    NSDate * date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateStr;
    dateStr = [formatter stringFromDate:date];

    return dateStr;
}
@end
