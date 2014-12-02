//
//  FUZMapViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//


#import "FUZMapViewController.h"
#import "FUZBookmark.h"
#import "FUZFetchedControllersBuilder.h"
#import "FUZMapDataSource.h"

typedef NS_ENUM(NSInteger, FUZMapViewControllerMode)
{
    FUZMapViewControllerModeBookmarks = 0,
    FUZMapViewControllerModeRoute
};

@interface FUZMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) FUZMapDataSource *mapDataSource;

@end

@implementation FUZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    
}

- (void)setupDataSource
{
    self.mapDataSource = [[FUZMapDataSource alloc] initWithTarget:self.map];
    self.mapDataSource.fetchedResultsController = [self.frcBuilder fetchedResultsControllerWithRequest:[FUZBookmark fetchRequestForAllBookmarks]];
}

#pragma mark IBActions

- (IBAction)longTapOnMapView:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [sender locationInView:self.map];
    CLLocationCoordinate2D touchMapCoordinate = [self.map convertPoint:touchPoint toCoordinateFromView:self.map];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    
    [FUZBookmark createBookmarkFromLocation:loc inManagedObjectContext:self.frcBuilder.managedObjectContext];
}



@end
