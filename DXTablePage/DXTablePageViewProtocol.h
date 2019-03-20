//
//  DXTablePageViewProtocol.h
//  TNews
//
//  Created by news365-macpro on 2018/10/19.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DXTablePageViewProtocol <NSObject>

/* 通过穿透手势来控制多个 scroll 直接的滚动
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
 {
     return ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] ||
            [gestureRecognizer isKindOfClass:UIPinchGestureRecognizer.class]);
 }
 */

-(UIScrollView<UIGestureRecognizerDelegate> *)currentScrollView;

@end

