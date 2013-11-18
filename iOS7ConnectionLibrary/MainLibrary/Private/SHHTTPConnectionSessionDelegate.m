//
//  LPSHHTTPConnectionSessionDelegate.m
//  LiteraPad
//
//  Created by hashimoto0623 on 2013/11/08.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import "SHHTTPConnectionSessionDelegate.h"
#import "SHHTTPConnectionNotificationCenter.h"
#import "SHHTTPObserverConfigurations.h"

@interface SHHTTPConnectionSessionDelegate(){
    NSMutableData *_data;
    NSHTTPURLResponse *_response;
    NSNumber *_totalLength;
}

@end

@implementation SHHTTPConnectionSessionDelegate

/**
 Receiving
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    [_data appendData:data];
    
    if (![_response isKindOfClass:[NSHTTPURLResponse class]]) return;
    
    NSDictionary *userInfo = @{@"bytesTotal": _totalLength,
                               @"bytesLoaded": [NSNumber numberWithInt:[_data length]]};
    
    [SHHTTPConnectionNotificationCenter postHTTPNotification:HTTPOBSERVER_RECEIVING data:nil userInfo:userInfo queue:self.queue];
}


/**
 Uploading
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    NSDictionary *userInfo = @{@"totalBytesSent": [NSNumber numberWithLongLong:totalBytesSent],
                               @"totalBytesExpectedToSend": [NSNumber numberWithLongLong:totalBytesExpectedToSend]};
    [SHHTTPConnectionNotificationCenter postHTTPNotification:HTTPOBSERVER_UPLOADING data:nil userInfo:userInfo queue:self.queue];
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    //NSLog(@"did Receive Response");
    _response = (NSHTTPURLResponse*)response;
    if ([_response isKindOfClass:[NSHTTPURLResponse class]]) {
        _totalLength = [NSNumber numberWithInt:[[_response.allHeaderFields objectForKey:@"Content-Length"] intValue]];
    }else{
        _totalLength = [NSNumber numberWithInt:-1];
    }
    _data = [[NSMutableData alloc] initWithCapacity:0];
    completionHandler(NSURLSessionResponseAllow);
}

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
    // do work on main thread
    if (error) {
        self.managerErrorBlock(error);
        return;
    }
    self.managerSuccessBlock(_data, _response);
    [session invalidateAndCancel];
}

@end
