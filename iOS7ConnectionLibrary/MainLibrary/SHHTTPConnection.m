//
//  SHHTTPConnection.m
//  MyanmmerApp
//
//  Created by hashimoto0623 on 2013/11/18.
//  Copyright (c) 2013年 Brick. All rights reserved.
//

#import "SHHTTPConnection.h"
#import "SHHTTPConnectionSync.h"
#import "SHHTTPConnectionChainManager.h"

@implementation SHHTTPConnection



/**
 キューに追加する
 */
+ (void)addRequestWithUrl:(NSString*)urlString
                    owner:(id)owner
          getArguments:(NSDictionary*)gets
         postArguments:(NSDictionary*)posts
             onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
               onError:(void (^)(NSError *error))errorBlock{
    
    //  managerにqueueを登録する
    [[SHHTTPConnectionChainManager sharedSHHTTPConnectionChainManager] addQueueWithUrl:urlString
                                                                                 owner:owner
                                                                                 getArguments:gets
                                                                                 postArguments:posts
                                                                                 successObserver:HTTPOBSERVER_SUCCESS
                                                                                 errorObserver:HTTPOBSERVER_ERROR
                                                                                 onSuccess:successBlock
                                                                                 onError:errorBlock
                                                                                 ];
}


/**
 その場で実行
 */
+ (void)requestWithUrl:(NSString*)urlString
                 owner:(id)owner
          getArguments:(NSDictionary*)gets
         postArguments:(NSDictionary*)posts
             onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
               onError:(void (^)(NSError *error))errorBlock{
    
    [[SHHTTPConnectionChainManager sharedSHHTTPConnectionChainManager] executeQueueWithUrl:urlString
                                                                                     owner:owner
                                                                          getArguments:gets
                                                                         postArguments:posts
                                                                       successObserver:HTTPOBSERVER_SUCCESS
                                                                         errorObserver:HTTPOBSERVER_ERROR
                                                                             onSuccess:successBlock
                                                                               onError:errorBlock
     ];
}


@end
