//
//  ExpenseCell.h
//  Dinero
//
//  Created by Domenico Majorana on 21/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *settingIcon;
@property (strong, nonatomic) IBOutlet UILabel *settingName;


- (void) UpdateCellLabels:(NSString *)title icon:(NSString *)icon;

@end

NS_ASSUME_NONNULL_END
