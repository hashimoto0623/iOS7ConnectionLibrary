//
//  LPSHHTTPConnectionSyncManager.h
//  LiteraPad
//
//  Created by hashimoto0623 on 2013/11/07.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHHTTPConnectionChainQueue.h"

@interface SHHTTPConnectionChainManager : NSObject

+ (SHHTTPConnectionChainManager*)sharedSHHTTPConnectionChainManager;

- (void)addQueueWithUrl:(NSString*)urlString
                  owner:(id)owner
           getArguments:(NSDictionary*)gets
          postArguments:(NSDictionary*)posts
        successObserver:(id)successObserver
          errorObserver:(id)errorObserver
              onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
                onError:(void (^)(NSError *error))errorBlock;


- (void)executeQueueWithUrl:(NSString*)urlString
                      owner:(id)owner
               getArguments:(NSDictionary*)gets
              postArguments:(NSDictionary*)posts
            successObserver:(id)successObserver
              errorObserver:(id)errorObserver
                  onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
                    onError:(void (^)(NSError *error))errorBlock;

@end
