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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    _productNameLabel.text = @"Product Name Here";
}

- (void) viewWillAppear:(BOOL)animated {
    _productNameLabel.text = _productName;
    
    //download our data here!
    _responseData = [[NSMutableData alloc] init];
    
    NSString *url = [NSString stringWithFormat:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/product?id=%@", _productId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    
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
    _calorieLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Calories_Count"];
    _saltLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Salt_Grammes"];
    _sugarLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Sugar_Grammes"];
    _fatLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Fat_Grammes"];
    _satFatLabel.text = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Saturates_Grammes"];
    NSString *imageURL = [[productInfo objectAtIndex:0] valueForKey:@"ImagePath"];
    NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:imageURL]];
    [_productImage setImage:[UIImage imageWithData:imageData]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - IBAction Method (Add to diary)
- (IBAction)addToDiary:(id)sender {
    UIAlertView *addMessage = [[UIAlertView alloc] initWithTitle:@"Add to Dictionary" message:@"Add this item to dictionary" delegate:self cancelButtonTitle:@"Canvel" otherButtonTitles:@"Add", nil];
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
