//
//  LPApiSession.m
//  LiteraPad
//
//  Created by Shingo Hashimoto on 2013/11/01.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import "SHHTTPConnectionSync.h"
#import "SHHTTPConnectionChainManager.h"
#import "SHHTTPConnectionChainQueue.h"
#import "SHHTTPConnectionSessionDelegate.h"

@interface NSString(CSTM)
- (NSString*)escapedUrlString;
@end


@implementation NSString(CSTM)
- (NSString*)escapedUrlString{
    NSString *escapedUrlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                       NULL,
                                                                                                       (CFStringRef)self,
                                                                                                       NULL,
                                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                       kCFStringEncodingUTF8 ));
    return escapedUrlString;
}

@end





@implementation SHHTTPConnectionSync


#pragma mark - Public

+ (void)syncWithQueue:(SHHTTPConnectionChainQueue*)queue
            onSuccess:(void (^)(NSData *data, NSURLResponse *response))successBlock
              onError:(void (^)(NSError *error))errorBlock{
    
    SHHTTPConnectionSessionDelegate *sessionDelegate = [[SHHTTPConnectionSessionDelegate alloc] init];
    sessionDelegate.queue = queue;
    sessionDelegate.managerSuccessBlock = successBlock;
    sessionDelegate.managerErrorBlock = errorBlock;
    
    
    
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf
                                                          delegate:sessionDelegate
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    //  get連結
    NSMutableArray *getArgsJoinKeyValue = [NSMutableArray arrayWithCapacity:0];
    if (queue.getArgs) {
        for (NSString *key in queue.getArgs){
            id value = [queue.getArgs objectForKey:key];
            [getArgsJoinKeyValue addObject:[NSString stringWithFormat:@"%@=%@",key, value]];
        }
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",queue.urlString, [getArgsJoinKeyValue componentsJoinedByString:@"&"]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //  post連結
    
    NSMutableArray *postArgsJoinKeyValue = [[NSMutableArray alloc] initWithCapacity:0];
    if (queue.postArgs) {
        request.HTTPMethod = @"POST";
        for (NSString *key in queue.postArgs){
            NSString *value = [queue.postArgs objectForKey:key];
            [postArgsJoinKeyValue addObject:[NSString stringWithFormat:@"%@=%@",key, value.escapedUrlString]];
        }
        NSString *postString = [postArgsJoinKeyValue componentsJoinedByString:@"&"];
        NSURLSessionUploadTask *upTask = [session uploadTaskWithRequest:request fromData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [upTask resume];
        return;
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

@end

                                
