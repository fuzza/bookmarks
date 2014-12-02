//
//  FUZCoreDataStack.h
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface FUZCoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext* managedObjectContext;

@end
