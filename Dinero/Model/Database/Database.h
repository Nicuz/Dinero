//
//  Database.h
//  Dinero
//
//  Created by Domenico Majorana on 20/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Expense.h"

@interface Database : NSObject {
    NSString *databasePath;
    sqlite3 *expensesDB;
}

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *expensesDB;
@property (strong, nonatomic) NSString *insertValue;

+ (id)getDatabaseInstance;

- (void) AddExpense:(Expense *)expense;
- (void) RemoveExpense:(Expense *)expense;
- (void) UpdateExpense:(Expense *)expense rowid:(NSString *)rowid;
- (NSMutableArray *) ReturnExpenses;

- (void) AddValue:(NSString *)table value:(NSString *)value;
- (void) RemoveValue:(NSString *)table value:(NSString *)value;
- (NSMutableArray *) ReturnItems:(NSString *)table;

- (NSString *) ReturnDate:(Expense *)expense;
- (NSString *) ReturnRowid:(NSString *)name date:(NSString *)date;

- (void) ClearExpensesList;

@end
