//
//  ProductsFromDatesViewController.h
//  FoodNudge
//
//  Created by Kunal  on 17/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsFromDatesViewController : UITableViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSMutableArray *tableDataId;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSString *date;

@property (assign, nonatomic) NSInteger selectedRow;


@end
