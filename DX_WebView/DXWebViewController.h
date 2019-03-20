//
//  WebViewController.h
//  365News
//
//  Created by news365-macpro on 2017/3/30.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface DXWebViewController : UIViewController

@property(nonatomic, strong, readonly) WKWebView * webView;

@property(nonatomic, strong) UIColor * navBarTitleColor;        // title 的颜色
@property(nonatomic, strong) UIColor * navBarBackgroundColor;   // 导航背景色
@property(nonatomic, strong) UIColor * navBarTintColor;         // 用来设置导航sub view 的颜色
@property(nonatomic, strong) UIColor * progressTintColor;       // 进度条的颜色
@property(nonatomic, strong) UIImage * backImage;               // 返回按钮的图片

@end
