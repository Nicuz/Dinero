//
//  AddExpenseView.m
//  Dinero
//
//  Created by Domenico Majorana on 20/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "AddExpenseView.h"
#import "Database.h"

@interface AddExpenseView() {
    @public Database *getDatabaseInstance;
}
@end

@implementation AddExpenseView

@synthesize scrollView;


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
    
    self.currencies = [NSMutableArray arrayWithObjects:@"AUD",@"CNY",
                       @"EUR", @"GBP", @"JPY", @"USD", nil];
    
    getDatabaseInstance = [Database getDatabaseInstance];
    self.categories = [getDatabaseInstance ReturnCategories];
    
    _currentCurrency = self.currencies[0];
    _currentCategory = self.categories[0];
    
    //Subscribe to keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //Subscribe to taps on the UI and dismiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [_nameField resignFirstResponder];
    [_amountField resignFirstResponder];
    [_notesField resignFirstResponder];
}

//Store keyboard height
- (void)keyboardWillShow:(NSNotification *)notification
{
    _keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

//Hide keyboard when pressing Return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //Scroll if textfield is under the keyboard
    if (textField.frame.origin.y > _keyboardHeight) {
        CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y - _keyboardHeight);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [scrollView setContentOffset:CGPointZero animated:YES];
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

- (IBAction)addToDatabase:(id)sender {
    
    //Get current date from DatePicker
    NSDate *myDate = _datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    _currentDate = [dateFormat stringFromDate:myDate];
    
    //Replace commas
    NSString *amountWithComma = [_amountField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    if (_nameField.text.length == 0 || _amountField.text.length==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Some fields are empty!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [getDatabaseInstance AddExpense:_nameField.text amount:[amountWithComma doubleValue] date:_currentDate currency:_currentCurrency category:_currentCategory notes:_notesField.text];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Data saved succesfully!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //Return to previous ViewController
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
