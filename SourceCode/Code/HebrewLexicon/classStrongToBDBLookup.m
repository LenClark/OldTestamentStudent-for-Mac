//
//  classStrongToBDBLookup.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 25/05/2022.
//

#import "classStrongToBDBLookup.h"

@implementation classStrongToBDBLookup

@synthesize noOfEntriesForStrongNo;
@synthesize bdbEntryList;
@synthesize bdbEntryArray;

classGlobal *globalVarsStrongLookup;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init])
    {
        globalVarsStrongLookup = inGlobal;
        noOfEntriesForStrongNo = 0;
        bdbEntryList = [[NSMutableDictionary alloc] init];
        bdbEntryArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addBDBEntry: (classBDBEntry *) newClass
{
    
    
    if( [bdbEntryArray containsObject:newClass] ) return;  // It has already been processed
    [bdbEntryList setObject:newClass forKey:[globalVarsStrongLookup convertIntegerToString:noOfEntriesForStrongNo++]];
    [bdbEntryArray addObject:newClass];
}

@end
