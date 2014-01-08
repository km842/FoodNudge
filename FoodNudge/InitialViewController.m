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
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker setDate:[NSDate date]];
    [picker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dob setInputView:picker];
}

-(void) updateTextField: (id) sender {
    UIDatePicker *dateP  = (UIDatePicker*) self.dob.inputView;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyy"];
    NSString *dateFormatted = [format stringFromDate:dateP.date];
    self.dob.text = dateFormatted;
}

-(IBAction) showMessage{
    NSLog(@"working!");
    
    
    NSString *identifier = [[NSUUID UUID] UUIDString];
    NSLog(@"%@", identifier);
    
    UIAlertView *test = [[UIAlertView alloc] initWithTitle: @"Working!"
                                                   message: @"Hopefully this is working?!"
                                                   delegate: nil
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles: nil];
    [test show ];
    
    NSLog(@"name: %@", _name.text);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
