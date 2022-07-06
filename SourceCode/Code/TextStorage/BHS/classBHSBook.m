/*============================================================================================================*
  *                                                                                                            *
  *                                             classBHSBook                                                   *
  *                                             ------------                                                   *
  *                                                                                                            *
  *  In essence, we want to identify each chapter that belongs to a given book.  At root, information about    *
  *    the chapter is provided by the class classBHSChapter.  However, we need to cater for the possibility    *
  *    that the chapter number is _not_ a simple integer but may contain alphanumerics (e.g. 12a).  So, we     *
  *    a) key the list of class instances on a sequential integer.  The sequence has no significance other     *
  *       than ensuring uniqueness.  (It will actually be generated in the sequence the chapters are           *
  *       encounteredin the source data.)                                                                      *
  *    b) we separately provide a lookup of this sequence number which gives the String-based version of the   *
  *       chapter "number" (which we will call a chapter reference"), which is recorded in the sequence listed *
  *       in the source data.  This means that numbers may also be out of strict sequence.                     *
  *    c) we also provide an inverse lookup that allows us to find the sequence number, if we know the string- *
  *       based chapter reference.  This is important because it allows us to find the chapter details (the    *
  *       class instance) from the chapter reference provided by the source data.                              *
  *                                                                                                            *
  *  Note: 1. chapter sequences will be zero-based (i.e. start at zero) while chapter references are           *
  *           (ostensibly) meaningful and normally start at 1 (although they can be zero).                     *
  *        2. noOfChaptersInBook will count the *sequence* of chapters                                         *
  *                                                                                                            *
  *  Created by Len Clark                                                                                      *
  *  May 2022                                                                                                  *
  *                                                                                                            *
  *============================================================================================================*/

#import "classBHSBook.h"

@implementation classBHSBook

/*--------------------------------------------------------------------------------------------------------------*
  *                                                                                                              *
  *                                                  category                                                    *
  *                                                  --------                                                    *
  *                                                                                                              *
  *  This is a categorisation that nods in the direction of the traditional Jewish categories but also attempts  *
  *    to reflect popular Christian usage.  It also has the benefit that most categories contain fewer           *
  *    individual books.                                                                                         *
  *                                                                                                              *
  *  The categories are as follows:                                                                              *
  *                                                                                                              *
  *   Category                                            Content                                                *
  *   --------                                            -------                                                *
  *      1       The books of Moses: Genesis, Exodus, Numbers, Leviticus, Deuteronomy                            *
  *      2       The "former prophets", which we would categorise as "history": Joshua, Judges, 1 & 2 Samuel,    *
  *                 1 & 2 Kings                                                                                  *
  *      3       The major prophets - a group within the "latter prophets": Isaiah, Jeremiah and Ezekiel         *
  *      4       The minor prophets - also in the "latter prophets": Hosea, Joel, Amos, Obadiah, Jonah, Micah,   *
  *                 Nahum, Habakkuk,    Zephaniah, Haggai, Zechariah, Malachi                                       *
  *      5       The poetical books in the Kethubim ("the rest"/ "the [other] writings"): Job, Psalms, Proverbs, *
  *                 Ecclesiastes, Song of Solomon, Lamentations                                                  *
  *      6       The "historical" books of the Kethubim: Ruth, 1 & 2 Chronicles, Ezra, Nehemiah, Esther, Daniel  *
  *                                                                                                              *
  *--------------------------------------------------------------------------------------------------------------*/
 
@synthesize noOfChaptersInBook;
@synthesize category;
@synthesize bookId;
@synthesize bookName;
@synthesize shortName;

 /*--------------------------------------------------------------------------------------------------------------*
  *                                                                                                              *
  *                                                chaptersBySequence                                            *
  *                                                ------------------                                            *
  *                                                                                                              *
  *  A look-up list of chapter class instances, keyed by a sequence no.                                          *
  *     Key:   chapter Sequence                                                                                  *
  *     Value: the class instance address                                                                        *
  *                                                                                                              *
  *--------------------------------------------------------------------------------------------------------------*/
@synthesize chaptersBySequence;

 /*--------------------------------------------------------------------------------------------------------------*
  *                                                                                                              *
  *                                             chapterReferencesBySequence                                      *
  *                                             ---------------------------                                      *
  *                                                                                                              *
  *  A list that will convert the simple chapter sequence to the chapter, as given in the data                   *
  *     Key:   chapter sequence                                                                                  *
  *     Value: the chapter reference provided from data                                                          *
  *                                                                                                              *
  *--------------------------------------------------------------------------------------------------------------*/
@synthesize chapterReferencesBySequence;

 /*--------------------------------------------------------------------------------------------------------------*
  *                                                                                                              *
  *                                             sequenceForChapterReference                                      *
  *                                             ---------------------------                                      *
  *                                                                                                              *
  *  A reverse lookup to chapterReferencesBySequence - i.e. given a chapter reference, this will give us the     *
  *  internal sequence number                                                                                    *
  *     Key:   chapter reference (from data)                                                                     *
  *     Value: chapter sequence                                                                                  *
  *                                                                                                              *
  *--------------------------------------------------------------------------------------------------------------*/
@synthesize sequenceForChapterReference;

classGlobal *globalVarsBHSBook;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init] )
    {
        globalVarsBHSBook = inGlobal;
        chaptersBySequence = [[NSMutableDictionary alloc] init];
        chapterReferencesBySequence = [[NSMutableDictionary alloc] init];
        sequenceForChapterReference = [[NSMutableDictionary alloc] init];
        noOfChaptersInBook = 0;
    }
    return self;
}

- (classBHSChapter *) addNewChapterToBook: (NSString *) chapterId
{
    NSInteger sequenceNo;
    NSString *sequenceCandidate;
    classBHSChapter *newChapter;

    newChapter = nil;
    sequenceCandidate = nil;
    sequenceCandidate = [sequenceForChapterReference objectForKey:chapterId];
    if (sequenceCandidate != nil)
    {
        sequenceNo = [sequenceCandidate integerValue];
        newChapter = [chaptersBySequence objectForKey:[globalVarsBHSBook convertIntegerToString: sequenceNo]];
    }
    else
    {
        newChapter = [[classBHSChapter alloc] init:globalVarsBHSBook];
        [sequenceForChapterReference setObject:[globalVarsBHSBook convertIntegerToString:noOfChaptersInBook] forKey:chapterId];
        [chapterReferencesBySequence setObject:chapterId forKey:[globalVarsBHSBook convertIntegerToString:noOfChaptersInBook]];
        [chaptersBySequence setObject:newChapter forKey:[globalVarsBHSBook convertIntegerToString:noOfChaptersInBook++]];
    }
    return newChapter;
}

- (classBHSChapter *) getChapterBySequence: (NSInteger) seqNo
{
    classBHSChapter *newChapter;

    newChapter = nil;
    newChapter = [chaptersBySequence objectForKey:[globalVarsBHSBook convertIntegerToString:seqNo]];
    return newChapter;
}

- (classBHSChapter *) getChapterByChapterNo: (NSString *) chapterId
{
    NSInteger seqNo;
    NSString *sequenceCandidate;

    sequenceCandidate = nil;
    sequenceCandidate = [sequenceForChapterReference objectForKey:chapterId];
    if( sequenceCandidate == nil) return nil;
    seqNo = [sequenceCandidate integerValue];
    if (seqNo == -1) return nil;
    return [self getChapterBySequence:seqNo];
}

- (NSInteger) getSequenceByChapterNo: (NSString *) chapterId
{
    NSInteger seqNo;
    NSString *sequenceCandidate;

    sequenceCandidate = nil;
    sequenceCandidate = [sequenceForChapterReference objectForKey:chapterId];
    if( sequenceCandidate == nil) return  -1;
    seqNo = [sequenceCandidate integerValue];
    return seqNo;
}

- (NSString *) getChapterNoBySequence: (NSInteger) seqNo
{
    NSString *chapNo;

    chapNo = nil;
    chapNo = [chapterReferencesBySequence objectForKey:[globalVarsBHSBook convertIntegerToString:seqNo]];
    return chapNo;
}

@end
