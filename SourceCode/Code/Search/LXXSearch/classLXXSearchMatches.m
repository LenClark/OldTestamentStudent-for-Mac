//
//  classLXXSearchMatches.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 31/05/2022.
//

#import "classLXXSearchMatches.h"

@implementation classLXXSearchMatches

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
