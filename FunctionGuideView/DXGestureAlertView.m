//
//  DXGestureAlertView.m
//  365News
//
//  Created by news365-macpro on 2017/1/18.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import "DXGestureAlertView.h"

@interface DXGestureAlertView()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
@implementation DXGestureAlertView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 12;
    self.contentView.layer.shadowOpacity = 0.4;
    self.contentView.layer.shadowOffset = CGSizeMake(2, 4);
    self.contentView.layer.shadowRadius = 4;
    
    self.actionButton.layer.cornerRadius = 22;
    self.actionButton.layer.borderColor = [UIColor redColor].CGColor;
    self.actionButton.layer.borderWidth = 0.6;
}

- (IBAction)buttonClick:(id)sender {
    
    if (_buttonClckHander) {
        _buttonClckHander(self);
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
