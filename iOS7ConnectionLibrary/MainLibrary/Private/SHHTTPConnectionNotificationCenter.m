//
//  SHHTTPConnectionNotification.m
//  MyanmmerApp
//
//  Created by hashimoto0623 on 2013/11/18.
//  Copyright (c) 2013年 Brick. All rights reserved.
//

#import "SHHTTPConnectionNotificationCenter.h"

@implementation SHHTTPConnectionNotificationCenter

+ (void)postHTTPNotification:(id)notificationName data:(id)data userInfo:(NSDictionary*)userInfo queue:(SHHTTPConnectionChainQueue*)queue{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [dict setObject:queue.owner forKey:@"queueOwner"];
    [dict setObject:[NSNumber numberWithInt:queue.queueId] forKey:@"queueId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:data userInfo:dict];
}

@end
