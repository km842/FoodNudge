//
//  DiaryDateViewController.m
//  FoodNudge
//
//  Created by Kunal  on 17/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "DiaryDateViewController.h"
#import "ProductsFromDatesTableViewController.h"
#import "DiaryDatabase.h"

@interface DiaryDateViewController ()

@end

@implementation DiaryDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _tableData = [[NSMutableArray alloc] init];
    _responseData = [[NSMutableData alloc] init];
    
    //    add user defaults here!!!!!!!!!!
    
    _tableData = [[DiaryDatabase database] uniqueDates];
    //    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/getDates"];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    [conn start];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSArray *array = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:nil];
    for (NSDictionary *dict in array) {
        //        NSLog(@"%@", [dict objectForKey:@"dateConsumed"]);
        [_tableData addObject: [dict objectForKey:@"dateConsumed"]];
    }
    [self.table reloadData];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString *date = [_tableData objectAtIndex:indexPath.row];
    NSLog(@"%@", date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    NSDate *date1 = [formatter dateFromString:date];
    [formatter setDateFormat:@"dd MMM, yyyy"];
    cell.textLabel.text = [formatter stringFromDate:date1];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedRow = indexPath.row;

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toProducts"]) {
        ProductsFromDatesTableViewController *dvc = (ProductsFromDatesTableViewController *) segue.destinationViewController;
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        NSString *date = [_tableData objectAtIndex:indexPath.row];
        //        NSLog(@"chosen row in here: %i", _selectedRow);
        [dvc setDate:date];
        date = @"";
    }
}
@end
