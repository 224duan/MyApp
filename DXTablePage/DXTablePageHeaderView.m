//
//  DXTablePageHeaderView.m
//  TNews
//
//  Created by news365-macpro on 2018/10/19.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import "DXTablePageHeaderView.h"

@implementation DXTablePageHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectIndex = 0;
}


-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = MIN(MAX(selectIndex, 0), 1);
    
    UIButton *selectButton = nil;
    if (_selectIndex == 0) {
        _leftButton.selected = YES;
        _rightButton.selected = NO;
        selectButton = _leftButton;
    }else{
        _leftButton.selected = YES;
        _rightButton.selected = NO;
        selectButton = _rightButton;
    }
    
    CGRect frame = _lineView.frame;
    frame.origin.x = selectButton.frame.origin.x;
    frame.size.width = selectButton.frame.size.width;
    
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.frame = frame;
    }];
}

- (IBAction)didClickButton:(UIButton *)sender {
    
    if (sender == _leftButton) {
        self.selectIndex = 0;
    }else{
        self.selectIndex = 1;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickItemInTablePageHeaderView:)]) {
        [_delegate didClickItemInTablePageHeaderView:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = _lineView.frame;
    frame.size.width = self.frame.size.width * 0.5;
    _lineView.frame = frame;
}

@end
