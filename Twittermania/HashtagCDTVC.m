//
//  HashtagCDTVC.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "HashtagCDTVC.h"
#import "TweetsCDTVC.h"
#import "Hashtag.h"
#import "Tweet+Twitter.h"
#import "TwitterFetcher.h"
#import "TwitterDatabaseAvailability.h"

@implementation HashtagCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hashtag"];
    
    request.predicate = nil;
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"tweetsCount"
                                                              ascending:NO
                                                               selector:@selector(compare:)] ];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Hashtag Cell"];
    Hashtag *hashtag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"#%@", hashtag.text];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d tweets", [hashtag.tweetsCount integerValue]];
    
    return cell;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserverForName:TWITTER_DATABASE_AVAILABILITY_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = [[note userInfo] valueForKey:TWITTER_DATABASE_AVAILABILITY_CONTEXT];
                                                  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Display Tweets"]) {
        if ([segue.destinationViewController isKindOfClass:[TweetsCDTVC class]]) {
            UITableViewCell *cell = (UITableViewCell *)sender;
            Hashtag *hashtag = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
            
            TweetsCDTVC *tcdtvc = (TweetsCDTVC *)segue.destinationViewController;
            [tcdtvc prepareTweetsForHashtag:hashtag];
        }
    }
}

@end
