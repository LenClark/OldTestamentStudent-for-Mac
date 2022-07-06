/*============================================================================================================*
 *                                                                                                            *
 *                                             classBHSChapter                                                *
 *                                             ---------------                                                *
 *                                                                                                            *
 *  In essence, we want to identify each verse that belongs to a given chapter.  At root, information about   *
 *    the verse is provided by the class classBHSVerse.  However, we need to cater for the possibility that   *
 *    verse number is _not_ a simple integer but may contain alphanumerics (e.g. 12a).  So, we                *
 *    a) key the list of class instances on a sequential integer.  The sequence has no significance other     *
 *       than ensuring uniqueness.  (It will actually be generated in the sequence the verses are encountered *
 *       in the source data.)                                                                                 *
 *    b) we separately provide a lookup of this sequence number which gives the String-based version of the   *
 *       verse "number" (which we will call a verse reference"), which is recorded in the sequence listed in  *
 *       the source data.  This means that numbers may also be out of strict sequence.                        *
 *    c) we also provide an inverse lookup that allows us to find the sequence number, if we know the string- *
 *       based verse reference.  This is important because it allows us to find the verse details (the class  *
 *       instance) from the verse reference provided by the source data.                                      *
 *                                                                                                            *
 *  Note: 1. verse sequences will be zero-based (i.e. start at zero) while  verse references are (ostensibly) *
 *           meaningful and normally start at 1 (although they can be zero).                                  *
 *        2. noOfVersesInChapter will count the *sequence* of verses                                          *
 *                                                                                                            *
 *  Created by Len Clark                                                                                      *
 *  May 2022                                                                                                  *
 *                                                                                                            *
 *============================================================================================================*/

#import "classBHSChapter.h"

@implementation classBHSChapter

@synthesize noOfVersesInChapter;
@synthesize bookNo;
@synthesize chapterSeqNo;
@synthesize chapterRef;
@synthesize previousChapter;
@synthesize nextChapter;

/*============================================================================================================*
 *                                                                                                            *
 *                                             versesBySequence                                               *
 *                                             ----------------                                               *
 *                                                                                                            *
 *  a look-up list of verse class instances, keyed by a sequence no.                                          *
 *     Key:   verse Sequence                                                                                  *
 *     Value: the class instance address                                                                      *
 *                                                                                                            *
 *============================================================================================================*/
@synthesize versesBySequence;

/*============================================================================================================*
 *                                                                                                            *
 *                                           verseReferenceBySequence                                         *
 *                                           ------------------------                                         *
 *                                                                                                            *
 *  A list that will convert the simple verse sequence to the verse "reference", as given in the data         *
 *     Key:   verse sequence                                                                                  *
 *     Value: the verse number provided from data                                                             *
 *                                                                                                            *
 *============================================================================================================*/
@synthesize verseReferenceBySequence;

/*============================================================================================================*
 *                                                                                                            *
 *                                           sequenceForVerseReference                                        *
 *                                           -------------------------                                        *
 *                                                                                                            *
 *  A reverse lookup to providedVersesBySequence - i.e. given a verse reference, this will give us the        *
 *    internal sequence number                                                                                *
 *     Key:   verse number (from data)                                                                        *
 *     Value: verse sequence                                                                                  *
 *                                                                                                            *
 *============================================================================================================*/
@synthesize sequenceForVerseReference;
classGlobal *globalVarsBHSChapter;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init] )
    {
        globalVarsBHSChapter = inGlobal;
        versesBySequence = [[NSMutableDictionary alloc] init];
        verseReferenceBySequence = [[NSMutableDictionary alloc] init];
        sequenceForVerseReference = [[NSMutableDictionary alloc] init];
        noOfVersesInChapter = 0;
    }
    return self;
}

- (classBHSVerse *) addVerseToChapter: (NSString *) verseId
{
    NSInteger seqNo;
    NSString *sequenceCandidate;
    classBHSVerse *newVerse;

    seqNo = -1;
    sequenceCandidate = [sequenceForVerseReference objectForKey:verseId];
    if (sequenceCandidate != nil)
    {
        seqNo = [sequenceCandidate integerValue];
        newVerse = [versesBySequence objectForKey:[globalVarsBHSChapter convertIntegerToString: seqNo]];
    }
    else
    {
        newVerse = [[classBHSVerse alloc] init:globalVarsBHSChapter];
        [sequenceForVerseReference setObject:[globalVarsBHSChapter convertIntegerToString: noOfVersesInChapter] forKey:verseId];
        [verseReferenceBySequence setObject:verseId forKey:[globalVarsBHSChapter convertIntegerToString: noOfVersesInChapter]];
        [versesBySequence setObject:newVerse forKey:[globalVarsBHSChapter convertIntegerToString: noOfVersesInChapter++]];
    }
    return newVerse;
}

- (classBHSVerse *) getVerseBySequence: (NSInteger) seqNo
{
    classBHSVerse *newVerse;

    newVerse = nil;
    newVerse = [versesBySequence objectForKey:[globalVarsBHSChapter convertIntegerToString: seqNo]];
    return newVerse;
}

- (classBHSVerse *) getVerseByVerseNo: (NSString *) verseId
{
    NSInteger seqNo;
    NSString *sequenceCandidate;

    seqNo = -1;
    sequenceCandidate = [sequenceForVerseReference objectForKey:verseId];
    if( sequenceCandidate == nil) return  nil;
    seqNo = [sequenceCandidate integerValue];
    if( seqNo == -1) return nil;
    return [self getVerseBySequence:seqNo];
}

- (NSInteger) getSequenceByVerseNo: (NSString *) verseId
{
    NSInteger seqNo;
    NSString *sequenceCandidate;

    seqNo = -1;
    sequenceCandidate = [sequenceForVerseReference objectForKey:verseId];
    if( sequenceCandidate == nil) return -1;
    seqNo = [sequenceCandidate integerValue];
    return seqNo;
}

- (NSString *) getVerseNoBySequence: (NSInteger) seqNo
{
    NSString *verseId;

    verseId = nil;
    verseId = [verseReferenceBySequence objectForKey:[globalVarsBHSChapter convertIntegerToString: seqNo]];
    return verseId;
}

@end
