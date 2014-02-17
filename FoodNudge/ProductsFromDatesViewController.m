//
//  ProductsFromDatesViewController.m
//  FoodNudge
//
//  Created by Kunal  on 17/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "ProductsFromDatesViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _tableData = [[NSMutableArray alloc] init];
    _responseData = [[NSMutableData alloc] init];
    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/productsFromDate?date=\"%@\"", _date];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource and Delegate Methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [_tableData count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
//    add text here to cell
    return cell;
}

#pragma mark - NSURLConnectionDataDelegate Methods
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
}








@end
