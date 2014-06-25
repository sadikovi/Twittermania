//
//  TwittermaniaAppDelegate.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "TwittermaniaAppDelegate.h"
#import "TwittermaniaAppDelegate+MOC.h"
#import "TwitterDatabaseAvailability.h"
#import "TwitterFetcher.h"
#import "Tweet+Twitter.h"

#define TWITTER_UPDATE_INTERVAL             10*60
#define TWITTER_BACKGROUND_FETCH_TIMEOUT    20

@interface TwittermaniaAppDelegate()
@property (nonatomic, strong) NSManagedObjectContext *databaseContext;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TwittermaniaAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.databaseContext = [self createMainQueueManagedObjectContext];
    [self saveContext:self.databaseContext];
    
    [self startTwitterLoad];
    
    return YES;
}

- (void)setDatabaseContext:(NSManagedObjectContext *)databaseContext {
    _databaseContext = databaseContext;
    [self postDatabaseContextNotification];
}

- (void)postDatabaseContextNotification {
    //[self.timer invalidate];
    self.timer = nil;
    
    if (self.databaseContext) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TWITTER_UPDATE_INTERVAL
                                                      target:self
                                                    selector:@selector(startTwitterLoad)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    // post notification with database context
    NSDictionary *userInfo = self.databaseContext ? @{ TWITTER_DATABASE_AVAILABILITY_CONTEXT : self.databaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:TWITTER_DATABASE_AVAILABILITY_NOTIFICATION
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)startTwitterLoad {
    NSLog(@"Start twitter load");
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"#worldcup", @"q",
                            @"true", @"include_entities",
                            @"recent", @"result_type",
                            @"20", @"count", nil];
    [TwitterFetcher performRequest:[TwitterFetcher requestForAPIUrl:TwitterFetcherAPIURLSearch
                                                          andParams:params]
             withCompletionHandler:^(BOOL success, id result, NSError *error) {
                 if (success) {
                     [Tweet loadTweetsFromTwitterArray:(NSDictionary *)result intoManagedObjectContext:self.databaseContext];
                     [self postDatabaseContextNotification];
                 } else {
                     NSLog(@"Error: %@", [error description]);
                 }
             }];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext:self.databaseContext];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self saveContext:self.databaseContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveContext:self.databaseContext];
}

@end
