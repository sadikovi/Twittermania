//
//  HashtagCDTVC.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface HashtagCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
