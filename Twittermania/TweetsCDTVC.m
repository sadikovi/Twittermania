//
//  TweetsCDTVC.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "TweetsCDTVC.h"
#import "TweetViewController.h"
#import "Tweet.h"
#import "Media.h"
#import "Hashtag.h"
#import "TwitterDatabaseAvailability.h"

@interface TweetsCDTVC()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation TweetsCDTVC
/*
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id"
                                                              ascending:NO
                                                               selector:@selector(localizedStandardCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserverForName:TWITTER_DATABASE_AVAILABILITY_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = [[note userInfo] valueForKey:TWITTER_DATABASE_AVAILABILITY_CONTEXT];
                                                  }];
}
 */

- (void)prepareTweetsForHashtag:(Hashtag *)hashtag {
    self.managedObjectContext = hashtag.managedObjectContext;
    if (self.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
        
        request.predicate = [NSPredicate predicateWithFormat:@"allHashtags contains %@", hashtag];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id"
                                                                  ascending:NO
                                                                   selector:@selector(localizedStandardCompare:)]];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tweet Cell"];
    
    Tweet *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = tweet.text;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = tweet.source;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    if ([tweet.allMedia count]) {
        cell.imageView.image = [UIImage imageNamed:@"default_icon"];
        
        dispatch_queue_t thumbQueue = dispatch_queue_create("Thumbnail_fetch_queue", NULL);
        dispatch_async(thumbQueue, ^{
            Media *media = (Media *)[[tweet.allMedia allObjects] lastObject];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:media.thumbnailURL]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
            });
        });
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Display Tweet"]) {
        if ([segue.destinationViewController isKindOfClass:[TweetViewController class]]) {
            TweetViewController *tvc = (TweetViewController *)segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            Tweet *tweet = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
            [tvc setTweet:tweet];
        }
    }
}

@end