//
//  IERefreshTableController.h
//  365News
//
//  Created by news365-macpro on 2017/5/29.
//  Copyright © 2017年 Duan. All rights reserved.
//  有下拉刷新和上拉加载控件

#import <UIKit/UIKit.h>

@interface IERefreshTableController : UITableViewController

/*
 下拉获取新数据
 */
-(void)loadNewData;

/*
 上拉加载更多
 */
-(void)loadMoreData;

@end
