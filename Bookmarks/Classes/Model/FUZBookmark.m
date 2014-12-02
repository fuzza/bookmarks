//
//  FUZBookmark.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZBookmark.h"

@implementation FUZBookmark

@dynamic name;
@dynamic location;

+ (instancetype)createBookmarkFromLocation:(CLLocation *)location inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    FUZBookmark* newBookmark = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:managedObjectContext];
    newBookmark.location = location;
    return newBookmark;
}

+ (NSFetchedResultsController *)fetchedResultsControllerForAllBookmarksInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *allBookmarksRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    [allBookmarksRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:allBookmarksRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

- (NSString *)title
{
    return self.name ? self.name : @"Unnamed";
}

@end
