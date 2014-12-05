//
//  FUZRouteDrawer.h
//  Bookmarks
//
//  Created by fuzza on 12/5/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FUZBookmark.h"

@protocol FUZRouteDrawerDelegate;

@interface FUZRouteDrawer : NSObject

@property (weak, nonatomic) FUZBookmark *routedBookmark;
@property (weak, nonatomic) id<FUZRouteDrawerDelegate> delegate;

- (instancetype)initWithMap:(MKMapView *)map andDelegate:(id<FUZRouteDrawerDelegate>)delegate;

- (void)reset;
- (void)showRouteToBookmark:(FUZBookmark *)bookmark;

@end

@protocol FUZRouteDrawerDelegate <NSObject>

- (void)routeCalculationFailedWithError:(NSError *)error;

@end