//
//  FUZFoursquareAPIClient.h
//  Bookmarks
//
//  Created by fuzza on 12/4/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking.h>

typedef void(^FUZFoursquareVenuesSuccessCallback)(NSArray *);
typedef void(^FUZFoursquareVenuesFailureCallback)(NSError *);

@interface FUZFoursquareSearchRequest : NSObject

@property (assign, nonatomic) BOOL processing;

- (void)loadNearbyPlacesForLocation:(CLLocation *)location withSuccess:(FUZFoursquareVenuesSuccessCallback)success andFailure:(FUZFoursquareVenuesFailureCallback)failure;
- (void)cancelRequest;

@end