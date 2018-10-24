//
//  SRMineHeadView.h
//  SharedResource
//
//  Created by FollowMe on 2018/10/19.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRMineHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *userName;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)sr_setViewValue;
@end

NS_ASSUME_NONNULL_END
