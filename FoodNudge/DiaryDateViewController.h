//
//  DiaryDateViewController.h
//  FoodNudge
//
//  Created by Kunal  on 17/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 Lists all the dates the user entered information.
 */
@interface DiaryDateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>

/*!
 @param NSMutableData responseData
 Holds the data from the url request to the API.
 */
@property (strong, nonatomic) NSMutableData *responseData;

/*!
 @param NSMutableArray tableData
 Holds the data to be shown in the table.
 */
@property (strong, nonatomic) NSMutableArray *tableData;

/*!
 @param UITableView table
 Outlet of a table that is used to perform tasks on the table.
 */
@property (weak, nonatomic) IBOutlet UITableView *table;

/*!
 @param NSInteger selectedRow
 Use to decipher the selected row of the table to ensure that the next view controller receives the correct information.
 */
@property (assign, nonatomic) NSInteger selectedRow;


@end
