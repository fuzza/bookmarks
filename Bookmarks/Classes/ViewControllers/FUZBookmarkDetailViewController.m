//
//  FUZBookmarkDetailViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/3/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZBookmarkDetailViewController.h"
#import "FUZFoursquareAPIClient.h"
#import "FUZFoursquareVenue.h"

@interface FUZBookmarkDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *loadNearbyLabel;

@property (strong, nonatomic) FUZFoursquareAPIClient *apiClient;

@end

@implementation FUZBookmarkDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = [self.bookmark title];
    
    self.apiClient = [[FUZFoursquareAPIClient alloc] init];
    
    [self.apiClient loadNearbyPlacesForLocation:self.bookmark.location withSuccess:^(NSArray *venues) {
        
    } andFailure:^(NSError *error) {
        
    }];
}

- (void)showDeletePrompt
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete bookmark" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weak_self = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [FUZBookmark deleteBookmark:weak_self.bookmark];
        [weak_self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)didTapShowOnMap:(id)sender {
    
}
- (IBAction)didTapBuildRoute:(id)sender {
    
}
- (IBAction)didTapLoadNearby:(id)sender {
    
}
- (IBAction)didTapDelete:(id)sender {
    [self showDeletePrompt];
}

@end
