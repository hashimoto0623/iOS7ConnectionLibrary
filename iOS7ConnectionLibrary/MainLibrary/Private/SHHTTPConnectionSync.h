//
//  LPApiSession.h
//  LiteraPad
//
//  Created by Shingo Hashimoto on 2013/11/01.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHHTTPConnectionChainQueue.h"

@interface SHHTTPConnectionSync : NSURLSession

+ (void)syncWithQueue:(SHHTTPConnectionChainQueue*)queue
            onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
              onError:(void (^)(NSError *error))errorBlock;

@end
