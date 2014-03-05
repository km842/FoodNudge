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
//    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
//        NSLog(@"de opened");
//    } else {
//        NSLog(@"database failed to open: %s", sqlite3_errmsg(db));
//    }
    return self;
}

-(Products*) getProductInfoById: (NSString*)pid {
    sqlite3_stmt *stmt;
    Products *product;
    NSString *query = [NSString stringWithFormat:@"SELECT name, calories, sugar, fat, saturates, salt FROM food_items where productId=%@", pid];
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"Opened DB");
        if (sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            NSLog(@"prepare: %@", query);
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSString *name = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(stmt, 0)];
                NSString *calories = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(stmt, 1)];
                NSString *sugar = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(stmt, 2)];
                NSString *fat = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(stmt, 3)];
                NSString *saturates = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(stmt, 4)];
                NSString *salt = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(stmt, 5)];
                product = [[Products alloc] initWithId:pid name:name calories:calories sugar:sugar fat:fat saturates:saturates salt:salt];
                NSLog(@"name is : %@", name);
            }
            sqlite3_finalize(stmt);
        } else {
            NSLog(@"Database Error: %s", sqlite3_errmsg(db));
        }
        sqlite3_close(db);
    }
        return product;
}

-(void) insertProductwithId:(NSString*)pid andName:(NSString*)name andCalories:(NSString *)calories andSugar:(NSString*)sugar andFat:(NSString*)fat andSaturates:(NSString*)saturates andSalt:(NSString*)salt {
    sqlite3_stmt *stmt;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO food_items (productId, name, calories, sugar, fat, saturates, salt) VALUES (?, ?, ?, ?, ?, ?, ?)"];
    if (sqlite3_prepare_v2(db, [insertQuery UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [pid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 3, [calories UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 4, [sugar UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 5, [fat UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 6, [saturates UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 7, [salt UTF8String], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            NSLog(@"inserted into database");
        } else {
            NSLog(@"failed to insert into database: %s", sqlite3_errmsg(db));
        }
        sqlite3_finalize(stmt);

    } else {
        NSLog(@"Error preparing insert statement: %s", sqlite3_errmsg(db));
    }
    sqlite3_close(db);
    }
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
