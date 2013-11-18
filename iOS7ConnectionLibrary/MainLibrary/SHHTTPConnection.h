//
//  SHHTTPConnection.h
//  MyanmmerApp
//
//  Created by hashimoto0623 on 2013/11/18.
//  Copyright (c) 2013年 Brick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHHTTPObserverConfigurations.h"

@interface SHHTTPConnection : NSObject

+ (void)addRequestWithUrl:(NSString*)urlString
                    owner:(id)owner
             getArguments:(NSDictionary*)gets
            postArguments:(NSDictionary*)posts
                onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
                  onError:(void (^)(NSError *error))errorBlock;


+ (void)requestWithUrl:(NSString*)urlString
                 owner:(id)owner
             getArguments:(NSDictionary*)gets
            postArguments:(NSDictionary*)posts
                onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
                  onError:(void (^)(NSError *error))errorBlock;

@end
