//
//  SRBaseTableView.h
//  SharedResource
//
//  Created by SHANG TOM on 2018/10/17.
//  Copyright © 2018年 FollowMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMEmptyTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRBaseTableView : BMEmptyTableView
/**  提示信息 */
@property (nonatomic ,copy) NSString *hintStr;
/**  占位图片名 */
@property (nonatomic ,copy) NSString *hintImgName;
@end

NS_ASSUME_NONNULL_END
