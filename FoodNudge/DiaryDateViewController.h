//
//  DiaryDateViewController.h
//  FoodNudge
//
//  Created by Kunal  on 17/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryDateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (weak, nonatomic) IBOutlet UITableView *table;


@end
