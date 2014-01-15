//
//  SearchViewController.m
//  FoodNudge
//
//  Created by Kunal  on 11/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController

-(void) viewDidLoad {
    [super viewDidLoad];
}

-(void) searchValue: (NSString *) withName {
    [self.indicator startAnimating];
    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/hello?id=%@", withName];
    NSLog(@"%@", withName);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:url]];
    _responseData = [[NSMutableData alloc] init];
    
    //    _responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    //    NSDictionary *output = [NSJSONSerialization JSONObjectWithData: _responseData options:0 error:nil];
    //    _tableData = [output objectForKey:@"Products"];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchValue:searchBar.text];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    NSLog(@"%@", searchBar.text);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
#pragma mark - UITableViewDataSource methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"Products";
//}

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
    NSLog(@"Selected :");
}

#pragma mark - NSURLConnectionDeleage Methods
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *output = [NSJSONSerialization JSONObjectWithData: _responseData options:0 error:nil];
    _tableData = [output objectForKey:@"Products"];
    NSLog(@"%@", _tableData);
    [self.indicator stopAnimating];
    [self.table reloadData];
}

@end
