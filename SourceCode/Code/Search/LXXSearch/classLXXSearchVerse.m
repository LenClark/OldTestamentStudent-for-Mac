/*===========================================================================================================*
 *                                                                                                           *
 *                                                classSearchVerse                                           *
 *                                                ================                                           *
 *                                                                                                           *
 *  A list of up to five verses can be defined as a SearchResult.  This record gives the following           *
 *    information:                                                                                           *
 *                                                                                                           *
 *  Variables:                                                                                               *
 *  =========                                                                                                *
 *                                                                                                           *
 *  isFollowed            This is set to true of there should be no bold line between this and the next      *
 *                          record                                                                           *
 *  chapterNumber         The real chapter number containing the verse                                       *
 *  verseNumber           The real verse number                                                              *
 *  noOfMatchingWords     Used to control the list of matchingWordPositions                                  *
 *  matchingWordPosition  The sequence value of the word matching the primary search word, if it exists      *
 *  impactedVerse         The instance of the verse, from which each word can be derived                     *
 *  matchingWordPositions The sequence numbewr of any primary or secondary matches in the verse              *
 *  matchingWordType      Indicates whether the match is Primary or secondary:                               *
 *                          Key:   The same integer index as used in matchingWordPositions                   *
 *                          Value: 1 = Primary, 2 = Secondary                                                *
 *                                                                                                           *
 *  Created by Len Clark                                                                                     *
 *  May 2022                                                                                                 *
 *                                                                                                           *
 *===========================================================================================================*/

#import "classLXXSearchVerse.h"

@implementation classLXXSearchVerse

@synthesize isFollowed;
@synthesize bookId;
@synthesize chapterNumber;
@synthesize verseNumber;
@synthesize noOfMatchingWords;
@synthesize chapterReference;
@synthesize verseReference;
@synthesize impactedVerse;
/*--------------------------------------------------------------*
 *  matchingWordPositions:                                      *
 *  ---------------------                                       *
 *  Key:   NSInteger sequence                                   *
 *  Value: NSInteger position in verse                          *
 *--------------------------------------------------------------*/
@synthesize matchingWordPositions;
/*--------------------------------------------------------------*
 *  matchingWordType:                                           *
 *  ----------------                                            *
 *  Key:   NSInteger sequence                                   *
 *  Value: NSInteger type code                                  *
 *--------------------------------------------------------------*/
@synthesize matchingWordType;

classGlobal *globalVarsLXXSearchVerse;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init])
    {
        globalVarsLXXSearchVerse = inGlobal;
        isFollowed = false;
        noOfMatchingWords = 0;
        matchingWordPositions = [[NSMutableDictionary alloc] init];
        matchingWordType = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) addWordPosition: (NSInteger) position forWordType: (NSInteger) wordType
{
    [matchingWordPositions setObject:[globalVarsLXXSearchVerse convertIntegerToString: position] forKey:[globalVarsLXXSearchVerse convertIntegerToString:noOfMatchingWords]];
    [matchingWordType setObject:[globalVarsLXXSearchVerse convertIntegerToString:wordType] forKey:[globalVarsLXXSearchVerse convertIntegerToString:noOfMatchingWords++]];
}

- (NSInteger) getWordPositionBySeq: (NSInteger) index
{
    NSInteger retrievedPosition = -1;
    NSString *positionCandidate;

    positionCandidate = nil;
    positionCandidate = [matchingWordPositions objectForKey:[globalVarsLXXSearchVerse convertIntegerToString:index]];
    if( positionCandidate != nil) retrievedPosition = [positionCandidate integerValue];
    return retrievedPosition;
}

- (NSInteger) getWordTypeBySeq: (NSInteger) index
{
    NSInteger retrievedType = -1;
    NSString *typeCandidate;

    typeCandidate = nil;
    typeCandidate = [matchingWordType objectForKey:[globalVarsLXXSearchVerse convertIntegerToString:index]];
    if( typeCandidate != nil) retrievedType = [typeCandidate integerValue];
    return retrievedType;
}

@end
