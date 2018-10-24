//
//  UIToastView.m
//
//  Created by MaoBing Ran on 16/2/17.
//  Copyright © 2016年 com. All rights reserved.
//

#import "GKToastView.h"

#define dispatch_main_sync_safe_toast(block)\
if ([NSThread isMainThread]) {\
block();\
}\
else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define UIToastViewWidthMax ([UIScreen mainScreen].bounds.size.width - self.UIToastView_Padding * 2)

@interface GKToastView()
{
    BOOL havLogo;
}
///详细内容字体
@property (nonatomic, strong) UIFont* detailtextFont;
///UIToastView_Width
@property (nonatomic, assign) CGFloat UIToastView_Width;
///UIToastView_Height
@property (nonatomic, assign) CGFloat UIToastView_Height;
///UIToastImage_Size
@property (nonatomic, assign) CGFloat UIToastImage_Size;
///DetailTextWidth
@property (nonatomic, assign) CGFloat UIToastViewDetailTextWidth;
///DetailTextHeight
@property (nonatomic, assign) CGFloat UIToastViewDetailTextHeight;
///UIToastView_Padding
@property (nonatomic, assign) CGFloat UIToastView_Padding;
@property (nonatomic, strong) UIImageView   *logoView;
@property (nonatomic, strong) UILabel* detailLabel;

@property (nonatomic, strong) UIView* mainToastView; //main UIToastView

@end

@implementation GKToastView

#pragma mark getter and setter
- (UIView *)mainToastView {
    if (!_mainToastView) {
        _mainToastView = [[UIView alloc] init];
        [_mainToastView setCenter:self.center];
    }
    return _mainToastView;
}

- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
    }
    return _logoView;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        [_detailLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _detailLabel;
}

#pragma mark Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.xOffset = 0.0;
        self.yOffset = 0.0;
        self.radius  = 5.0;
        self.alpha   = 0.0;
        self.removeFromSuperViewOnHide = YES;
    }
    return self;
}

- (instancetype)initWIthDetailText:(NSString *)detailtext needLogo:(BOOL)needLogo
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        havLogo = needLogo;
        self.detailText = detailtext;
        self.detailtextFont = [UIFont systemFontOfSize:17.0];
        self.UIToastImage_Size = 30;
        self.UIToastView_Padding = 10;
        [self detailTextSize];
        [self UIToastViewWidth];
        [self UIToastViewHeight];
        [self.mainToastView.layer setCornerRadius:5];
        [self layout];
    }
    return self;
}

- (void)UIToastViewWidth
{
    if (havLogo) {
        self.UIToastView_Width = self.UIToastView_Padding + self.UIToastImage_Size + self.UIToastView_Padding + self.UIToastViewDetailTextWidth + self.UIToastView_Padding;
    } else {
        self.UIToastView_Width = self.UIToastView_Padding + self.UIToastViewDetailTextWidth + self.UIToastView_Padding;
    }
}

- (void)UIToastViewHeight
{
    if (havLogo) {
        if (self.UIToastImage_Size > self.UIToastViewDetailTextHeight) {
            self.UIToastView_Height = self.UIToastView_Padding + self.UIToastImage_Size + self.UIToastView_Padding;
        } else {
            self.UIToastView_Height = self.UIToastView_Padding + self.UIToastViewDetailTextHeight + self.UIToastView_Padding;
        }
    } else {
        self.UIToastView_Height = self.UIToastView_Padding + self.UIToastViewDetailTextHeight + self.UIToastView_Padding;
    }
}

- (void)detailTextSize
{
    CGSize detailLabelSize  = [self.detailText sizeWithAttributes:@{NSFontAttributeName :self.detailtextFont}];
    if (havLogo) {
        if (self.UIToastView_Padding *3 + self.UIToastImage_Size + detailLabelSize.width > UIToastViewWidthMax) {
            //设置换行
            CGFloat lineCount = detailLabelSize.width * 1.0 / (UIToastViewWidthMax - self.UIToastView_Padding *3 - self.UIToastImage_Size);
            if (lineCount - (int)lineCount > 0) {
                lineCount += 1;
            }
            self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.detailLabel.numberOfLines = 0;
            
            self.UIToastViewDetailTextWidth = 1.0 * detailLabelSize.width / lineCount;
            self.UIToastViewDetailTextHeight = (int)lineCount *detailLabelSize.height;
        } else {
            self.UIToastViewDetailTextWidth = detailLabelSize.width;
            self.UIToastViewDetailTextHeight = detailLabelSize.height;
        }
    } else {
        if (self.UIToastView_Padding *2 + detailLabelSize.width > UIToastViewWidthMax) {
            //设置换行
            self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.detailLabel.numberOfLines = 0;
            CGFloat lineCount = detailLabelSize.width * 1.0/ (UIToastViewWidthMax - self.UIToastView_Padding *3 - self.UIToastImage_Size);
            if (lineCount - (int)lineCount > 0) {
                lineCount += 1;
            }
            self.UIToastViewDetailTextWidth = 1.0 * detailLabelSize.width / lineCount;
            self.UIToastViewDetailTextHeight = (int)lineCount *detailLabelSize.height;
        } else {
            self.UIToastViewDetailTextWidth = detailLabelSize.width;
            self.UIToastViewDetailTextHeight = detailLabelSize.height;
        }
    }
}

#pragma mark UI
- (void)addView
{
    [self addSubview:self.mainToastView];
    [self.mainToastView addSubview:self.logoView];
    [self.mainToastView addSubview:self.detailLabel];
}

#pragma mark Layout

- (void)layout {
    [self addView];
    [self setupLabel];
    [self setFrames];
//    NSArray* windows = [UIApplication sharedApplication].windows;
//    UIView *window = [windows objectAtIndex:0];
    UIView *window = [self lastWindow];
    dispatch_main_sync_safe_toast(^{
        [window addSubview:self];
    });
}
/*!
 *  获取正在显示的window
 */
- (UIWindow *)lastWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds) && ![window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")] && !window.isHidden)
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (void)setupLabel {
    [self.detailLabel setText:self.detailText];
    [self.detailLabel setTextColor:[UIColor whiteColor]];
    [self.detailLabel setFont:self.detailtextFont];
}

- (void)setDetailLabelFont:(UIFont *)font
{
    self.detailtextFont = font;
    [self.detailLabel setFont:font];
    [self setFrames];
}

- (void)setDetailLabelColor:(UIColor *)color
{
    [self.detailLabel setTextColor:color];
}

- (void)rotate360DegreeWithImageView:(UIImageView *)imageView
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)setFrames
{
    [self detailTextSize];
    [self UIToastViewWidth];
    [self UIToastViewHeight];
    [self.detailLabel sizeToFit];
    if (havLogo) {
        [self.mainToastView setFrame:CGRectMake(0, 0, self.UIToastView_Width, self.UIToastView_Height)];
        [self.mainToastView setBackgroundColor:[UIColor colorWithRed:81.f/255.f green:81.f/255.f blue:81.f/255.f alpha:1]];
        
        [self.logoView setFrame:CGRectMake(0, 0, self.UIToastImage_Size, self.UIToastImage_Size)];
        [self.logoView setCenter:CGPointMake(self.UIToastView_Padding + self.UIToastImage_Size * 0.5, self.UIToastView_Height * 0.5)];

        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[GKToastView class]] pathForResource:@"GKImages" ofType:@"bundle"]];
        UIImage *arrowImage = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"loading" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.logoView setImage:arrowImage];
        [self rotate360DegreeWithImageView:self.logoView];
        
        CGFloat detailLabelCenterX = self.UIToastView_Width - self.UIToastViewDetailTextWidth * 0.5 - self.UIToastView_Padding;
        CGFloat detailLabelCenterY = self.UIToastView_Height * 0.5;
        [self.detailLabel setFrame:CGRectMake(0, 0, self.UIToastViewDetailTextWidth, self.UIToastViewDetailTextHeight)];
        [self.detailLabel setCenter:CGPointMake(detailLabelCenterX, detailLabelCenterY)];
        
    } else {
        [self.mainToastView setFrame:CGRectMake(0, 0, self.UIToastView_Width, self.UIToastView_Height)];
        [self.mainToastView setBackgroundColor:[UIColor colorWithRed:81.f/255.f green:81.f/255.f blue:81.f/255.f alpha:1]];
        
        CGFloat detailLabelCenterX = self.UIToastView_Width * 0.5;
        CGFloat detailLabelCenterY = self.UIToastView_Height * 0.5;
        [self.detailLabel setFrame:CGRectMake(0, 0, self.UIToastViewDetailTextWidth, self.UIToastViewDetailTextHeight)];
        [self.detailLabel setCenter:CGPointMake(detailLabelCenterX, detailLabelCenterY)];
    }
}

#pragma mark show & hide
- (void)show {
    [self showAnimateWithDuration:0];
}

- (void)showAnimateWithDuration:(NSTimeInterval)duration {
    CGRect frame = self.mainToastView.frame;
    
    [self.mainToastView setFrame:frame];
    [self setAlpha:0];
    [self.mainToastView setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width *0.5, [[UIScreen mainScreen] bounds].size.height * 0.5)];

    [UIView animateWithDuration:.3 animations:^{
        [self setAlpha:1];
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    [self.logoView.layer removeAnimationForKey:@"rotationAnimation"];
    NSTimeInterval interval = .3;
    CGRect frame = self.mainToastView.frame;
    
    [UIView animateWithDuration:interval animations:^{
        [self setAlpha:0];
        [self.mainToastView setFrame:frame];
    } completion:^(BOOL finished) {
        if (self.removeFromSuperViewOnHide) {
            [self removeFromSuperview];
        }
    }];
}

- (void)setUIToastViewBackground:(UIColor *)backgroundColor {
    [self.mainToastView setBackgroundColor:backgroundColor];
}

- (void)setUIToastViewPadding:(CGFloat)padding {
    self.UIToastView_Padding = padding;
    [self setFrames];
}

+ (void)makeText:(NSString *)text duration:(NSTimeInterval)duration {
    id d = [[self alloc] initWIthDetailText:text needLogo:NO];
    [d show];
    __block int timeout=duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [d hide];
                
            });
        }else{
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void)timerDownWithDuration:(int)duration
{
    __block int timeout=duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hide];
                
            });
        }else{
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


@end
