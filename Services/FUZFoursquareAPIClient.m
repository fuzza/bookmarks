//
//  FUZFoursquareAPIClient.m
//  Bookmarks
//
//  Created by fuzza on 12/4/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZFoursquareAPIClient.h"
#import "FUZFoursquareVenue.h"
#import "FUZMacroses.h"

static  NSString * const foursquareSearchAPIURL = @"https://api.foursquare.com/v2/venues/search";
static  NSString * const foursquareClientId = @"AZ2TFPWBOSCLIX0A0REOXH22Y5T0ZRJWKIQUFM1PGRQXG5TA";
static  NSString * const foursquareClientSecret = @"RJ2M0C2E4NJY5XBL0C3FG4IDDODWASRTHQYAOMZU5WGLHRST";
static  NSString * const foursquareAPIVersion = @"20141204";

@interface FUZFoursquareAPIClient()

@property (strong, nonatomic) AFHTTPRequestOperation *operation;

@end

@implementation FUZFoursquareAPIClient

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)loadNearbyPlacesForLocation:(CLLocation *)location withSuccess:(FUZFoursquareVenuesSuccessCallback)success andFailure:(FUZFoursquareVenuesFailureCallback)failure;
{
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:foursquareSearchAPIURL parameters:[self createRequestParamsForLocation:location] error:nil];
    
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    self.operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    DEFINE_WEAK(self);
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *venuesResponse = responseObject[@"response"][@"venues"];
        [weak_self parseVenuesFromResponse:venuesResponse];
        success(venuesResponse);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:self.operation];
    [self.operation resume];
}

- (void)cancelRequest
{
    [self.operation cancel];
    self.operation = nil;
}

- (NSDictionary *)createRequestParamsForLocation:(CLLocation *)location
{
    NSDictionary *params = @{
                             @"client_id" : foursquareClientId,
                             @"client_secret" : foursquareClientSecret,
                             @"v" : foursquareAPIVersion,
                             @"ll" : [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude]
                             };
    return params;
}

- (NSArray *)parseVenuesFromResponse:(NSArray *)venues
{
    NSMutableArray *result = [@[] mutableCopy];
    
   for(NSDictionary *venueDict in venues)
   {
       FUZFoursquareVenue *venue = [self parseVenue:venueDict];
       [result addObject:venue];
   }
    return result;
}

- (FUZFoursquareVenue *)parseVenue:(NSDictionary *)dictionary
{
    FUZFoursquareVenue *venue = [[FUZFoursquareVenue alloc] init];
    
    venue.uid = [dictionary objectForKey:@"id"] ? [dictionary objectForKey:@"id"] : nil;
    venue.name = [dictionary objectForKey:@"name"] ? [dictionary objectForKey:@"name"] : nil;

    return venue;
}

@end
