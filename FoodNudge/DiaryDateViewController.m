//
//  DiaryDateViewController.m
//  FoodNudge
//
//  Created by Kunal  on 17/02/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "DiaryDateViewController.h"
#import "ProductsFromDatesViewController.h"

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
    NSLog(@"Now in dd viEW CONTROLLER");
    _tableData = [[NSMutableArray alloc] init];
    _responseData = [[NSMutableData alloc] init];
    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/getDates"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
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
    NSLog(@"Connection did finish loading");
    NSArray *array = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:nil];
    NSLog(@"here");
    NSLog(@"%d", [array count]);
    for (NSDictionary *dict in array) {
        NSLog(@"%@", [dict objectForKey:@"dateConsumed"]);
        [_tableData addObject: [dict objectForKey:@"dateConsumed"]];
        NSLog(@"%d", [_tableData count]);
    }
    [self.table reloadData];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Count = %i", [_tableData count]);
    return [_tableData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected row");
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toProducts"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        ProductsFromDatesViewController *dvc = (ProductsFromDatesViewController *) segue.destinationViewController;
        NSString *date = [_tableData objectAtIndex:indexPath.row];
        [dvc setDate:date];
    }
}
@end
