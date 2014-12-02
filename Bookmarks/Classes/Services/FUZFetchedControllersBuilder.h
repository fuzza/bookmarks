//
//  FUZFetchedControllersBuilder.h
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface FUZFetchedControllersBuilder : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request;

@end
