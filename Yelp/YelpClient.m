//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term atOffset:(NSString *) offset success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
   
   //NSDictionary *parameters = @{@"term": term, @"ll" : @"37.774866,-122.394556", @"offset" : offset, @"deals_filter" : @"", @"radius_filter" : @"", @"category_filter" : @"", @"sort" : @""};
    NSDictionary *parameters = @{@"term": term, @"ll" : @"37.774866,-122.394556", @"offset" : offset, @"deals_filter" : @""};
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *state = [defaults objectForKey:@"8"]; //8 is 1*6+2, the deal switch
//    if ([state isEqualToString:@"yes"]) {
//        
//    }
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
