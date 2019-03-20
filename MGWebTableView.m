//
//  MGWebTableView.m
//  TNews
//
//  Created by news365-macpro on 2018/7/16.
//  Copyright © 2018年 Intelligent-earnings. All rights reserved.
//

#import "MGWebTableView.h"
#import "UIView+MGKit.h"

@interface MGWebTableView()
{
    CGFloat _lastWebViewContentHeight;
    CGFloat _lastTableViewContentHeight;
    
    CGFloat _lastHeaderViewHeight;
    CGFloat _lastCenterViewHeight;
    CGFloat _lastFooterViewHeight;
}

@property(nonatomic, strong) UIView * contentView;

@end

@implementation MGWebTableView

-(instancetype)initWithWebView:(WKWebView *)webView tableView:(UITableView *)tableView frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _webViewMinHeight = _tableViewMinHeight = 0.1;
        
        _webView = webView;
        _tableView = tableView;
        
        _webView.autoresizingMask = UIViewAutoresizingNone;
        _tableView.autoresizingMask = UIViewAutoresizingNone;
        
        _tableView.scrollEnabled = NO;
        _webView.scrollView.scrollEnabled = NO;
        
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addObservers];
        
        [self.contentView addSubview:_webView];
        [self.contentView addSubview:_tableView];
        [self addSubview:self.contentView];
        
        
        [self updateContentSize:YES];
    }
    return self;
}

-(void)setWebViewMinHeight:(CGFloat)webViewMinHeight
{
    _webViewMinHeight = webViewMinHeight;
    [self updateContentSize:YES];
}

-(void)setTableViewMinHeight:(CGFloat)tableViewMinHeight
{
    _tableViewMinHeight = tableViewMinHeight;
    [self updateContentSize:YES];
}

-(void)setHeaderView:(UIView *)headerView
{
    if (_headerView != headerView) {
        if (_headerView != nil) {
            [_headerView removeFromSuperview];
        }
        if (headerView != nil) {
            [self.contentView addSubview:headerView];
        }
    }
    _headerView = headerView;
    [self updateContentSize:YES];
}

-(void)setCenterView:(UIView *)centerView
{
    if (_centerView != centerView) {
        if (_centerView != nil) {
            [_centerView removeFromSuperview];
        }
        if (centerView != nil) {
            [self.contentView addSubview:centerView];
        }
    }
    _centerView = centerView;
    [self updateContentSize:YES];
}


-(void)setFooterView:(UIView *)footerView
{
    if (_footerView != footerView) {
        if (_footerView != nil) {
            [_footerView removeFromSuperview];
        }
        if (footerView != nil) {
            [self.contentView addSubview:footerView];
        }
    }
    _footerView = footerView;
    [self updateContentSize:YES];
}


// 监听值的变化，追加
#pragma mark - Observers
- (void)addObservers{
    
    [_webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers{
    
    [_webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == _webView) {
        if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
            [self updateContentSize:NO];
        }
    }else if(object == _tableView) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self updateContentSize:NO];
        }
    }
}

// 更新content size
- (void)updateContentSize:(BOOL)must{
    
    CGFloat webViewContentHeight   = _webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = _tableView.contentSize.height;
    CGFloat headerViewHeight = _headerView.frame.size.height;
    CGFloat centerViewHeight = _centerView.frame.size.height;
    CGFloat footerViewHeight = _footerView.frame.size.height;
    
    
    if (must == NO &&
        tableViewContentHeight == _lastTableViewContentHeight  &&
        webViewContentHeight   == _lastWebViewContentHeight    &&
        headerViewHeight    == _lastHeaderViewHeight &&
        footerViewHeight    == _lastFooterViewHeight &&
        centerViewHeight    == _lastCenterViewHeight
        ) {return;}
    
    _lastWebViewContentHeight    = webViewContentHeight;
    _lastTableViewContentHeight  = tableViewContentHeight;
    _lastHeaderViewHeight        = headerViewHeight;
    _lastFooterViewHeight        = footerViewHeight;
    _lastCenterViewHeight        = centerViewHeight;
    
    CGSize size = self.frame.size;
    
    CGFloat webViewHeight = MIN(webViewContentHeight, size.height);
    CGFloat tableViewHeight = MIN(tableViewContentHeight, size.height);
    
    
    
    webViewHeight   = MAX(webViewHeight, _webViewMinHeight);
    tableViewHeight = MAX(tableViewHeight, _tableViewMinHeight);
    
    webViewContentHeight = MAX(webViewContentHeight, webViewHeight);
    tableViewContentHeight = MAX(tableViewContentHeight, tableViewHeight);
    
    _headerView.frame = CGRectMake(0, 0, size.width, headerViewHeight);
    _webView.frame    = CGRectMake(0, 0 + headerViewHeight, size.width, webViewHeight);
    _centerView.frame = CGRectMake(0, CGRectGetMaxY(_webView.frame), size.width, centerViewHeight);
    _tableView.frame  = CGRectMake(0, CGRectGetMaxY(_webView.frame) + centerViewHeight, size.width, tableViewHeight);
    _footerView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), size.width, footerViewHeight);
    
    CGFloat contentViewHeight = CGRectGetMaxY(_tableView.frame) + footerViewHeight;
    _contentView.bounds = CGRectMake(0, 0, size.width, contentViewHeight);
    
    CGFloat contentSizeHeight = webViewContentHeight + tableViewContentHeight + headerViewHeight + footerViewHeight + centerViewHeight;
    self.contentSize = CGSizeMake(size.width,contentSizeHeight);
    
    //    NSLog(@"content:%f tableViewHeight %f",tableViewHeight,_tableView.frame.size.height);
    
}


#pragma mark - Setter
-(void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    /*
     需要处理的位置
     修改两个值 contentView 的 height
     可滚动试图的 contentOffsetY
     */
    
    if (_tableView == nil || _webView == nil) return;
    
    CGFloat offsetY = self.contentOffset.y;
    
    CGFloat headerHeight = _headerView.frame.size.height;
    CGFloat webViewHeight = _webView.frame.size.height;
    CGFloat centerViewHeight = _centerView.frame.size.height;
    CGFloat tableViewHeight = _tableView.frame.size.height;
    
    CGFloat webViewContentHeight = self.webView.scrollView.contentSize.height;
    CGFloat tableViewContentHeight = MAX(self.tableView.contentSize.height, tableViewHeight);
    
    if (offsetY <= headerHeight) {
        
        [self setContentViewTop:0];
        _webView.scrollView.contentOffset = CGPointZero;
        _tableView.contentOffset = CGPointZero;
        
    }else if(offsetY < headerHeight + webViewContentHeight - webViewHeight){
        
        [self setContentViewTop:(offsetY - headerHeight)];
        _webView.scrollView.contentOffset = CGPointMake(0, offsetY - headerHeight);
        
        
    }else if(offsetY < headerHeight + webViewContentHeight + centerViewHeight){
        
        [self setContentViewTop:(webViewContentHeight - webViewHeight)];
        _tableView.contentOffset = CGPointZero;
        _webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        
    }else if(offsetY < headerHeight + webViewContentHeight + centerViewHeight + tableViewContentHeight - tableViewHeight){
        
        [self setContentViewTop:(offsetY - headerHeight - webViewHeight - centerViewHeight)];
        _tableView.contentOffset = CGPointMake(0, offsetY - headerHeight - webViewContentHeight - centerViewHeight);
        _webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        
    }else{
        
        _webView.scrollView.contentOffset = CGPointMake(0, webViewContentHeight - webViewHeight);
        _tableView.contentOffset = CGPointMake(0, tableViewContentHeight - tableViewHeight);
        [self setContentViewTop:(self.contentSize.height - self.contentView.frame.size.height)];
    }
    
    //  if(offsetY <= headerHeight + webViewContentHeight + centerViewHeight + tableViewContentHeight + footerHeight)
}

-(void)setContentViewTop:(CGFloat)top
{
    CGRect frame = self.contentView.frame;
    frame.origin.y = top;
    self.contentView.frame = frame;
}

-(void)scrollView:(UIView *)view toOffsetY:(CGFloat)y animated:(BOOL)animated
{
    if (view == nil || y < 0) return;
    
    CGFloat offsetY = -1;
    if (view == _webView) {
        
        y = MIN(y, _webView.scrollView.contentSize.height - _webView.mg_height);
        offsetY = _headerView.mg_height + y;
        
    }else if (view == _tableView){
        y = MIN(y, _tableView.contentSize.height - _tableView.mg_height);
        offsetY = _headerView.mg_height + _webView.scrollView.contentSize.height + _centerView.mg_height +y;
        
    }else{
        
        y = MIN(y, view.mg_height);
        if (view == _headerView) {
            
            offsetY = y;
            
        }else if (view == _centerView){
            
            offsetY = _headerView.mg_height + _webView.scrollView.contentSize.height +y;
            
        }else if (view == _footerView){
            offsetY = self.contentSize.height - (view.mg_height - offsetY);
        }
    }
    
    if (offsetY != -1) {
        
        offsetY = MIN(offsetY, self.contentSize.height - self.mg_height);
        [self setContentOffset:CGPointMake(0, offsetY) animated:animated];
        
    }
}


#pragma mark - Private
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

-(void)dealloc
{
    [self removeObservers];
}

@end
