//
//  DXInputView.m
//  TNews
//
//  Created by news365-macpro on 2018/11/2.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import "DXInputView.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"


@interface DXInputView()

@property(nonatomic, strong) CALayer * lineLayer;

@property(nonatomic, strong) UIView     * leadingView;
@property(nonatomic, strong) DXTextView * textView;
@property(nonatomic, strong) UIButton   * sendButton;

@end

@implementation DXInputView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self uiSetup];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self uiSetup];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewContentDidChange)
                                                     name:UITextViewTextDidBeginEditingNotification
                                                   object:_textView];
    }
    return self;
}

-(void)uiSetup
{
    self.backgroundColor = [UIColor whiteColor];
    [self.layer addSublayer:self.lineLayer];
    [self addSubview:self.leadingView];
    [self addSubview:self.textView];
    [self addSubview:self.sendButton];
    
    [_sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.trailing).offset(-8);
        make.bottom.equalTo(self.bottom).offset(-5);
        make.width.equalTo(44);
        make.height.equalTo(38);
    }];
    
    [_leadingView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leading).offset(0);
        make.height.equalTo(0);
        make.width.equalTo(0);
        make.bottom.equalTo(self.textView.bottom);
        make.trailing.equalTo(self.textView.leading).offset(-8);
    }];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {

        make.trailing.equalTo(self.sendButton.leading).offset(-8);
        make.top.equalTo(self.top).offset(5);
        make.centerY.equalTo(self.centerY);
    }];
    
    [_textView addObserver:self
                forKeyPath:@"contentSize"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
}



- (void)textViewContentDidChange {
    
    if (_heightChangedBlock) {
        CGFloat width = _textView.frame.size.width;
        CGFloat height = ceilf([_textView sizeThatFits:CGSizeMake(width, MAXFLOAT)].height) + 10;
        if (self.frame.size.height != height) {
            if (_maxH != 0) {
                height = MIN(_maxH, height);
            }
            __weak typeof(self) weakSelf = self;
            _heightChangedBlock(weakSelf,height);
        }
    }
    _sendButton.enabled = (_textView.text.length > 0);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"] && object == _textView) {
        [self textViewContentDidChange];
    }
}

#pragma mark - Action
-(void)didClickSendButton:(UIButton *)sender
{
    self.accessoryView = nil;
}

#pragma mark - getter / setter

-(UIView *)leadingView
{
    if (_leadingView == nil) {
        _leadingView = [[UIView alloc] init];
    }
    return _leadingView;
}

-(DXTextView *)textView
{
    if (_textView == nil) {
        
        _textView = [[DXTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.scrollsToTop = NO;
        
        _textView.layer.cornerRadius = 18;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        
        __weak typeof(self) weakSelf = self;
        _textView.contentChangedBlock = ^(DXTextView *textView) {
            [weakSelf textViewContentDidChange];
        };
        
        UIEdgeInsets inset = _textView.textContainerInset;
        inset.left += 4;    inset.right += 4;
        _textView.textContainerInset = inset;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//        [_sendButton mg_setHUDColor:mainHeaderGreenColor forState:UIControlStateSelected];
//        [_sendButton mg_setHUDColor:mainHeaderGreenColor forState:UIControlStateNormal];
//        UIImage *image = [UIImage imageNamed:@"Detail_send"];
//        UIImage *normal = [image imageChangeColor:RGB(163, 163, 163)];
//        UIImage *selec = [image imageChangeColor:mainHeaderGreenColor];
//        [_sendButton setImage:selec forState:UIControlStateNormal];
//        [_sendButton setImage:normal forState:UIControlStateDisabled];
//        [_sendButton setImage:selec forState:UIControlStateSelected];

        [_sendButton setTitle:@"send" forState:UIControlStateNormal];
        _sendButton.enabled = NO;
        [_sendButton addTarget:self action:@selector(didClickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

-(CALayer *)lineLayer
{
    if (_lineLayer == nil) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    }
    return _lineLayer;
}

-(void)setAccessoryView:(UIView *)accessoryView
{
    if (_accessoryView != nil) {
        [_accessoryView removeFromSuperview];
    }
    _accessoryView = accessoryView;
    
    CGFloat leading = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (accessoryView != nil) {
        leading = 8;
        width = _accessoryView.frame.size.width;
        height = _accessoryView.frame.size.height;
        [_leadingView addSubview:_accessoryView];
    }
    
    [_leadingView updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leading).offset(leading);
        make.height.equalTo(height);
        make.width.equalTo(width);
    }];
}


-(CGFloat)recommendHeight
{
    return ceil(_textView.font.lineHeight + _textView.textContainerInset.top + _textView.textContainerInset.bottom) + 10;
}


#pragma mark - Private
-(void)layoutSubviews
{
    [super layoutSubviews];
    _lineLayer.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    if (_maxH != 0) {
        _textView.scrollEnabled = (self.frame.size.height >= _maxH);
    }
}

-(void)dealloc
{
    [_textView removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
