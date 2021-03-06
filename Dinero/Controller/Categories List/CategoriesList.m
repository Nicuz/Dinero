//
//  CategoriesList.m
//  Dinero
//
//  Created by Domenico Majorana on 20/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "CategoriesList.h"
#import "Database.h"

@interface CategoriesList() {
    @public Database *getDatabaseInstance;
}
@property (nonatomic) NSMutableArray *categories;

@end

@implementation CategoriesList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    getDatabaseInstance = [Database getDatabaseInstance];
    self.categories = [getDatabaseInstance ReturnItems:@"CATEGORIES"];
    
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.categories.count != 0) {
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
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryRow" forIndexPath:indexPath];

    cell.textLabel.text = self.categories[indexPath.row];
    
    return cell;
}

//Allow rows deletion
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [getDatabaseInstance RemoveValue:@"CATEGORIES" value:self.categories[indexPath.row]];
        self.categories = [getDatabaseInstance ReturnItems:@"CATEGORIES"];
        [tableView reloadData];
    }
}

- (void) addCategory:(id)sender {
    
    //Alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New category" message:@"Insert a name for the new category:" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull categoryField) {
        categoryField.placeholder = @"Category name";
    }];
    
    //Add button
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self.categories containsObject:alert.textFields[0].text]) {
            
            //Show error alert if category already exists
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error!" message:@"This category already exists!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [error addAction:add];
            [self presentViewController:error animated:YES completion:nil];
            
        } else {
            [self->getDatabaseInstance AddValue:@"CATEGORIES" value:alert.textFields[0].text];
            self.categories = [self->getDatabaseInstance ReturnItems:@"CATEGORIES"];
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
