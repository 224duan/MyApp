//
//  HHTableViewController.h
//  TNews
//
//  Created by news365-macpro on 2018/10/18.
//  Copyright © 2018 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXTablePageViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface DXTablePageViewController : UITableViewController

-(DXTablePageViewController *)initWithTitles:(NSArray<NSString *> *)titles viewControllers:(NSArray<UIViewController<DXTablePageViewProtocol> *> *)viewControllers contentH:(CGFloat)contentH;

@end

NS_ASSUME_NONNULL_END
