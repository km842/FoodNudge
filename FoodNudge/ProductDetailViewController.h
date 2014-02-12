//
//  ProductDetailViewController.h
//  FoodNudge
//
//  Created by Kunal  on 29/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController <NSURLConnectionDataDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *saltLabel;
@property (weak, nonatomic) IBOutlet UILabel *sugarLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatLabel;
@property (weak, nonatomic) IBOutlet UILabel *satFatLabel;

@property (weak, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSMutableData *responseData;
- (IBAction)addToDiary:(id)sender;

@end
