//
//  Database.m
//  Dinero
//
//  Created by Domenico Majorana on 20/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "Database.h"

@implementation Database

@synthesize databasePath;
@synthesize expensesDB;

#pragma mark Singleton Methods

+ (id)getDatabaseInstance {
    static Database *dbInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbInstance = [[self alloc] init];
    });
    return dbInstance;
}

- (id)init {
    if (self = [super init]) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        
        // Build the path to the database file
        databasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"Dinero.db"]];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: databasePath ] == NO) {
            const char *dbpath = [databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
                char *errMsg;
                
                const char *createCategoriesTable = "CREATE TABLE CATEGORIES (NAME TEXT NOT NULL PRIMARY KEY)";
                const char *createExpensesTable =
                "CREATE TABLE EXPENSES (NAME TEXT NOT NULL, AMOUNT REAL NOT NULL, DATE DATETIME NOT NULL, CURRENCY TEXT NOT NULL, CATEGORY TEXT NOT NULL REFERENCES CATEGORIES(NAME), NOTES TEXT, CONSTRAINT avoid_duplicates UNIQUE (NAME, DATE))";
                
                const char *InsertBillsCategory =
                "INSERT INTO CATEGORIES VALUES (\"Bills\")";
                const char *InsertFoodCategory =
                "INSERT INTO CATEGORIES VALUES (\"Food\")";
                const char *InsertHealthcareCategory = "INSERT INTO CATEGORIES VALUES (\"Healthcare\")";
                
                
                if (sqlite3_exec(expensesDB, createCategoriesTable, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Can't create CATEGORIES table, already exists.");
                } else if (sqlite3_exec(expensesDB, createExpensesTable, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Can't create EXPENSES table, already exists.");
                } else if (sqlite3_exec(expensesDB, InsertBillsCategory, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Can't insert BILLS category, already exists.");
                } else if (sqlite3_exec(expensesDB, InsertFoodCategory, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Can't insert FOOD category, already exists.");
                } else if (sqlite3_exec(expensesDB, InsertHealthcareCategory, NULL, NULL, &errMsg) != SQLITE_OK) {
                    NSLog(@"Can't insert HEALTHCARE category, already exists.");
                }
                
                sqlite3_close(expensesDB);
            } else {
                NSLog(@"Failed to open/connect to DB.");
            }
        }
    }
    return self;
}

- (void) AddExpense:(NSString *)name amount:(double)amount date:(NSString *)date currency:(NSString *)currency category:(NSString *)category notes:(NSString *)notes {
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
        NSString *insertExpense = [NSString stringWithFormat:
                                   @"INSERT INTO EXPENSES (NAME, AMOUNT, DATE, CURRENCY, CATEGORY, NOTES) VALUES (\"%@\", \"%.02f\", \"%@\", \"%@\", \"%@\", \"%@\")",
         name, amount, date, currency, category, notes];
        
        sqlite3_exec(expensesDB, "PRAGMA foreign_keys = on", NULL, NULL, NULL);
        
        sqlite3_prepare_v2(expensesDB, [insertExpense UTF8String],-1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to add expense.");
        } else {
            NSLog(@"Data saved succesfully.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(expensesDB);
    }
}

- (void) RemoveExpense:(NSString *)name amount:(NSString *)amount date:(NSString *)date currency:(NSString *)currency category:(NSString *)category notes:(NSString *)notes {
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
        NSString *deleteExpense = [NSString stringWithFormat:
                                   @"DELETE FROM EXPENSES WHERE NAME = \"%@\" AND AMOUNT = \"%@\" AND DATE = \"%@\" AND CURRENCY = \"%@\" AND CATEGORY = \"%@\" AND NOTES = \"%@\"",
                                   name, amount, date, currency, category, notes];
        
        sqlite3_prepare_v2(expensesDB, [deleteExpense UTF8String],-1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to remove expense.");
        } else {
            NSLog(@"Expense removed succesfully.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(expensesDB);
    }
}

- (void) AddCategory:(NSString *)name {
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
        NSString *insertCategory = [NSString stringWithFormat:
                                   @"INSERT INTO CATEGORIES (NAME) VALUES (\"%@\")",
                                   name];
        
        sqlite3_prepare_v2(expensesDB, [insertCategory UTF8String],-1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to add category.");
        } else {
            NSLog(@"Category saved succesfully.");
        }
        sqlite3_finalize(statement);
        sqlite3_close(expensesDB);
    }
}

- (void) RemoveCategory:(NSString *)name {
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
        NSString *deleteCategory = [NSString stringWithFormat:
                                    @"DELETE FROM CATEGORIES WHERE NAME = \"%@\"",
                                    name];
        
        sqlite3_prepare_v2(expensesDB, [deleteCategory UTF8String],-1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Category deleted");
        } else {
            NSLog(@"Can't remove category");
        }
        sqlite3_finalize(statement);
        sqlite3_close(expensesDB);
    }
}

- (NSMutableArray *) ReturnExpenses {
    NSMutableArray *expensesList = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
        NSString *selectExpenses = @"SELECT NAME, AMOUNT, strftime('%d/%m/%Y', DATE), CURRENCY, CATEGORY, NOTES FROM EXPENSES ORDER BY DATE DESC";
        
        if (sqlite3_prepare_v2(expensesDB, [selectExpenses UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *expense = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *amount = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *currency = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *category = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *notes = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                
                NSDictionary *expensesData= [NSDictionary dictionaryWithObjectsAndKeys:
                                     expense, @"name",
                                     amount, @"amount",
                                     date, @"date",
                                     currency, @"currency",
                                     category, @"category",
                                     notes, @"notes",
                                     nil];
                
                [expensesList addObject:expensesData];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(expensesDB);
    }
    return expensesList;
}

- (NSMutableArray *) ReturnCategories {
    NSMutableArray *categoriesList = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
        NSString *selectCategories = @"SELECT * FROM CATEGORIES ORDER BY NAME";
        
        if (sqlite3_prepare_v2(expensesDB, [selectCategories UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *category = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                
                [categoriesList addObject:category];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(expensesDB);
    }
    return categoriesList;
}

- (NSString *) ReturnDate:(NSString *)name amount:(NSString *)amount currency:(NSString *)currency category:(NSString *)category notes:(NSString *)notes {
    NSString *date;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
        NSString *selectDate = [NSString stringWithFormat:
                                @"SELECT DATE FROM EXPENSES WHERE NAME = \"%@\" AND AMOUNT = \"%@\" AND CURRENCY = \"%@\" AND CATEGORY = \"%@\" AND NOTES = \"%@\"",
                                name, amount, currency, category, notes];
        
        if (sqlite3_prepare_v2(expensesDB, [selectDate UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                date = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(expensesDB);
    }
    return date;
}

- (void) ClearExpensesList {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &expensesDB) == SQLITE_OK) {
        char *errMsg;
        NSString *deleteAll = @"DELETE FROM EXPENSES";
        
        sqlite3_exec(expensesDB, [deleteAll UTF8String], NULL, NULL, &errMsg);
        
        if (sqlite3_exec(expensesDB, [deleteAll UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
            NSLog(@"Expenses table is now empty");
        } else {
            NSLog(@"Unable to clear the expenses table");
        }
        sqlite3_close(expensesDB);
    }
}

@end
