//
//  InitialViewController.h
//  FoodNudge
//
//  Created by Kunal  on 07/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 InitialViewController handles the user login and processes existing users.
 */
@interface InitialViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate>

/*!
 @param UITextfield name
 Stores the name of the user in a textfield displayed on the screen.
 */
@property (weak, nonatomic) IBOutlet UITextField *name;

/*!
 @param UITextField lastName
 Stores the last name of the user in a textfield displayed on the screen
 */
@property (weak, nonatomic) IBOutlet UITextField *lastName;

/*!
 @param UITextfield dob
 Stores the date of birth of the user in a textfield displayed on the screen.
 */
@property (weak, nonatomic) IBOutlet UITextField *dob;

/*!
 @param UITextfield height
 Stores the height of the user in a textfield displayed on the screen.
 */
@property (weak, nonatomic) IBOutlet UITextField *height;

/*!
 @param UITextfield weight
 Stores the weight of the user in a textfield displayed on the screen.
 */
@property (weak, nonatomic) IBOutlet UITextField *weight;

/*!
 @param NSMutable Data responseData
 Holds the data that is sent back from the user sending their
 credentials*/
@property (strong, nonatomic) NSMutableData *responseData;

/*!
 @param NSString dateHolder
 Holds the converted date to input into the database correctly.
 */
@property (strong, nonatomic) NSString *dateHolder;

/*!
 @param NSString databasePath
 Used to ensure that the local sqlite database is in the correct directory.
 */
@property (strong, nonatomic) NSString *databasePath;

/*!
 @param UIButton signUpButton
 Used that when the user completes their details, they press the button that segues them to another view.
 */
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;


/*!
 @Function IBAction showMessage
  @result
 Shows the user a message to determine whether they have successfully registered.
 */
-(IBAction) showMessage;

/*!
 @Function void updateTextField
 @param sender
 USing sender we can distinguish which one of the interfaces is sending the message, and thus take the appropriate action.
 @result
 The textfield is updated with the value in the keyboard/date picker etc
 */
-(void) updateTextField:(id) sender;

/*!
 @Function void addUser
 @result
 Adds a user to the iPhone using user defaults and to the database using the API.
 */
-(void) addUser;


@end
