//
//  LPSHHTTPConnectionSessionDelegate.h
//  LiteraPad
//
//  Created by hashimoto0623 on 2013/11/08.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHHTTPConnectionChainQueue.h"

@interface SHHTTPConnectionSessionDelegate : NSObject <NSURLSessionDataDelegate>

@property (nonatomic, strong) SHHTTPConnectionChainQueue *queue;
@property (nonatomic, strong) void(^managerSuccessBlock)(NSData *data, NSURLResponse *response);
@property (nonatomic, strong) void(^managerErrorBlock)(NSError *error);

@end
