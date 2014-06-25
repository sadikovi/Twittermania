//
//  Hashtag+Twitter.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "Hashtag+Twitter.h"
#import "TwitterFetcher.h"

@implementation Hashtag (Twitter)

+ (NSSet *)hashtagsForArray:(NSArray *)hashtags inManagedObjectContext:(NSManagedObjectContext *)context {
    NSMutableSet *hashtagsSet = [NSMutableSet set];
    
    if (!hashtags) {
        // handle error
        NSLog(@"Error while loading hashtags");
    } else {
        for (NSDictionary *hashtagDict in hashtags) {
            NSString *hashtagText = [hashtagDict valueForKey:TWITTER_RESULT_E_HASHTAG_TEXT];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hashtag"];
            request.predicate = [NSPredicate predicateWithFormat:@"text = %@", hashtagText];
            
            NSError *error;
            NSArray *matches = [context executeFetchRequest:request error:&error];
            
            if (!matches || error || [matches count] > 1) {
                // handle error
                NSLog(@"Error while processing hashtag with text: %@", hashtagText);
            } else {
                if (![matches count]) {
                    Hashtag *newHashtag = [NSEntityDescription insertNewObjectForEntityForName:@"Hashtag" inManagedObjectContext:context];
                    newHashtag.text = hashtagText;
                    //newHashtag.tweetsCount = [NSNumber numberWithInteger:[newHashtag.allTweets count]];
                    // add object into set
                    [hashtagsSet addObject:newHashtag];
                } else {
                    Hashtag *existedHashtag = [matches lastObject];
                    //existedHashtag.tweetsCount = [NSNumber numberWithInteger:[existedHashtag.allTweets count]];
                    [hashtagsSet addObject:existedHashtag];
                }
            }
        }
    }
    
    return hashtagsSet;
}

@end
