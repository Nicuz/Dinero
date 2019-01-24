//
//  ExpenseCell.h
//  Dinero
//
//  Created by Domenico Majorana on 21/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpenseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UILabel *currency;

- (void) UpdateCellLabels:(NSString *)title date:(NSString *)date amount:(NSString *)amount currency:(NSString *)currency category:(NSString *)category;

@end

NS_ASSUME_NONNULL_END
