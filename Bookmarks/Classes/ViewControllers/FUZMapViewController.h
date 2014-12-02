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

@class FUZFetchedControllersBuilder;

@interface FUZMapViewController : UIViewController <NSFetchedResultsControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) FUZFetchedControllersBuilder *frcBuilder;

@end
