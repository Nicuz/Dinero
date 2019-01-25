//
//  CurrenciesList.m
//  Dinero
//
//  Created by Domenico Majorana on 25/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "CurrenciesList.h"
#import "Database.h"

@interface CurrenciesList() {
    @public Database *getDatabaseInstance;
}
@property (nonatomic) NSMutableArray *currencies;

@end

@implementation CurrenciesList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    getDatabaseInstance = [Database getDatabaseInstance];
    self.currencies = [getDatabaseInstance ReturnItems:@"CURRENCIES"];
    
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currencies.count != 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
        return 1;
    } else {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        noDataLabel.text             = @"No data available. Add something!";
        noDataLabel.textColor        = [UIColor grayColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.tableView.backgroundView = noDataLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryRow" forIndexPath:indexPath];
    
    cell.textLabel.text = self.currencies[indexPath.row];
    
    return cell;
}

//Allow rows deletion
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [getDatabaseInstance RemoveValue:@"CURRENCIES" value:self.currencies[indexPath.row]];
        self.currencies = [getDatabaseInstance ReturnItems:@"CURRENCIES"];
        [tableView reloadData];
    }
}

- (IBAction)addCurrency:(id)sender {
    
    //Alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New currency" message:@"Insert a name for the new currency:" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull categoryField) {
        categoryField.placeholder = @"Currency name";
    }];
    
    //Add button
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self.currencies containsObject:alert.textFields[0].text]) {
            
            //Show error alert if category already exists
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error!" message:@"This currency already exists!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [error addAction:add];
            [self presentViewController:error animated:YES completion:nil];
            
        } else {
            [self->getDatabaseInstance AddValue:@"CURRENCIES" value:alert.textFields[0].text];
            self.currencies = [self->getDatabaseInstance ReturnItems:@"CURRENCIES"];
            [self.tableView reloadData];
        }
    }];
    
    //Cancel button
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:add];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
