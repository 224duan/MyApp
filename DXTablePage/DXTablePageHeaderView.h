//
//  DXTablePageHeaderView.h
//  TNews
//
//  Created by news365-macpro on 2018/10/19.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXTablePageHeaderView;
NS_ASSUME_NONNULL_BEGIN

@protocol DXTablePageHeaderViewDelegate <NSObject>

-(void)didClickItemInTablePageHeaderView:(DXTablePageHeaderView *)headerView;

@end

@interface DXTablePageHeaderView : UIView

@property(nonatomic, weak) id<DXTablePageHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
// 简单版本 两个按钮一条线

@property(nonatomic, assign) NSInteger selectIndex;


@end

NS_ASSUME_NONNULL_END
