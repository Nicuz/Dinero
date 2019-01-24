//
//  DetailsTable.h
//  Dinero
//
//  Created by Domenico Majorana on 24/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsTable : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *expense;
@property (strong, nonatomic) IBOutlet UILabel *currency;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *notes;

@property (strong, nonatomic) NSString *expenseValue;
@property (strong, nonatomic) NSString *amountValue;
@property (strong, nonatomic) NSString *dateValue;
@property (strong, nonatomic) NSString *currencyValue;
@property (strong, nonatomic) NSString *categoryValue;
@property (strong, nonatomic) NSString *notesValue;

@property (strong, nonatomic) NSString *shareString;
@property (strong, nonatomic) NSString *CSVString;

- (IBAction)saveCSVAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
