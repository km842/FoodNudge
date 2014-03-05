//
//  ProductDetailViewController.m
//  FoodNudge
//
//  Created by Kunal  on 29/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "ProductDetailViewController.h"
#import "SearchViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

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
    NSLog(@"NOW IN THIS VIEW CONTROLLER");
    NSLog(@"HERE: %@", _productName);
    NSLog(@"id in here: %@", _productId);
//    _productNameLabel.text = @"Product Name Here";
}

- (void) viewWillAppear:(BOOL)animated {
    _productNameLabel.text = _productName;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];


    
    //download our data here!
    _responseData = [[NSMutableData alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/product?id=%@", _productId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
     _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [_conn start];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
}

-(void) viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_conn cancel];
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
    NSDictionary *output = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:Nil];
    NSArray *productInfo = [[NSArray alloc] init];
    productInfo = [output objectForKey: @"Products"];
    
//    use products class?
    
    _calorieLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Calories_Count"];
    _saltLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Salt_Grammes"];
    _sugarLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Sugar_Grammes"];
    _fatLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Fat_Grammes"];
    _satFatLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Saturates_Grammes"];
    NSString *imageURL = [[productInfo objectAtIndex:0] valueForKey:@"ImagePath"];
    NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:imageURL]];
    [_productImage setImage:[UIImage imageWithData:imageData]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"getting data : %@", [[productInfo objectAtIndex:0] valueForKey:@"RDA_Calories_Count"]);
    NSLog(@"array data: %@", productInfo);
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get information. Please check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorMessage show];
}

#pragma mark - IBAction Method (Add to diary)
- (IBAction)addToDiary:(id)sender {
    UIAlertView *addMessage = [[UIAlertView alloc] initWithTitle:@"Add to Diary" message:@"Add this item to dictionary" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [addMessage show];
}

#pragma mark - UIAlertiView Delegate Methods

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clicked button = %i", buttonIndex);
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if (buttonIndex == 1) {
        NSLog(@"hit okay button!");
//      add to database here! then prop view controller
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
