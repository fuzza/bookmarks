//
//  FUZFetchedControllersBuilder.m
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZFetchedControllersBuilder.h"
#import "FUZBookmark.h"

@implementation FUZFetchedControllersBuilder

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if(self)
    {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request;
{
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
