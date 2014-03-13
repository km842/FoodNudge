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

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocumentDir = [Paths objectAtIndex:0];
    _databasePath = [[NSString alloc] initWithString:[DocumentDir stringByAppendingPathComponent:@"products.sqlite3"]];
    BOOL success;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"products.sqlite3"];
    success = [fm fileExistsAtPath:_databasePath];
    if (success) {
        NSLog(@"exists in docs directory");
    } else {
        [fm copyItemAtPath:bundlePath toPath:_databasePath error:nil];
//        NSLog(@"%hhd", [fm fileExistsAtPath:_databasePath]);
    }

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

    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    NSCharacterSet *numberSet = [NSCharacterSet decimalDigitCharacterSet];
    
    if ([[self.name.text stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""] && [[self.lastName.text stringByTrimmingCharactersInSet:alphaSet] isEqualToString: @""] && [[self.height.text stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""] && [self.height.text intValue] < 220 & [self.height.text intValue] > 120 && [[self.weight.text stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""] && [self.weight.text intValue] > 35 && [self.weight.text intValue] < 140) {
       
        [self addUser];

        UIAlertView *good = [[UIAlertView alloc] initWithTitle: @"Congratulations! You've signed up!"
                                                       message: @"You'll be automatically logged in from now on!"
                                                      delegate: self
                                             cancelButtonTitle: @"OK"
                                             otherButtonTitles: nil];
        [good setTag:1];
        [good show];
        
    } else {
        UIAlertView *nameWrong = [[UIAlertView alloc] initWithTitle: @"Invalid Input!"
                                                            message: @"Please check the data in the fields to ensure that they are valid!"
                                                           delegate: self
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        [nameWrong setTag:2];
        [nameWrong show];

        }
    }

// Called when a user imputs their details. Adds user details to local user database. TODO calls html to add to database.
-(void) addUser {
    
    NSLog(@"add user");
    
    NSString *identifier = [[NSUUID UUID] UUIDString];
    NSLog(@"%@", identifier);
    NSString *name = [NSString stringWithFormat:@"%@ %@", self.name.text, self.lastName.text];
        
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:identifier forKey:@"id"];
    [preferences setValue:name forKey:@"name"];
    [preferences setValue:self.dob.text forKey:@"dob"];
    [preferences setValue:self.weight.text forKey:@"weight"];
    [preferences setValue:self.height.text forKey:@"height"];
    [preferences synchronize];
    NSLog(@"data saved!");
    
    NSLog(@"DAte holder = %@", _dateHolder);
    
    // Add to database here using post. create json object!
    NSDictionary *userInfo = @ {
        @"id" : identifier,
        @"name" : name,
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *failedConnection = [[UIAlertView alloc] initWithTitle:@"Sign Up Failure" message:@"An internet error occured so we could not sign you up. Please try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedConnection setTag:3];
    [failedConnection show];
    
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
    if (alertView.tag == 1) {
        self.name.text = @"";
        self.dob.text = @"";
        self.height.text = @"";
        self.weight.text = @"";
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self performSegueWithIdentifier:@"signUpSegueNo" sender:nil];
    } else {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    
}

@end