//
//  FUZPopoverContentViewController.h
//  Bookmarks
//
//  Created by fuzza on 12/2/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FUZBookmarksPopoverDelegate;
@class FUZBookmark;

@interface FUZBookmarksPopoverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) id <FUZBookmarksPopoverDelegate> delegate;

@end

@protocol FUZBookmarksPopoverDelegate <NSObject>

- (void)bookmarksPopover:(FUZBookmarksPopoverViewController *)popover didSelectBookmark:(FUZBookmark *)bookmark;

@end