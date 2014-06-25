//
//  TwittermaniaViewController.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "TwittermaniaViewController.h"
#import "TwitterFetcher.h"

@interface TwittermaniaViewController ()

@end

@implementation TwittermaniaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

// test TwitterFetcher API
- (IBAction)sendRequest:(UIButton *)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"#worldcup", @"q",
                            @"true", @"include_entities",
                            @"recent", @"result_type",
                            @"20", @"count", nil];

    [TwitterFetcher performRequest:[TwitterFetcher requestForAPIUrl:TwitterFetcherAPIURLSearch
                                                          andParams:params]
             withCompletionHandler:^(BOOL success, id result, NSError *error) {
                 if (success) {
                     NSLog(@"Success. Result: %@", result);
                 } else {
                     NSLog(@"Error: %@", [error description]);
                 }
             }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
