//
//  InitialViewController.m
//  FoodNudge
//
//  Created by Kunal  on 07/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "InitialViewController.h"

@implementation InitialViewController

-(void) viewDidLoad {
    [super viewDidLoad];
}

-(IBAction)showMessage{
    NSLog(@"working!");
    UIAlertView *test = [[UIAlertView alloc] initWithTitle:@"Working!" message:@"working, i hope?!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [test show ];
    
    NSLog(@"name: %@", _name.text);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
