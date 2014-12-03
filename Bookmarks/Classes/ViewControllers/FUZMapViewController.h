//
//  FUZMapViewController.h
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <WYPopoverController.h>

#import "FUZBookmarksPopoverViewController.h"

typedef NS_ENUM(NSInteger, FUZMapViewControllerMode)
{
    FUZMapViewControllerModeBookmarks = 0,
    FUZMapViewControllerModeRoute
};

@class FUZFetchedControllersBuilder;

@interface FUZMapViewController : UIViewController <WYPopoverControllerDelegate, FUZBookmarksPopoverDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *routeButton;
@property (assign, nonatomic) FUZMapViewControllerMode mode;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longTapOnMapRecognizer;

@end