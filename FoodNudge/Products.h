//
//  Products.h
//  FoodNudge
//
//  Created by Kunal  on 04/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Product is part of the model. It allows the creation of products to be stored in a sensible way.
 */
@interface Products : NSObject {
}

/*!
 @param NSString pid
 String that corresponds to the product's id.
 */
@property (nonatomic, retain) NSString *pid;

/*!
 @param NSString name
 String that corresponds to the product's name.
 */
@property (nonatomic, retain) NSString *name;

/*!
 @param NSString calories
 String that corresponds to the product's calories.
 */
@property (nonatomic, retain) NSString *calories;

/*!
 @param NSString sugar
 String that corresponds to the product's sugar.
 */
@property (nonatomic, retain) NSString *sugar;

/*!
 @param NSString fat
 String that corresponds to the product's fat.
 */
@property (nonatomic, retain) NSString *fat;

/*!
 @param NSString saturates
 String that corresponds to the product's saturates.
 */
@property (nonatomic, retain) NSString *saturates;

/*!
 @param NSString salt
 String that corresponds to the product's salt.
 */
@property (nonatomic, retain) NSString *salt;


/*!
 @Function initWithIdnamecaloriessugarfatsaturatessalt
 @param NSString pid
 Product id.
 @param NSString name
 Product name.
 @param NSString calories
 Product calories.
 @param NSString sugar
 Product sugar.
 @param NSString fat
 Product fat.
 @param NSString saturates.
 Product saturated fat.
 @param NSString salt
 Product salt.
 @result
 <#desc of result#>
 */
-(id) initWithId: (NSString*)Ppid name:(NSString*)Pname calories: (NSString*)Pcalories sugar:(NSString*)Psugar fat:(NSString*)Pfat saturates:(NSString*)Psaturates salt:(NSString *)Psalt;


@end
