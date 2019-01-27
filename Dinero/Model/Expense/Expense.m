//
//  Expense.m
//  Dinero
//
//  Created by Domenico Majorana on 26/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "Expense.h"

@implementation Expense

+ (id)getExpenseInstance {
    static Expense *ExpenseInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExpenseInstance = [[self alloc] init];
    });
    return ExpenseInstance;
}

-(void)setName:(NSString *)nameValue {
    name = nameValue;
}

-(void)setDate:(NSString *)dateValue {
    date = dateValue;
}

-(void)setAmount:(float)amountValue {
    amount = amountValue;
}

-(void)setCurrency:(NSString *)currencyValue {
    currency = currencyValue;
}

-(void)setCategory:(NSString *)categoryValue {
    category = categoryValue;
}
-(void)setNotes:(NSString *)notesValue {
    notes = notesValue;
}

-(NSString *)getName {
    return name;
}

-(NSString *)getDate {
    return date;
}

-(float)getAmount {
    return amount;
}

-(NSString *)getCurrency {
    return currency;
}

-(NSString *)getCategory {
    return category;
}

-(NSString *)getNotes {
    return notes;
}

@end
