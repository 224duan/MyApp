//
//  DXTextView.h
//  TNews
//
//  Created by news365-macpro on 2018/11/2.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXTextView;

typedef void(^DXTextViewContentChangedBlock)(DXTextView *textView);


NS_ASSUME_NONNULL_BEGIN

@interface DXTextView : UITextView

/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 图片item 的尺寸
 default (80, 120)
 */
@property(nonatomic, assign) CGSize imageItemSize;
@property(nonatomic, strong, readonly) NSArray<UIImage *> * images;


/**
 images 、 text 发生变化时调用
 */
@property(nonatomic, copy) DXTextViewContentChangedBlock contentChangedBlock;

-(void)addImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
