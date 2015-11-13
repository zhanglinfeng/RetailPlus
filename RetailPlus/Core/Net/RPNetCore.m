//
//  RPNetCore.m
//  RetailPlus
//
//  Created by lin dong on 13-8-12.
//  Copyright (c) 2013年 lin dong. All rights reserved.
//

#import "RPNetCore.h"
#import "AFXMLRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "RPError.h"
#import "RPBLogic.h"

@implementation RPNetCore

/*    NSURLResponse *theResponse;
 NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://124.207.254.165:8095/ccpsxp_new/rest/demo_tel/tel_demo"]];
 [theRequest setHTTPMethod:@"POST"];
 
 NSString * strBody = @"{\"userTel\":\"18930909273\",\"myTel\":\"15221531215\"}";
 
 [theRequest setHTTPBody:[strBody dataUsingEncoding:NSASCIIStringEncoding]];
 [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [theRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
 NSError *error;
 NSData * data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&error];*/

+(void)doRequestBySimple:(NSString *)strMethod withHead:(NSDictionary *)dictHead withBody:(NSArray *)arrayBody success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (!strMethod || !dictHead)
    {
        failedBlock(RPNetTaskError_InputParam,@"param error!");
        return;
    }
    
    NSString * strUrl = [NSString stringWithFormat:@"%@/%@",[RPBLogic defaultInstance].strApiBaseUrl,strMethod];
    
    for (NSString * str in arrayBody) {
        strUrl = [strUrl stringByAppendingString:@"/"];
        strUrl = [strUrl stringByAppendingString:str];
    }
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:API_TIMEOUTINTERVAL];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    if (dictHead)
    {
        for (NSString * strKey in [dictHead allKeys]) {
            NSString * strHead = [dictHead objectForKey:strKey];
            NSString * strUtf8String = [NSString stringWithCString:[strHead UTF8String] encoding:NSUTF8StringEncoding];
            
            [request addValue:strUtf8String forHTTPHeaderField:strKey];
        }
    }
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary * dict) {
            NSInteger nRetCode = ((NSNumber *)[dict objectForKey:@"ReturnCode"]).intValue;
            if (nRetCode == 0) {
                successBlock([dict objectForKey:@"data"]);
            }
            else
            {
                failedBlock(((NSNumber *)[dict objectForKey:@"ReturnCode"]).intValue,[dict objectForKey:@"ReturnDesc"]);
            }
                
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                failedBlock(RPNetTasKError_Request,@"Request data error!");
        }];
    
    [operation start];
}

+(void)doRequest:(NSString *)strMethod withHead:(NSDictionary *)dictHead withBodyString:(NSString *)strBody success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (!strMethod || !dictHead)
    {
        failedBlock(RPNetTaskError_InputParam,@"param error!");
        return;
    }
    
    NSString * strUrl = nil;
    if (strMethod == nil) {
        strUrl = [RPBLogic defaultInstance].strApiBaseUrl;
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@/%@",[RPBLogic defaultInstance].strApiBaseUrl,strMethod];
    }
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:API_TIMEOUTINTERVAL];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"json" forHTTPHeaderField:@"Data-Type"];
    
    if (strBody)
    {
        [request setHTTPBody:[strBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:[NSString stringWithFormat:@"%d",strBody.length] forHTTPHeaderField:@"Content-Length"];
    }
    
    if (dictHead)
    {
        for (NSString * strKey in [dictHead allKeys]) {
            NSString * strHead = [dictHead objectForKey:strKey];
            NSString * strUtf8String = [NSString stringWithCString:[strHead UTF8String] encoding:NSUTF8StringEncoding];
            
            [request addValue:strUtf8String forHTTPHeaderField:strKey];
        }
    }
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary * dict) {
        NSInteger nRetCode = ((NSNumber *)[dict objectForKey:@"Colleague"]).intValue;
        if (nRetCode == 0) {
            successBlock([dict objectForKey:@"data"]);
        }
        else
        {
            failedBlock(((NSNumber *)[dict objectForKey:@"ReturnCode"]).intValue,[dict objectForKey:@"ReturnDesc"]);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failedBlock(RPNetTasKError_Request,@"Request data error!");
    }];
    
    [operation start];
}

+(void)doRequest:(NSString *)strMethod withHead:(NSDictionary *)dictHead withBody:(NSDictionary *)dictBody success:(RPRuntimeSuccess)successBlock failed:(RPRuntimeFailed)failedBlock
{
    if (!strMethod || !dictHead)
    {
        failedBlock(RPNetTaskError_InputParam,@"param error!");
        return;
    }
    
    NSString * strUrl = nil;
    if (strMethod == nil) {
        strUrl = [RPBLogic defaultInstance].strApiBaseUrl;
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@/%@",[RPBLogic defaultInstance].strApiBaseUrl,strMethod];
    }
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:API_TIMEOUTINTERVAL];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"json" forHTTPHeaderField:@"Data-Type"];
    
    if (dictBody)
    {
        NSError *error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictBody options:NSJSONWritingPrettyPrinted error:&error];
        NSString * strBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [request setHTTPBody:[strBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:[NSString stringWithFormat:@"%d",strBody.length] forHTTPHeaderField:@"Content-Length"];
    }
    
    if (dictHead)
    {
        for (NSString * strKey in [dictHead allKeys]) {
            NSString * strHead = [dictHead objectForKey:strKey];
            NSString * strUtf8String = [NSString stringWithCString:[strHead UTF8String] encoding:NSUTF8StringEncoding];
            
            [request addValue:strUtf8String forHTTPHeaderField:strKey];
        }
    }
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary * dict) {
        NSInteger nRetCode = ((NSNumber *)[dict objectForKey:@"ReturnCode"]).intValue;
        if (nRetCode == 0) {
            successBlock([dict objectForKey:@"data"]);
        }
        else
        {
            failedBlock(((NSNumber *)[dict objectForKey:@"ReturnCode"]).intValue,[dict objectForKey:@"ReturnDesc"]);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failedBlock(RPNetTasKError_Request,@"Request data error!");
    }];
                                         
    [operation start];
}
@end
