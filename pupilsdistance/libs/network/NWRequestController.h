//
//  NWRequestController.h
//  Kurashiki
//
//  Created by ductc on 10/30/13.
//  Copyright (c) 2013 ductc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^DataHandle)(id data);

@interface NWRequestController : NSObject
/** Cancel request
 @author ductc
 */
+(void)cancelRequest:(id)request;

/** MARK: REQUEST WITH PATH
    @author ductc
 */
+(id)getJSONRequestWithPath:(NSString *)path params:(NSDictionary *)param handle:(DataHandle)handler;
+(id)postJSONRequestWithPath:(NSString *)path params:(NSDictionary *)param handle:(DataHandle)handler;


/** send synchronized post request
 */
+(id)postJSONSynchronizedWithPath:(NSString*)path params:(NSDictionary*)params;
+(id)postJSONSynchronizedWithUrl:(NSString *)urlStr params:(NSDictionary *)params files:(NSDictionary*)files;

@end
