//
//  FUZTableViewDataSource.h
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FUZDataSource.h"
#import "FUZFRCDataSource.h"

@interface FUZTableViewDataSource : FUZFRCDataSource <FUZDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *target;

- (id)selectedItem;

@end
