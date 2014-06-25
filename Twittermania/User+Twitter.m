//
//  User+Twitter.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "User+Twitter.h"
#import "TwitterFetcher.h"

@implementation User (Twitter)

+ (User *)userWithUserInfo:(NSDictionary *)userInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    User *user = nil;
    
    NSString *userId = [NSString stringWithFormat:@"%@", [userInfo valueForKey:TWITTER_RESULT_USER_ID]];
    
    if ([userId length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        request.predicate = [NSPredicate predicateWithFormat:@"id = %@", userId];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        if (!matches || [matches count] > 1) {
            // handle error
            NSLog(@"Error while loading user with id: %@", userId);
        } else if (![matches count]) {
            user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            user.id = [NSString stringWithFormat:@"%@", [userInfo valueForKey:TWITTER_RESULT_USER_ID]];
            user.name = [userInfo valueForKey:TWITTER_RESULT_USER_NAME];
            user.desc = [userInfo valueForKey:TWITTER_RESULT_USER_DESC];
            user.location = [userInfo valueForKey:TWITTER_RESULT_USER_LOCATION];
            user.profileImageURL = [userInfo valueForKey:TWITTER_RESULT_USER_PROFILE_IMAGE_URL];
            user.backgroundImageURL = [userInfo valueForKey:TWITTER_RESULT_USER_BACKGRND_IMAGE_URL];
            user.bannerImageURL = [userInfo valueForKey:TWITTER_RESULT_USER_BANNER_IMAGE_URL];
            user.screenName = [userInfo valueForKey:TWITTER_RESULT_USER_SCREEN_NAME];
        } else {
            user = [matches lastObject];
        }
    }
    
    return user;
}

@end
