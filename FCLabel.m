//
//  FCLabel.m
//  Fujitsu LifeCam
//
//  Created by news365-macpro on 2017/3/27.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import "FCLabel.h"

@implementation FCLabel
@synthesize insets=_insets;

-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
