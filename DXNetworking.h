//
//  DXNetworking.h
//  webViewTest
//
//  Created by news365-macpro on 2017/4/26.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^SuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface DXNetworking : NSObject

+(NSURLSessionDataTask *)getRequestPath:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure;

+(NSURLSessionDataTask *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure;

@end
