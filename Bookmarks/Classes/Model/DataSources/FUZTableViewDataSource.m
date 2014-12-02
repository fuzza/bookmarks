//
//  FUZTableViewDataSource.m
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZTableViewDataSource.h"

@implementation FUZTableViewDataSource

- (instancetype)initWithTarget:(UITableView *)target
{
    self = [super init];
    if(self)
    {
        _target = target;
        _target.dataSource = self;
        _target.delegate = self;
    }
    return self;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    [super setFetchedResultsController:fetchedResultsController];
    [self.target reloadData];
}

#pragma mark UITableViewDelegate



#pragma mark UITableViewDataSource



#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.target beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.target endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    
    
}

@end
