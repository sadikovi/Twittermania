//
//  TweetViewController.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "TweetViewController.h"
#import "ImageViewController.h"
#import "User.h"
#import "Media.h"
#import <QuartzCore/QuartzCore.h>

#define TABLE_VIEW_ROWS     4
#define TABLE_VIEW_SECTIONS 1

@interface TweetViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSURL *backgroundImageURL;

@end

@implementation TweetViewController

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.username = [NSString stringWithFormat:@"%@ @%@", self.tweet.myUser.name, self.tweet.myUser.screenName];
    self.profileImageURL = [NSURL URLWithString:tweet.myUser.profileImageURL];
    self.backgroundImageURL = [NSURL URLWithString:tweet.myUser.backgroundImageURL];
    
    [self.tableView reloadData];
}

- (UIImageView *)profileImageView {
    if (!_profileImageView) {
        _profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.profileImageView.image = nil;
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileImageView.layer.borderWidth = 1;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
        self.profileImageView.clipsToBounds = YES;
    }
    
    return _profileImageView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeCenter;
    }
    //_backgroundImageView.clipsToBounds = YES;
    
    return _backgroundImageView;
}

// download method for imageView
- (void)downloadImageForView:(UIImageView *)imageView withURL:(NSURL *)url {
    imageView.image = nil;
    // download profile image
    dispatch_queue_t backgroundDownloadQueue = dispatch_queue_create("background_download_queue", NULL);
    dispatch_async(backgroundDownloadQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        if (self.username) _usernameLabel.text = self.username;
        self.usernameLabel.backgroundColor = [UIColor clearColor];
        self.usernameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _usernameLabel;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TABLE_VIEW_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self.tweet.allMedia count]) return TABLE_VIEW_ROWS - 1;
    
    return TABLE_VIEW_ROWS;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    }
    if (indexPath.row == 1) {
        return 50;
    }
    
    if (indexPath.row == 2) {
        CGSize maximumSize = CGSizeMake(self.tableView.frame.size.width-20, 200);
        CGSize expectedSize = [self.tweet.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maximumSize
                                              lineBreakMode:NSLineBreakByWordWrapping];
        
        return expectedSize.height;
    }
    
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetVC Cell"];
    
    if (indexPath.row == 0) {
        // adding background image view
        self.backgroundImageView.frame = CGRectMake(0, 0, cell.frame.size.width, 120);
        [self downloadImageForView:self.backgroundImageView withURL:self.backgroundImageURL];
        self.backgroundImageView.center = CGPointMake(cell.frame.size.width/2, 120/2);
        [cell.contentView addSubview:self.backgroundImageView];
        [cell setNeedsDisplay];
        [cell setNeedsLayout];
        
        // adding profile image view
        self.profileImageView.frame = CGRectMake(0, 0, cell.frame.size.width/6, cell.frame.size.width/6);
        [self downloadImageForView:self.profileImageView withURL:self.profileImageURL];
        self.profileImageView.center = CGPointMake(cell.frame.size.width/6, 120/2);
        self.profileImageView.layer.cornerRadius = cell.frame.size.width/12;
        [cell.contentView addSubview:self.profileImageView];
        
        cell.textLabel.text = nil;
    }
    
    if (indexPath.row == 1) {
        cell.textLabel.text = self.username;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.row == 2) {
        cell.textLabel.text = self.tweet.text;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 99;
    }
    
    if (indexPath.row == 3) {
        cell.textLabel.text = nil;
        [cell.contentView addSubview:self.collectionView];
        [self.collectionView reloadData];
    }
    
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(80, 80)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 160)
                                             collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Image Collection Cell"];
    }
    
    _collectionView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 160);
    
    return _collectionView;
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.tweet.allMedia count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"Image Collection Cell" forIndexPath:indexPath];
    
    Media *media = [[self.tweet.allMedia allObjects] objectAtIndex:indexPath.row];
    NSURL *thumbnailURL = [NSURL URLWithString:media.thumbnailURL];
    
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.width/2);
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    dispatch_queue_t mediaDownloadQueue = dispatch_queue_create("media_download_queue", NULL);
    dispatch_async(mediaDownloadQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.image = image;
            imageView.frame = cell.contentView.frame;
            [spinner stopAnimating];
            [cell.contentView addSubview:imageView];
        });
    });
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Media *media = [[[self.tweet allMedia] allObjects] objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:media.largeImageURL];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ImageViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
    [ivc setImageURL:imageURL];
    ivc.title = @"Media";
    
    [self.navigationController pushViewController:ivc animated:YES];
}

@end
