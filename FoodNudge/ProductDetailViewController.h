//
//  ProductDetailViewController.h
//  FoodNudge
//
//  Created by Kunal  on 29/01/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <UIKit/UIKit.h>

@class Products;

/*!
 ProductDetailViewController manages how the product information is displayed to the user.
 */
@interface ProductDetailViewController : UIViewController <NSURLConnectionDataDelegate, UIAlertViewDelegate> {
    BOOL local;
}
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

/*!
 @param UILabel productNameLAbel
 Hold the name of the product in a label displayed to the user.
 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

/*!
 @param UILabel calorieLAbel
 Hold the name of the product in a label displayed to the user.
 */
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;

/*!
 @param UILabel saltLAbel
 Hold the name of the product in a label displayed to the user.
 */
@property (weak, nonatomic) IBOutlet UILabel *saltLabel;

/*!
 @param UILabel sugarLAbel
 Hold the name of the product in a label displayed to the user.
 */
@property (weak, nonatomic) IBOutlet UILabel *sugarLabel;

/*!
 @param UILabel fatLAbel
 Hold the name of the product in a label displayed to the user.
 */
@property (weak, nonatomic) IBOutlet UILabel *fatLabel;

/*!
 @param UILabel saturatesLAbel
 Hold the name of the product in a label displayed to the user.
 */
@property (weak, nonatomic) IBOutlet UILabel *satFatLabel;

/*!
 @param UILabel caloreiesLeftLabel
 Holds the number of calories left for TODAY
 */
@property (weak, nonatomic) IBOutlet UILabel *caloriesLeftLabel;

/*!
 @param NSString productName
 Used to set the productName label from the previous view controller.
 */
@property (weak, nonatomic) NSString *productName;

/*!
 @param NSString productId
 Used to set the product id to get the correct product data.
 */
@property (strong, nonatomic) NSString *productId;

/*!
 @param NSMutableData responseData
 Stores the data from the URL request.
 */
@property (strong, nonatomic) NSMutableData *responseData;

/*!
 @param NSURLConnection conn
 Used to perform multiple URL requests in this specific view controller.
 */
@property (strong, nonatomic) NSURLConnection *conn;

/*!
 @param Products product
 Instance of class Products to store and read product information.
 */
@property (nonatomic, retain) Products *product;


/*!
 @Function addToDiary
 @param id sender
 Distinguish which action has caused the mehtod.
 @result
 Adds the product to the local diary and performs URL request to update the database.
 */
- (IBAction)addToDiary:(id)sender;

/*!
 @Function createLabels
 @param Products product
 Instance of product.
 @result
 Creates labels for the view using an instance of product.
 */
-(void) createLabels: (Products*) product;

@end
