//
//  UIImage+DXWeb.h
//  internet
//
//  Created by news365-macpro on 2018/6/6.
//  Copyright © 2018年 macpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DXWeb)

-(UIImage*)imageChangeColor:(UIColor*)color;

+(UIImage *)imageNamed:(NSString *)name changeColor:(UIColor*)color;

@end
