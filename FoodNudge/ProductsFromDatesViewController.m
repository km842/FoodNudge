//
//  ProductsFromDatesViewController.m
//  FoodNudge
//
//  Created by Kunal  on 17/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "ProductsFromDatesViewController.h"
#import "ProductDetailViewController.h"
#import "DiaryDatabase.h"
//#import "Products.h"

@interface ProductsFromDatesViewController ()

@end

@implementation ProductsFromDatesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated {

    [self.table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _tableData = [[NSMutableArray alloc] init];
    NSLog(@"Date in dates view controller: %@", _date);
    _tableData = [[DiaryDatabase database] productIdFromDate:_date];
    [self.table reloadData];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    _tableDataId = [[NSMutableArray alloc] init];
//    _responseData = [[NSMutableData alloc] init];
    
//    SEND USER ID TOO.
    
//    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/productsFromDate?date=%@", _date];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [conn start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource and Delegate Methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
//    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
//    cell.detailTextLabel.text = [_tableDataId objectAtIndex:indexPath.row];

    cell.textLabel.text = [[_tableData objectAtIndex:indexPath.row] name];
    return cell;
}

#pragma mark - NSURLConnectionDataDelegate Methods
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", [error description]);
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSArray *output = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:nil];
    for (NSDictionary *dict in output) {
        [_tableData addObject:[dict objectForKey:@"name"]];
        [_tableDataId addObject:[dict objectForKey:@"productId"]];
    }
    [self.table reloadData];
    NSLog(@"%@", _tableDataId);
}

#pragma mark - Segue preparation
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToDetail"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        ProductDetailViewController *dvc = (ProductDetailViewController *)segue.destinationViewController;
        NSLog(@"Option selected: %ld", (long)indexPath.row);
        NSString * dvcPodName = [_tableData objectAtIndex:indexPath.row];
        NSLog(@"Product name is: %@", dvcPodName);
        [dvc setProductName:dvcPodName];
        NSString *prodID = [_tableDataId objectAtIndex:indexPath.row];
        NSLog(@"%@", prodID);
        [dvc setProductId:prodID];

    }
    
    
}



@end
