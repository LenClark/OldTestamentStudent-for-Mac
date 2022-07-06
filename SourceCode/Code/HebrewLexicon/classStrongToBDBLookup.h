//
//  classStrongToBDBLookup.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 25/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classBDBEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface classStrongToBDBLookup : NSObject

@property (nonatomic) NSInteger noOfEntriesForStrongNo;
@property (retain) NSMutableDictionary *bdbEntryList;
@property (retain) NSMutableArray *bdbEntryArray;

- (id) init: (classGlobal *) inGlobal;
- (void) addBDBEntry: (classBDBEntry *) newClass;

@end

NS_ASSUME_NONNULL_END
