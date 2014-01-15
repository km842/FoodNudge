//
//  SearchViewController.h
//  FoodNudge
//
//  Created by Kunal  on 11/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
