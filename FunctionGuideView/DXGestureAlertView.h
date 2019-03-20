//
//  DXGestureAlertView.h
//  365News
//
//  Created by news365-macpro on 2017/1/18.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXGestureAlertView;
typedef void (^buttonClckHander)(DXGestureAlertView *alertView);

@interface DXGestureAlertView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property(nonatomic, copy) buttonClckHander buttonClckHander;

@end
