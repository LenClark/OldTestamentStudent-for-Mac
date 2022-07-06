/*============================================================================================================*
 *                                                                                                            *
 *                                              classLXXBook                                                  *
 *                                              ------------                                                  *
 *                                                                                                            *
 *  In essence, we want to identify each chapter that belongs to a given book.  At root, information about    *
 *    the chapter is provided by the class classLXXChapter.  However, we need to cater for the possibility    *
 *    that the chapter number is _not_ a simple integer but may contain alphanumerics (e.g. 12a).  So, we     *
 *    a) key the list of class instances on a sequential integer.  The sequence has no significance other     *
 *       than ensuring uniqueness.  (It will actually be generated in the sequence the chapters are           *
 *       encountered in the source data.)                                                                     *
 *    b) we separately provide a lookup of this sequence number which gives the String-based version of the   *
 *       chapter "number" (which we will call a "chapter reference"), which is recorded in the sequence       *
 *       listed in the source data.  This means that numbers may also be out of strict sequence.              *
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

#import "classLXXBook.h"

@implementation classLXXBook

@synthesize noOfChaptersInBook;
/*--------------------------------------------------------------------------------------------------------------*
 *                                                                                                              *
 *                                                  category                                                    *
 *                                                  --------                                                    *
 *                                                                                                              *
 *  This reflects the categorisation used for MT books: the books of LXX are placed in the same category groups *
 *    as their Hebrew (and Aramaic) equivalents.  However, we also need an additional category for those books  *
 *    not found in the Hebrew and Aramaic canon.                                                                *
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
 *      7       The pseudo-canonical books: 1 Esdras, Judith, Tobit, 1-4 Macabees, Odes, Wisdom of Solomon,     *
 *                 Ecclesiasticus, Psalms of Solomon, Baruch, Epistle of Jeremiah, Bel and the Dragon, Susanna  *
 *                                                                                                              *
 *--------------------------------------------------------------------------------------------------------------*/
@synthesize category;
@synthesize bookId;
@synthesize shortName;
@synthesize commonName;
@synthesize lxxName;
@synthesize fileName;

/*--------------------------------------------------------------------------------------------------------------*
 *                                                                                                              *
 *                                                chaptersBySequence                                            *
 *                                                ------------------                                            *
 *                                                                                                              *
 *  A look-up list of chapter class instances, keyed by a sequence no.                                          *
 *      Key:   chapter Sequence                                                                                 *
 *      Value: the class instance address                                                                       *
 *                                                                                                              *
 *--------------------------------------------------------------------------------------------------------------*/
@synthesize chaptersBySequence;

/*--------------------------------------------------------------------------------------------------------------*
 *                                                                                                              *
 *                                            chapterReferencesBySequence                                       *
 *                                            ---------------------------                                       *
 *                                                                                                              *
 *  A list that will convert the simple chapter sequence to the chapter reference, as given in the data         *
 *      Key:   chapter sequence                                                                                 *
 *      Value: the chapter "number" provided from data (which can be e.g. 12a)                                  *
 *                                                                                                              *
 *--------------------------------------------------------------------------------------------------------------*/
@synthesize chapterReferencesBySequence;

/*--------------------------------------------------------------------------------------------------------------*
 *                                                                                                              *
 *                                            sequenceForChapterReference                                       *
 *                                            ---------------------------                                       *
 *                                                                                                              *
 *  A reverse lookup to chapterReferencesBySequence - i.e. given a data chapter reference, this will give us    *
 *    the internal sequence number                                                                              *
 *      Key:   chapter number (from data)                                                                       *
 *      Value: chapter sequence                                                                                 *
 *                                                                                                              *
 *--------------------------------------------------------------------------------------------------------------*/
@synthesize sequenceForChapterReference;

/*--------------------------------------------------------------------------------------------------------------*
 *                                                                                                              *
 *                              lower bound processing                                                          *
 *                              ----------------------                                                          *
 *                                                                                                              *
 *  This is used specifically for those books where a chapter may be separated by another, out-of-sequence      *
 *    chapter.  For example, we may find chapter 24 followed by chapter 30 and later the rest of chapter 24.    *
 *                                                                                                              *
 *  secondLowerBound: an array of arrays.  It will contain 3 sub-arrays.  Each of these sub-arrays will be an   *
 *    array of strings.                                                                                         *
 *                                                                                                              *
 *  lowerBoundSizes: A second array of 3 integers will indicate how many are in each of the three sub-arrays.   *
 *                                                                                                              *
 *  lowerBoundChapters: the "key" to the three sub-arrays: the chapters affected.                               *
 *                                                                                                              *
 *--------------------------------------------------------------------------------------------------------------*/
@synthesize secondLowerBound;
@synthesize lowerBoundSizes;
@synthesize lowerBoundChapters;

classGlobal *globalVarsLXXBook;

- (id) init: (classGlobal *) inGlobal
{
    NSArray *array1, *array2, *array3;
    
    if( self = [super init])
    {
        globalVarsLXXBook = inGlobal;
        chaptersBySequence = [[NSMutableDictionary alloc] init];
        chapterReferencesBySequence = [[NSMutableDictionary alloc] init];
        sequenceForChapterReference = [[NSMutableDictionary alloc] init];
        array1 = [[NSArray alloc] initWithObjects: @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", nil];
        array2 = [[NSArray alloc] initWithObjects: @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", nil];
        array3 = [[NSArray alloc] initWithObjects: @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", nil];
        secondLowerBound = [[NSArray alloc] initWithObjects:array1, array2, array3, nil];
        lowerBoundSizes = [[NSArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%ld", [array1 count]], [[NSString alloc] initWithFormat:@"%ld", [array2 count]], [[NSString alloc] initWithFormat:@"%ld", [array3 count]], nil];
        lowerBoundChapters = [[NSArray alloc] initWithObjects: @"24", @"30", @"31", nil];
        noOfChaptersInBook = 0;
    }
    return self;
}

- (classLXXChapter *) addNewChapterToBook: (NSString *) chapterRef
{
    /*==========================================================================================================*
     *                                                                                                          *
     *                                           addNewChapterToBook                                            *
     *                                           ===================                                            *
     *                                                                                                          *
     *  This method will:                                                                                       *
     *  a) create a new instance of the chapter;                                                                *
     *  b) accept the text chapter designation of the source file (= chapterId);                                *
     *  c) generate a sequential chapter reference number (= noOfChaptersInBook);                               *
     *  d) add the chapter instance to a List, keyed on the sequential value;                                   *
     *  e) add the text chapter designation to a list, keyed by the sequential value;                           *
     *  f) create a reverse reference list to the sequential value so that we can retrieve the sequence number  *
     *       if we know the chapter designation                                                                 *
     *                                                                                                          *
     *  This approach has been used because the LXX sometimes has some non-sequential chapters (and even some   *
     *       chapters that aren't actual numbers).  However, there is a problem: in Proverbs, Rahlfs chapter    *
     *       designation is as follows:                                                                         *
     *           1 - 24 (v22e), 30 (vv 1-14), 24 again (vv 23-34), 30 again (vv 15-33), 31 (vv 1-9), 32 - 36,   *
     *           31 (vv 11-31).                                                                                 *
     *       As a result, the reverse list (keyed on the chapter designation) is not unique for chapters 24, 30 *
     *       and 31.                                                                                            *
     *                                                                                                          *
     *  To enable this, we have added a wierd extra:                                                            *
     *    occurrenceList will be keyed on the chapter reference with a value of the last occurrence of the      *
     *    chapter.  So, most will have a value of 0 but, for example, the second time we hit 24, the occurrence *
     *    will be adjusted up to 1. chapterSequence will then *not* be keyed on the chapter designation alone   *
     *    but a concatenation of chapter designation and occurrence (seperated by "-").  This will ensure       *
     *    uniqueness.  Retrieving the chapter designation will require the removal of this occurrence value.    *
     *                                                                                                          *
     *==========================================================================================================*/
    NSInteger sequenceNo;
    NSString *candidateSequence;
    NSMutableString *substituteChapterId;
    classLXXChapter *newChapter;

    newChapter = nil;
    candidateSequence = nil;
    candidateSequence = [sequenceForChapterReference objectForKey:chapterRef];
    if (candidateSequence != nil)
    {
        sequenceNo = [candidateSequence integerValue];
        newChapter = [chaptersBySequence objectForKey:candidateSequence];
    }
    else
    {
        newChapter = [[classLXXChapter alloc] init:globalVarsLXXBook];
        [chaptersBySequence setValue:newChapter forKey:[globalVarsLXXBook convertIntegerToString: noOfChaptersInBook]];
        if (bookId == 28)  // bookId must have been supplied independently before calling this method
        {
            substituteChapterId = [[NSMutableString alloc] initWithString:chapterRef];
            candidateSequence = nil;
            candidateSequence = [sequenceForChapterReference objectForKey:chapterRef];
            if (candidateSequence != nil)
            {
                [substituteChapterId appendString: @"b"];
            }
            [chapterReferencesBySequence setObject:[[NSString alloc] initWithString:substituteChapterId] forKey:[globalVarsLXXBook convertIntegerToString:noOfChaptersInBook]];
            [sequenceForChapterReference setObject:[globalVarsLXXBook convertIntegerToString:noOfChaptersInBook] forKey:[[NSString alloc] initWithString:substituteChapterId]];
        }
        else
        {
            [chapterReferencesBySequence setObject:chapterRef forKey:[globalVarsLXXBook convertIntegerToString:noOfChaptersInBook]];
            [sequenceForChapterReference setObject:[globalVarsLXXBook convertIntegerToString:noOfChaptersInBook] forKey:chapterRef];
        }
        noOfChaptersInBook++;
    }
    return newChapter;
}

- (classLXXChapter *) getChapterBySequence: (NSInteger) seqNo
{
    classLXXChapter *newChapter;

    newChapter = nil;
    newChapter = [chaptersBySequence objectForKey:[globalVarsLXXBook convertIntegerToString:seqNo]];
    return newChapter;
}

- (classLXXChapter *) getChapterByChapterNo: (NSString *) chapterRef
{
    NSInteger seqNo;
    NSString *candidateSequence;

    candidateSequence = nil;
    candidateSequence = [sequenceForChapterReference objectForKey:chapterRef];
    if( candidateSequence == nil) return nil;
    seqNo = [candidateSequence integerValue];
    return [self getChapterBySequence:seqNo];
}

- (NSInteger) getSequenceByChapterNo: (NSString *) chapterRef
{
    NSString *candidateSequence;
    
    candidateSequence = nil;
    candidateSequence = [sequenceForChapterReference objectForKey:chapterRef];
    if( candidateSequence == nil) return -1;
    return [candidateSequence integerValue];
}

- (NSString *) getChapterNoBySequence: (NSInteger) seqNo
{
    NSString *chapterRef;

    chapterRef = nil;
    chapterRef = [chapterReferencesBySequence objectForKey:[globalVarsLXXBook convertIntegerToString:seqNo]];
    return chapterRef;
}

@end
