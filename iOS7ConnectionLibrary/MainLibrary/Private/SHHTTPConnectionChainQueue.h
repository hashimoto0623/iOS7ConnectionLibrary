//
//  LPSHHTTPConnectionChainQueue.h
//  LiteraPad
//
//  Created by hashimoto0623 on 2013/11/07.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHHTTPConnectionChainQueue : NSObject

@property (nonatomic, readonly) int queueId;
@property (nonatomic, readonly, strong) id owner;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSDictionary *getArgs;
@property (nonatomic, strong) NSDictionary *postArgs;
@property (nonatomic, strong) NSString *successObserver;
@property (nonatomic, strong) NSString *errorObserver;
@property (nonatomic, readonly) BOOL onBackground;
@property (nonatomic, strong) void(^successBlock)(NSData *data, NSURLResponse *response);
@property (nonatomic, strong) void(^errorBlock)(NSError *error);




+ (SHHTTPConnectionChainQueue*)queueWithUrl:(NSString*)urlString
                                    queueId:(int)queueId
                                      owner:(id)owner
                               getArguments:(NSDictionary*)gets
                              postArguments:(NSDictionary*)posts
                            successObserver:(id)successObserver
                              errorObserver:(id)errorObserver
                                  onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
                                    onError:(void (^)(NSError *error))errorBlock;



- (id)initWithUrl:(NSString*)urlString
          queueId:(int)queueId
            owner:(id)owner
     getArguments:(NSDictionary*)gets
    postArguments:(NSDictionary*)posts
  successObserver:(id)successObserver
    errorObserver:(id)errorObserver
        onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
          onError:(void (^)(NSError *error))errorBlock;


@end
