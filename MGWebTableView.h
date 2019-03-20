//
//  MGWebTableView.h
//  TNews
//
//  Created by news365-macpro on 2018/7/16.
//  Copyright © 2018年 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

/*
 结构如下：
 
 headerView
 |
 webView
 |
 centerView
 |
 tableView
 |
 Footer

 */


@interface MGWebTableView : UIScrollView

@property(nonatomic, strong, readonly) UIView * contentView;

@property(nonatomic, strong, readonly) WKWebView * webView;
@property(nonatomic, strong, readonly) UITableView * tableView;

@property(nonatomic, strong) UIView * headerView;
@property(nonatomic, strong) UIView * centerView;
@property(nonatomic, strong) UIView * footerView;

// 用来控制webView 的最小高度
@property(nonatomic, assign) CGFloat webViewMinHeight;
@property(nonatomic, assign) CGFloat tableViewMinHeight;

// webView 和 tableView 不能为空
-(instancetype)initWithWebView:(WKWebView *)webView
                     tableView:(UITableView *)tableView
                         frame:(CGRect)frame;


// 设置view想要在self 中显示的位置, y 必须大于0
-(void)scrollView:(UIView *)view toOffsetY:(CGFloat)y animated:(BOOL)animated;

@end
