//
//  FUZMapViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/1/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "FUZMapViewController.h"

typedef NS_ENUM(NSInteger, FUZMapViewControllerMode)
{
    FUZMapViewControllerModeBookmarks = 0,
    FUZMapViewControllerModeRoute
};

@interface FUZMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end

@implementation FUZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)longTapOnMapView:(UILongPressGestureRecognizer *)sender {
}

@end
