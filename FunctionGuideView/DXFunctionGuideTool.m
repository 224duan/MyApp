//
//  DXFunctionGuideView.m
//  IENews_test
//
//  Created by news365-macpro on 2017/1/13.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//


#import "DXFunctionGuideTool.h"
#import "DXClickAlertView.h"
#import "DXGestureAlertView.h"
#import "UIImage+DXCate.h"
NSString *const FunctionGuideKey = @"functionGuideKey";

@interface DXFunctionGuideTool()

@end

@implementation DXFunctionGuideTool


+(void)showFunctionGuideViewWithClickTarget:(UIView *)targetView guideMessage:(NSString *)message key:(NSString *)key completionHandler:(DXFunctionGuideViewCompletionHandler)completionHandler
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect targetViewRect = [targetView convertRect:targetView.bounds toView:window];
    CGPoint targetViewCenter = CGPointMake(CGRectGetMidX(targetViewRect), CGRectGetMidY(targetViewRect));
    
    [self showFunctionGuideViewWithClickPoint:targetViewCenter guideMessage:message key:key completionHandler:completionHandler];
}

+(void)showFunctionGuideViewWithClickPoint:(CGPoint)point guideMessage:(NSString *)message key:(NSString *)key completionHandler:(DXFunctionGuideViewCompletionHandler)completionHandler
{
    if ([self canDisPLayFunctionGuideViewWithKey:key]) {
        
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        DXClickAlertView *clickAlert = [[DXClickAlertView alloc] initWithFrame:window.bounds targetPoint:point];
        
        clickAlert.message = message;
        clickAlert.tapHander = ^(DXClickAlertView *alertView){
            
            [self handerWithView:alertView completionHandler:completionHandler];
        };
        clickAlert.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [window addSubview:clickAlert];
    }
}


+(void)showFunctionGuideViewWithGestureType:(DXGuideGestureType)gestureType guideMessage:(NSString *)message key:(NSString *)key completionHandler:(DXFunctionGuideViewCompletionHandler)completionHandler
{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    NSString *imageName = [NSString stringWithFormat:@"Gesture%ld",(long)gestureType];
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DXGestureAlertView" owner:nil options:nil];
    DXGestureAlertView *gestureAlert = [array firstObject];
    gestureAlert.frame = window.bounds;
    gestureAlert.imageView.image = [UIImage dx_imageInKit:imageName];;
    gestureAlert.detailLabel.text = message;
    gestureAlert.buttonClckHander = ^(DXGestureAlertView *alertView){
        [self handerWithView:alertView completionHandler:completionHandler];
    };
    [window addSubview:gestureAlert];
}


+(BOOL)canDisPLayFunctionGuideViewWithKey:(NSString *)key
{
    if (key == nil) return  YES;
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:FunctionGuideKey];
    if (array == nil) {
        
        array = [NSArray array];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:FunctionGuideKey];
        
    }else{
        
        for (NSString *str in array) {
            if ([str isEqualToString:key]) {
                return NO;
            }
        }
        NSMutableArray *mutableArray = [array mutableCopy];
        [mutableArray addObject:key];
        [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:FunctionGuideKey];
    }
    return YES;
}

+(void)handerWithView:(UIView *)view completionHandler:(DXFunctionGuideViewCompletionHandler)completionHandler
{
    [UIView animateWithDuration:0.4 animations:^{
        
        view.alpha = 0;
        
    }completion:^(BOOL finished) {
        if (completionHandler) {
            completionHandler();
        }
        [view removeFromSuperview];
    }];
}

@end
