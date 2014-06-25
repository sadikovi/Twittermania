//
//  ImageViewController.m
//  TumblrPhotoBlogger
//
//  Created by Ivan Sadikov on 24/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ImageViewController

// set imageView
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}

// set scrollView
- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 0.1;
    _scrollView.maximumZoomScale = 1.2;
    self.scrollView.contentSize = self.image?self.image.size : CGSizeZero;
}

// get image as imageView.image
- (UIImage *)image {
    return self.imageView.image;
}

// set image and setup all the properties
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.spinner stopAnimating];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    
    // calculate zoom scale to fit the screen size
    float minScale = (image.size.width > image.size.height) ? self.scrollView.frame.size.width / image.size.width : self.scrollView.frame.size.height / image.size.height;
    self.scrollView.zoomScale = minScale;
    // set image in the center
    self.imageView.center = self.scrollView.center;
}

// set image url
// every time we set url we have to download image
- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self downloadingImage];
    
}

- (void)downloadingImage {
    [self.spinner startAnimating];
    self.image = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   self.image = image;
                               }
                           }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // calculate zoom scale to fit the screen size
    float minScale = (self.imageView.image.size.width > self.imageView.image.size.height) ? self.scrollView.frame.size.width / self.imageView.image.size.width : self.scrollView.frame.size.height / self.imageView.image.size.height;
    self.scrollView.zoomScale = minScale;
    // set image in the center
    self.imageView.center = self.scrollView.center;
    
    [self.scrollView setNeedsDisplay];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
