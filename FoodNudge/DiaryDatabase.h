//
//  DiaryDatabase.h
//  FoodNudge
//
//  Created by Kunal  on 05/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DiaryDatabase : NSObject {
    sqlite3 *db;
    NSString *databasePath;
}

+(DiaryDatabase*) database;
-(void) insertIntoDatabase: (NSString*)pid;
-(NSMutableArray*) uniqueDates;
-(NSMutableArray*) productIdFromDate: (NSString*) date;
-(void) selectAll;
-(void) deleteAll;

@end
