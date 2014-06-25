//
//  Tweet+Twitter.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "Tweet.h"

@interface Tweet (Twitter)

+ (Tweet *)tweetWithTwitterInfo:(NSDictionary *)tweetInfo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)loadTweetsFromTwitterArray:(NSDictionary *)tweets intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
