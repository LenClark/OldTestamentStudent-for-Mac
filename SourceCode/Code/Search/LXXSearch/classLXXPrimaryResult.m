/*================================================================================================================*
 *                                                                                                                *
 *                                              classLXXSearchResult                                              *
 *                                              ====================                                              *
 *                                                                                                                *
 *  This class is specific to the situation where a single word is being sought (i.e. no secondary word is        *
 *    involved.  (Of course, it is also specific to the Septuagint.)                                              *
 *                                                                                                                *
 *  Instance members:                                                                                             *
 *  ================                                                                                              *
 *                                                                                                                *
 *  isValid     For secondary searches, the process will occur in two stages:                                     *
 *              a) a primary search, as normal, potentially returning a substantial number of records;            *
 *              b) a further scan through these primary matches to find those that also have a secondary match.   *
 *              We would expect the majority *not* to have a secondary match.  In these case, we need to remove   *
 *                the record but, rather than deleting it, we mark it as invalid.                                 *
 *  bookId      The normal reference to the book from which the verse comes                                       *
 *  chapReference   The meaningful chapter number of the reference.                                               *
 *                (Note: this is *not* the sequence number for the chapter.)                                      *
 *  chapSeq     This _is_ the internal sequence                                                                   *
 *  verseReference  The verse number                                                                              *
 *  verseSeq    The internal sequence                                                                             *
 *  noOfSearchCandidates                                                                                          *
 *              If we had to go back or forward verses when performing a secondary search, then this tells us     *
 *                whether we need to go back or forward 1 or 2 verses.  So the value be 0, 1 or 2.                *
 *  preOrPostCandidates                                                                                           *
 *              If noOfSearchCandidates > 0, then this will tell us whether the additional verses are *before*    *
 *                the main match or *after*.  Values will be:                                                     *
 *                  0   No additional verses accessed                                                             *
 *                 -n  Additional verse(s) is (are) before the main match                                         *
 *                  n   Additional verse(s) is (are) after the main match                                         *
 *  wordNo      This is the word sequence number of the matched word in the verse                                 *
 *  allWords    A list of all the words in the verse, in sequence:                                                *
 *                Key    The sequence number for the word                                                         *
 *                Value  The word (including accents, etc.)                                                       *
 *  prefixList  This list contains a flag to indicate whether the matching word is a prefix or full word          *
 *                Key    The word sequence (matching the key to allWords                                          *
 *                Value  A boolean: true, if it *is* a prefix                                                     *
 *                                  false, if it is a full word                                                   *
 *  affixList   This is a list of affixes.                                                                        *
 *                Key    The word sequence (matching the key to allWords                                          *
 *                Value  The affix, if there is one.  If the word has no affix, then Value = ""                   *
 *  candidateList                                                                                                 *
 *              The class instance(s) of additional verses, as described for noOfSearchCandidates.                *
 *                                                                                                                *
 *  Created by Len Clark                                                                                          *
 *  May 2022                                                                                                      *
 *                                                                                                                *
 *================================================================================================================*/

#import "classLXXPrimaryResult.h"

@implementation classLXXPrimaryResult

@synthesize isRepeatInVerse;
@synthesize bookId;
@synthesize chapSeq;
@synthesize verseSeq;
@synthesize noOfMatchingWords;
@synthesize chapReference;
@synthesize verseReference;
@synthesize matchingWordPositions;
@synthesize impactedVerse;

classGlobal *globalVarsLXXPrimaryResult;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init])
    {
        globalVarsLXXPrimaryResult = inGlobal;
        isRepeatInVerse = false;
        noOfMatchingWords = 0;
        /*---------------------------------------------------------------------------*
        *                                                                           *
        *  matchingWordPositions:                                                   *
        *                                                                           *
        *  Key:   NSInteger                                                         *
        *  Value: NSInteger                                                         *
        *                                                                           *
        *---------------------------------------------------------------------------*/
        matchingWordPositions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) addWordPosition: (NSInteger) position
{
    [matchingWordPositions setValue:[globalVarsLXXPrimaryResult convertIntegerToString:position] forKey:[globalVarsLXXPrimaryResult convertIntegerToString:noOfMatchingWords++]];
}

- (NSInteger) getWordPositionBySeq: (NSInteger) index
{
    NSInteger retrievedPosition = -1;
    NSString *positionCandidate;

    positionCandidate = nil;
    positionCandidate = [matchingWordPositions objectForKey:[globalVarsLXXPrimaryResult convertIntegerToString:index]];
    if( positionCandidate != nil) retrievedPosition = [positionCandidate integerValue];
    return retrievedPosition;
}

@end
