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

@interface TweetViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *backgroundSpinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *profileSpinner;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userName.text = self.username;
    self.profileImageView.image = nil;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 1;
    self.backgroundImageView.image = nil;
    
    // download profile image
    [self.profileSpinner startAnimating];
    dispatch_queue_t tweetProfileImagesQueue = dispatch_queue_create("Tweet_profile_images_fetch_queue", NULL);
    dispatch_async(tweetProfileImagesQueue, ^{
        UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.profileImageURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImageView.image = profileImage;
            [self.profileSpinner stopAnimating];
        });
    });
    
    // download background image
    [self.backgroundSpinner startAnimating];
    dispatch_queue_t tweetBackgroundImagesQueue = dispatch_queue_create("Tweet_background_images_fetch_queue", NULL);
    dispatch_async(tweetBackgroundImagesQueue, ^{
        UIImage *backgroundImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.backgroundImageURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = backgroundImage;
            [self.backgroundSpinner stopAnimating];
        });
    });
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self.tweet.allMedia count]) {
        return 1;
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGSize maximumSize = CGSizeMake(self.tableView.frame.size.width-20, 200);
        CGSize expectedSize = [self.tweet.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maximumSize
                                              lineBreakMode:NSLineBreakByWordWrapping];
        
        return expectedSize.height;
    }
    
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetVC Cell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = self.tweet.text;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 99;
    }
    
    if (indexPath.row == 1) {        
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-20, 160)
                                             collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Image Collection Cell"];
    }
    
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
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    spinner.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    [cell.contentView addSubview:spinner];
    
    dispatch_queue_t collectionQueue = dispatch_queue_create("image_collection_fetch_queue", NULL);
    dispatch_async(collectionQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnailURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
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
