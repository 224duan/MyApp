//
//  FCLabel.h
//  Fujitsu LifeCam
//
//  Created by news365-macpro on 2017/3/27.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//  自定义 label 内容 UIEdgeInsets

#import <UIKit/UIKit.h>

@interface FCLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;

@end
