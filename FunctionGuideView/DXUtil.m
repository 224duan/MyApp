//
//  DXUtil.m
//  365News
//
//  Created by news365-macpro on 2017/1/18.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import "DXUtil.h"

@implementation DXUtil

+(CGFloat)angleBetweenLinesWithLine1Start:(CGPoint)line1Start line1End:(CGPoint)line1End line2Start:(CGPoint)line2Start line2End:(CGPoint)line2End
{
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    return rads;
}


@end
