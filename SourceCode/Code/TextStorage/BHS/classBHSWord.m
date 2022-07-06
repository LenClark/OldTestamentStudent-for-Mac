//
//  classBHSWord.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import "classBHSWord.h"

@implementation classBHSWord

@synthesize isPrefix;
@synthesize hasVariant;
@synthesize eRef;
@synthesize noOfStrongRefs;
@synthesize actualWord;
@synthesize morphology;
@synthesize affix;
@synthesize unaccentedWord;
@synthesize bareWord;
@synthesize gloss;
@synthesize wordVariant;
@synthesize listOfStrongRefs;

classGlobal *globalVarsMTWord;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init] )
    {
        globalVarsMTWord = inGlobal;
        listOfStrongRefs = [[NSMutableDictionary alloc] init];
        noOfStrongRefs = 0;
    }
    return self;
}

- (void) addStrongRef: (NSInteger) strongRef
{
    BOOL isFound;
    NSInteger idx, candidate;
    NSString *candidateSource;
    
    isFound = false;
    for( idx = 0; idx < noOfStrongRefs; idx++)
    {
        candidateSource = [listOfStrongRefs objectForKey:[[NSString alloc] initWithFormat:@"%ld", idx]];
        if( candidateSource != nil)
        {
            candidate = [candidateSource integerValue];
            if( candidate == strongRef)
            {
                isFound = true;
                break;
            }
        }
    }
    if( ! isFound)
    {
        [listOfStrongRefs setObject:[[NSString alloc] initWithFormat:@"%ld", strongRef] forKey:[[NSString alloc] initWithFormat:@"%ld", noOfStrongRefs++]];
    }
}

- (NSInteger) getStrongRefBySeq: (NSInteger) seqNo
{
    NSInteger strongRef = 0;
    NSString *candidateStrong;

    if (seqNo < noOfStrongRefs)
    {
        candidateStrong = [listOfStrongRefs objectForKey:[[NSString alloc] initWithFormat:@"%ld", seqNo]];
        if( candidateStrong != nil) strongRef = [candidateStrong integerValue];
    }
    return strongRef;
}

@end
