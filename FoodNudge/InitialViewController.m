//
//  InitialViewController.m
//  FoodNudge
//
//  Created by Kunal  on 07/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "InitialViewController.h"

@implementation InitialViewController

#pragma mark - UIViewController
-(void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:NO];
    
    // Removes all instances of user default savings.
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSUserDefaults *checkUser = [NSUserDefaults standardUserDefaults];
    
    if (![checkUser stringForKey:@"id"]) {
        NSLog(@"%@", [checkUser valueForKey:@"id"]);
        NSLog(@"There is no user registerd!");
        
    } else {
        NSLog(@"User registered so perform segue");
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

#pragma mark - ViewController method to show and change textfields.
// Updates the dob textfield to display selected date.
-(void) updateTextField: (id) sender {
    UIDatePicker *dateP  = (UIDatePicker*) self.dob.inputView;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MM/yyyy"];
    NSString *dateFormatted = [format stringFromDate:dateP.date];
    self.dob.text = dateFormatted;
    [format setDateFormat:@"yyyy/MM/dd"];
    _dateHolder = [[NSString alloc] initWithString:[format stringFromDate:dateP.date]];
    NSLog(@"Date in sql form: %@", _dateHolder);
}

// Shows a message when a button is clicked.
-(IBAction) showMessage{
    NSLog(@"working!");
    //need a check here to see if parameters are correct so nothing bad happens in the database, stop sql injection etc.
    //add to ns user defaults
    
    [self addUser];
    
    UIAlertView *test = [[UIAlertView alloc] initWithTitle: @"Congratulations! You've signed up!"
                                                   message: @"You'll be automatically logged in from now on!"
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
    
    // check parameters. if ok return ok message else return parameter error and clear field that provided error.
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:identifier forKey:@"id"];
    [preferences setValue:self.name.text forKey:@"name"];
    [preferences setValue:self.dob.text forKey:@"dob"];
    [preferences setValue:self.weight.text forKey:@"weight"];
    [preferences setValue:self.height.text forKey:@"height"];
    [preferences synchronize];
    NSLog(@"data saved!");
    
    NSLog(@"DAte holder = %@", _dateHolder);
    
    // Add to database here using post. create json object!
    NSDictionary *userInfo = @ {
        @"id" : identifier,
        @"name" : self.name.text,
        @"dob" : _dateHolder,
        @"height" : self.height.text,
        @"weight" : self.weight.text,
    };
    NSLog(@"%@", userInfo);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/post"]];
    NSError *err;
    NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&err];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonRequest];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection scheduleInRunLoop: [NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
    
}

#pragma mark - NSURLConnectionDataDelegate protocols
-(void) connection: (NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

-(void) connection: (NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData: data];
}

-(void) connectionDidFinishLoading: (NSURLConnection *)connection {
    NSLog(@"to parse return info");
    NSDictionary *output = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:nil];
    NSLog(@"%@", [output objectForKey:@"id"]);
}

#pragma mark - UITextfieldDelegate
// Textfield delegate method to return the keyboard when DONE button is pressed.
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UIALertViewDelegate
// Alert View delegate method when button is pressed to clear the textfields.
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.name.text = @"";
    self.dob.text = @"";
    self.height.text = @"";
    self.weight.text = @"";
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    [self performSegueWithIdentifier:@"signUpSegueNo" sender:nil];
}

@end