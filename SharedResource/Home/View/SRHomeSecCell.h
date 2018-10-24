//
//  SRHomeSecCell.h
//  SharedResource
//
//  Created by FollowMe on 2018/10/19.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRUserM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRHomeSecCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *useNum;
@property (weak, nonatomic) IBOutlet UILabel *lockNum;

- (void)setcellValue;
@end

NS_ASSUME_NONNULL_END
