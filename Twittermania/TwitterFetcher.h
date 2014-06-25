//
//  TwitterFetcher.h
//  Twittermania
//
//  Created by Ivan Sadikov on 25/06/14.
//  Copyright (c) 2014 Ivan Sadikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

// keys in twitter result dictionary
// tweets array key
#define TWITTER_RESULT_TWEETS           @"statuses"
// tweet keys
#define TWITTER_RESULT_TWEET_ID         @"id"
#define TWITTER_RESULT_TWEET_TEXT       @"text"
#define TWITTER_RESULT_TWEET_SOURCE     @"source"
// user keys
#define TWITTER_RESULT_USER             @"user"
#define TWITTER_RESULT_USER_ID          @"id"
#define TWITTER_RESULT_USER_NAME        @"name"
#define TWITTER_RESULT_USER_SCREEN_NAME @"screen_name"
#define TWITTER_RESULT_USER_DESC        @"description"
#define TWITTER_RESULT_USER_LOCATION    @"location"
#define TWITTER_RESULT_USER_PROFILE_IMAGE_URL   @"profile_image_url_https"
#define TWITTER_RESULT_USER_BACKGRND_IMAGE_URL  @"profile_background_image_url_https"
#define TWITTER_RESULT_USER_BANNER_IMAGE_URL    @"profile_banner_url"
// entity keys
#define TWITTER_RESULT_ENTITIES         @"entities"
// hashtags keys
#define TWITTER_RESULT_E_HASHTAG        @"hashtags"
#define TWITTER_RESULT_E_HASHTAG_TEXT   @"text"
// media keys
#define TWITTER_RESULT_E_MEDIA          @"media"
#define TWITTER_RESULT_E_MEDIA_ID       @"id"
#define TWITTER_RESULT_E_MEDIA_TYPE     @"type"
#define TWITTER_RESULT_E_MEDIA_URL      @"media_url_https"
#define TWITTER_RESULT_E_MEDIA_URL_THU  @"thumb"
#define TWITTER_RESULT_E_MEDIA_URL_LAR  @"large"

enum {
    TwitterFetcherAPIURLSearch
} typedef TwitterFetcherAPIURL;

typedef void(^TwitterFetcherHandler)(BOOL success, id result, NSError *error);

@interface TwitterFetcher : NSObject

// request for search
+ (SLRequest *)requestForAPIUrl:(TwitterFetcherAPIURL)apiURL andParams:(NSDictionary *)params;
// run request and get results
+ (void)performRequest:(SLRequest *)request withCompletionHandler:(TwitterFetcherHandler)handler;
// check whether account info is available or not
+ (BOOL)twitterAccountInfoIsAvailable;

@end
