//
//  TwittermaniaAppDelegate+MOC.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "TwittermaniaAppDelegate.h"

@interface TwittermaniaAppDelegate (MOC)

- (NSManagedObjectContext *)createMainQueueManagedObjectContext;
- (void)saveContext:(NSManagedObjectContext *)managedObjectContext;

@end
