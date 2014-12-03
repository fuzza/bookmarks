//
//  FUZBookmarksListViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/3/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZBookmarksListViewController.h"
#import "FUZBookmarkDetailViewController.h"

#import "FUZTableViewDataSource.h"
#import "FUZBookmark.h"

@interface FUZBookmarksListViewController()

@property (nonatomic, strong) FUZTableViewDataSource *tableDataSource;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FUZBookmarksListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableDataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableDataSource.paused = YES;
}

- (void)setupDataSource
{
    self.tableDataSource = [[FUZTableViewDataSource alloc] initWithTarget:self.tableView];
    self.tableDataSource.fetchedResultsController = [FUZBookmark fetchedResultsControllerForAllBookmarksInContext:self.managedObjectContext];
}

- (IBAction)editButtonDidTap:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if(self.tableView.editing)
    {
        [self.editButton setTitle:@"Done"];
    }
    else
    {
        [self.editButton setTitle:@"Edit"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"list_to_detail_segue"])
    {
        FUZBookmarkDetailViewController *destinationController = segue.destinationViewController;
        destinationController.bookmark = [self.tableDataSource selectedItem];
    }
}

@end
