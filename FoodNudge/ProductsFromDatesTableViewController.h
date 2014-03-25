//
//  ProductsFromDatesTableViewController.h
//  FoodNudge
//
//  Created by Kunal  on 11/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 Part of the diary, ProductsFromDatesTableViewController allows the user to search through their products by date.
 */

@interface ProductsFromDatesTableViewController : UITableViewController <NSURLConnectionDataDelegate>

/*!
 @param NSMutableData responseData
 Data received from url request.
 */
@property (strong, nonatomic) NSMutableData *responseData;

/*!
 @param NSMutableArray tableData
 Array holding all the table data required to output cells.
 */
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSMutableArray *tableDataId;

/*!
 @param UITableView
 Tableview that access the table in the view controller. Table instance that allows manipulation of table contents and returning information about the table.
 */
@property (weak, nonatomic) IBOutlet UITableView *table;

/*!
 @param [param name]
 Holds the date variable from the previous view controller to ensure the correct products are shown.
 */
@property (strong, nonatomic) NSString *date;

/*!
 @param NSInteger selectedRow
 Holds the selected row of the table to pass the correct cell information through to the next view controller.
 */
@property (assign, nonatomic) NSInteger selectedRow;

/*!
 @param NSMutableArray filteredTableData
 When the user searchs for a product the filtered table array is populated with the results.
 */
@property (strong, nonatomic) NSMutableArray *filteredTableData;

/*!
 @param UISearchBar searchBar
 A visual search bar at the top of the view allowing users to search for products.
 */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/*!
 @Function update
 @result
 Updates the table to show newly entered data.
 */
-(void) update;
@end

