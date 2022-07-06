//
//  classBHSSearchMatches.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 29/05/2022.
//

#import "classBHSSearchMatches.h"

@implementation classBHSSearchMatches

@synthesize isValid;
@synthesize bookId;
@synthesize primaryChapterSeq;
@synthesize primaryVerseSeq;
@synthesize primaryWordSeq;
@synthesize secondaryChapterSeq;
@synthesize secondaryVerseSeq;
@synthesize secondaryWordSeq;
@synthesize primaryChapterRef;
@synthesize primaryVerseRef;
@synthesize secondaryChapterRef;
@synthesize secondaryVerseRef;
@synthesize primaryScanWord;
@synthesize secondaryScanWord;

- (id) init
{
    if( self = [super init])
    {
        isValid = true;
    }
    return self;
}

@end
