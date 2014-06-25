//
//  Hashtag.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet;

@interface Hashtag : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * tweetsCount;
@property (nonatomic, retain) NSSet *allTweets;
@end

@interface Hashtag (CoreDataGeneratedAccessors)

- (void)addAllTweetsObject:(Tweet *)value;
- (void)removeAllTweetsObject:(Tweet *)value;
- (void)addAllTweets:(NSSet *)values;
- (void)removeAllTweets:(NSSet *)values;

@end
