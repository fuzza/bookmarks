//
//  FUZBookmark.h
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FUZBookmark : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, assign) id location;

@end
