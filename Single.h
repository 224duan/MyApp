//
//  Single.h
//  HardestGgame
//
//  Created by Duan on 15/8/25.
//  Copyright (c) 2015年 Duan. All rights reserved.
//  单例

#ifndef HardestGgame_Single_h
#define HardestGgame_Single_h

//@interface
#define single_interface(className)  +(className *)share##className;

//@implementation
#define single_implementation(className) \
static className *_instance;    \
+(instancetype)allocWithZone:(struct _NSZone *)zone \
{   \
    static dispatch_once_t onceToken;   \
    dispatch_once(&onceToken, ^{    \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance;   \
}   \
+(className *) share##className   \
{   \
    static dispatch_once_t onceToken;   \
    dispatch_once(&onceToken, ^{    \
        _instance = [[super alloc] init];   \
    }); \
    return _instance;   \
}

#endif
