//
//  classKbCommon.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import <Foundation/Foundation.h>
#import "classReturnedModifiedText.h"

NS_ASSUME_NONNULL_BEGIN

@interface classKbCommon : NSObject

- (NSArray *) loadKeyWidths: (NSString *) fileName withNoOfRows: (NSInteger) noOfRows andNoOfColumns: (NSInteger) noOfCols;
- (NSArray *) loadFileData: (NSString *) fileName withNoOfRows: (NSInteger) noOfRows andNoOfColumns: (NSInteger) noOfCols;
- (NSInteger) getKeyWidth: (NSArray *) arrayOfWidths fromRow: (NSInteger) rowNum andColumn: (NSInteger) colNum;
- (NSString *) getLoadedData: (NSArray *) arrayOfData fromRow: (NSInteger) rowNum andColumn: (NSInteger) colNum;
-(classReturnedModifiedText *) reviseSearchString: (NSString *) sourceString atCursorPosition: (NSUInteger) Pstn forAction: (NSMutableDictionary *) actionArray addChar: (NSString *) addChar;

@end

NS_ASSUME_NONNULL_END
