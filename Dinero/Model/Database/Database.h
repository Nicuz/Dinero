//
//  Database.h
//  Dinero
//
//  Created by Domenico Majorana on 20/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject {
    NSString *databasePath;
    sqlite3 *expensesDB;
}

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *expensesDB;
@property (strong, nonatomic) NSString *insertValue;

+ (id)getDatabaseInstance;

- (void) AddExpense:(NSString *)name amount:(double)amount date:(NSString *)date currency:(NSString *)currency category:(NSString *)category notes:(NSString *)notes;
- (void) RemoveExpense:(NSString *)name amount:(NSString *)amount date:(NSString *)date currency:(NSString *)currency category:(NSString *)category notes:(NSString *)notes;
- (NSMutableArray *) ReturnExpenses;

- (void) AddValue:(NSString *)table value:(NSString *)value;
- (void) RemoveValue:(NSString *)table value:(NSString *)value;
- (NSMutableArray *) ReturnItems:(NSString *)table;

- (NSString *) ReturnDate:(NSString *)name amount:(NSString *)amount currency:(NSString *)currency category:(NSString *)category notes:(NSString *)notes;

- (void) ClearExpensesList;

@end
