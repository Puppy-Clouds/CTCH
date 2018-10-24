//
//  RMBLoadingView.h
//
//  Created by MaoBing Ran on 16/2/17.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKToastView : UIView

/**
 *  初始换
 *
 *  @param detailtext 内容Toast.makeText(getApplicationContext(), "默认的Toast", Toast.LENGTH_SHORT);
 *
 *  @return UIToastView
 */
- (instancetype)initWIthDetailText:(NSString *)detailtext needLogo:(BOOL)needLogo;

/**
 *  类似Android Toast
 *
 *  @param text     显示文字
 *  @param duration 时长
 *
 */
+ (void)makeText:(NSString *)text duration:(NSTimeInterval)duration;

/**
 *  隐藏视图
 */
- (void)hide;


/**
 *  显示 UIToastView
 */
- (void)show;

/**
 *  带动画效果显示  UIToastView
 *
 *  @param duration 时间
 */
- (void)showAnimateWithDuration:(NSTimeInterval)duration;

/**
 *  设置背景颜色
 *
 *  @param backgroundColor 背景颜色
 */
- (void)setUIToastViewBackground:(UIColor *)backgroundColor;

/**
 *  设置详细内容字体
 *
 *  @param font 字体
 */
- (void)setDetailLabelFont:(UIFont *)font;

/**
 *  设置详细内容字体颜色
 *
 *  @param color 字体颜色
 */

- (void)setDetailLabelColor:(UIColor *)color;

/**
 *  设置 LoadingView边距
 *
 *  @param padding 边距
 */
- (void)setUIToastViewPadding:(CGFloat)padding;

/**
 * An optional details message displayed below the titleText message.
 * property is also set and is different from an empty string (@""). The details text can span multiple lines.
 */
@property (nonatomic, copy)   NSString *detailText;

/**
 * The x-axis offset of the LoadingView relative to the centre of the superview.
 */
@property (nonatomic, assign) CGFloat xOffset;

/**
 * The y-axis offset of the LoadingView relative to the centre of the superview.
 */
@property (nonatomic, assign) CGFloat yOffset;

/**
 *  the radius of the LoadingView
 *  default value is 5.0
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to YES.
 */
@property (nonatomic, assign) BOOL removeFromSuperViewOnHide;

@end

