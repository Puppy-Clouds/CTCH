//
//  IWComposePhotos.h
//  WeiBo17
//
//  Created by teacher on 15/8/26.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWComposePhotos : UIView

/**
 删除回调
 */
//@property(nonatomic, copy) void(^bIWRemoveImageRemove)(NSInteger tag);
@property(nonatomic, copy) void(^RemoveImageRemove)(UIImage *img);

/**
 *  向当前配图view里面添加图片
 */
- (void)addImage:(UIImage *)image;
/**
 *  获取当前配图里面的图片
 */
- (NSArray *)images;

- (void)showAddBtnWihtTarget:(id)target action:(SEL)action hiddenWithImageCount:(NSInteger)count;
- (void)hiddenAddButton;
- (void)showAddButton;

@end
