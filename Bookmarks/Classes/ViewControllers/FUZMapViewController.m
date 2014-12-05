//
//  FUZMapViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <WYStoryboardPopoverSegue.h>
#import <SVProgressHUD.h>

#import "FUZMapViewController.h"
#import "FUZBookmark.h"
#import "FUZBookmarksListViewController.h"
#import "FUZBookmarkDetailViewController.h"
#import "FUZMacroses.h"
#import "FUZConstants.h"

@interface FUZMapViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) FUZMapViewControllerMode mode;
@property (nonatomic, strong) FUZRouteDrawer *routeDrawer;

@property (strong, nonatomic) WYPopoverController *bookmarksPopover;
@property (nonatomic, strong) FUZBookmark *selectedBookmark;

@property (assign, nonatomic) BOOL initalLocationReceived;

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *longTapOnMapRecognizer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *routeButton;

@end

@implementation FUZMapViewController

#pragma mark UIViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFetchedResultsController];
    [self setupDrawer];
    [self subscribeToNotifications];
}

- (void)dealloc
{
    [self unsubscribeFromNotifications];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"main_popover_segue"])
    {
        WYStoryboardPopoverSegue *popoverSegue = (WYStoryboardPopoverSegue *)segue;
        [self setupBookmarksPopoverController:popoverSegue.destinationViewController];
        self.bookmarksPopover = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        self.bookmarksPopover.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"main_to_list_segue"])
    {
        FUZBookmarksListViewController *destinationController = (FUZBookmarksListViewController *)segue.destinationViewController;
        destinationController.managedObjectContext = self.managedObjectContext;
    }
    else if([segue.identifier isEqualToString:@"main_to_detail_segue"])
    {
        FUZBookmarkDetailViewController *destinationController = (FUZBookmarkDetailViewController *)segue.destinationViewController;
        destinationController.bookmark = self.selectedBookmark;
    }
}

#pragma mark Setup

- (void)setupDrawer
{
    self.routeDrawer = [[FUZRouteDrawer alloc] initWithMap:self.map andDelegate:self];
}

- (void)setupFetchedResultsController
{
    self.fetchedResultsController = [FUZBookmark fetchedResultsControllerForAllBookmarksInContext:self.managedObjectContext];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    [self.map addAnnotations:self.fetchedResultsController.fetchedObjects];
}

- (void)setupBookmarksPopoverController:(FUZBookmarksPopoverViewController *)destinationController
{
    destinationController.items = self.fetchedResultsController.fetchedObjects;
    destinationController.delegate = self;
}

#pragma mark NSNotifications

- (void)subscribeToNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBookmarkFromNotification:) name:kShowOnMapNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildRouteFromNotification:) name:kBuildRouteNotification object:nil];
}

- (void)unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowOnMapNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBuildRouteNotification object:nil];
}

- (void)buildRouteFromNotification:(NSNotification *)notification
{
    if(notification.object && [notification.object isKindOfClass:[FUZBookmark class]])
    {
        [self switchToRouteModeWithBookmark:notification.object];
    }
}

- (void)showBookmarkFromNotification:(NSNotification *)notification
{
    if(notification.object && [notification.object isKindOfClass:[FUZBookmark class]])
    {
        FUZBookmark *bookmark = notification.object;
        if(self.mode != FUZMapViewControllerModeBookmarks)
        {
            [self switchToBookmarksMode];
        }
        [self centerMapInLocation:bookmark.location];
    }
}

#pragma mark Map actions

- (void)switchToRouteModeWithBookmark:(FUZBookmark *)bookmark
{
    self.mode = FUZMapViewControllerModeRoute;
    [self.routeButton setTitle:@"Clear route"];
    [self.routeDrawer showRouteToBookmark:bookmark];
}

- (void)switchToBookmarksMode
{
    self.mode = FUZMapViewControllerModeBookmarks;
    [self.routeButton setTitle:@"Route"];
    [self.routeDrawer reset];
    [self.map addAnnotations:self.fetchedResultsController.fetchedObjects];
}

#pragma mark Map geometry

- (void)setupMapRegion
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = self.map.userLocation.location.coordinate.latitude;
    location.longitude = self.map.userLocation.location.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.map setRegion:region animated:YES];
}

- (void)centerMapInLocation:(CLLocation *)newLocation {
    
    MKCoordinateRegion region = self.map.region;
    
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = newLocation.coordinate.latitude;
    centerCoordinate.longitude = newLocation.coordinate.longitude;
    
    region.center = centerCoordinate;
    [self.map setRegion:region animated:YES];
}

#pragma mark IBActions

- (IBAction)longTapOnMapView:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [sender locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    [FUZBookmark createBookmarWithCoordinates:touchMapCoordinate inManagedObjectContext:self.managedObjectContext];
}

- (IBAction)routeButtonDidTap:(id)sender {
    switch (self.mode) {
        case FUZMapViewControllerModeBookmarks:
            [self tryToCallPopoverWithSender:sender];
            break;
        case FUZMapViewControllerModeRoute:
            [self switchToBookmarksMode];
            break;
    }
}

- (void)tryToCallPopoverWithSender:(id)sender
{
    if(self.fetchedResultsController.fetchedObjects.count > 0)
    {
        [self performSegueWithIdentifier:@"main_popover_segue" sender:sender];
    }
    else
    {
        [self showMessage:@"There are no bookmarks"];
    }
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeInsert) {
        if(self.mode == FUZMapViewControllerModeBookmarks)
        {
            [self.map addAnnotation:self.fetchedResultsController.fetchedObjects[newIndexPath.row]];
        }
    } else if (type == NSFetchedResultsChangeUpdate) {
        
    } else if (type == NSFetchedResultsChangeDelete) {
        if(self.mode == FUZMapViewControllerModeRoute && self.routeDrawer.routedBookmark == anObject)
        {
            [self switchToBookmarksMode];
        }
    }
}

#pragma mark WYPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    self.bookmarksPopover.delegate = nil;
    self.bookmarksPopover = nil;
}

#pragma mark FUZBookmarkPopoverDelegate

- (void)bookmarksPopover:(FUZBookmarksPopoverViewController *)popover didSelectBookmark:(FUZBookmark *)bookmark
{
    [self.bookmarksPopover dismissPopoverAnimated:YES];
    [self switchToRouteModeWithBookmark:bookmark];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    switch (self.mode) {
        case FUZMapViewControllerModeRoute:
            return NO;
        case FUZMapViewControllerModeBookmarks:
            return YES;
        default:
            return NO;
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
    if(self.initalLocationReceived)
    {
        return;
    }
    [self setupMapRegion];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if([view.annotation isKindOfClass:[FUZBookmark class]])
    {
        self.selectedBookmark = (FUZBookmark *)view.annotation;
        [self performSegueWithIdentifier:@"main_to_detail_segue" sender:self];
    }
}

#pragma mark FUZRouteDrawerDelegate

-(void) routeCalculationFailedWithError:(NSError *)error
{
    [self showErrorMessage:error];
    [self switchToBookmarksMode];
}

@end
