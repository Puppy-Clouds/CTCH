//
//  LEImagePickerTool.m
//  CreditAddressBook
//
//  Created by LE on 16/1/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "LEImagePickerTool.h"
#import "GKAlertView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GKImageCropViewController.h"
#import "UIImage+Luban_iOS_Extension_h.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <objc/runtime.h>
#import "RITLPhotos.h"
#import "TZImagePickerController.h"

//static LEHandlerBlock _imageBlock;

static inline BOOL addMethod(Class class, SEL selector, Method method) {
    return class_addMethod(class, selector, method_getImplementation(method),  method_getTypeEncoding(method));
}

@interface LEImagePickerTool ()<GKImageCropControllerDelegate, TZImagePickerControllerDelegate>

/// 最大允许选择的图片数目
@property (nonatomic, assign) NSUInteger maxNumberOfSelectedPhoto;

@end

@implementation LEImagePickerTool {
    LEHandlerBlock _imageBlock;
    BOOL _isEdit;
    UIImagePickerController *_imagePickerController;
}

#pragma mark - LazyLoad
#pragma mark - Super
#pragma mark - Init

- (void)initData {
    _cropSize = CGSizeMake(280, 280);
    _imageSize = CGSizeMake(800, 800);
}

/**
 动态添加方法
 */
- (void)addMethod {
    Method afSuspendMethod = class_getInstanceMethod([self class], @selector(willDealloc));
    addMethod([UIImagePickerController class], @selector(willDealloc), afSuspendMethod);
}

#pragma mark - PublicMethod

+ (instancetype)shared {
    static LEImagePickerTool *tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[LEImagePickerTool alloc] init];
        [tool initData];
        [tool addMethod];
    });
    return tool;
}

+ (instancetype)selectImageWithController:(UIViewController *)controller edit:(BOOL)isEdit completion:(LEHandlerBlock)completion {
    LEImagePickerTool *tool = [LEImagePickerTool shared];
    tool->_imageBlock = [completion copy];
    tool->_isEdit = isEdit;
    tool.originalImage = YES;
    [tool selectImgeWithController:controller];
    return tool;
}

/**
 从相机选取照片
 */
+ (instancetype)selectImageFromCameraWithController:(UIViewController *)controller edit:(BOOL)isEdit completion:(LEHandlerBlock)completion {
    LEImagePickerTool *tool = [LEImagePickerTool shared];
    tool->_imageBlock = [completion copy];
    tool->_isEdit = isEdit;
    tool.originalImage = YES;
    [tool selectImageFromCameraWithController:controller];
    return tool;
}

/**
 选取图片数组
 maxNumber：最大允许选择的图片数目
 */
+ (instancetype)selectImagesWithController:(UIViewController *)controller maxNumber:(NSUInteger)maxNumber completion:(void(^)(NSArray<UIImage *> *images))completion {
    LEImagePickerTool *tool = [LEImagePickerTool shared];
    tool.originalImage = YES;
    tool.maxNumberOfSelectedPhoto = maxNumber;
    [tool selectImagesWithController:controller completion:completion];
    return tool;
}

#pragma mark - PrivateMethod

- (void)selectImgeWithController:(UIViewController *)controller {
    [GKAlertView showActionSheetInView:controller.view WithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机",@"相册"] clickAtIndex:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1:
                [self imageFromCameraWithController:controller];
                break;
            case 2:
//                [self imageFromPhotoLibraryWithController:controller];
            {
                self.originalImage = YES;
                self.maxNumberOfSelectedPhoto = 1;
                [self imagesFromTZImagePickerWithController:controller completion:^(NSArray<UIImage *> *images) {
                    _imageBlock(images.firstObject);
                }];
            }
                break;
            case 0:
                _imageBlock = nil;
                break;
            default:
                break;
        }
    }];
}

- (void)selectImagesWithController:(UIViewController *)controller completion:(void(^)(NSArray *images))completion {
    [GKAlertView showActionSheetInView:controller.view WithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机",@"相册"] clickAtIndex:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1:
            {
                _imageBlock = ^(UIImage *image) {
                    if (completion) completion(@[image]);
                };
                [self imageFromCameraWithController:controller];
                break;
            }
            case 2:
                [self imagesFromTZImagePickerWithController:controller completion:completion];
                break;
            case 0:
                _imageBlock = nil;
                break;
            default:
                break;
        }
    }];
}

/*!
 *  @brief  从相机中选择图片
 */
- (void)selectImageFromCameraWithController:(UIViewController *)controller {
    [GKAlertView showActionSheetInView:controller.view WithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机"] clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex != 0) {
            [self imageFromCameraWithController:controller];
        }
    }];
}

#pragma mark -
/**
 *  从相机选取
 */
- (void)imageFromCameraWithController:(UIViewController *)con {
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        if ([self cameraPemission]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            _imagePickerController = controller;
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            //        controller.allowsEditing = _isEdit;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [con presentViewController:controller animated:YES completion:nil];
        } else {
            [GKAlertView showAlertViewWithTitle:@"请允许应用访问您的相机" message:@"应用需要您的同意,才能访问相机﻿﻿" cancelButtonTitle:@"取消" otherButtonTitles:@[@"设置"] clickAtIndex:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
        }
    }
}
/**
 *  从相册选取
 */
- (void)imageFromPhotoLibraryWithController:(UIViewController *)con {
    if ([self isPhotoLibraryAvailable]) {
        if ([self photoPermission]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            _imagePickerController = controller;
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //        controller.allowsEditing = _isEdit;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;

            controller.navigationController.navigationBar.translucent = NO;

//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
            [con presentViewController:controller animated:YES completion:nil];
        } else {
            [GKAlertView showAlertViewWithTitle:@"请允许应用访问您的相册" message:@"应用需要您的同意,才能访问相册﻿﻿" cancelButtonTitle:@"取消" otherButtonTitles:@[@"设置"] clickAtIndex:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
        }
    }
}
/**
 *  照片截取
 */
- (GKImageCropViewController *)imageCropWithImage:(UIImage *)image {
    GKImageCropViewController *cropController = [[GKImageCropViewController alloc] init];
//    cropController.contentSizeForViewInPopover = picker.contentSizeForViewInPopover;
    cropController.sourceImage = image;
    cropController.resizeableCropArea = NO;
    cropController.cropSize = self.cropSize;
    cropController.delegate = self;
    return cropController;
}

//对图片尺寸进行压缩--
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    newSize = [self scaleWithImage:image size:newSize];
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    if (!newImage) {
        //        LELog(@"压缩失败！");
        return image;
    }
    // Return the new image.
    return newImage;
}

/**
 *  根据size获取image的等比例放大或者缩小size
 *

 */
- (CGSize)scaleWithImage:(UIImage *)image size:(CGSize)size {
    CGSize imageSize = image.size;
    if (imageSize.width > imageSize.height) {
        size.height = image.size.height * (size.width / imageSize.width);

    } else {
        size.width = imageSize.width * (size.height / imageSize.height);
    }
    return size;
}

#pragma mark - RITLPhotos

- (void)imagesFromRITLPhotoWithController:(UIViewController *)controller completion:(void(^)(NSArray<UIImage *> *images))completion {
    RITLPhotoNavigationViewModel *viewModel = [[RITLPhotoNavigationViewModel alloc] init];

//    viewModel.bridgeDelegate = self;//优先级高于block回调

    //设置需要图片剪切的大小，不设置为图片的原比例大小
//    viewModel.imageSize = _assetSize;

    viewModel.maxNumberOfSelectedPhoto = self.maxNumberOfSelectedPhoto;
//    __weak typeof(self) weakSelf = self;
    viewModel.RITLBridgeGetImageBlock = completion;

    viewModel.RITLBridgeGetImageDataBlock = ^(NSArray <NSData *> * datas){
        //可以进行数据上传操作..
    };

    RITLPhotoNavigationViewController *viewController = [RITLPhotoNavigationViewController photosViewModelInstance:viewModel];

    [controller presentViewController:viewController animated:true completion:^{}];
}

#pragma mark - TZImagePickerController

- (void)imagesFromTZImagePickerWithController:(UIViewController *)controller completion:(void(^)(NSArray<UIImage *> *images))completion {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxNumberOfSelectedPhoto columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;

#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;

    if (self.maxNumberOfSelectedPhoto > 1) {
        // 1.设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = self.selectedAccest; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮

    // imagePickerVc.photoWidth = 1000;

    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // if (iOS7Later) {
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // }
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;

    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频

    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;

    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;

    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;

    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = controller.view.ritl_width - 2 * left;
    NSInteger top = (controller.view.ritl_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/

    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */

    imagePickerVc.isStatusBarDefault = NO;

//    LEWeakifySelf
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        LEStrongifySelf
//        self.selectedImages = [NSMutableArray arrayWithArray:photos];
//        self.selectedAccest = [NSMutableArray arrayWithArray:assets];

        if (completion) {
            completion(photos);
        }
    }];

    [controller presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - Events
#pragma mark - LoadFromService
#pragma mark - Delegate

/**
 *  代理方法
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (_isEdit) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIViewController *cropController = [self imageCropWithImage:image];
        [picker pushViewController:cropController animated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:^{
            if (_originalImage) {
                UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
                if (_imageBlock) {
                    _imageBlock(portraitImg);
                }
            } else {
                //对图片进行压缩
                UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
//                CYLog(@"oldH:%f---oldW:%f", portraitImg.size.height, portraitImg.size.width);
//                UIImage *newImage = [self imageWithImage:portraitImg scaledToSize:self.imageSize];
                UIImage *newImage = [UIImage lubanCompressImage:portraitImg];
//                CYLog(@"height---%f, with---%f", newImage.size.height, newImage.size.width);
                if (_imageBlock) {
                    _imageBlock(newImage);
                }
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
//    if (![_imagePickerController.presentedViewController isKindOfClass:[UIPopoverController class]]){
//        [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    }
}

#pragma mark GKImageCropControllerDelegate

/**
 *  GKImageCropControllerDelegate代理
 */
- (void)imageCropController:(GKImageCropViewController *)imageCropController didFinishWithCroppedImage:(UIImage *)croppedImage {
    [imageCropController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];//防止拍照时状态栏隐藏出现的错误
        if (_originalImage) {
//            CYLog(@"newH:%f---oldW:%f", croppedImage.size.height, croppedImage.size.width);
            if (_imageBlock) {
                _imageBlock(croppedImage);
            }
        } else {
            //对图片进行压缩
//            CYLog(@"oldH:%f---oldW:%f", croppedImage.size.height, croppedImage.size.width);
//            UIImage *newImage = [self imageWithImage:croppedImage scaledToSize:self.imageSize];
            UIImage *newImage = [UIImage lubanCompressImage:croppedImage];
//            CYLog(@"height---%f, with---%f", newImage.size.height, newImage.size.width);
            if (_imageBlock) {
                _imageBlock(newImage);
            }
        }
    }];
}

#pragma mark -

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - 权限

- (BOOL)cameraPemission {
    BOOL isHavePemission = YES;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                isHavePemission = NO;
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }

    return isHavePemission;
}

- (void)requestCameraPemissionWithResult:(void(^)( BOOL granted))completion {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {

                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted) {
                            completion(true);
                        } else {
                            completion(false);
                        }
                    });
                }];
            }
                break;

        }
    }


}

- (BOOL)photoPermission {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];

        if ( author == ALAuthorizationStatusDenied ) {

            return NO;
        }
        return YES;
    }

    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {

        return NO;
    }
    return YES;
}

- (BOOL)willDealloc {
    return NO;
}

@end
