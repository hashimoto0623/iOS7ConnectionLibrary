//
//  SHHTTPConnectionNotification.h
//  MyanmmerApp
//
//  Created by hashimoto0623 on 2013/11/18.
//  Copyright (c) 2013年 Brick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHHTTPConnectionChainQueue.h"

@interface SHHTTPConnectionNotificationCenter : NSObject

+ (void)postHTTPNotification:(id)notificationName data:(id)data userInfo:(NSDictionary*)userInfo queue:(SHHTTPConnectionChainQueue*)queue;

@end
