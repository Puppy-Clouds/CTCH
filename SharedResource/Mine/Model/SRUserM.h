//
//  SRUserM.h
//  SharedResource
//
//  Created by FollowMe on 2018/10/22.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRUserM : NSObject
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *unlockCount;
@property(nonatomic, copy) NSString *tradetime;
@property(nonatomic, strong) NSNumber *vipLevel;
@property(nonatomic, copy) NSString *lockcount;
@property(nonatomic, copy) NSString *tradePwd;
@property(nonatomic, copy) NSString *originalAssets;
@property(nonatomic, strong) NSDate *createdAt;


//@property(nonatomic, assign) BOOL mobilePhoneVerified;

@end

NS_ASSUME_NONNULL_END
