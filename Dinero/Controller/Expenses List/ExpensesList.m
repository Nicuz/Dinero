//
//  ExpensesList.m
//  Dinero
//
//  Created by Domenico Majorana on 19/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "ExpensesList.h"
#import "Database.h"
#import "DetailsTable.h"
#import "CSV.h"

@interface ExpensesList() {
    @public Database *getDatabaseInstance;
    @public CSV *getCSVInstance;
}

@property (nonatomic) NSMutableArray *expenses;

@end

@implementation ExpensesList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add top spacing
    [self.tableView setContentInset:UIEdgeInsetsMake(15,0,0,0)];
    
    getDatabaseInstance = [Database getDatabaseInstance];
    self.expenses = [getDatabaseInstance ReturnExpenses];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.expenses = [getDatabaseInstance ReturnExpenses];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.expenses.count != 0) {
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

//TABLEVIEW ROWS NUMBER
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpenseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseRow" forIndexPath:indexPath];
    
    NSDictionary *expense = self.expenses[indexPath.row];
    
    [cell UpdateCellLabels:expense[@"name"] date:expense[@"date"] amount:expense[@"amount"] currency:expense[@"currency"] category:expense[@"category"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Delete row both from tableView and Database
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Select date with correct format from database
        NSString *date = [getDatabaseInstance ReturnDate:self.expenses[indexPath.row][@"name"] amount:self.expenses[indexPath.row][@"amount"] currency:self.expenses[indexPath.row][@"currency"] category:self.expenses[indexPath.row][@"category"] notes:self.expenses[indexPath.row][@"notes"]];
        
        //Delete expense from dataase
        [getDatabaseInstance RemoveExpense:self.expenses[indexPath.row][@"name"] amount:self.expenses[indexPath.row][@"amount"] date:date currency:self.expenses[indexPath.row][@"currency"] category:self.expenses[indexPath.row][@"category"] notes:self.expenses[indexPath.row][@"notes"]];
        self.expenses = [getDatabaseInstance ReturnExpenses];
        [tableView reloadData];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"showAddSomething"] && [getDatabaseInstance ReturnItems:@"CATEGORIES"].count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Category list is empty!" message:@"You don't have any categories, you can't save expenses before you add at least one category." preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Got it!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        DetailsTable *detailView = [segue destinationViewController];
        detailView.expenseValue = self.expenses[indexPath.row][@"name"];
        detailView.dateValue = self.expenses[indexPath.row][@"date"];
        detailView.amountValue = self.expenses[indexPath.row][@"amount"];
        detailView.currencyValue = self.expenses[indexPath.row][@"currency"];
        detailView.categoryValue = self.expenses[indexPath.row][@"category"];
        detailView.notesValue = self.expenses[indexPath.row][@"notes"];
    }
        
}

- (IBAction)importCSV:(id)sender {
    getCSVInstance = [CSV getCSVInstance];
    NSString *CSVData = [getCSVInstance readCSV];
    
    if (CSVData.length == 0) {
        CSVData = @"CSV file is empty";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CSV" message:CSVData preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CSV" message:CSVData preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *import = [UIAlertAction actionWithTitle:@"Import" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray* rows = [CSVData componentsSeparatedByString:@"\n"];
            for (NSString *row in rows){
                NSArray* columns = [row componentsSeparatedByString:@","];
                if (columns.count == 5) {
                    [self->getDatabaseInstance AddExpense:columns[0] amount:[columns[1] doubleValue] date:columns[2] currency:columns[3] category:columns[4] notes:@""];
                } else if (columns.count == 6) {
                    [self->getDatabaseInstance AddExpense:columns[0] amount:[columns[1] doubleValue] date:columns[2] currency:columns[3] category:columns[4] notes:columns[5]];
                }
            }
            self.expenses = [self->getDatabaseInstance ReturnExpenses];
            [self.tableView reloadData];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Import completed!" message:@"Note that duplicated expenses or expenses with a category you don't have won't be saved." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        [alert addAction:import];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
@end
