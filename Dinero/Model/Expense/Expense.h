//
//  Expense.h
//  Dinero
//
//  Created by Domenico Majorana on 26/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Expense : NSObject {
    NSString *name;
    NSString *date;
    float amount;
    NSString *currency;
    NSString *category;
    NSString *notes;
}

+ (id)getExpenseInstance;

-(void)setName:(NSString *)name;
-(void)setDate:(NSString *)date;
-(void)setAmount:(float)amount;
-(void)setCurrency:(NSString *)currency;
-(void)setCategory:(NSString *)category;
-(void)setNotes:(NSString *)notes;

-(NSString *)getName;
-(NSString *)getDate;
-(float)getAmount;
-(NSString *)getCurrency;
-(NSString *)getCategory;
-(NSString *)getNotes;
@end

NS_ASSUME_NONNULL_END
