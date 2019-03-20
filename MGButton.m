//
//  MGButton.m
//  Solat
//
//  Created by news365-macpro on 2017/8/15.
//  Copyright © 2017年 Low Wai Hong. All rights reserved.
//

#import "MGButton.h"

@implementation MGButton


-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageFrame = self.imageView.frame;
    CGRect labelFrame = self.titleLabel.frame;
    
    labelFrame.origin.x = 0;
    labelFrame.origin.y = (self.frame.size.height - labelFrame.size.height) * 0.5;
    
    imageFrame.origin.x = self.frame.size.width - imageFrame.size.width;
    imageFrame.origin.y = (self.frame.size.height - imageFrame.size.height) * 0.5;
    
    self.titleLabel.frame = labelFrame;
    self.imageView.frame = imageFrame;
}


@end
