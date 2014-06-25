//
//  Tweet+Twitter.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "Tweet+Twitter.h"
#import "TwitterFetcher.h"
#import "User+Twitter.h"
#import "Hashtag+Twitter.h"
#import "Media+Twitter.h"

@implementation Tweet (Twitter)

+ (Tweet *)tweetWithTwitterInfo:(NSDictionary *)tweetInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    Tweet *tweet = nil;
    
    NSString *tweetId = [NSString stringWithFormat:@"%@", [tweetInfo valueForKey:TWITTER_RESULT_TWEET_ID]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", tweetId];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count]>1) {
        // handle error
        NSLog(@"Error while loading tweet with id: %@", tweetId);
    } else if ([matches count]) {
        tweet = [matches lastObject];
    } else {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet"
                                              inManagedObjectContext:context];
        
        tweet.id = [NSString stringWithFormat:@"%@", [tweetInfo valueForKey:TWITTER_RESULT_TWEET_ID]];
        tweet.text = [tweetInfo valueForKey:TWITTER_RESULT_TWEET_TEXT];
        tweet.source = [tweetInfo valueForKey:TWITTER_RESULT_TWEET_SOURCE];
        
        // create user for the tweet
        tweet.myUser = [User userWithUserInfo:[tweetInfo valueForKey:TWITTER_RESULT_USER] inManagedObjectContext:context];
        
        // create hashtags for tweet
        tweet.allHashtags = [Hashtag hashtagsForArray:[[tweetInfo valueForKey:TWITTER_RESULT_ENTITIES] valueForKey:TWITTER_RESULT_E_HASHTAG]
                               inManagedObjectContext:context];
        
        // create media for tweet
        tweet.allMedia = [Media mediaWithMediaInfo:[[tweetInfo valueForKey:TWITTER_RESULT_ENTITIES] valueForKey:TWITTER_RESULT_E_MEDIA]
                            inManagedObjectContext:context];
    }
    
    return tweet;
}

+ (void)loadTweetsFromTwitterArray:(NSDictionary *)tweets intoManagedObjectContext:(NSManagedObjectContext *)context {
    NSArray *tweetsArray = [tweets valueForKey:TWITTER_RESULT_TWEETS];

    // inefficient! find a way to do that faster
    for (NSDictionary *tweetInfo in tweetsArray) {
        [Tweet tweetWithTwitterInfo:tweetInfo inManagedObjectContext:context];
    }
}

@end
