//
//  SRHomeHeadView.h
//  SharedResource
//
//  Created by FollowMe on 2018/10/19.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRHomeHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *usertype;
- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
