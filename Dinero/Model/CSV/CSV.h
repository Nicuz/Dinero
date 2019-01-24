//
//  CSV.h
//  Dinero
//
//  Created by Domenico Majorana on 22/01/2019.
//  Copyright © 2019 Domenico Majorana. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSV : NSObject {
    NSString *CSVPath;
}

@property (strong, nonatomic) NSString *CSVPath;

+ (id)getCSVInstance;
- (void) saveToCSV:(NSString *)expense_details;
- (NSString*) readCSV;
- (void) clearCSVfile;

@end

NS_ASSUME_NONNULL_END
