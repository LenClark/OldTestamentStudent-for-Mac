//
//  classBook.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import "classBook.h"

@implementation classBook

/*--------------------------------------------------------------------------------*
 *                                                                                *
 *                               Storage of Chapters                              *
 *                               -------------------                              *
 *                                                                                *
 *  Chapters occur in a specific sequence, which is provided to us as a sequence  *
 *    of similarly named (or numbered chapters).  Because chapters are somethimes *
 *    not strictly logical in LXX we will adopt the following strategy:           *
 *    a) we will handle Proverbs differently from other books;                    *
 *    b) as a consequence, we will store a bookId when we create the instance;    *
 *    c) these will be as follows:                                                *
 *         -1   all NT books will have this value;                                *
 *         0-58 the LXX book id (the filenumber - 1)                              *
 *         28   will indicate the book is Proverbs and must be handled            *
 *                differently                                                     *
 *                                                                                *
 *  chaptersInBook:  a look-up list of chapter instances, keyed by a sequence no. *
 *  chapterLookup:   the text-based, visible chapter associated with the same     *
 *                   sequence key as used in chaptersInBook                       *
 *  chapterSequence: a look-up list keyed on the meaningful, text-based chapter   *
 *                   which returns the associated sequence number                 *
 *                                                                                *
 *--------------------------------------------------------------------------------*/

@synthesize bookName;
@synthesize shortName;
@synthesize fileName;
@synthesize noOfChaptersInBook;
@synthesize chaptersInBook;
@synthesize chapterLookup;
@synthesize chapterSequence;

NSInteger bookId;
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
 *  chaptersInBook    String    String    Key: logically, a sequence integer, but *
 *                                             string is used in case non-numeric *
 *                                             values are returned.               *
 *                                        Value: a classContentChapter instance   *
 *                                                                                *
 *      Examples:                                                                 *
 *         Genesis - @"1"; address of chapter 1                                   *
 *                   @"2"; address of chapter 2, etc                              *
 *         Judges -  @"15"; address of chapter 15 (the first chapter!             *
 *                   @"18"; address of the next chapter, etc                      *
 *                                                                                *
 *  chapterLookup     Int       String    Key: a simple sequence (0 - no of       *
 *                                             chapters.                          *
 *                                        Value: the real chapter, as provided by *
 *                                             the source data (and is, in fact,  *
 *                                             the key to chaptersInBook).        *
 *                                                                                *
 *      Examples:                                                                 *
 *         Genesis - @"0"; @"1" - zeroth element -> chapter 1                     *
 *                   @"1"; @"2" - 1st element -> chapter 2, etc                   *
 *         Judges -  @"0"; @"15" - 0th element -> chapter 15 (the first actual)   *
 *                   @"1"; @"18" - 1st element -> next in sequence = 18, etc      *
 *                                                                                *
 *  chapterSequence   String    Int       Key: the real chapter (see above)       *
 *                                        Value: the sequence (see above)         *
 *                                        In other words, this is the inverse of  *
 *                                        chapterLookup and allows us to find the *
 *                                        sequence key if we know the given       *
 *                                        chapter                                 *
 *                                                                                *
 *       Examples:                                                                *
 *          Genesis - @"1"; @"0" - inverse of chapterLookup                       *
 *                    @"2"; @"1"                                                  *
 *          Judges -  @"15"; @"0"                                                 *
 *                    @"18"; @"1"                                                 *
 *                                                                                *
 *  secondLowerBound  String    Array     Key: the chapter, as provided within    *
 *                                             the text.                          *
 *                                        Value: an array of all verse values     *
 *                                             that are found in the *second*     *
 *                                             occurrence of the chapter.         *
 *                                        (This is used in Proverbs.)             *
 *                                                                                *
 *--------------------------------------------------------------------------------*/

classConfig *globalVarsBook;

-(void) initialise: (classConfig *) passedConfig forBook: (NSString *) currentBookName
{
        globalVarsBook = passedConfig;
        chaptersInBook = [[NSMutableDictionary alloc] init];
        chapterLookup = [[NSMutableDictionary alloc] init];
        chapterSequence = [[NSMutableDictionary alloc] init];
        noOfChaptersInBook = 0;
        bookName = currentBookName;
}

- (classChapter *) getChapterBySeqNo: (NSInteger) seqNo
{
    classChapter *tempChapter;
    
    tempChapter = [chaptersInBook objectForKey:[[NSString alloc] initWithFormat:@"%li", (seqNo + 1)]];
    return tempChapter;
}

- (classChapter *) getChapterByChapterId: (NSString *) chapterId
{
    NSInteger seqNo;
    classChapter *tempChapter;
    
//    seqNo = [[chapterSequence objectForKey:chapterId] integerValue];
//    tempChapter = [self getChapterBySeqNo:seqNo];
    tempChapter = [chaptersInBook objectForKey:chapterId];
    return tempChapter;
}

- (NSInteger) getSeqNoByChapterId: (NSString *) chapterId
{
    return [[chapterSequence objectForKey:chapterId] integerValue];
}

- (NSString *) getChapterIdBySeqNo: (NSInteger) seqNo
{
    return [chapterLookup objectForKey:[[NSString alloc] initWithFormat:@"%li", seqNo]];
}

@end
