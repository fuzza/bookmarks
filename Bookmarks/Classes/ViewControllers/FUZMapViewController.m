//
//  FUZMapViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <WYStoryboardPopoverSegue.h>

#import "FUZMapViewController.h"
#import "FUZBookmark.h"
#import "FUZBookmarksListViewController.h"
#import "FUZBookmarkDetailViewController.h"

@interface FUZMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) FUZMapDataSource *mapDataSource;
@property (strong, nonatomic) WYPopoverController *bookmarksPopover;

@end

@implementation FUZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapDataSource.paused = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.mode == FUZMapViewControllerModeBookmarks)
    {
        self.mapDataSource.paused = NO;
    }
}

- (void)setupDataSource
{
    self.mapDataSource = [[FUZMapDataSource alloc] initWithTarget:self.map];
    self.mapDataSource.fetchedResultsController = [FUZBookmark fetchedResultsControllerForAllBookmarksInContext:self.managedObjectContext];
    self.mapDataSource.delegate = self;
}

- (void)setMode:(FUZMapViewControllerMode)mode
{
    if(_mode != mode)
    {
        _mode = mode;
    }
    [self setupUIForCurrentMode];
}

- (void)setupUIForCurrentMode
{
    switch (self.mode) {
        case FUZMapViewControllerModeBookmarks:
            [self.routeButton setTitle:@"Route"];
            [self.mapDataSource switchToBookmarks];
            break;
        case FUZMapViewControllerModeRoute:
            [self.routeButton setTitle:@"Clear route"];
            break;
    }
}

#pragma mark IBActions

- (IBAction)longTapOnMapView:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [sender locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    
    [FUZBookmark createBookmarkFromLocation:loc inManagedObjectContext:self.managedObjectContext];
}

- (IBAction)routeButtonDidTap:(id)sender {
    
    switch (self.mode) {
        case FUZMapViewControllerModeBookmarks:
            [self performSegueWithIdentifier:@"main_popover_segue" sender:sender];
            break;
        case FUZMapViewControllerModeRoute:
            [self setMode:FUZMapViewControllerModeBookmarks];
            break;
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

- (void)didSelectBookmark:(FUZBookmark *)bookmark
{
    [self.bookmarksPopover dismissPopoverAnimated:YES];
    [self setMode:FUZMapViewControllerModeRoute];
    
    [self.mapDataSource showRouteToAnnotation:bookmark];
}

#pragma mark Navigation Logic

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
        destinationController.bookmark = [self.mapDataSource selectedObject];
    }
}

- (void)setupBookmarksPopoverController:(FUZBookmarksPopoverViewController *)destinationController
{
    destinationController.items = [self.mapDataSource items];
    destinationController.delegate = self;
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

#pragma mark FUZMapDataSourceDelegate

- (void)didSelectObject:(FUZBookmark *)object
{
    [self performSegueWithIdentifier:@"main_to_detail_segue" sender:self];
}

@end
