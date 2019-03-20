//
//  DXUtil.h
//  365News
//
//  Created by news365-macpro on 2017/1/18.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXUtil : NSObject

/**
 获取两条线之间的角度
 */
+(CGFloat)angleBetweenLinesWithLine1Start:(CGPoint)line1Start line1End:(CGPoint)line1End line2Start:(CGPoint)line2Start line2End:(CGPoint)line2End;

@end
