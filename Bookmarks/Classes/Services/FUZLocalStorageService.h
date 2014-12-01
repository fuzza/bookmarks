//
//  LocalStorageService.h
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FUZLocalStorageService : NSObject

+ (instancetype)sharedInstance;

- (void)createBookmarkFromLocation:(CLLocation *)location;

- (NSFetchedResultsController *)fetchedResultControllerForAllBookmarks;

@end
