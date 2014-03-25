//
//  DiaryDatabase.h
//  FoodNudge
//
//  Created by Kunal  on 05/03/2014.
//  Copyright (c) 2014 Kunal . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
/*!
 DiaryDatabase is part of the model. It allows operations on the local database.
 */

@interface DiaryDatabase : NSObject {
    sqlite3 *db;
    NSString *databasePath;
}

/*!
 @Function DiaryDatabase database
 @result
 Creates a static reference to a database object.
 */
+(DiaryDatabase*) database;

/*!
 @Function createDatabase
 @result
 Creates the database required to store diary information by finding the database if it already exists and ensure the diary table is created.
 */
-(void) createDatabase;

/*!
 @Function insertIntoDatabase
 @param NSString pid
 The product id of the product required to be inserted to the database.
 @result
 Insert the product into the database.
 */
-(void) insertIntoDatabase: (NSString*)pid;

/*!
 @Function uniquesDates
 @result
 Return the unique dates in the diary table to show on a view controller.
 */
-(NSMutableArray*) uniqueDates;

/*!
 @Function productIdFromDate
 @param NSString date
 The date that corresponds to the diary entry.
 @result
 Returns a list od products that have been consumed on that
 */
-(NSMutableArray*) productIdFromDate: (NSString*) date;

/*!
 @Function selectAll
 @result
 Checks to see whether the database selects all the items in the database. Used mainly for checking.
 */
-(void) selectAll;

/*!
 @FunctiondeleteAll
 @result
 Deletes all the entries in the database by dropping the table. Used for debugging.
 */
-(void) deleteAll;

/*!
 @Function caloriesForTheDay
 @result
 Return the number of calories consumed TODAY. Used for view controller to display information.
 */
-(NSInteger) caloriesForTheDay;

@end
