//
//  AddExpenseView.h
//  Dinero
//
//  Created by Domenico Majorana on 20/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExpenseView : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *amountField;
@property (strong, nonatomic) IBOutlet UIPickerView *currencyPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *notesField;

@property (nonatomic) NSMutableArray *currencies;
@property (nonatomic) NSMutableArray *categories;

@property (nonatomic) NSString *currentCurrency;
@property (nonatomic) NSString *currentCategory;
@property (nonatomic) NSString *currentDate;
@property (nonatomic) CGFloat keyboardHeight;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)addToDatabase:(id)sender;


@end
