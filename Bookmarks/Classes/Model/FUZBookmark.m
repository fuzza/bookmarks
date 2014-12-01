//
//  FUZBookmark.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZBookmark.h"

@implementation FUZBookmark

@dynamic name;
@dynamic location;

+ (NSString *)entityName
{
    return NSStringFromClass(self);
}

#pragma mark MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

- (NSString *)title
{
    return self.name ? self.name : @"Unnamed";
}

@end
