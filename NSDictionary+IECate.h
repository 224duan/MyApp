//
//  NSDictionary+IECate.h
//  365News
//
//  Created by news365-macpro on 2017/6/23.
//  Copyright © 2017年 Duan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IECate)

/*
 将另一个 dic 中的所有object 更新到 self 中
 */
-(NSMutableDictionary *)updateEntriesFromDictionary:(NSDictionary *)dicTwo;

@end
