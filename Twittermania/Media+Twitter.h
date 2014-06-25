//
//  Media+Twitter.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "Media.h"

@interface Media (Twitter)

+ (NSSet *)mediaWithMediaInfo:(NSArray *)mediaArray inManagedObjectContext:(NSManagedObjectContext *)context;

@end
