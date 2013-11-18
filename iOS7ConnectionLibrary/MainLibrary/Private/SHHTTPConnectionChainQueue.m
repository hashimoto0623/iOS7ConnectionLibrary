//
//  LPSHHTTPConnectionChainQueue.m
//  LiteraPad
//
//  Created by hashimoto0623 on 2013/11/07.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import "SHHTTPConnectionChainQueue.h"

@implementation SHHTTPConnectionChainQueue


+ (SHHTTPConnectionChainQueue*)queueWithUrl:(NSString*)urlString
                                    queueId:(int)queueId
                                      owner:(id)owner
                               getArguments:(NSDictionary*)gets
                              postArguments:(NSDictionary*)posts
                            successObserver:(id)successObserver
                              errorObserver:(id)errorObserver
                                  onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
                                    onError:(void (^)(NSError *error))errorBlock{
    
    
    return [[SHHTTPConnectionChainQueue alloc] initWithUrl:urlString
                                                   queueId:queueId
                                                     owner:owner
                                              getArguments:gets
                                             postArguments:posts
                                           successObserver:successObserver
                                             errorObserver:errorObserver
                                                 onSuccess:successBlock
                                                   onError:errorBlock
            ];
}



- (id)initWithUrl:(NSString*)urlString
          queueId:(int)queueId
            owner:(id)owner
       getArguments:(NSDictionary*)gets
    postArguments:(NSDictionary*)posts
  successObserver:(id)successObserver
    errorObserver:(id)errorObserver
          onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
            onError:(void (^)(NSError *error))errorBlock{
    
    self = [super init];
    if (self) {
        _urlString = urlString;
        _owner = owner;
        _queueId = queueId;
        _getArgs = gets;
        _postArgs = posts;
        _successObserver = successObserver;
        _errorObserver = errorObserver;
        _successBlock = successBlock;
        _errorBlock = errorBlock;
    }
    return self;
}



@end
