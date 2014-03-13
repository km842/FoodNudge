//
//  ProductsFromDatesTableViewController.h
//  FoodNudge
//
//  Created by Kunal  on 11/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsFromDatesTableViewController : UITableViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSMutableArray *tableDataId;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSMutableArray *filteredTableData;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

