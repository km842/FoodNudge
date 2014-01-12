//
//  InitialViewController.m
//  FoodNudge
//
//  Created by Kunal  on 07/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "InitialViewController.h"

@implementation InitialViewController

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    // Removes all instances of user default savings.
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
   
    NSUserDefaults *checkUser = [NSUserDefaults standardUserDefaults];
    
    if (! [checkUser stringForKey:@"id"]) {
        NSLog(@"%@", [checkUser valueForKey:@"id"]);
        UIAlertView *working = [[UIAlertView alloc] initWithTitle:@"No user registered!" message:@"No user registered!" delegate:nil cancelButtonTitle:@"No user registered!" otherButtonTitles: nil];
        [working show];
        
    } else {
        NSLog(@"in here");
        UIAlertView *working = [[UIAlertView alloc] initWithTitle:@"User Registered!" message:@"User Registered!" delegate:nil cancelButtonTitle:@"User Registered!" otherButtonTitles: nil];
        [working show];
        
        //change view controller here.
        
        [self performSegueWithIdentifier:@"signUpSegueNo" sender:nil];
    }

}

// Load the date picker for texfield option.
-(void) viewDidLoad {
    [super viewDidLoad];
    
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDate;
    [picker setDate:[NSDate date]];
    [picker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dob setInputView:picker];
}


// Updates the dob textfield to display selected date.
-(void) updateTextField: (id) sender {
    UIDatePicker *dateP  = (UIDatePicker*) self.dob.inputView;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyy"];
    NSString *dateFormatted = [format stringFromDate:dateP.date];
    self.dob.text = dateFormatted;
}

// Shows a message when a button is clicked.
-(IBAction) showMessage{
    NSLog(@"working!");
    //need a check here to see if parameters are correct so nothing bad happens in the database, stop sql injection etc.
    //add to ns user defaults
    
    [self addUser];
    
    UIAlertView *test = [[UIAlertView alloc] initWithTitle: @"Working!"
                                                   message: @"Hopefully this is working?!"
                                                   delegate: self
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles: nil];
    [test show];
}

// Called when a user imputs their details. Adds user details to local user database. TODO calls html to add to database.
-(void) addUser {
    
    NSLog(@"add user");
    
    NSString *identifier = [[NSUUID UUID] UUIDString];
    NSLog(@"%@", identifier);
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:identifier forKey:@"id"];
    [preferences setValue:self.name.text forKey:@"name"];
    [preferences setValue:self.dob.text forKey:@"dob"];
    [preferences setValue:self.weight.text forKey:@"weight"];
    [preferences setValue:self.height.text forKey:@"height"];
    [preferences synchronize];
    
    NSLog(@"data saved!");
    
}

// Textfield delegate method to return the keyboard when DONE button is pressed.
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

// Alert View delegate method when button is pressed to clear the textfields.
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.name.text = @"";
    self.dob.text = @"";
    self.height.text = @"";
    self.weight.text = @"";
}

@end