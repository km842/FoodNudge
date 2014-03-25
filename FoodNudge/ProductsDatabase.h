//
//  ProductsDatabase.h
//  FoodNudge
//
//  Created by Kunal  on 04/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class Products;

/*!
 ProductsDatabase allows database operations on products.
 */

@interface ProductsDatabase : NSObject {
    sqlite3 *db;
    NSString *databasePath;
}


/*!
 @Function ProductDatabase database
 @result
 Returns a static instance of a database that can be used to query products.
 */
+(ProductsDatabase*) database;
/*!
 @Function Products getProductInfoById
 @param NSString pid
 @result
 Returns a project object from the database that matches the product id given.
 */
-(Products*) getProductInfoById: (NSString*)pid;

/*!
 @Function insertProductwithIdandNameandCaloriesandSugarandFatandSaturatesandSalt
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
 @param NSString saturates
 Product saturates.
 @param NSString salt
 Product salt.
 @result
 Adds the specified product into the local database of food items.
 */
-(void) insertProductwithId:(NSString*)pid andName:(NSString*)name andCalories:(NSString *)calories andSugar:(NSString*)sugar andFat:(NSString*)fat andSaturates:(NSString*)saturates andSalt:(NSString*)salt;

@end
