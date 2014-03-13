//
//  DiaryDatabase.m
//  FoodNudge
//
//  Created by Kunal  on 05/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import "DiaryDatabase.h"
#import "Products.h"


@implementation DiaryDatabase

static DiaryDatabase *database;

+(DiaryDatabase*) database {
    if (database == nil) {
        database = [[DiaryDatabase alloc] init];
    }
    return database;
}

-(id) init {
    self = [super init];
    if (self) {
        [self createDatabase];
    }
    return self;
}

-(void) createDatabase {
    NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDirPath = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDirPath stringByAppendingPathComponent: @"products.sqlite3"]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath: databasePath ] == YES)
    {
        if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)
        {
            char *errMsg;
            
            NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Diary(dateConsumed TEXT, productId TEXT)"];
            
            if (sqlite3_exec(db, [createTable UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            } else {
                NSLog(@"created table");
            }
            sqlite3_close(db);
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
    else{
        NSLog(@"Database already exists");
    }
}

-(void) insertIntoDatabase:(NSString*)pid {
    sqlite3_stmt *stmt;
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@", [dateFormat stringFromDate:date]);
    NSString *query = [NSString stringWithFormat:@"INSERT INTO Diary(dateConsumed, productId) VALUES (date(?), ?)"];
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        if (sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            NSString *dateS = [dateFormat stringFromDate:date];
            sqlite3_bind_text(stmt, 1, [dateS UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 2, [pid UTF8String], -1, SQLITE_TRANSIENT);
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                NSLog(@"inserted into diary");
            } else {
                NSLog(@"faliedl to insert to diary: %s", sqlite3_errmsg(db));
            }
            sqlite3_finalize(stmt);
        } else {
            NSLog(@"error preparing: %s", sqlite3_errmsg(db));
        }
        sqlite3_close(db);
    }
}

-(void) selectAll {
    sqlite3_stmt *stmt;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM DIARY"];
        if (sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil)  == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSString *date = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(stmt, 0)];
                NSString *pid = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(stmt, 1)];
                NSLog(@"Date: %@ and Product ID: %@", date, pid);
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
}

-(void) deleteAll {
    
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        NSString *query = [NSString stringWithFormat: @"DROP TABLE Diary"];
        char *err;
        if (sqlite3_exec(db, [query UTF8String], NULL, NULL, &err) == SQLITE_OK) {
            NSLog(@"table dropped");
        }
        sqlite3_close(db);
    } else {
        NSLog(@"failed to drop table");
    }
}

-(NSMutableArray*) uniqueDates {
    NSMutableArray *retVals = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK)  {
//        NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT dateConsumed FROM Diary"];
        NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT strftime(\"%%Y-%%m-%%d\", dateConsumed) FROM Diary"];
        if (sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil) == SQLITE_OK ) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                NSString *date = [[NSString alloc] initWithUTF8String:(char*) sqlite3_column_text(stmt, 0)];
                [retVals addObject:date];
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    
    return retVals;
}

// SELECT fi.productId, fi.name FROM food_items fi INNER JOIN Diary di ON fi.productId = di.productId WHERE di.dateConsumed=\'%@\', date

-(NSMutableArray*) productIdFromDate: (NSString*) date {
    NSLog(@"enttered");
    NSMutableArray *retVals = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
       NSString *query = [NSString stringWithFormat:@"SELECT fi.productId, fi.name FROM food_items fi INNER JOIN Diary di ON fi.productId = di.productId WHERE di.dateConsumed=\'%@\'", date];
        if (sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
            NSLog(@"hate prep");
            while (sqlite3_step(stmt) == SQLITE_ROW) {
//                NSLog(@"returning fuck all");
                NSString *pid = [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 0)];
                NSString *name = [NSString stringWithUTF8String:(char*) sqlite3_column_text(stmt, 1)];
                Products *product = [[Products alloc] initWithId:pid name:name calories:@"" sugar:@"" fat:@"" saturates:@"" salt:@""];
                [retVals addObject:product];
//                NSLog(@"Date passed = %@, Products: %@, Name: %s", date, [product pid], (char*) sqlite3_column_text(stmt, 1));
                NSLog(@"Product Id: %@, Name: %@", pid, name);
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    return retVals;
}


@end
