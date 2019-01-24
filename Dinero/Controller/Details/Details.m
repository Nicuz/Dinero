//
//  Details.m
//  Dinero
//
//  Created by Domenico Majorana on 22/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "Details.h"
#import "CSV.h"
#import "Database.h"

@interface Details() {
    @public Database *getDatabaseInstance;
    @public CSV *getCSVInstance;
}

@end

@implementation Details

@synthesize expense, amount, date, currency, category, notes, notesIcon;
@synthesize expenseValue, amountValue, dateValue, currencyValue, categoryValue, notesValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [expense setText:expenseValue];
    [amount setText:amountValue];
    [date setText:dateValue];
    [currency setText:currencyValue];
    [category setText:categoryValue];
    [notes setText:notesValue];
    
    getDatabaseInstance = [Database getDatabaseInstance];
    NSString *dateFromDB = [getDatabaseInstance ReturnDate:expense.text amount:amount.text currency:currency.text category:category.text notes:notes.text];
    
    if (notes.text.length == 0) {
        [notesIcon setHidden:YES];
        _shareString = [NSString stringWithFormat:@"ℹ️ %@\n💶 %@ %@\n🗓 %@\n❓ %@\n\nSent from Dinero app by Domenico Majorana", expense.text, currency.text, amount.text, date.text, category.text];
        _CSVString = [NSString stringWithFormat:@"\n%@,%@,%@,%@,%@\n", expense.text, amount.text, dateFromDB, currency.text, category.text];
    } else {
        _shareString = [NSString stringWithFormat:@"ℹ️ %@\n💶 %@ %@\n🗓 %@\n❓ %@\n🗒 %@\n\nSent from Dinero app by Domenico Majorana", expense.text, currency.text, amount.text, date.text, category.text, notes.text];
        _CSVString = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@\n", expense.text, amount.text, dateFromDB, currency.text, category.text, notes.text];
    }
    
    UIBarButtonItem *CSVButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"CSV"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(saveCSVAction:)];
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: shareButton, CSVButton, nil];
}

- (IBAction)shareAction:(id)sender {
    NSArray* sharedObjects=[NSArray arrayWithObjects:_shareString,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)saveCSVAction:(id)sender {
    getCSVInstance = [CSV getCSVInstance];
    [getCSVInstance saveToCSV:_CSVString];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Data exported succesfully!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
