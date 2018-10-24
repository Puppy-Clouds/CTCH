//
//  SRBaseViewController.h
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/17.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRBaseViewController : UIViewController
- (void)sr_backBtnTitle:(NSString *)title img:(NSString *)imgName isPush:(BOOL)isbol;

- (void)sr_leftBtnTitle:(NSString *)title img:(NSString *)imgName;
- (void)sr_leftItemClick;

- (void)sr_rightBtnTitle:(NSString *)title img:(NSString *)imgName;
- (void)sr_rightItemClick;
@end

NS_ASSUME_NONNULL_END
