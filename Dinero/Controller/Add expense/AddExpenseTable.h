//
//  AddExpenseTable.h
//  Dinero
//
//  Created by Domenico Majorana on 25/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddExpenseTable : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *amountField;
@property (strong, nonatomic) IBOutlet UIPickerView *currencyPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *notesField;

@property (strong, nonatomic) Expense *expense;

@property (nonatomic) NSMutableArray *currencies;
@property (nonatomic) NSMutableArray *categories;

@property (nonatomic) NSString *currentCurrency;
@property (nonatomic) NSString *currentCategory;
@property (nonatomic) NSString *currentDate;

- (IBAction)addToDatabase:(id)sender;

@end

NS_ASSUME_NONNULL_END
