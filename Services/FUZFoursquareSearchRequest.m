//
//  FUZFoursquareAPIClient.m
//  Bookmarks
//
//  Created by fuzza on 12/4/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <SVProgressHUD.h>
#import "FUZFoursquareSearchRequest.h"
#import "FUZFoursquareVenue.h"
#import "FUZMacroses.h"
#import "FUZConstants.h"

@interface FUZFoursquareSearchRequest()

@property (strong, nonatomic) AFHTTPRequestOperation *operation;

@end

@implementation FUZFoursquareSearchRequest

- (void)loadNearbyPlacesForLocation:(CLLocation *)location withSuccess:(FUZFoursquareVenuesSuccessCallback)success andFailure:(FUZFoursquareVenuesFailureCallback)failure;
{
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:kFoursquareSearchAPIURL parameters:[self createRequestParamsForLocation:location] error:nil];
    
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    self.operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    DEFINE_WEAK(self);

    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *venuesResponse = responseObject[@"response"][@"venues"];
        NSArray *venuesObjects = [weak_self parseVenuesFromResponse:venuesResponse];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            success(venuesObjects);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            failure(error);
        });
    }];
    
    [[NSOperationQueue mainQueue] addOperation:self.operation];
    [SVProgressHUD show];
    [self.operation resume];
}

- (void)cancelRequest
{
    [SVProgressHUD dismiss];
    if(self.operation.isExecuting)
    {
        [self.operation cancel];
        self.operation = nil;
    }
}

- (NSDictionary *)createRequestParamsForLocation:(CLLocation *)location
{
    NSDictionary *params = @{
                             @"client_id" : kFoursquareClientId,
                             @"client_secret" : kFoursquareClientSecret,
                             @"v" : kFoursquareAPIVersion,
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
