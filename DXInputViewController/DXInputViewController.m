//
//  DXInputViewController.m
//  TNews
//
//  Created by news365-macpro on 2018/11/7.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import "DXInputViewController.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface DXInputViewController ()

@property(nonatomic, strong) DXInputView * inputView;

@end

@implementation DXInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _uiSetup];
    
    //监听键盘出现、消失
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewTextDidEndEditingNotification)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:_inputView.textView];
}

-(void)_uiSetup
{
    _inputView = [[DXInputView alloc] init];
    [self.view addSubview:_inputView];
    
    CGFloat height = _inputView.recommendHeight;
    [_inputView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.leading);
        make.trailing.equalTo(self.view.trailing);
        make.height.equalTo(height);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.safeAreaLayoutGuideBottom).offset(-_inputViewBottomMargin);
        }else{
            make.bottom.equalTo(self.view.bottom).offset(-_inputViewBottomMargin);
        }
    }];
    
    __weak typeof(self) weakSelf = self;
    _inputView.heightChangedBlock = ^(DXInputView *inputView, CGFloat height) {
        [weakSelf updateInputViewViewHeight:height];
    };
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (_inputView.textView.isFirstResponder) {
        CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat constant = endFrame.size.height;
        if (@available(iOS 11.0, *)) {
            constant -= self.view.safeAreaInsets.bottom;
        }
        [self updateInputViewBottomConstant:(-constant)];
        __weak typeof(self) weakSelf = self;
        [self keyboardNotifi:notification animations:^{
            [weakSelf.view layoutIfNeeded];
        } completion:nil];
    }
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self updateInputViewBottomConstant:-_inputViewBottomMargin];
    __weak typeof(self) weakSelf = self;
    [self keyboardNotifi:notification animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

-(void)textViewTextDidEndEditingNotification
{
    [self updateInputViewViewHeight:_inputView.recommendHeight];
}

#pragma mark - Tool
-(void)keyboardNotifi:(NSNotification *)notification animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0 options:options animations:animations completion:completion];
}

-(void)updateInputViewBottomConstant:(CGFloat)constant
{
    [_inputView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.safeAreaLayoutGuideBottom).offset(constant);
        }else{
            make.bottom.equalTo(self.view.bottom).offset(constant);
        }
    }];
}

-(void)updateInputViewViewHeight:(CGFloat)height
{
    [_inputView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_inputView.textView resignFirstResponder];
}


#pragma mark - setter / getter
-(void)setInputViewBottomMargin:(CGFloat)inputViewBottomMargin
{
    _inputViewBottomMargin = inputViewBottomMargin;
    if (_inputView.superview != nil && !_inputView.textView.isFirstResponder) {
        [self updateInputViewBottomConstant:-inputViewBottomMargin];
    }
}

#pragma mark - Private
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (_inputView != nil) {
        [self.view bringSubviewToFront:_inputView];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:_inputView.textView];
}
@end
