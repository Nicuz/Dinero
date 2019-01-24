//
//  Settings.m
//  Dinero
//
//  Created by Domenico Majorana on 23/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "Settings.h"
#import "Database.h"
#import "CSV.h"

@interface Settings() {
    @public Database *getDatabaseInstance;
    @public CSV *getCSVInstance;
}
@property (nonatomic) NSArray *settings;
@property (nonatomic) NSMutableArray *expenses;

@end

@implementation Settings

- (void)viewDidLoad {
    [super viewDidLoad];
    
    getDatabaseInstance = [Database getDatabaseInstance];
    getCSVInstance = [CSV getCSVInstance];
    
    self.settings = @[ @{@"name":@"Clear expenses list", @"icon":@""},
                         @{@"name":@"Clear CSV file",@"icon":@""} ];
    
    //Disable row selection
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingRow" forIndexPath:indexPath];
    
    //NSDictionary *expense = self.settings[indexPath.row];
    
    [cell UpdateCellLabels:self.settings[indexPath.row][@"name"] icon:self.settings[indexPath.row][@"icon"]];
    
    return cell;
}

- (IBAction)settingAction:(id)sender {
    UISwitch *actionSwitch = (UISwitch *)sender;
    CGPoint pointInTable = [actionSwitch convertPoint:actionSwitch.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInTable];
    if (indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Clear expenses list" message:@"Are you sure? All data will be lost." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->getDatabaseInstance ClearExpensesList];
            
            //Feedback alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Done." message:@"Expenses list is now empty." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
            [actionSwitch setOn:NO animated:YES];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            [actionSwitch setOn:NO animated:YES];
        }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Clear CSV file." message:@"Are you sure? All data will be lost." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->getCSVInstance clearCSVfile];
            
            //Feedback alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Done." message:@"CSV file is now empty." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
            [actionSwitch setOn:NO animated:YES];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            [actionSwitch setOn:NO animated:YES];
        }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
