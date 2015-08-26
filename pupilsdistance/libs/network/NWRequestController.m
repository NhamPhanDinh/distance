//
//  NWRequestController.m
//  Kurashiki
//
//  Created by ductc on 10/30/13.
//  Copyright (c) 2013 ductc. All rights reserved.
//

#import "NWRequestController.h"
#import "JSONKit.h"

#define K_TIME_OUT 60

#define NWLOG(...) NSLog(__VA_ARGS__)
@implementation NWRequestController
/** This function make get request with url and params
    @author ductc
 */
+(id)getRequest:(NSString*)url params:(NSDictionary*)params isJson:(BOOL)isJsonResponse isSynchronize:(BOOL)isSycn handle:(DataHandle)handler
{
    NSLog(@"GET %@, param %@", url, [params JSONString]);
    NSString* paramStr = @"";
	
	if (params) {
        NSMutableArray *arrObj = [NSMutableArray array];
        for (NSString *key in params) {
            NSString *val = [params[key] description];
            [arrObj addObject:[NSString stringWithFormat:@"%@=%@",key,[self encodeURL:val]]];
        }
        paramStr = [arrObj componentsJoinedByString:@"&"];
	}
	if (paramStr.length > 0) {
        url = [url stringByAppendingFormat:@"?%@", paramStr];
    }
    NSLog(@"Full URL %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
    request.timeoutInterval = K_TIME_OUT;
	
	[request setHTTPMethod:@"GET"];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    DataHandle handleData = ^(id responseObject){
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Response = %@", responseObject);
        
        if (isJsonResponse) {
            responseObject = [(NSString *)responseObject objectFromJSONString];
        }
        handler(responseObject);
    };
    
    if (!isSycn) {
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleData(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NWLOG(@"Error network %@", error);
            handler(nil);
        }];
        [operation start];
    }else{
        [operation start];
        [operation waitUntilFinished];
        if (operation.error) {
            NWLOG(@"Error network %@", operation.error);
            handler(nil);
        }else{
            id responseObject = operation.responseData;
            handleData(responseObject);
        }
        
    }
    return operation;
}

+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
	if (newString) {
		return newString;
	}
	return @"";
}


/** This function make post request with url and params
    @author ductc
 */
+(id)postRequest:(NSString*)url params:(NSDictionary*)params isJson:(BOOL)isJsonResponse sync:(BOOL)isSycn handle:(DataHandle)handler
{
    NSLog(@"POST %@, param %@", url, [params JSONString]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
    request.timeoutInterval = 60;
	
	[request setHTTPMethod:@"POST"];
	
	NSString* paramStr = @"";
	
	if (params) {
        for (NSString *key in params) {
            NSString *val = [params[key] description];
            val = [self encodeURL:val];
            paramStr = [NSString stringWithFormat:@"%@&%@=%@",paramStr,key,val];
        }
	}
	NSLog(@"paramStr -= %@", paramStr);
	if (paramStr.length > 0) {
		NSData* requestData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
		NSString* requestDataLengthString = [NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]];
		[request setHTTPBody: requestData];
		[request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
	}
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    DataHandle handleData = ^(id responseObject){
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Response = %@", responseObject);
        
        if (isJsonResponse) {
            responseObject = [(NSString *)responseObject objectFromJSONString];
        }
        handler(responseObject);
    };
    
    if (!isSycn) {
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            handleData(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NWLOG(@"Error network %@", error);
            handler(nil);
        }];
        [operation start];
    }else{
        [operation start];
        [operation waitUntilFinished];
        if (operation.error) {
            NWLOG(@"Error network %@", operation.error);
            handler(nil);
        }else{
            id responseObject = operation.responseData;
            handleData(responseObject);
        }
        
    }
    return operation;
}

/** Cancel request
    @author ductc
 */
+(void)cancelRequest:(id)request
{
    if (![request isKindOfClass:[AFHTTPRequestOperation class]]) {
        NWLOG(@"Error request is not %@", [AFHTTPRequestOperation class]);
        return;
    }
    [(AFHTTPRequestOperation*)request cancel];
}

+(id)getJSONRequestWithPath:(NSString *)path params:(NSDictionary *)param handle:(DataHandle)handler
{
    return [self getRequest:path  params:param isJson:YES isSynchronize:NO handle:handler];
}

+(id)postJSONRequestWithPath:(NSString *)path params:(NSDictionary *)param handle:(DataHandle)handler
{
    return [self postRequest:path params:param isJson:YES sync:NO handle:handler];
}
+(id)postJSONSynchronizedWithPath:(NSString*)path params:(NSDictionary*)params
{
    __block id resdata = nil;
    [self postRequest:path params:params isJson:YES sync:YES handle:^(id data) {
        resdata = data;
    }];
    return resdata;
}
+(id)postJSONSynchronizedWithUrl:(NSString *)urlStr params:(NSDictionary *)params files:(NSDictionary*)files{
    NSLog(@"send post %@, params %@, file count %lu", urlStr, params,(unsigned long)files.count);
    
    NSURL *url = [NSURL URLWithString:urlStr];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    __block BOOL success = NO;
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString *key in files) {
            id value = [files objectForKey:key];
            
            NSError *err = NULL;
            
            if ([value isKindOfClass:[NSURL class]]) {
                [formData appendPartWithFileURL:value name:key error:&err];
            }else if ([value isKindOfClass:[NSString class]]){
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:value] name:key error:&err];
            }else if ([value isKindOfClass:[NSData class]]){
                [formData appendPartWithFileData:value name:key fileName:@"image.jpg" mimeType:@"image/jpeg"];
            }else{
                NSLog(@"file data error");
                success = NO;
                return;
            }
            if (err) {
                NSLog(@"Error when append file %@", err);
                success = NO;
            }else{
                success = YES;
            }
        }
    }];
    if (!success) {
        return nil;
    }
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation start];
    [operation waitUntilFinished];
    if (operation.error) {
        NWLOG(@"Error network %@", operation.error);
        return nil;
    }else{
        id responseObject = operation.responseData;
//        return responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Response = %@", responseObject);
        
        id response = [(NSString *)responseObject objectFromJSONString];
        return response;
    }
}
@end
