//
//  InitialViewController.h
//  FoodNudge
//
//  Created by Kunal  on 07/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *dob;
@property (weak, nonatomic) IBOutlet UITextField *height;
@property (weak, nonatomic) IBOutlet UITextField *weight;

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *dateHolder;
@property (weak, nonatomic) IBOutlet UITextField *lastName;

@property (strong, nonatomic) NSString *databasePath;



- (IBAction)showMessage;


@end
