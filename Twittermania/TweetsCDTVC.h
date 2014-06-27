//
//  TweetsCDTVC.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CoreDataTableViewController.h"
#import "Hashtag.h"

@interface TweetsCDTVC : CoreDataTableViewController

- (void)prepareTweetsForHashtag:(Hashtag *)hashtag;

@end
