//
//  IWComposeImageView.h
//  WeiBo17
//
//  Created by teacher on 15/8/26.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWComposeImageView : UIImageView

//@property(nonatomic, copy) void(^bIWRemoveImageRemove)(NSInteger tag);

@property(nonatomic, copy) void(^RemoveImageRemove)(UIImage *img);

@end
