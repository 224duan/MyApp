//
//  DXFunctionGuideView.h
//  IENews_test
//
//  Created by news365-macpro on 2017/1/13.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DXGuideGestureType) {

    DXGuideGestureNone,         // 无
    DXGuideGesturePinch,        // 捏合手势
    DXGuideGesturePinchToSmall, // 缩小手势
    DXGuideGesturePinchToBig,   // 放大手势
    DXGuideGesturePan,          // 拖拽
    DXGuideGestureSwipe,        // 轻扫
    DXGuideGestureRotation,     // 旋转
    DXGuideGestureLongPress,    // 长按
    DXGuideGestureScreenEdgePan,// 屏幕边缘轻扫
};


typedef void (^DXFunctionGuideViewCompletionHandler)();

@interface DXFunctionGuideTool : NSObject

/**
 显示点击类事件的引导界面

 @param targetView 响应点击事件的view
 @param message 引导内容
 @param key 唯一标识, 用来保证该引导界面只会显示一次
 @param completionHandler 引导图消失之后调用
 */
+(void)showFunctionGuideViewWithClickTarget:(UIView *)targetView guideMessage:(NSString *)message key:(NSString *)key completionHandler:(DXFunctionGuideViewCompletionHandler)completionHandler;

/**
 显示点击类事件的引导界面
 
 @param point 目标点在 window 中的位置
 @param message 引导内容
 @param key 唯一标识, 用来保证该引导界面只会显示一次
 @param completionHandler 引导图消失之后调用
 */
+(void)showFunctionGuideViewWithClickPoint:(CGPoint)point guideMessage:(NSString *)message key:(NSString *)key completionHandler:(DXFunctionGuideViewCompletionHandler)completionHandler;

/**
 显示手势类事件的引导界面
 
 @param gestureType 手势类型
 @param message 引导内容
 @param key 唯一标识，用来保证该引导界面只会显示一次
 @param completionHandler 引导图消失之后调用
 */
+(void)showFunctionGuideViewWithGestureType:(DXGuideGestureType)gestureType guideMessage:(NSString *)message key:(NSString *)key completionHandler:(DXFunctionGuideViewCompletionHandler)completionHandler;

@end
