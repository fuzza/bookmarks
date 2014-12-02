//
//  FUZMapDataSource.h
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FUZDataSource.h"
#import "FUZFRCDataSource.h"

@class FUZBookmark;

@interface FUZMapDataSource : FUZFRCDataSource <FUZDataSource, MKMapViewDelegate>

@property (weak, nonatomic) MKMapView *map;

- (void)showRouteToAnnotation:(id <MKAnnotation>)annotation;

@end
