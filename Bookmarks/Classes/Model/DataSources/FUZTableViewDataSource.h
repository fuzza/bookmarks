//
//  FUZTableViewDataSource.h
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "FUZDataSource.h"

@interface FUZTableViewDataSource : NSObject <FUZDataSource, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) UITableView *target;

- (id)selectedItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSArray *)items;
- (void)reloadDataSource;

@end
