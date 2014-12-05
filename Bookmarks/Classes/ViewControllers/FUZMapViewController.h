//
//  FUZMapViewController.h
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <WYPopoverController.h>

#import "FUZViewController.h"
#import "FUZRouteDrawer.h"
#import "FUZBookmarksPopoverViewController.h"

typedef NS_ENUM(NSInteger, FUZMapViewControllerMode)
{
    FUZMapViewControllerModeBookmarks = 0,
    FUZMapViewControllerModeRoute
};

@class FUZFetchedControllersBuilder;

@interface FUZMapViewController : FUZViewController <FUZRouteDrawerDelegate, NSFetchedResultsControllerDelegate, WYPopoverControllerDelegate, FUZBookmarksPopoverDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end