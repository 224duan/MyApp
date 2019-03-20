//
//  DXClickAlertView.h
//  365News
//
//  Created by news365-macpro on 2017/1/19.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXClickAlertView;

typedef void (^tapHander)(DXClickAlertView *alertView);

@interface DXClickAlertView : UIView

@property(nonatomic, copy) NSString * message;
@property(nonatomic, copy) tapHander  tapHander;

// targetPoint 指向的点
-(instancetype)initWithFrame:(CGRect)frame targetPoint:(CGPoint)targetPoint;
//-(instancetype)initWithFrame:(CGRect)frame targetView:(UIView *)targetView;

@end
