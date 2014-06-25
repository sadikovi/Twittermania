//
//  Tweet.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hashtag, Media, User;

@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) User *myUser;
@property (nonatomic, retain) NSSet *allMedia;
@property (nonatomic, retain) NSSet *allHashtags;
@end

@interface Tweet (CoreDataGeneratedAccessors)

- (void)addAllHashtagsObject:(Hashtag *)value;
- (void)removeAllHashtagsObject:(Hashtag *)value;
- (void)addAllHashtags:(NSSet *)values;
- (void)removeAllHashtags:(NSSet *)values;

@end
