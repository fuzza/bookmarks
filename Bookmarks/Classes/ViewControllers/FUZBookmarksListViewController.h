//
//  FUZBookmarksListViewController.h
//  Bookmarks
//
//  Created by fuzza on 12/3/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface FUZBookmarksListViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
