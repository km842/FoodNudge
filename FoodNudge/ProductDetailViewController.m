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
#import "DiaryDatabase.h"
#import "ProgressHUD.h"
#import "MapViewController.h"

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"USer id is : %@", [defaults objectForKey:@"id"]);
    NSString *check = [NSString stringWithFormat:@"\'%@\'", [defaults objectForKey:@"id"]];
    NSLog(@"user id 2 is :%@", check);


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
        [ProgressHUD show:@"Loading Data....."];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        [self createLabels:_product];
        [self performSelectorOnMainThread:@selector(createLabels:) withObject:_product waitUntilDone:YES];
      
        NSLog(@"lael text is %@", _calorieLabel.text);

    }
   }

-(void) viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [_conn cancel];
    [ProgressHUD dismiss];
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
    
    //check values here!
    NSString* calories = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Calories_Count"];
    NSString *salt = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Salt_Grammes"];
    NSString *sugar = [[productInfo objectAtIndex:0] valueForKey:@"RDA_Sugar_Grammes"];
    NSString *fat= [[productInfo objectAtIndex:0] valueForKey:@"RDA_Fat_Grammes"];
    NSString *saturates= [[productInfo objectAtIndex:0] valueForKey:@"RDA_Saturates_Grammes"];
    
    _product = [[Products alloc] initWithId:_productId name:_productName calories:calories sugar:sugar fat:fat saturates:saturates salt:salt];
    [[ProductsDatabase database] insertProductwithId:_productId andName:_productName andCalories:calories andSugar:sugar andFat:fat andSaturates:saturates andSalt:salt];
    
//    NSString *imageURL = [[productInfo objectAtIndex:0] valueForKey:@"ImagePath"];
//    NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:imageURL]];
//    [_productImage setImage:[UIImage imageWithData:imageData]];

    [self createLabels:_product];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [ProgressHUD showSuccess:@"Food Data!" Interacton:YES];
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *n = [NSNumber numberWithInteger:2500 - [[DiaryDatabase database] caloriesForTheDay]];
    
//    NSString *cal = [NSString stringWithFormat:@"%d", 2500 - [[DiaryDatabase database] caloriesForTheDay]];
//    NSLog(@"calorsadsa here : %@",cal);
    
    _caloriesLeftLabel.text = [formatter stringFromNumber:n];
    }

#pragma mark - UIAlertiView Delegate Methods
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if (buttonIndex == 1) {
//      ADD TO SQL DATABAse + CHECK USER DEFAULTS AND SEND USER NUMBER !!!!!!!!!!!!!
        [[DiaryDatabase database] insertIntoDatabase:_productId];
    
        NSDate *date = [[NSDate alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"USer id is : %@", [defaults objectForKey:@"id"]);
//        NSString *aposDate = [NSString stringWithFormat:@"\'%@\'", [dateFormat stringFromDate:date]];
        NSDictionary *diaryInfo = @ {
            @"id" : [defaults objectForKey:@"id"],
            @"productCode" : _productId,
            @"date" : [dateFormat stringFromDate:date]
        };
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://km842.host.cs.st-andrews.ac.uk/sh/index.php/insertIntoDiary"]];
        NSError *err;
        NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:diaryInfo options:0 error:&err];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonRequest];
//        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil startImmediately:NO];
//        [connection start];
        NSURLResponse *response;
        NSError *errr;
        [ProgressHUD show:@"Adding to database...." Interacton:YES];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errr];
        (void) responseData;
        [ProgressHUD showSuccess:@"Sucessfully added to database!" Interacton:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Prepare for next view controller.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toMap"]) {
        MapViewController *dvc = (MapViewController*)segue.destinationViewController;
        NSString *s = _calorieLabel.text;
        double calories = [s doubleValue];
        NSLog(@"setting calories at : %f", calories);
        [dvc setCalories:calories];
        
    }
}
@end
