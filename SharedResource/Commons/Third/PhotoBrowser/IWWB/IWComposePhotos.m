//
//  IWComposePhotos.m
//  WeiBo17
//
//  Created by teacher on 15/8/26.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "IWComposePhotos.h"
#import "IWComposeImageView.h"
#import "UIView+Extension.h"
#import "SDPhotoBrowser.h"

#define MAX_COL 3
#define MARGIN 8

#define ChildWH (self.width - MARGIN * 4)/MAX_COL

@interface IWComposePhotos ()<SDPhotoBrowserDelegate>

@property(nonatomic, weak) UIButton *addBtn;
/*!
 *  @brief  图片达到hiddenCount张时隐藏addBtn
 */
@property(nonatomic, assign) NSInteger hiddenCount;
@end

@implementation IWComposePhotos
/*!
 *  @brief  显示添加图片的button
 *  @param count 图片达到count张时隐藏addBtn
 */
- (void)showAddBtnWihtTarget:(id)target action:(SEL)action hiddenWithImageCount:(NSInteger)count {
    CGFloat childWH = (self.width - MARGIN * 4)/MAX_COL;
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setBackgroundImage:[UIImage imageNamed:cameraPlacehoder] forState:UIControlStateNormal];
    addBtn.size = CGSizeMake(childWH, childWH);
    [self addSubview:addBtn];
    [addBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;
    self.hiddenCount = count;

    //若是不走block则添加通知强制删除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeImgClick:) name:@"RemoveImageRemove" object:nil];
}

- (void)hiddenAddButton {
    self.addBtn.hidden = YES;
}

- (void)showAddButton {
    self.addBtn.hidden = NO;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat childWH = (self.width - MARGIN * 4)/MAX_COL;
    NSInteger count = self.subviews.count;
    for (int i=0; i<count; i++) {
        UIView *childView = self.subviews[count-1-i];
        //计算列数与行数
        NSInteger col = i % MAX_COL;
        NSInteger row = i / MAX_COL;
        childView.size = CGSizeMake(childWH, childWH);
        
        if (!(childView.x == 0 && childView.y == 0)) {
            [UIView animateWithDuration:0.25 animations:^{
                //计算宽高位置
                childView.x = MARGIN+(childWH + MARGIN) * col;
                childView.y = MARGIN+(childWH + MARGIN) * row;
            }];
        } else {
            childView.x =  MARGIN+(childWH + MARGIN) * col;
            childView.y =  MARGIN+(childWH + MARGIN) * row;
            [UIView animateWithDuration:0.5 animations:^(){
                childView.alpha = 1.0;
            }];
        }
    }
    if (self.addBtn) {
        if ((count-1) == self.hiddenCount) {
            [self hiddenAddButton];
        } else {
            [self showAddButton];
        }
    }
}

- (void)addImage:(UIImage *)image {
    IWComposeImageView *imageView = [[IWComposeImageView alloc] init];
    imageView.image = image;
    imageView.layer.cornerRadius = 4;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    imageView.alpha = 0.1;
    //初始化手势并指定调用方法
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    //添加手势
    [imageView addGestureRecognizer:tap];

    ///删除事件
//    imageView.bIWRemoveImageRemove = self.bIWRemoveImageRemove;
    imageView.RemoveImageRemove = self.RemoveImageRemove;
    
}

//利用通知强制走block
- (void)removeImgClick:(NSNotification *)info{
    if (self.RemoveImageRemove) {
        self.RemoveImageRemove(info.object);
    }
}

- (void)imageTap:(UITapGestureRecognizer *)ges {
    IWComposeImageView *imageView = (IWComposeImageView *)ges.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.images.count; // 图片总数
    NSUInteger index = [self.images indexOfObject:imageView.image];
    browser.currentImageIndex = self.images.count - index - 1;
    browser.delegate = self;
    [browser show];
}

#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    NSArray *images = [self images];
    UIImage *image = nil;
    image = images[images.count - index - 1];
    return image;
}
// 返回高质量图片的url
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
//    NSString *urlStr = [[self.pic_urls[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//    return [NSURL URLWithString:urlStr];
//}

- (NSArray *)images {
    //数组使用kvc,调用valueForKeyPath方法,取的就是数组里面每一个元素的某个属性,并且作为一个数组返回
    NSArray *image = [self.subviews valueForKeyPath:@"image"];
    if (self.addBtn) {
        if ([image.firstObject isKindOfClass:[NSNull class]]) {
            image = [image subarrayWithRange:NSMakeRange(1, image.count-1)];
        }
    }
    if ([image.firstObject isKindOfClass:[NSNull class]]) {
        image = [image subarrayWithRange:NSMakeRange(1, image.count-1)];
    }
    return image;
}

@end
