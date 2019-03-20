//
//  NSDictionary+IECate.m
//  365News
//
//  Created by news365-macpro on 2017/6/23.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import "NSDictionary+IECate.h"

@implementation NSDictionary (IECate)

-(NSMutableDictionary *)updateEntriesFromDictionary:(NSDictionary *)dicTwo
{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    
    __weak typeof(self) weakSelf = self;
    [dicTwo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            if ([[self objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *subDic = [[weakSelf objectForKey:key] updateEntriesFromDictionary:obj];
                [newDic setObject:subDic forKey:key];
            }
        }
    }];
    NSMutableDictionary *lastDic = [NSMutableDictionary dictionaryWithDictionary:self];
    [lastDic addEntriesFromDictionary:dicTwo];
    [lastDic addEntriesFromDictionary:newDic];
    return lastDic;

}

@end
