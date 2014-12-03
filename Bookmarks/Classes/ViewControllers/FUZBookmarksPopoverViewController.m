//
//  FUZPopoverContentViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZBookmarksPopoverViewController.h"
#import "FUZBookmark.h"

@implementation FUZBookmarksPopoverViewController

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectBookmark:[self.items objectAtIndex:indexPath.row]];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUZBookmark *object = [self.items objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookmarkPopupReuseIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = object.name;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

@end
