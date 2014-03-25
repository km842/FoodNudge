//
//  SearchViewController.h
//  FoodNudge
//
//  Created by Kunal  on 11/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 SearchViewController manages user interaction when searching for a product.
 */
@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSURLConnectionDataDelegate>

/*!
 @param NSArray tableData
 Holds the data to be displayed by the table.
 */
@property (strong, nonatomic) NSArray *tableData;

/*!
 @param NSMutableData responseData
 Holds the data from the URL request to the API.
 */
@property (strong, nonatomic) NSMutableData *responseData;

/*!
 @param UITableView table
 Instance of table that provides methods to alter values of table.
 */
@property (weak, nonatomic) IBOutlet UITableView *table;

/*!
 @param UISearchBar searchBar
 Search bar that allows the user to search for a specified product using text or number.
 */
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (assign, nonatomic) NSInteger selectedRow;
@end
