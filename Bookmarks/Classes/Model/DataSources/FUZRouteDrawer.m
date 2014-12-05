//
//  FUZRouteDrawer.m
//  Bookmarks
//
//  Created by fuzza on 12/5/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <SVProgressHUD.h>
#import "FUZRouteDrawer.h"
#import "FUZMacroses.h"

@interface FUZRouteDrawer ()

@property (weak, nonatomic) MKMapView *map;
@property (nonatomic, strong) MKDirections *currentRoute;

@end

@implementation FUZRouteDrawer

- (instancetype)initWithMap:(MKMapView *)map andDelegate:(id<FUZRouteDrawerDelegate>)delegate
{
    self = [super init];
    {
        _map = map;
        _delegate = delegate;
    }
    return self;
}

- (void)reset
{
    if([self.currentRoute isCalculating])
    {
        [self.currentRoute cancel];
    }
    [self.map removeAnnotations:self.map.annotations];
    [self.map removeOverlays:self.map.overlays];
    self.routedBookmark = nil;
    self.currentRoute = nil;
}

#pragma mark Route drawing

- (void)showRouteToBookmark:(FUZBookmark *)bookmark
{
    [self reset];
    self.routedBookmark = bookmark;
    [self.map addAnnotation:bookmark];
    [self performRouteRequestForAnnotation:bookmark];
}

- (void)performRouteRequestForAnnotation:(id <MKAnnotation>)annotation
{
    if(!self.map.userLocation.location)
    {
        NSDictionary *details = @{NSLocalizedDescriptionKey : @"Seems location is disabled"};
        NSError *error = [NSError errorWithDomain:@"routeDrawer" code:500 userInfo:details];
        [self.delegate routeCalculationFailedWithError:error];
        return;
    }
    
    MKPlacemark *destinationMark = [[MKPlacemark alloc] initWithCoordinate:annotation.coordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationMark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destination;
    request.requestsAlternateRoutes = NO;
    
    self.currentRoute = [[MKDirections alloc] initWithRequest:request];
    
    DEFINE_WEAK(self);
    
    [SVProgressHUD show];
    [self.currentRoute calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error) {
                 [self.delegate routeCalculationFailedWithError:error];
                 [SVProgressHUD dismiss];
             } else {
                 [SVProgressHUD dismiss];
                 [weak_self drawRoute:response];
             }
         });
     }];
}

-(void)drawRoute:(MKDirectionsResponse *)response
{
    MKMapRect totalRect = MKMapRectNull;
    for (MKRoute *route in response.routes)
    {
        [self.map addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        MKPolygon *polygon = [MKPolygon polygonWithPoints:route.polyline.points count:route.polyline.pointCount];
        MKMapRect routeRect = [polygon boundingMapRect];
        totalRect = MKMapRectUnion(totalRect, routeRect);
    }
    [self.map setVisibleMapRect:totalRect edgePadding:UIEdgeInsetsMake(30, 30, 30, 30) animated:YES];
}

@end
