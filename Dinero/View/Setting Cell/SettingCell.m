//
//  ExpenseCell.m
//  Dinero
//
//  Created by Domenico Majorana on 21/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) UpdateCellLabels:(NSString *)title icon:(NSString *)icon {
    self.settingName.text = title;
    self.settingIcon.text = icon;
}
@end
