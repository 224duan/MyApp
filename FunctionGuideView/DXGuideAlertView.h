//
//  DXGuideAlertView.h
//  IENews_test
//
//  Created by news365-macpro on 2017/1/16.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    DXGuideAlertViewArrowDirectionNone,
    DXGuideAlertViewArrowDirectionUp,
    DXGuideAlertViewArrowDirectionDown,
    DXGuideAlertViewArrowDirectionLeft,
    DXGuideAlertViewArrowDirectionRight,
    
} DXGuideAlertViewArrowDirection;

@interface DXGuideAlertView : UIView

@property(nonatomic, assign) DXGuideAlertViewArrowDirection arrowDirection;
@property(nonatomic, assign) CGFloat arrowPosition;
@property(nonatomic, copy)   NSString * message;

@end
