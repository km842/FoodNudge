//
//  SearchViewController.m
//  FoodNudge
//
//  Created by Kunal  on 11/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "SearchViewController.h"
#import "ProductDetailViewController.h"
#import "ProgressHUD.h"


@implementation SearchViewController

-(void) viewDidLoad {
    [super viewDidLoad];    
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    }

-(void) searchValue: (NSString *) withName {
    [self.indicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/hello?id=%@", withName];
    NSLog(@"%@", withName);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:url]];
    _responseData = [[NSMutableData alloc] init];
    
    //    _responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    [ProgressHUD show:@"Loading Data....."];
    
    //    NSDictionary *output = [NSJSONSerialization JSONObjectWithData: _responseData options:0 error:nil];
    //    _tableData = [output objectForKey:@"Products"];
}

- (void) viewDidDisappear:(BOOL)animated {
    _tableData = nil;
    [ProgressHUD dismiss];
    [self.table reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *withoutSpaces = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self searchValue: withoutSpaces];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    NSLog(@"%@", withoutSpaces);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [ProgressHUD dismiss];
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIndentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: cellIndentifier];
    }
        cell.textLabel.text = [[_tableData objectAtIndex:indexPath.row] valueForKey:@"Name"];
        cell.detailTextLabel.text = [[_tableData objectAtIndex:indexPath.row] valueForKey:@"ProductId"];
   
//    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"Selected : %@", [[_tableData objectAtIndex:indexPath.row] valueForKey:@"Name"]);
    _selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"productDetail" sender:self];
}

#pragma mark - NSURLConnectionDeleage Methods
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *output = [NSJSONSerialization JSONObjectWithData: _responseData options:0 error:nil];
    _tableData = [output objectForKey:@"Products"];
//    NSLog(@"%@", _tableData);
    [self.indicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [ProgressHUD showSuccess:@"Got your Data" Interacton:YES];
    [self.table reloadData];
}

#pragma mark - Method to transfer data to next view
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"in here!");
    if ([segue.identifier isEqualToString:@"productDetail"]) {
//        NSLog(@"here now");
//        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
//        NSLog(@"%ld", (long)indexPath.row);
        ProductDetailViewController *dvc = (ProductDetailViewController *)segue.destinationViewController;
//        NSLog(@"controller instantiated");
//        NSLog(@"Option selected: %ld", (long)_selectedRow);
        NSString * dvcPodName = [[_tableData objectAtIndex:_selectedRow] valueForKey:@"Name"];
//        NSLog(@"Product name is: %@", dvcPodName);
        [dvc setProductName:dvcPodName];
        NSString *prodID = [[_tableData objectAtIndex: _selectedRow] valueForKey:@"ProductId"];
//        NSLog(@"%@", prodID);
        [dvc setProductId:prodID];
            }
}


@end
