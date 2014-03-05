//
//  ProductsDatabase.m
//  FoodNudge
//
//  Created by Kunal  on 04/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "ProductsDatabase.h"
#import "Products.h"

@implementation ProductsDatabase

static ProductsDatabase *database;

+(ProductsDatabase*) database {
    NSLog(@"here1");
    if (database == nil) {
        database = [[ProductsDatabase alloc] init];
    }
    return database;
}

-(id) init {
    self = [super init];
    NSArray *Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocumentDir = [Paths objectAtIndex:0];
    databasePath= [[NSString alloc] initWithString:[DocumentDir stringByAppendingPathComponent:@"products.sqlite3"]];
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"de opened");
    }
    return self;
}

-(Products*) getProductInfoById: (NSString*)pid {
    sqlite3_stmt *stmt;
    Products *product;
    NSString *query = [NSString stringWithFormat:@"SELECT name, calories, sugar, fat, saturates, salt FROM food_items where productId=%@", pid];
    if (sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        NSLog(@"prepare: %@", query);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *name = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(stmt, 0)];
            NSLog(@"name is : %@", name);
        }
        sqlite3_finalize(stmt);
    } else {
        NSLog(@"Database Error: %s", sqlite3_errmsg(db));
    }
    sqlite3_close(db);
    
    return product;
}


//-(NSArray*) productInfoWithId:(int)pid {
//    NSMutableArray *returnValues = [[NSMutableArray alloc] init];
//    sqlite3_stmt *stmt;
//    
//    NSString *query = [NSString stringWithFormat:@"SELECT name, calories, sugar, fat, saturates FROM food_items where productId=%@", [NSString stringWithFormat:@"%d", 258147391]];
//    NSLog(@"%@", query);
//    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
//        NSLog(@"prepare");
//        while (sqlite3_step(stmt) == SQLITE_OK) {
//            NSString *name = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 0)];
//            NSLog(@"Name: %@", name);
//            NSString *calories = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 1)];
//            NSString *sugar = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 2)];
//            NSString *fat = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 3)];
//            NSString *saturates = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 4)];
//            NSString *salt = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(stmt, 5)];
//            Products *product = [[Products alloc] initWithId:pid name:name calories:calories sugar:sugar fat:fat saturates:saturates salt:salt];
//            [returnValues addObject:product];
//        }
//        sqlite3_finalize(stmt);
//    }
//    return returnValues;
//}

@end
