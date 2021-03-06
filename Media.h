//
//  Media.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet;

@interface Media : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * largeImageURL;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSSet *allTweets;
@end

@interface Media (CoreDataGeneratedAccessors)

- (void)addAllTweetsObject:(Tweet *)value;
- (void)removeAllTweetsObject:(Tweet *)value;
- (void)addAllTweets:(NSSet *)values;
- (void)removeAllTweets:(NSSet *)values;

@end
