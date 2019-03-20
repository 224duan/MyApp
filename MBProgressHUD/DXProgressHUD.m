//
//  DXProgressHUD.m
//  365News
//
//  Created by news365-macpro on 2017/2/26.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import "DXProgressHUD.h"

@implementation DXProgressHUD

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        self.bezelView.backgroundColor = [UIColor blackColor];
        self.contentColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
//        [UIActivityIndicatorView appearanceWhenContainedIn:[DXProgressHUD class], nil].color = [UIColor whiteColor];
        
    }
    return self;
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    DXProgressHUD *hud = [DXProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

#pragma mark 显示时间设置
+ (void)showSuccess:(NSString *)success toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    [self show:success icon:@"success.png" view:view hideAfterDelay:delay];
}

+ (void)showError:(NSString *)error toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    [self show:error icon:@"error.png" view:view hideAfterDelay:delay];
}


#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self showError:error toView:view hideAfterDelay:0.7];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self showSuccess:success toView:view hideAfterDelay:0.7];
}

#pragma mark 显示一些信息
+ (DXProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    DXProgressHUD *hud = [DXProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (DXProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


+ (void)showSuccessWithInternationKey:(NSString *)key
{
    [self showSuccess:kInternationStrForKey(key)];
}
+ (void)showErrorWithInternationKey:(NSString *)key
{
    [self showError:kInternationStrForKey(key)];
}

+ (void)showSuccessWithInternationKey:(NSString *)key toView:(UIView *)view
{
    [self showSuccess:kInternationStrForKey(key) toView:view];
}

+ (void)showErrorWithInternationKey:(NSString *)key toView:(UIView *)view
{
    [self showError:kInternationStrForKey(key) toView:view];
}

#pragma mark 显示无网络
+(void)showNoInternet
{
    [self showNoInternetHideAfterDelay:0.7];
}

+ (void)showNoInternetToView:(UIView *)view
{
    [self showNoInternetToView:view HideAfterDelay:0.7];
}

+ (void)showNoInternetHideAfterDelay:(NSTimeInterval)delay
{
    [self showNoInternetToView:nil HideAfterDelay:delay];
}

+ (void)showNoInternetToView:(UIView *)view HideAfterDelay:(NSTimeInterval)delay;
{
    [self show:nil icon:@"noInternet" view:view hideAfterDelay:delay];
}

#pragma mark 重写父类方法
-(void)hideAnimated:(BOOL)animated
{
    [super hideAnimated:animated];
    self.show = NO;
}

- (void)showAnimated:(BOOL)animated
{
    [super showAnimated:animated];
    self.show = YES;
}

@end
