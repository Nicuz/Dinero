//
//  CSV.m
//  Dinero
//
//  Created by Domenico Majorana on 22/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import "CSV.h"

@implementation CSV

@synthesize CSVPath;

#pragma mark Singleton Methods

+ (id)getCSVInstance {
    static CSV *CSVInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CSVInstance = [[self alloc] init];
    });
    return CSVInstance;
}

- (id)init {
    if (self = [super init]) {
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        
        // Build the path to CSV file
        CSVPath = [[NSString alloc]
                        initWithString: [docsDir stringByAppendingPathComponent:
                                         @"expenses.csv"]];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: CSVPath ] == NO) {
            [[NSFileManager defaultManager] createFileAtPath:CSVPath contents:nil attributes:nil];
            NSLog(@"Created CSV File");
        } else {
            NSLog(@"CSV file already exists");
        }
    }
    return self;
}

- (void) saveToCSV:(NSString *)expense_details {
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:CSVPath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[expense_details dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

- (NSString *) readCSV {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:CSVPath];
    NSString *data = [[NSString alloc] initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding];
    [fileHandle closeFile];
    return data;
}

- (void) clearCSVfile {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:CSVPath];
    [fileHandle seekToEndOfFile];
    [fileHandle truncateFileAtOffset:0];
    [fileHandle closeFile];
}

@end
