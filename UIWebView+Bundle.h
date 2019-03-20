//
//  UIWebView+Bundle.h
//  GDLottery
//
//  Created by news365-macpro on 2017/3/15.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Bundle)

-(void)loadHtmlResource:(NSString *)name fromBundle:(NSString *)bundleName;

@end
