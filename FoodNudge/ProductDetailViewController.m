//
//  ProductDetailViewController.m
//  FoodNudge
//
//  Created by Kunal  on 29/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "ProductDetailViewController.h"
#import "SearchViewController.h"
#import "Products.h"
#import "ProductsDatabase.h"

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
    local = NO;
//    NSLog(@"NOW IN THIS VIEW CONTROLLER");
//    NSLog(@"HERE: %@", _productName);
//    NSLog(@"id in here: %@", _productId);
//    _productNameLabel.text = @"Product Name Here";
}

- (void) viewWillAppear:(BOOL)animated {
    _productNameLabel.text = _productName;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0/255.0 green:143.0/255.0 blue:220.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


    
    //download our data here!
    
    _product = [[ProductsDatabase database] getProductInfoById:_productId];
    NSLog(@"%@", _product.name);
    
    if (_product == nil) {
        NSLog(@"started conncection");
        _responseData = [[NSMutableData alloc] init];
        
        NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/product?id=%@", _productId];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [_conn start];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        [self createLabels:_product];
    }
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
    
    NSString* calories = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Calories_Count"];
    NSString *salt = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Salt_Grammes"];
    NSString *sugar = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Sugar_Grammes"];
    NSString *fat= [[productInfo objectAtIndex:0] valueForKey:@"RDA_Fat_Grammes"];
    NSString *saturates= [[productInfo objectAtIndex:0] valueForKey:@"RDA_Saturates_Grammes"];
    
    _product = [[Products alloc] initWithId:_productId name:_productName calories:calories sugar:sugar fat:fat saturates:saturates salt:salt];
    [[ProductsDatabase database] insertProductwithId:_productId andName:_productName andCalories:calories andSugar:sugar andFat:fat andSaturates:saturates andSalt:salt];
    
    NSString *imageURL = [[productInfo objectAtIndex:0] valueForKey:@"ImagePath"];
    NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:imageURL]];
    [_productImage setImage:[UIImage imageWithData:imageData]];

    [self createLabels:_product];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    NSLog(@"getting data : %@", [[productInfo objectAtIndex:0] valueForKey:@"RDA_Calories_Count"]);
//    NSLog(@"array data: %@", productInfo);
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

-(void) createLabels: (Products*) product {
    _calorieLabel.text = product.calories;
    _sugarLabel.text = product.sugar;
    _fatLabel.text = product.fat;
    _satFatLabel.text = product.saturates;
    _saltLabel.text = product.salt;
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
