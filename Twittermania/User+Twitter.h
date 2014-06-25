//
//  User+Twitter.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "User.h"

@interface User (Twitter)

+ (User *)userWithUserInfo:(NSDictionary *)userInfo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
