//
//  classGkLexiconExtras.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import "classGkLexiconExtras.h"

@implementation classGkLexiconExtras

@synthesize setOfKeys;

- (id) init
{
    if( self = [super init])
    {
        setOfKeys = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addAKey: (NSString *) keyValue
{
    if ( ! [setOfKeys containsObject:keyValue] )
    {
        [setOfKeys addObject:keyValue];
    }
}

@end
