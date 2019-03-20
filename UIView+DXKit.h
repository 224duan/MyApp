//
//  UIView+DXKit.h
//  Fujitsu LifeCam
//
//  Created by news365-macpro on 2017/3/20.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DXKit)

@property (nonatomic) CGFloat dx_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat dx_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat dx_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat dx_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat dx_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat dx_height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat dx_centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat dx_centerY;
/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint dx_origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize dx_size;

//找到自己的vc
- (UIViewController *)dx_viewController;

@end
