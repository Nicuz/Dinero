//
//  EditExpense.m
//  Dinero
//
//  Created by Domenico Majorana on 26/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "EditExpense.h"
#import "Database.h"

@interface EditExpense () {
    @public Database *getDatabaseInstance;
}

@end

@implementation EditExpense

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameField.delegate = self;
    _amountField.delegate = self;
    _notesField.delegate = self;
    
    _currencyPicker.delegate = self;
    _currencyPicker.dataSource = self;
    
    _categoryPicker.delegate = self;
    _categoryPicker.dataSource = self;
    
    _datePicker.maximumDate = [NSDate date];
    
    //Set data values
    [_nameField setText:[_expense getName]];
    [_amountField setText:[NSString stringWithFormat:@"%.02f", [_expense getAmount]]];
    [_notesField setText:[_expense getNotes]];
    
    getDatabaseInstance = [Database getDatabaseInstance];
    self.categories = [getDatabaseInstance ReturnItems:@"CATEGORIES"];
    self.currencies = [getDatabaseInstance ReturnItems:@"CURRENCIES"];
    _currentCurrency = self.currencies[[self.currencies indexOfObject:[_expense getCurrency]]];
    _currentCategory = self.categories[[self.categories indexOfObject:[_expense getCategory]]];
    [_currencyPicker selectRow:[self.currencies indexOfObject:[_expense getCurrency]] inComponent:0 animated:YES];
    [_categoryPicker selectRow:[self.categories indexOfObject:[_expense getCategory]] inComponent:0 animated:YES];
    
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat dateFromString:[_expense getDate]];
    
    [_datePicker setDate:date animated:YES];
    
    //Subscribe to taps on the UI and dismiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.tableView.allowsSelection = NO;
    
}

-(void)dismissKeyboard {
    [_nameField resignFirstResponder];
    [_amountField resignFirstResponder];
    [_notesField resignFirstResponder];
}

//Hide keyboard when pressing Return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _currencyPicker) {
        return _currencies.count;
    } else if (pickerView == _categoryPicker) {
        return _categories.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == _currencyPicker) {
        return _currencies[row];
    } else if (pickerView == _categoryPicker) {
        return _categories[row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == _currencyPicker) {
        _currentCurrency = _currencies[row];
    } else {
        _currentCategory = _categories[row];
    }
}

@end
