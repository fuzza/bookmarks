//
//  FUZViewController.h
//  Bookmarks
//
//  Created by fuzza on 12/5/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FUZViewController : UIViewController

- (void)showErrorMessage:(NSError *)error;
- (void)showMessage:(NSString *)message;
- (void)showAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message withActions:(NSArray *)actions;

@end
