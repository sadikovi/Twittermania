//
//  TwitterFetcher.m
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import "TwitterFetcher.h"

#define TWITTER_RESULT_ERROR        @"errors"
#define TWITTER_RESULT_ERROR_CODE   @"code"
#define TWITTER_RESULT_ERROR_MSG    @"message"

@implementation TwitterFetcher

// API urls for typedef
+ (NSURL *)urlForTwitterAPIURL:(TwitterFetcherAPIURL)apiURL {
    if (apiURL == TwitterFetcherAPIURLSearch)
        return [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    
    return nil;
}

// request for search
+ (SLRequest *)requestForAPIUrl:(TwitterFetcherAPIURL)apiURL andParams:(NSDictionary *)params {
    NSURL *url = [self urlForTwitterAPIURL:apiURL];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    // retrieve twitter account
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:[accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter]];
    ACAccount *twitterAccount = [twitterAccounts lastObject];
    request.account = twitterAccount;
    
    return request;
}

// run request and get results
+ (void)performRequest:(SLRequest *)request withCompletionHandler:(TwitterFetcherHandler)handler {
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            handler(NO, nil, error);
        } else {
            id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                        options:0
                                                          error:&error];
            if (error) {
                handler(NO, nil, error);
            } else {
                // it can be twitter error so we are going to check result to include "errors" key
                if ([result objectForKey:TWITTER_RESULT_ERROR]) {
                    error = [NSError errorWithDomain:@"Twitter result error"
                                                code:100
                                            userInfo:(NSDictionary *)result];
                    handler(NO, nil, error);
                } else {
                    handler(YES, result, nil);
                }
            }
        }
    }];
}

// check whether account info is available or not
+ (BOOL)twitterAccountInfoIsAvailable {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:[accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter]];
    
    if (twitterAccounts && [twitterAccounts count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
