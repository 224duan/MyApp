//
//  DXInputView.h
//  TNews
//
//  Created by news365-macpro on 2018/11/2.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXTextView.h"
@class DXInputView;

typedef void(^DXInputViewHeightChangedBlock)(DXInputView *inputView, CGFloat height);

@protocol DXInputViewDelegate <NSObject>

-(void)didClickedSendButtonInInputView:(DXInputView *)inputView;

@end

@interface DXInputView : UIView

@property(nonatomic, weak) id<DXInputViewDelegate> delegate;

@property(nonatomic, strong, readonly) DXTextView * textView; 

@property(nonatomic, strong, readonly) UIButton * sendButton;

@property(nonatomic, strong) UIView * accessoryView;

@property(nonatomic, copy)   DXInputViewHeightChangedBlock heightChangedBlock; // 返回高度的值，最后具体的高度由外部决定

@property(nonatomic, assign) CGFloat maxH; // == 0 表示不限高

@property(nonatomic, assign, readonly) CGFloat recommendHeight; // 通过计算字体高度和间距得出的推荐高度


@end
