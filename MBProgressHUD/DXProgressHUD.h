//
//  DXProgressHUD.h
//  365News
//
//  Created by news365-macpro on 2017/2/26.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import "MBProgressHUD.h"

@interface DXProgressHUD : MBProgressHUD

@property(nonatomic, assign, getter=isShow) BOOL show; // 当前是否显示

+ (void)showSuccess:(NSString *)success toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (void)showError:(NSString *)error toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

// 显示菊花状态
+ (DXProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (DXProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

/**
 @params key : (国际化)中的参数
 */
+ (void)showSuccessWithInternationKey:(NSString *)key;
+ (void)showErrorWithInternationKey:(NSString *)key;

+ (void)showSuccessWithInternationKey:(NSString *)key toView:(UIView *)view;
+ (void)showErrorWithInternationKey:(NSString *)key toView:(UIView *)view;

// 无网络
+ (void)showNoInternetToView:(UIView *)view HideAfterDelay:(NSTimeInterval)delay;
+ (void)showNoInternetHideAfterDelay:(NSTimeInterval)delay;
+ (void)showNoInternetToView:(UIView *)view;
+ (void)showNoInternet;

@end
