//
//  UIWebView+Bundle.m
//  GDLottery
//
//  Created by news365-macpro on 2017/3/15.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import "UIWebView+Bundle.h"

@implementation UIWebView (Bundle)

-(void)loadHtmlResource:(NSString *)name fromBundle:(NSString *)bundleName
{
    NSString *htmlBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSBundle *htmlBundle = [NSBundle bundleWithPath:htmlBundlePath];
    NSURL *url = [NSURL fileURLWithPath:htmlBundlePath];
    
    NSString *htmlPath = [htmlBundle pathForResource:name ofType:@"html"];
    NSError *error = nil;
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error];
    [self loadHTMLString:html baseURL:url];
}

@end
