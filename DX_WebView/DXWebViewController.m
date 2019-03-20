//
//  WebViewController.m
//  365News
//
//  Created by news365-macpro on 2017/3/30.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import "DXWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIImage+DXWeb.h"

#define DXWeb_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375.f && [UIScreen mainScreen].bounds.size.height == 812.f)

@interface DXWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property(nonatomic, assign) CGFloat lastContentY;

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarHeightC;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@property (weak, nonatomic) IBOutlet UIButton *goForwardButton;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonTopC;

@end

@implementation DXWebViewController

-(instancetype)init
{
    if (self = [super init]) {
        
        _progressTintColor  = mainHeaderGreenColor;
        _navBarTintColor    = mainHeaderGreenColor;
        _navBarTitleColor   = [UIColor blackColor];
        _navBarBackgroundColor = [UIColor groupTableViewBackgroundColor];
        _backImage = [UIImage imageNamed:@"DXWeb_close"];
        
        _webView = [[WKWebView alloc] init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiSetup];
    [self addObserver];
}

-(void)uiSetup
{
    _bottomBar.hidden = _refreshButton.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarTintColor = _navBarTintColor;
    self.navBarTitleColor = _navBarTitleColor;
    self.progressTintColor = _progressTintColor;
    self.navBarBackgroundColor = _navBarBackgroundColor;
    self.backImage = _backImage;
    
    if (DXWeb_iPhoneX) {
        _backButtonTopC.constant = 44;
        _bottomBarHeightC.constant = 44 + 30;
    }
    
    // 修改按钮的颜色
    [_goBackButton setImage:[UIImage imageNamed:@"DXWeb_goBack"
                                    changeColor:[UIColor lightTextColor]]
                   forState:UIControlStateNormal];
    
    [_goForwardButton setImage:[UIImage imageNamed:@"DXWeb_goForward"
                                       changeColor:[UIColor lightTextColor]]
                      forState:UIControlStateNormal];
    
    
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progress = 0.00;
    
    CGFloat webViewY = _backButtonTopC.constant + _backButton.frame.size.height;
    _webView.frame = CGRectMake(0, webViewY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - webViewY);
    [_webView.scrollView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
    [self.view insertSubview:_webView atIndex:0];
    
    [_topBar setTranslatesAutoresizingMaskIntoConstraints:false];
    [_webView setTranslatesAutoresizingMaskIntoConstraints:false];


    if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){11,0,0}]){
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.title == nil) {
        
        __weak typeof(self) weakSelf = self;
        [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString * _Nullable response, NSError * _Nullable error) {
            
            if (response != nil && [response isKindOfClass:[NSString class]]) {
                weakSelf.titleLabel.text = response;
            }
        }];
    }
    
    self.progressView.hidden = YES;
    self.progressView.progress = 0.0;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error
{
    _refreshButton.hidden = NO;
    self.progressView.hidden = YES;
    self.progressView.progress = 0.0;
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}


// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    self.progressView.progress = 0.0;
}

#pragma mark WKUIDelegate
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

#pragma mark - observe
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSString *newValue = [change valueForKey:NSKeyValueChangeNewKey];
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.hidden = NO;
        [self.progressView setProgress:[newValue floatValue] animated:YES];
        
    }else{
        
        if ([keyPath isEqualToString:@"canGoBack"]){
            
            _goBackButton.selected = _goBackButton.enabled = _webView.canGoBack;

        }else if ([keyPath isEqualToString:@"canGoForward"]){
            
            _goForwardButton.selected = _goForwardButton.enabled = _webView.canGoForward;
        }
        _bottomBar.hidden = !(_webView.canGoBack || _webView.canGoForward);
    }
}



#pragma mark - Action

- (IBAction)backButtonClicked:(UIButton *)sender {
    
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)goBackButtonClicked:(UIButton *)sender {
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}
- (IBAction)goForwardButtonCliked:(UIButton *)sender {
    
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (IBAction)refreshButtonDidClicked:(UIButton *)sender {
    
    [_webView reload];
    sender.hidden = YES;
}


#pragma mark - Setter

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    _titleLabel.text = title;
}

-(void)setNavBarBackgroundColor:(UIColor *)navBarBackgroundColor
{
    _navBarBackgroundColor = navBarBackgroundColor;
    _topBar.backgroundColor = _navBarBackgroundColor;
}

-(void)setNavBarTintColor:(UIColor *)navBarTintColor
{
    if (navBarTintColor == nil) return;
    
    _navBarTintColor = navBarTintColor;
    _topBar.tintColor = _navBarTintColor;
    
    [_backButton setImage:[_backButton.currentImage imageChangeColor:_navBarTintColor]
                 forState:UIControlStateNormal];
    
    [_refreshButton setImage:[_refreshButton.currentImage imageChangeColor:_navBarTintColor]
                    forState:UIControlStateNormal];
    
}

-(void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressView.progressTintColor = _progressTintColor = progressTintColor;
}

-(void)setNavBarTitleColor:(UIColor *)navBarTitleColor
{
    _titleLabel.textColor = _navBarTitleColor = navBarTitleColor;
}

-(void)setBackImage:(UIImage *)backImage
{
    _backImage = backImage;
    [_backButton setImage:_backImage forState:UIControlStateNormal];
}


#pragma mark - Private
-(void)addObserver
{
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:(NSKeyValueObservingOptionNew)
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"canGoBack"
                      options:(NSKeyValueObservingOptionNew)
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"canGoForward"
                      options:(NSKeyValueObservingOptionNew)
                      context:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//}

-(BOOL)fd_prefersNavigationBarHidden
{
    return true;
}

//移除
-(void)dealloc{
    
    [_progressView removeFromSuperview];
    _progressView = nil;
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    
}

#pragma mark - UIScrollView Gesture
-(void)panAction:(UIPanGestureRecognizer *)sender
{
    CGFloat vH = self.bottomBar.frame.size.height;
    CGFloat contentOffsetY = _webView.scrollView.contentOffset.y;
    CGFloat separateLineY = vH - _webView.scrollView.contentInset.top;
    CGFloat transformTy = self.bottomBar.transform.ty;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            
            _lastContentY = contentOffsetY;
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            // 在顶部区域，值为view 的高度值
            
            CGFloat ty = 0.0;
            if (contentOffsetY <= separateLineY) { // 顶部区域
                
                // 已经在顶部时不需要管
                ty = (transformTy == 0) ? 0 : (contentOffsetY + _webView.scrollView.contentInset.top);
                
            }else{
                
                if (transformTy == vH) {
                    ty = vH;
                }else{
                    ty = transformTy + (contentOffsetY - _lastContentY);
                }
            }
            
            ty = ty > 0  ? ty : 0;
            ty = ty < vH ? ty : vH;
            
            //            self.rootNavBar.transform = CGAffineTransformMakeTranslation(0, -(44 * ty) / vH);
            self.bottomBar.transform = CGAffineTransformMakeTranslation(0, ty);
            _lastContentY = contentOffsetY;
            
            if (@available(iOS 11.0, *)) {
            } else {
                // Fallback on earlier versions
            }
            
        }break;
            
            
        default:{
            
            BOOL show = NO;
            NSTimeInterval duration = 0.2;
            CGFloat velocityY = [sender velocityInView:self.view].y;
            
            if (fabs(velocityY) > 200) { //快速
                
                show = (velocityY > 0);
                duration = (show ? transformTy : (vH - transformTy)) / (fabs(velocityY) * 0.5);
                
            }else{ // 慢速
                
                // 在上面的部分, 或者到了必须要显示的时候
                show = ((transformTy < vH * 0.5) || contentOffsetY <= separateLineY);
            }
            
            if ((show && transformTy != 0) || (show == NO && transformTy != vH)) {
                
                [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    if (show) {
                        
                        self.bottomBar.transform = CGAffineTransformIdentity;
                    }else{
                        
                        self.bottomBar.transform = CGAffineTransformMakeTranslation(0, vH);
                    }
                    
                } completion:nil];
            }
            
        }break;
    }
}

@end
