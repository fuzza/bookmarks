//
//  FUZFRCDataSource.m
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZFRCDataSource.h"

@implementation FUZFRCDataSource

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    [self reloadDataSource];
}

- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    } else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:nil];
        [self reloadDataSource];
    }
}

- (void)reloadDataSource
{
     NSAssert(NO, @"This is an abstract method and should be overridden.");
}

- (NSArray *)items
{
    return self.fetchedResultsController.fetchedObjects;
}

@end
