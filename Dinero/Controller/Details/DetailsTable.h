//
//  DetailsTable.h
//  Dinero
//
//  Created by Domenico Majorana on 24/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsTable : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *expenseLabel;
@property (strong, nonatomic) IBOutlet UILabel *currencyLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;

@property (nonatomic, strong) Expense *expense;

@property (strong, nonatomic) NSString *shareString;
@property (strong, nonatomic) NSString *CSVString;

- (IBAction)saveCSVAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
