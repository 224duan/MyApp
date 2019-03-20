//
//  DXInputViewController.h
//  TNews
//
//  Created by news365-macpro on 2018/11/7.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXInputView.h"

typedef void(^DXAnimationBlock)(BOOL finished);

@interface DXInputViewController : UIViewController

@property(nonatomic, strong, readonly) DXInputView * inputView;

/**
 用来设置 inputView 距离底部的位置
 */
@property(nonatomic, assign) CGFloat inputViewBottomMargin;

@end

