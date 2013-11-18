//
//  AppDelegate.m
//  iOS7ConnectionLibrary
//
//  Created by hashimoto0623 on 2013/11/18.
//  Copyright (c) 2013年 Brick. All rights reserved.
//

#import "AppDelegate.h"
#import "SHHTTPConnection.h"

@implementation AppDelegate

- (void)didSuccess:(NSNotification*)notification{
    NSLog(@"Observer Success!!");
    NSString *dataString = [[NSString alloc] initWithData:notification.object encoding:NSUTF8StringEncoding];
    NSLog(@"%@", dataString);
    NSLog(@"%@", notification.userInfo);
}

- (void)didError:(NSNotification*)notification{
    NSLog(@"Observer Error!!");
    NSLog(@"%@", notification.object);
    NSLog(@"%@", notification.userInfo);
}

- (void)receiving:(NSNotification*)notification{
    NSLog(@"Receiving %@", notification.userInfo);
}
- (void)uploading:(NSNotification*)notification{
    NSLog(@"Uploading %@", notification.userInfo);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSuccess:) name:HTTPOBSERVER_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didError:) name:HTTPOBSERVER_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploading:) name:HTTPOBSERVER_UPLOADING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiving:) name:HTTPOBSERVER_RECEIVING object:nil];
    
    
    [SHHTTPConnection requestWithUrl:@"http://git.localhost.com/post.php"
                               owner:self
                        getArguments:nil
                       postArguments:@{@"hoge":@"hogehoge"}
                           onSuccess:^(NSData *data, NSURLResponse *response){
                               NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"Block Success");
                               NSLog(@"%@", dataString);
                           }onError:^(NSError *err){
                               NSLog(@"Block Error");
                               NSLog(@"%@" ,err);
                           }];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
