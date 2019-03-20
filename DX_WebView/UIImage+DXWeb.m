//
//  UIImage+DXWeb.m
//  internet
//
//  Created by news365-macpro on 2018/6/6.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import "UIImage+DXWeb.h"

@implementation UIImage (DXWeb)

-(UIImage*)imageChangeColor:(UIColor*)color
{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(UIImage *)imageNamed:(NSString *)name changeColor:(UIColor*)color
{
    if (name != nil){
        UIImage *image = [UIImage imageNamed:name];
        if (image != nil) {
            return [image imageChangeColor:color];
        }
    }
    return nil;
}

@end
