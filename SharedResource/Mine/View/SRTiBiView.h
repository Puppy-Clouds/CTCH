//
//  SRTiBiView.h
//  SharedResource
//
//  Created by FollowMe on 2018/10/19.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRTiBiM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRTiBiView : UIView
@property (nonatomic, copy) void(^sendValueBlock)(SRTiBiM *value);
- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
