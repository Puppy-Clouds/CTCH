//
//  LEImagePickerTool.h
//  CreditAddressBook
//
//  Created by LE on 16/1/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LEHandlerBlock) (UIImage *image);

@interface LEImagePickerTool : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/**
 *  选取的图片size，默认800*800的等比例缩放或者放大
 */
@property(nonatomic, assign) CGSize imageSize;
/**
 *  originalImage为YES时imageSize将失效，返回原图；
 *  默认为YES
 */
@property(nonatomic, assign) BOOL originalImage;
/**
 *  图片截取的size，默认280*280
 */
@property(nonatomic, assign) CGSize cropSize;
/**
 *  
 */
+ (instancetype)selectImageWithController:(UIViewController *)controller edit:(BOOL)isEdit completion:(LEHandlerBlock)completion;
/*!
 *  @brief  从相机中选择图片
 */
+ (instancetype)selectImageFromCameraWithController:(UIViewController *)controller edit:(BOOL)isEdit completion:(LEHandlerBlock)completion;

/**
 选取图片数组
 maxNumber：最大允许选择的图片数目
 */
+ (instancetype)selectImagesWithController:(UIViewController *)controller maxNumber:(NSUInteger)maxNumber completion:(void(^)(NSArray<UIImage *> *images))completion;

@end
