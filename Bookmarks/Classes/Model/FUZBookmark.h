//
//  FUZBookmark.h
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FUZBookmark : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, assign) CLLocation * location;

- (BOOL)isUnnamed;

+ (NSString *)entityName;
+ (NSFetchedResultsController *)fetchedResultsControllerForAllBookmarksInContext:(NSManagedObjectContext *)context;
+ (instancetype)createBookmarWithCoordinates:(CLLocationCoordinate2D)coordinates inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (void)deleteBookmark:(FUZBookmark *)bookmark;

@end
