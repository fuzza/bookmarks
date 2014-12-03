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
    [self setupMapForLocation:self.map.userLocation.location];
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
    
    __weak typeof(self) weak_self = self;
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle Error
         } else {
             [weak_self showRoute:response];
         }
     }];
}

- (void)setupMapForLocation:(CLLocation *)newLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.map setRegion:region animated:YES];
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
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BookmarksAnnotationReuseIdentifier"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedObject = (FUZBookmark *)view.annotation;
    [self.delegate didSelectObject:view.annotation];
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.map addAnnotation:self.fetchedResultsController.fetchedObjects[newIndexPath.row]];
    } else if (type == NSFetchedResultsChangeUpdate) {
        
    } else if (type == NSFetchedResultsChangeDelete) {
        NSAssert(NO, @"Should be disconnected");
    }
}

@end
