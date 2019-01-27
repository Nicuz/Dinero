//
//  ExpensesList.m
//  Dinero
//
//  Created by Domenico Majorana on 19/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "ExpensesList.h"
#import "Expense.h"
#import "Database.h"
#import "DetailsTable.h"
#import "EditExpense.h"
#import "CSV.h"

@interface ExpensesList() {
    @public Expense *expense;
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
    
    expense = [Expense getExpenseInstance];
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
        
        [expense setName:self.expenses[indexPath.row][@"name"]];
        [expense setAmount:[self.expenses[indexPath.row][@"amount"] floatValue]];
        [expense setCurrency:self.expenses[indexPath.row][@"currency"]];
        [expense setCategory:self.expenses[indexPath.row][@"category"]];
        [expense setNotes:self.expenses[indexPath.row][@"notes"]];
        
        //Select date with correct format from database
        NSString *date = [getDatabaseInstance ReturnDate:expense];
        
        //Update date value
        [expense setDate:date];
        
        [getDatabaseInstance RemoveExpense:(Expense *)expense];
        
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
        detailView.expense = [Expense getExpenseInstance];
        [detailView.expense setName:self.expenses[indexPath.row][@"name"]];
        [detailView.expense setDate:self.expenses[indexPath.row][@"date"]];
        [detailView.expense setAmount:[self.expenses[indexPath.row][@"amount"] floatValue]];
        [detailView.expense setCurrency:self.expenses[indexPath.row][@"currency"]];
        [detailView.expense setCategory:self.expenses[indexPath.row][@"category"]];
        [detailView.expense setNotes:self.expenses[indexPath.row][@"notes"]];
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
                    [self->expense setName:columns[0]];
                    [self->expense setAmount:[columns[1] floatValue]];
                    [self->expense setDate:columns[2]];
                    [self->expense setCurrency:columns[3]];
                    [self->expense setCategory:columns[4]];
                    [self->expense setNotes:@""];
                    [self->getDatabaseInstance AddExpense:self->expense];
                } else if (columns.count == 6) {
                    [self->expense setName:columns[0]];
                    [self->expense setAmount:[columns[1] floatValue]];
                    [self->expense setDate:columns[2]];
                    [self->expense setCurrency:columns[3]];
                    [self->expense setCategory:columns[4]];
                    [self->expense setNotes:columns[5]];
                    [self->getDatabaseInstance AddExpense:self->expense];
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

-(IBAction)unwindToMainMenu:(UIStoryboardSegue *)unwindSegue {
    EditExpense *editView = [unwindSegue sourceViewController];
    
    //Select date with correct format from database
    //editView.expense.name contains data passed by segue from DetailsTable.m
    NSString *date = [getDatabaseInstance ReturnDate:editView.expense];
    
    //Replace commas
    NSString *amountWithComma = [editView.amountField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    NSString *rowid = [getDatabaseInstance ReturnRowid:[editView.expense getName] date:date];
    
    //Get current date from DatePicker
    NSDate *myDate = editView.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    editView.currentDate = [dateFormat stringFromDate:myDate];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    //Add current time to select date from DatePicker
    editView.currentDate = [NSString stringWithFormat:@"%@ %@", editView.currentDate, [dateFormat stringFromDate:[NSDate date]]];
    
    editView.expense = [Expense getExpenseInstance];
    [expense setName:editView.nameField.text];
    [expense setDate:editView.currentDate];
    [expense setAmount:[amountWithComma floatValue]];
    [expense setCurrency:editView.currentCurrency];
    [expense setCategory:editView.currentCategory];
    [expense setNotes:editView.notesField.text];
    
    [getDatabaseInstance UpdateExpense:editView.expense rowid:rowid];
    
};

@end
