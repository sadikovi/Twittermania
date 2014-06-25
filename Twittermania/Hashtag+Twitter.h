//
//  Hashtag+Twitter.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "Hashtag.h"

@interface Hashtag (Twitter)

+ (NSSet *)hashtagsForArray:(NSArray *)hashtags inManagedObjectContext:(NSManagedObjectContext *)context;

@end
