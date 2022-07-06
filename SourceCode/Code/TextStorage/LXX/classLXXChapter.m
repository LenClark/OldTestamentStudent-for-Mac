/*============================================================================================================*
  *                                                                                                            *
  *                                             classLXXChapter                                                *
  *                                             ---------------                                                *
  *                                                                                                            *
  *  In essence, we want to identify each verse that belongs to a given chapter.  At root, information about   *
  *    the verse is provided by the class classLXXVerse.  However, we need to cater for the possibility that   *
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

#import "classLXXChapter.h"

@implementation classLXXChapter

@synthesize noOfVersesInChapter;
@synthesize bookNo;
@synthesize chapterNo;
@synthesize chapterRef;

/*=========================================================================================================================*
 *                                                                                                                         *
 *                                                  versesBySequence                                                       *
 *                                                  ----------------                                                       *
 *                                                                                                                         *
 *  A look-up list of verse class instances, keyed by a sequence no.                                                       *
 *      Key:   verse Sequence                                                                                              *
 *      Value: the class instance address                                                                                  *
 *                                                                                                                         *
 *=========================================================================================================================*/
@synthesize versesBySequence;

/*=========================================================================================================================*
 *                                                                                                                         *
 *                                               verseReferenceBySequence                                                  *
 *                                               ------------------------                                                  *
 *                                                                                                                         *
 *  A list that will convert the simple verse sequence to the verse "reference", as given in the data.                     *
 *      Key:   verse sequence                                                                                              *
 *      Value: the verse number provided from data                                                                         *
 *                                                                                                                         *
 *=========================================================================================================================*/
@synthesize verseReferenceBySequence;

/*=========================================================================================================================*
 *                                                                                                                         *
 *                                              sequenceForVerseReference                                                  *
 *                                              -------------------------                                                  *
 *                                                                                                                         *
 *  A reverse lookup to verseReferenceBySequence - i.e. given a data verse reference, this will give us the internal       *
 *    sequence number                                                                                                      *
 *      Key:   verse number (from data)                                                                                    *
 *      Value: verse sequence                                                                                              *
 *                                                                                                                         *
 *=========================================================================================================================*/
@synthesize sequenceForVerseReference;
@synthesize previousChapter;
@synthesize nextChapter;

classGlobal *globalVarsLXXChapter;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init])
    {
        globalVarsLXXChapter = inGlobal;
        versesBySequence = [[NSMutableDictionary alloc] init];
        verseReferenceBySequence = [[NSMutableDictionary alloc] init];
        sequenceForVerseReference = [[NSMutableDictionary alloc] init];
        noOfVersesInChapter = 0;
    }
    return self;
}

- (classLXXVerse *) addVerseToChapter: (NSString *) verseId
{
    NSInteger seqNo = -1;
    NSString *candidateSequence, *noOfVerses;
    classLXXVerse *newVerse;

    newVerse = nil;
    candidateSequence = nil;
    candidateSequence = [sequenceForVerseReference objectForKey:verseId];
    if (candidateSequence != nil)
    {
        seqNo = [candidateSequence integerValue];
        newVerse = [versesBySequence objectForKey:candidateSequence];
    }
    else
    {
        newVerse = [[classLXXVerse alloc] init:globalVarsLXXChapter];
        noOfVerses = [globalVarsLXXChapter convertIntegerToString: noOfVersesInChapter];
        [sequenceForVerseReference setValue:noOfVerses forKey:verseId];
        [verseReferenceBySequence setValue:verseId forKey:noOfVerses];
        [versesBySequence setValue:newVerse forKey:noOfVerses];
        noOfVersesInChapter++;
    }
    return newVerse;
}

- (classLXXVerse *) getVerseBySequence: (NSInteger) seqNo
{
    classLXXVerse *newVerse;

    newVerse = nil;
    newVerse = [versesBySequence objectForKey:[globalVarsLXXChapter convertIntegerToString: seqNo]];
    return newVerse;
}

- (classLXXVerse *) getVerseByVerseNo: (NSString *) verseRef
{
    NSInteger seqNo;
    NSString *candidateSequence;

    candidateSequence = nil;
    candidateSequence = [sequenceForVerseReference objectForKey:verseRef];
    if( candidateSequence == nil) return nil;
    seqNo = [candidateSequence integerValue];
    return [self getVerseBySequence:seqNo];
}

- (NSInteger) getSequenceByVerseNo: (NSString *) verseRef
{
    NSString *candidateSequence;

    candidateSequence = nil;
    candidateSequence = [sequenceForVerseReference objectForKey:verseRef];
    if( candidateSequence == nil) return -1;
    return [candidateSequence integerValue];
}

- (NSString *) getVerseNoBySequence: (NSInteger) seqNo
{
    NSString *verseRef;

    verseRef = nil;
    verseRef = [verseReferenceBySequence objectForKey:[globalVarsLXXChapter convertIntegerToString:seqNo]];
    return verseRef;
}

@end
