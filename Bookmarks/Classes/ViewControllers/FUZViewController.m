//
//  FUZViewController.m
//  Bookmarks
//
//  Created by fuzza on 12/5/14.
//  Copyright (c) 2014 fuzza. All rights reserved.
//

#import "FUZViewController.h"

@implementation FUZViewController

- (void)showErrorMessage:(NSError *)error
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:nil];
    [self showAlertControllerWithTitle:@"Error" andMessage:error.localizedDescription withActions:@[okAction]];
}

- (void)showMessage:(NSString *)message
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [self showAlertControllerWithTitle:@"" andMessage:message withActions:@[okAction]];
}

- (void)showAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message withActions:(NSArray *)actions
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for(UIAlertAction *action in actions)
    {
        [alert addAction:action];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

@end
