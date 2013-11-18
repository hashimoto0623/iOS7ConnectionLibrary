//
//  LPSHHTTPConnectionSyncManager.m
//  LiteraPad
//
//  Created by hashimoto0623 on 2013/11/07.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import "SHHTTPConnectionChainManager.h"
#import "SHHTTPConnectionSync.h"
#import "SHHTTPConnectionNotificationCenter.h"

@interface SHHTTPConnectionChainManager(){
    NSMutableArray *_chain;
    BOOL _connecting;
    int _queueSequence;
}

@end

@implementation SHHTTPConnectionChainManager

static SHHTTPConnectionChainManager* _sharedSHHTTPConnectionChainManager = nil;

+ (SHHTTPConnectionChainManager*)sharedSHHTTPConnectionChainManager {
    @synchronized(self) {
        if (_sharedSHHTTPConnectionChainManager == nil) {
            (void) [[self alloc] init]; // ここでは代入していない
        }
    }
    return _sharedSHHTTPConnectionChainManager;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_sharedSHHTTPConnectionChainManager == nil) {
            _sharedSHHTTPConnectionChainManager = [super allocWithZone:zone];
            return _sharedSHHTTPConnectionChainManager;  // 最初の割り当てで代入し、返す
        }
    }
    return nil; // 以降の割り当てではnilを返すようにする
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // 初期処理
        _chain = [NSMutableArray arrayWithCapacity:0];
        _connecting = NO;
        _queueSequence = 1;
    }
    return self;
}


#pragma mark - Private


- (void)addQueue:(SHHTTPConnectionChainQueue*)queue{
    
    [_chain addObject:queue];
    if (!_connecting) {
        _connecting = YES;
        [self execFirstChain];
    }
}

- (void)executeQueue:(SHHTTPConnectionChainQueue*)queue{
    
    [SHHTTPConnectionSync syncWithQueue:queue
                              onSuccess:^(NSData *data, NSURLResponse *response){
                                  if (queue.successObserver) {
                                      [SHHTTPConnectionNotificationCenter postHTTPNotification:queue.successObserver data:data userInfo:nil queue:queue];
                                  }
                                  if (queue.successBlock) {
                                      queue.successBlock(data, response);
                                  }
                              }onError:^(NSError *err){
                                  if (queue.errorBlock) {
                                      queue.errorBlock(err);
                                  }
                                  if (queue.errorObserver) {
                                      [SHHTTPConnectionNotificationCenter postHTTPNotification:queue.errorObserver data:err userInfo:nil queue:queue];
                                  }
                              }];
}


- (void)execFirstChain{
    if ([_chain count] < 1) {
        NSLog(@"-- [Chain Current chain Cleared]");
        _connecting = NO;
        return;
    }
    
    SHHTTPConnectionChainQueue *queue = [_chain objectAtIndex:0];
    NSLog(@"-- [Chain Start %@]", queue.urlString);
    
    [SHHTTPConnectionSync syncWithQueue:queue
                              onSuccess:^(NSData *data, NSURLResponse *response){
                                  
                                  //  キューの成功Blockを走らせてから、
                                  //  次のキューを走らせる処理
                                  NSLog(@"-- [Chain End %@]", queue.urlString);
                                  if (queue.successObserver) {
                                      [SHHTTPConnectionNotificationCenter postHTTPNotification:queue.successObserver data:data userInfo:nil queue:queue];
                                  }
                                  if (queue.successBlock) {
                                      queue.successBlock(data, response);
                                  }
                                  [_chain removeObjectAtIndex:0];
                                  [[SHHTTPConnectionChainManager sharedSHHTTPConnectionChainManager] execFirstChain];
                                  
                              }onError:^(NSError *err){
                                  if (queue.errorBlock) {
                                      queue.errorBlock(err);
                                  }
                                  if (queue.errorObserver) {
                                      [SHHTTPConnectionNotificationCenter postHTTPNotification:queue.errorObserver data:err userInfo:nil queue:queue];
                                  }
                              }];
    
}


- (void)incrementQueueId{
    _queueSequence++;
}

#pragma mark - Main


- (void)addQueueWithUrl:(NSString*)urlString
                  owner:(id)owner
           getArguments:(NSDictionary*)gets
          postArguments:(NSDictionary*)posts
        successObserver:(id)successObserver
          errorObserver:(id)errorObserver
              onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
                onError:(void (^)(NSError *error))errorBlock{
    
    [self addQueue:[SHHTTPConnectionChainQueue queueWithUrl:urlString queueId:_queueSequence owner:owner getArguments:gets postArguments:posts successObserver:successObserver errorObserver:errorObserver onSuccess:successBlock onError:errorBlock]];
    [self incrementQueueId];
}


- (void)executeQueueWithUrl:(NSString*)urlString
                      owner:(id)owner
               getArguments:(NSDictionary*)gets
              postArguments:(NSDictionary*)posts
            successObserver:(id)successObserver
              errorObserver:(id)errorObserver
                  onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
                    onError:(void (^)(NSError *error))errorBlock{
    
    [self executeQueue:[SHHTTPConnectionChainQueue queueWithUrl:urlString queueId:_queueSequence owner:owner getArguments:gets postArguments:posts successObserver:successObserver errorObserver:errorObserver onSuccess:successBlock onError:errorBlock]];
    [self incrementQueueId];
}


@end
