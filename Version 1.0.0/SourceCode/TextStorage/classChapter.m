//
//  classChapter.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import "classChapter.h"

@implementation classChapter

/*--------------------------------------------------------------------------------*
 *                                                                                *
 *                                Storage of Verses                               *
 *                                -----------------                               *
 *                                                                                *
 *  Verses, as seen by users, will be stored as text (strings) in much the same   *
 *    way as chapters (see the relevant comment in Books).  This will enable us   *
 *    to use (e.g) names in lieu of verses - or even a null string.               *
 *                                                                                *
 *  To facilitate sensible access to Verses we will also identify them by a       *
 *    non-visible sequence number.  So:                                           *
 *                                                                                *
 *  versesInChapter: a look-up list of verse instances, keyed by a sequence no.   *
 *  verseLookup:     the text-based, visible verse associated with the same       *
 *                   sequence key as used in versesInChapter                      *
 *  verseSequence:   a look-up list keyed on the meaningful, text-based verse     *
 *                   which returns the associated sequence number                 *
 *                                                                                *
 *--------------------------------------------------------------------------------*/

@synthesize noOfVersesInChapter;
@synthesize versesInChapter;
@synthesize verseLookup;
@synthesize verseSequence;

/*--------------------------------------------------------------------------------*
*                                                                                *
*   Dictionaries:                                                                *
*   ------------                                                                 *
*                                                                                *
*  Because Objective-C doesn't provide typed Dictionaries, it's useful to        *
*    document the virtual structure of each dictionary, as well as its function. *
*                                                                                *
*  Dictionary       Key Type Value Type             Description                  *
*                                                                                *
*  versesInChapter   Int    see desc     Key: A sequence integer (see below for  *
*                                             more details).                     *
*                                        Value: a classContentVerses instance    *
*                                                                                *
*  verseLookup       Int      String     Key: a simple sequence (0 - no of       *
*                                             chapters - the *same* sequence as  *
*                                             versesInChapter, above             *
*                                        Value: the real verse, as provided by   *
*                                             the source data                    *
*                                                                                *
*  verseSequence     String    Int       Key: the real chapter (see above)       *
*                                        Value: the sequence (see above)         *
*                                        In other words, this is the inverse of  *
*                                        verseLookup and allows us to find the   *
*                                        sequence key if we know the given       *
*                                        chapter                                 *
*                                                                                *
*--------------------------------------------------------------------------------*/

-(void) initialise: (NSInteger) inBookId forChapter: (NSString *) inChapId
{
     /*---------------------------------------*
     * chapterId is a string representation  *
     *   of the chapter, as known by the     *
     *   reader.                             *
     *---------------------------------------*/
        noOfVersesInChapter = 0;
        bookId = inBookId;
        chapterId = inChapId;
        versesInChapter = [[NSMutableDictionary alloc] init];
        verseLookup = [[NSMutableDictionary alloc] init];
        verseSequence = [[NSMutableDictionary alloc] init];
}

- (NSInteger) getBookId
{
    return bookId;
}

- (NSString *) getChapterId
{
    return chapterId;
}

- (classChapter *) getPreviousChapter
{
    return previousChapter;
}

- (classChapter *) getNextChapter
{
    return nextChapter;
}

- (void) setBookId: (NSInteger) inBookId
{
    bookId = inBookId;
}

- (void) setChapterId: (NSString *) inChapterId
{
    chapterId = inChapterId;
}

- (void) setPreviousChapter:(classChapter *)InPreviousChapter
{
    previousChapter = InPreviousChapter;
}

- (void) setNextChapter:(nullable classChapter *)InNextChapter
{
    if( InNextChapter != nil ) nextChapter = InNextChapter;
}

- (NSUInteger) NoOfVersesInChapter
{
    return noOfVersesInChapter;
}

- (classVerse *) getVerseBySeqNo: (NSInteger) seqNo
{
    return [versesInChapter objectForKey:[[NSString alloc] initWithFormat:@"%li", seqNo]];
}

- (classVerse *) getVerseByVerseNo: (NSString *) verseId
{
    NSInteger seqNo;
    
    seqNo = [[verseSequence objectForKey:verseId] integerValue];
    return [self getVerseBySeqNo:seqNo];
}

- (NSString *) getVerseIdBySeqNo: (NSInteger) seqNo
{
    return [verseLookup objectForKey:[[NSString alloc] initWithFormat:@"%li", seqNo]];
}

@end
