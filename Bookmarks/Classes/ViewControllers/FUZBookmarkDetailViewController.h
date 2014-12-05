//
//  FUZBookmarkDetailViewController.h
//  Bookmarks
//
//  Created by fuzza on 12/3/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZViewController.h"
#import "FUZBookmark.h"

@interface FUZBookmarkDetailViewController : FUZViewController <UITabBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) FUZBookmark *bookmark;

@property (weak, nonatomic) IBOutlet UITableView *nearbyTable;

@end
