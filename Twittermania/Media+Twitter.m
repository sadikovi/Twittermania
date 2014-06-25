//
//  Media+Twitter.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "Media+Twitter.h"
#import "TwitterFetcher.h"

@implementation Media (Twitter)

+ (NSSet *)mediaWithMediaInfo:(NSArray *)mediaArray inManagedObjectContext:(NSManagedObjectContext *)context {
    NSMutableSet *mediaSet = [NSMutableSet set];
    
    if (!mediaArray) {
        // handle error
        NSLog(@"Error while loading media");
    } else {
        for (NSDictionary *mediaObject in mediaArray) {
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Media"];
            NSString *mediaId = [NSString stringWithFormat:@"%@", [mediaObject valueForKey:TWITTER_RESULT_E_MEDIA_ID]];
            request.predicate = [NSPredicate predicateWithFormat:@"id = %@", mediaId];
            
            NSError *error;
            NSArray *matches = [context executeFetchRequest:request error:&error];
            
            if (!matches || error || [matches count] > 1) {
                // handle error
                NSLog(@"Error while processing media with id: %@", mediaId);
            } else {
                if (![matches count]) {
                    Media *newMedia = [NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:context];
                    newMedia.id = [NSString stringWithFormat:@"%@", [mediaObject valueForKey:TWITTER_RESULT_E_MEDIA_ID]];
                    newMedia.thumbnailURL = [NSString stringWithFormat:@"%@:%@", [mediaObject valueForKey:TWITTER_RESULT_E_MEDIA_URL], TWITTER_RESULT_E_MEDIA_URL_THU];
                    newMedia.largeImageURL = [NSString stringWithFormat:@"%@:%@", [mediaObject valueForKey:TWITTER_RESULT_E_MEDIA_URL], TWITTER_RESULT_E_MEDIA_URL_LAR];
                    
                    // add object into set
                    [mediaSet addObject:newMedia];
                } else {
                    Media *existedMedia = [matches lastObject];
                    [mediaSet addObject:existedMedia];
                }
            }
        }
    }
    
    return mediaSet;
}

@end
