//
//  ProductsFromDatesTableViewController.m
//  FoodNudge
//
//  Created by Kunal  on 11/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "ProductsFromDatesTableViewController.h"
#import "ProductDetailViewController.h"
#import "DiaryDatabase.h"
#import "Products.h"

@interface ProductsFromDatesTableViewController ()

@end

@implementation ProductsFromDatesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableData = [[NSMutableArray alloc] init];
    _tableData = [[DiaryDatabase database] productIdFromDate:_date];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(update) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    _filteredTableData = [NSMutableArray arrayWithCapacity:[_tableData count]];
    [self.table reloadData];
    
}
-(void) update {
    _tableData = [[DiaryDatabase database] productIdFromDate:_date];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    //    _tableDataId = [[NSMutableArray alloc] init];
    //    _responseData = [[NSMutableData alloc] init];
    
    //    SEND USER ID TOO.
    
    //    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/productsFromDate?date=%@", _date];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //    [conn start];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _date = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredTableData count];
    } else {
        return [_tableData count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    Products *p;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        p = [_filteredTableData objectAtIndex:indexPath.row];
    } else {
        p = [_tableData objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [p name];
    cell.detailTextLabel.text = [p pid];
    
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

        Products * p;
        if(self.searchDisplayController.active) {
            NSLog(@"here1111");
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            p = [self.filteredTableData objectAtIndex:indexPath.row];
        }
        else {
            NSLog(@"ikfajkajks");
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            p = [self.tableData objectAtIndex:indexPath.row];
        }
        ProductDetailViewController *dvc = (ProductDetailViewController *)segue.destinationViewController;
        [dvc setProductId:[p pid]];
        [dvc setProductName:[p name]];

    }
}


 #pragma mark Content Filtering
 -(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {

     [self.filteredTableData removeAllObjects];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
     _filteredTableData = [NSMutableArray arrayWithArray:[_tableData filteredArrayUsingPredicate:predicate]];
 }

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

@end
