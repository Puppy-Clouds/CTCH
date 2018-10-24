//
//  LEProgressButton.m
//  CreditAddressBook
//
//  Created by Lee on 15/9/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "LEProgressButton.h"
#import "UIView+GK.h"

@interface LEProgressButton ()

@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIView *progress;
@property (nonatomic, strong) UIView *progressBorder;
@end

@implementation LEProgressButton

- (UIView *)cover {
    if (!_cover) {
        //进度条遮盖view
        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self addSubview:cover];
        cover.backgroundColor = [UIColor blackColor];
//        cover.alpha = .8;
        cover.layer.masksToBounds = YES;
        cover.layer.cornerRadius = 4.0;
        
        //进度条边框
        UIView *progressBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cover.width/1.3, 10)];
        [cover addSubview:progressBorder];
        progressBorder.center = cover.center;
        progressBorder.layer.masksToBounds = YES;
        progressBorder.layer.cornerRadius = 5;
        progressBorder.layer.borderColor = [UIColor whiteColor].CGColor;
        progressBorder.layer.borderWidth = 2;
        progressBorder.backgroundColor = [UIColor whiteColor];
        progressBorder.center = cover.center;
        self.progressBorder = progressBorder;
        
        //进度条
        UIView *progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, progressBorder.height)];
        [progressBorder addSubview:progress];
        progress.backgroundColor = [UIColor blackColor];
        self.progress = progress;
        _cover = cover;
    }
    return _cover;
}

- (void)setRatio:(CGFloat)ratio {
    _ratio = ratio;

    if (ratio < 0) {
        self.cover.alpha = .0;
    } else {
        self.cover.alpha = .8;
        self.progress.width = self.progressBorder.width * ratio;
        if (self.progress.width >= self.progressBorder.width) {
            [UIView animateWithDuration:.7f animations:^{
                self.cover.alpha = 0;
            }];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
@end
