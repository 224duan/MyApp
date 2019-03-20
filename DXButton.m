//
//  DXButton.m
//  365News
//
//  Created by news365-macpro on 2017/2/25.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import "DXButton.h"

@implementation DXButton

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 8;
    CGFloat imageH = self.imageView.frame.size.height;
    CGFloat labelH = self.titleLabel.frame.size.height;
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    // image
    CGPoint imageCenter = center;
    imageCenter.y -= (labelH + margin) * 0.5;
    self.imageView.center = imageCenter;
    
    //text
    CGPoint labelCenter = center;
    labelCenter.y += (imageH + margin) * 0.5;
    self.titleLabel.center = labelCenter;
    self.titleLabel.bounds = CGRectMake(0, 0, self.frame.size.width, self.titleLabel.frame.size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
