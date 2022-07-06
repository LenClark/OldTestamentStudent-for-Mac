/*================================================================================================================*
 *                                                                                                                *
 *                                              classMTPrimaryResult                                              *
 *                                              ====================                                              *
 *                                                                                                                *
 *  This class is specific to the situation where a single word is being sought (i.e. no secondary word is        *
 *    involved.  (Of course, it is also specific to the Masoretic text.)                                          *
 *                                                                                                                *
 *  Instance members:                                                                                             *
 *  ================                                                                                              *
 *                                                                                                                *
 *  isRepeatInVerse                                                                                               *
 *              An indicator for the display stage that this is the first of connected "records"                  *
 *  bookId      The normal reference to the book from which the verse comes                                       *
 *  chapReference                                                                                                 *
 *              The meaningful chapter number of the reference.                                                   *
 *                (Note: this is *not* the sequence number for the chapter.)                                      *
 *  chapSeq     This _is_ the internal sequence                                                                   *
 *  verseReference                                                                                                *
 *              The verse number, as provided by the source data                                                  *
 *  verseSeq    The internal sequence                                                                             *
 *  noOfMatchingWords                                                                                             *
 *              The total number of entires in the list, matchingWordPositions                                    *
 *  matchingWordPositions                                                                                         *
 *              This allows for multiple occurrences of matched primary words in a given verse                    *
 *  ImpactedVerse                                                                                                 *
 *              The address of the verse itself                                                                   *
 *                                                                                                                *
 *  Created by Len Clark                                                                                          *
 *  May 2022                                                                                                      *
 *                                                                                                                *
 *================================================================================================================*/

#import "classBHSPrimaryResult.h"

@implementation classBHSPrimaryResult

@synthesize isRepeatInVerse;
@synthesize bookId;
@synthesize chapSeq;
@synthesize verseSeq;
@synthesize noOfMatchingWords;
@synthesize chapReference;
@synthesize verseReference;
@synthesize matchingWordPositions;
@synthesize impactedVerse;

- (id) init
{
    if( self = [super init])
    {
        isRepeatInVerse = false;
        matchingWordPositions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) addWordPosition: (NSInteger) position
{
    [matchingWordPositions setObject:[[NSString alloc] initWithFormat:@"%ld", position] forKey:[[NSString alloc] initWithFormat:@"%ld", noOfMatchingWords++]];
}

- (NSInteger) getWordPositionBySeq: (NSInteger) index
{
    NSInteger retrievedPosition = -1;
    NSString *positionCandidate;

    positionCandidate = nil;
    positionCandidate = [matchingWordPositions objectForKey:[[NSString alloc] initWithFormat:@"%ld", index]];
    if (positionCandidate != nil) retrievedPosition = [positionCandidate integerValue];
    return retrievedPosition;
}

@end
