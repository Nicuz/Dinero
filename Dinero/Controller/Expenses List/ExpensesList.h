//
//  ExpensesList.h
//  Dinero
//
//  Created by Domenico Majorana on 19/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpensesList : UITableViewController
- (IBAction)importCSV:(id)sender;

@end

NS_ASSUME_NONNULL_END
