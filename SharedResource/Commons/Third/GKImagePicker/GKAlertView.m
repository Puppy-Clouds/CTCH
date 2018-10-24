//
//  UIInfomationView.m
//  CreditAddressBook
//
//  Created by LEE on 15/6/23.
//  Copyright (c) 2015年 LEE. All rights reserved.
//

#import "GKAlertView.h"
#import <UIKit/UIKit.h>

/**
 *  让类方法中的对象被持有
 */
static ClickAtIndexBlock _clickAtIndexBlock;
/**
 *  让类方法中的对象被持有
 */
static AlertViewBlock _alertViewBlock;

@interface GKAlertView () <UIActionSheetDelegate, UIAlertViewDelegate>

@end

@implementation GKAlertView

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)otherButtons
                           clickAtIndex:(AlertViewBlock)clickAtIndex {
    
    _alertViewBlock = [clickAtIndex copy];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
//    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:15]constrainedToSize:CGSizeMake(220,300) lineBreakMode:NSLineBreakByTruncatingTail];
//    
//    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 220, size.height)];
//    textLabel.font = [UIFont systemFontOfSize:14];
//    textLabel.textColor = [UIColor blackColor];
//    textLabel.backgroundColor = [UIColor clearColor];
//    textLabel.lineBreakMode =NSLineBreakByWordWrapping;
//    textLabel.numberOfLines =0;
//    textLabel.textAlignment =NSTextAlignmentLeft;
//    textLabel.text = message;
//    [alert setValue:textLabel forKey:@"accessoryView"];
//    alert.message =@"";
    
    [alert show];
    return alert;
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)otherButtons
                                  style:(UIAlertViewStyle)style
                           keyboardType:(UIKeyboardType)keyboardType
                           clickAtIndex:(AlertViewBlock)clickAtIndex {
    
    _alertViewBlock = [clickAtIndex copy];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    alert.alertViewStyle = style;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = keyboardType;
    for(NSString *buttonTitle in otherButtons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    [alert show];
    return alert;
}

#pragma mark - ActionSheet
+ (UIActionSheet *)showActionSheetInView:(UIView *)view
                               WithTitle:(NSString *)title
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                  destructiveButtonTitle:(NSString *)destructiveButton
                       otherButtonTitles:(NSArray *)otherButtons
                            clickAtIndex:(ClickAtIndexBlock)clickAtIndex {
    
    _clickAtIndexBlock = [clickAtIndex copy];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destructiveButton
                                              otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons) {
        [sheet addButtonWithTitle:buttonTitle];
    }
    
    [sheet showInView:view];
    return sheet;
}

#pragma mark - alertView代理
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_clickAtIndexBlock) {
        _clickAtIndexBlock(buttonIndex);
    }
    if (_alertViewBlock) {
        _alertViewBlock(alertView, buttonIndex);
    }
}

+ (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    _clickAtIndexBlock = nil;
    _alertViewBlock = nil;
}

#pragma mark - actionSheetView代理
+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    _clickAtIndexBlock(buttonIndex);
}

+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    _clickAtIndexBlock = nil;
}

@end
