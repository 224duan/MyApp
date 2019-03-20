//
//  DXNetworking.m
//  webViewTest
//
//  Created by news365-macpro on 2017/4/26.
//  Copyright © 2017年 Intelligent-earnings. All rights reserved.
//

#import "DXNetworking.h"

@implementation DXNetworking

+(NSURLSessionDataTask *)getRequestPath:(NSString *)path success:(SuccessBlock)success failure:(FailureBlock)failure
{
    return [self requestPath:path dic:nil HTTPMethod:@"GET" success:success failure:failure];
}

+(NSURLSessionDataTask *)postRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure
{
    return [self requestPath:path dic:parameters HTTPMethod:@"POST" success:success failure:failure];
}


+(NSURLSessionDataTask *)requestPath:(NSString *)path dic:(NSDictionary *)parameters HTTPMethod:(NSString *)httpMethod success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = httpMethod;
    if (parameters.count) {
        NSMutableString *args = [NSMutableString string];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if (args.length > 0) {
                [args appendString:@"&"];
            }
            [args appendFormat:@"%@=%@",key,obj];
        }];
        request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            if (success) {
                id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(dataTask,responseObject);
                });
            }
            
        }else{
        
            if (failure) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(dataTask,error);
                });
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

@end
