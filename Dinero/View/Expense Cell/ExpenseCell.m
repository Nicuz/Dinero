//
//  ExpenseCell.m
//  Dinero
//
//  Created by Domenico Majorana on 21/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "ExpenseCell.h"

@implementation ExpenseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) UpdateCellLabels:(NSString *)title date:(NSString *)date amount:(NSString *)amount currency:(NSString *)currency category:(NSString *)category {
    self.title.text = title;
    self.amount.text = amount;
    self.date.text = date;
    self.currency.text = currency;
    self.category.text = category;
}

@end
