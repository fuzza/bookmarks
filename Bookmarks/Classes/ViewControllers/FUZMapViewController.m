//
//  FUZMapViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//


#import "FUZMapViewController.h"
#import "FUZLocalStorageService.h"

typedef NS_ENUM(NSInteger, FUZMapViewControllerMode)
{
    FUZMapViewControllerModeBookmarks = 0,
    FUZMapViewControllerModeRoute
};

@interface FUZMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (strong, nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation FUZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultsController = [[FUZLocalStorageService sharedInstance] fetchedResultControllerForAllBookmarks];
    self.resultsController.delegate = self;
    
    [self.resultsController performFetch:nil];
    
    [self.map addAnnotations:self.resultsController.fetchedObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)longTapOnMapView:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [sender locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    
    [[FUZLocalStorageService sharedInstance] createBookmarkFromLocation:loc];
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
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

    [self.map addAnnotation:self.resultsController.fetchedObjects[newIndexPath.row]];
    
}

@end
