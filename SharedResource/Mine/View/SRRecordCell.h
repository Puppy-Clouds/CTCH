//
//  SRRecordCell.h
//  SharedResource
//
//  Created by FollowMe on 2018/10/22.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRecordM.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numlb;
@property (weak, nonatomic) IBOutlet UILabel *addresslb;
@property (weak, nonatomic) IBOutlet UILabel *datelb;

- (void)setCellValue:(SRRecordM *)model;
@end

NS_ASSUME_NONNULL_END
