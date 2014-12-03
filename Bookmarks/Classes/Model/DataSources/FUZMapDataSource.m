//
//  FUZMapDataSource.m
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZMapDataSource.h"

@implementation FUZMapDataSource

- (instancetype)initWithTarget:(MKMapView *)target
{
    self = [super init];
    if(self)
    {
        _map = target;
        _map.delegate = self;
    }
    return self;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    [super setFetchedResultsController:fetchedResultsController];
    [self.map addAnnotations:self.fetchedResultsController.fetchedObjects];
}

#pragma mark Route mode

- (void)showRouteToAnnotation:(id <MKAnnotation>)annotation
{
    self.paused = YES;
    
    [self.map removeAnnotations:self.map.annotations];
    [self.map addAnnotation:annotation];
    
    [self performRouteRequestForAnnotation:annotation];
}

- (void)switchToBookmarks
{
    [self.map removeOverlays:self.map.overlays];
    self.paused = NO;
}

- (void)reloadDataSource
{
    [self.map addAnnotations:self.fetchedResultsController.fetchedObjects];
}

- (void)performRouteRequestForAnnotation:(id <MKAnnotation>)annotation
{
    MKPlacemark *destinationMark = [[MKPlacemark alloc] initWithCoordinate:annotation.coordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationMark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = destination;
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle Error
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.map addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
}

#pragma mark MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return [mapView viewForAnnotation:annotation];
    }
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    [self.map addAnnotation:self.fetchedResultsController.fetchedObjects[newIndexPath.row]];
    
}

@end
