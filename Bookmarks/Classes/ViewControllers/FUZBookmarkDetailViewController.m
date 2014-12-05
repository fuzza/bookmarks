//
//  FUZBookmarkDetailViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/3/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZBookmarkDetailViewController.h"
#import "FUZFoursquareSearchRequest.h"
#import "FUZFoursquareVenue.h"
#import "FUZMacroses.h"
#import "FUZConstants.h"
#import "FUZMapViewController.h"

@interface FUZBookmarkDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadNearbyButton;

@property (strong, nonatomic) FUZFoursquareSearchRequest *apiClient;
@property (strong, nonatomic) NSArray *places;

@end

@implementation FUZBookmarkDetailViewController

#pragma mark UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = [self.bookmark title];
    self.apiClient = [[FUZFoursquareSearchRequest alloc] init];
    
    if([self.bookmark isUnnamed])
    {
        [self showTable:YES];
        [self loadVenues];
    }
    else
    {
        [self showTable:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.apiClient cancelRequest];
    [super viewWillDisappear:animated];
}

- (void)showTable:(BOOL)show
{
    self.nearbyTable.hidden = !show;
    self.loadNearbyButton.hidden = !self.nearbyTable.hidden;
}

- (void)showDeletePrompt
{
    DEFINE_WEAK(self);
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [FUZBookmark deleteBookmark:weak_self.bookmark];
        [weak_self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self showAlertControllerWithTitle:@"Delete bookmark" andMessage:@"Are you sure?" withActions:@[cancelAction, okAction]];
}

#pragma mark Networking

- (void)loadVenues
{
    DEFINE_WEAK(self);
    [self.apiClient loadNearbyPlacesForLocation:self.bookmark.location withSuccess:^(NSArray *venues) {
        weak_self.places = venues;
        [weak_self.nearbyTable reloadData];
    } andFailure:^(NSError *error) {
        [weak_self showErrorMessage:error];
    }];
}

#pragma mark IBActions

- (IBAction)didTapShowOnMap:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowOnMapNotification object:self.bookmark];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didTapBuildRoute:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBuildRouteNotification object:self.bookmark];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didTapLoadNearby:(id)sender {
    self.nearbyTable.hidden = NO;
    self.loadNearbyButton.hidden = YES;
    [self loadVenues];
}

- (IBAction)didTapDelete:(id)sender {
    [self showDeletePrompt];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUZFoursquareVenue *selectedPlace = [self.places objectAtIndex:indexPath.row];
    self.bookmark.name = selectedPlace.name;
    self.nameLabel.text = self.bookmark.name;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUZFoursquareVenue *object = [self.places objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCellReuseIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = object.name;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

@end
