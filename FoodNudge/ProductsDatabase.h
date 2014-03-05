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

@interface ProductsDatabase : NSObject {
    sqlite3 *db;
    NSString *databasePath;
}

+(ProductsDatabase*) database;
-(Products*) getProductInfoById: (NSString*)pid;
-(void) insertProductwithId:(NSString*)pid andName:(NSString*)name andCalories:(NSString *)calories andSugar:(NSString*)sugar andFat:(NSString*)fat andSaturates:(NSString*)saturates andSalt:(NSString*)salt;

@end
