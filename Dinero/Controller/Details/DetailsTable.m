//
//  DetailsTable.m
//  Dinero
//
//  Created by Domenico Majorana on 24/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "DetailsTable.h"
#import "CSV.h"
#import "Database.h"
#import "EditExpense.h"

@interface DetailsTable() {
    @public Database *getDatabaseInstance;
    @public CSV *getCSVInstance;
}

@end

@implementation DetailsTable

@synthesize expenseLabel, amountLabel, dateLabel, currencyLabel, categoryLabel, notesLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [expenseLabel setText:[_expense getName]];
    [amountLabel setText:[NSString stringWithFormat:@"%.02f", [_expense getAmount]]];
    [dateLabel setText:[_expense getDate]];
    [currencyLabel setText:[_expense getCurrency]];
    [categoryLabel setText:[_expense getCategory]];
    [notesLabel setText:[_expense getNotes]];
    
    getDatabaseInstance = [Database getDatabaseInstance];
    NSString *dateFromDB = [getDatabaseInstance ReturnDate:_expense];
    NSLog(@"%@", dateFromDB);
    
    if (notesLabel.text.length == 0) {
        _shareString = [NSString stringWithFormat:@"ℹ️ %@\n💶 %@ %@\n🗓 %@\n❓ %@\n\nSent from Dinero app by Domenico Majorana", expenseLabel.text, currencyLabel.text, amountLabel.text, dateLabel.text, categoryLabel.text];
        _CSVString = [NSString stringWithFormat:@"\n%@,%@,%@,%@,%@\n", expenseLabel.text, amountLabel.text, dateFromDB, currencyLabel.text, categoryLabel.text];
    } else {
        _shareString = [NSString stringWithFormat:@"ℹ️ %@\n💶 %@ %@\n🗓 %@\n❓ %@\n🗒 %@\n\nSent from Dinero app by Domenico Majorana", expenseLabel.text, currencyLabel.text, amountLabel.text, dateLabel.text, categoryLabel.text, notesLabel.text];
        _CSVString = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@\n", expenseLabel.text, amountLabel.text, dateFromDB, currencyLabel.text, categoryLabel.text, notesLabel.text];
    }
    
    //Disable row selection
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (notesLabel.text.length == 0) {
        return 4;
    }
    return 5;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showEdit"]) {
        EditExpense *editView = [segue destinationViewController];
        editView.expense = [Expense getExpenseInstance];
        editView.expense = _expense;
    }
    
}

- (IBAction)saveCSVAction:(id)sender {
    NSArray* sharedObjects=[NSArray arrayWithObjects:_shareString,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)shareAction:(id)sender {
    getCSVInstance = [CSV getCSVInstance];
    [getCSVInstance saveToCSV:_CSVString];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Data exported succesfully!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
