//
//  UIImage+Cate.h
//  365News
//
//  Created by news365-macpro on 2017/1/18.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DXCate)

+ (UIImage *)dx_imageInKit:(NSString *)imageName;

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

@end
