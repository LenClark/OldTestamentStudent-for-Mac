//
//  classNotes.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 18/01/2021.
//

#import "classNotes.h"

@implementation classNotes

classConfig *globalVarsNotes;
NSString *seperator, *unspace;

- (id) init: (classConfig *) inConfig
{
    if( self = [super init])
    {
        globalVarsNotes = inConfig;
        seperator = @"\u2063";
        unspace = @"\u200b";
    }
    return self;
}

- (void) retrieveAllNotes
{
    /********************************************************************************
     *                                                                              *
     *                            retrieveAllNotes                                  *
     *                            ================                                  *
     *                                                                              *
     *  Loads all notes data from the provided file contents into the relevant      *
     *    verses.  It assumes a line format as follows:                             *
     *                                                                              *
     *    Field                    Content                                          *
     *    -----                    -------                                          *
     *      1        A code indicating whether the note is for a NT book or an LXX  *
     *                 book:                                                        *
     *                  1 => NT,  2 => LXX                                          *
     *      2        The zero-based bok id                                          *
     *      3        The chapter (this is the actual chapter, not a sequence code)  *
     *      4        The verse (also the actual verse number)                       *
     *      5        The entirety of the note (and may include carriage returnes)   *
     *                                                                              *
     *  Each of the four fields are seperated by the unicode character 0x200b.      *
     *    Each note (with book/chapter/verse details) is delimited by the unicode   *
     *    character 0x2063.                                                         *
     *                                                                              *
     *  The only exceptions to the above structure is that lines can be blank or    *
     *    comments - i.e. have the character ';' as the first non-whitespace        *
     *    entry.                                                                    *
     *                                                                              *
     ********************************************************************************/

    BOOL isDir = true;
    NSUInteger testamentIdx, bookIdx;
    NSString *notesPath, *notesName, *fileName, *noteFileName, *dataStore, *chapIdx, *verseIdx;
    NSArray *noteContent, *directoryContents;
    NSDictionary *bookList;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    NSFileManager *fmNotes;

    fmNotes = [NSFileManager defaultManager];
    notesPath = [[NSString alloc] initWithString:[globalVarsNotes notesFolder]];
    notesName = [[NSString alloc] initWithString:[globalVarsNotes notesName]];
    fileName = [[NSString alloc] initWithFormat:@"%@/%@", notesPath, notesName];
    if( [fmNotes fileExistsAtPath:fileName isDirectory:&isDir] )
    {
        directoryContents = [[NSArray alloc] initWithArray:[fmNotes contentsOfDirectoryAtPath:fileName error:nil]];
        for (NSString *discoveredFile in directoryContents)
        {
            if( [discoveredFile characterAtIndex:0] == '.') continue;
            noteFileName = [[NSString alloc] initWithFormat:@"%@/%@", fileName, discoveredFile];
            dataStore = [[NSString alloc] initWithContentsOfFile:noteFileName encoding:NSUTF8StringEncoding error:nil];
            noteContent = [discoveredFile componentsSeparatedByString:@"-"];
            testamentIdx = [[noteContent objectAtIndex:0] integerValue];
            bookIdx = [[noteContent objectAtIndex:1] integerValue];
            chapIdx = [noteContent objectAtIndex:2];
            verseIdx = [noteContent objectAtIndex:3];
            if( testamentIdx == 1 ) bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsNotes ntListOfBooks]];
            else bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsNotes lxxListOfBooks]];
            currentBook = [bookList valueForKey:[NSString stringWithFormat:@"%li", bookIdx]];
            currentChapter = [currentBook getChapterByChapterId:chapIdx];
            currentVerse = [currentChapter getVerseByVerseNo:verseIdx];
            currentVerse.noteText = dataStore;
        }
    }
}

-(void) saveAllNotes
{
    /********************************************************************************
     *                                                                              *
     *                               saveAllNotes                                   *
     *                               ============                                   *
     *                                                                              *
     *  See _retrieveAllNotes_ head comment for details of the file structure       *
     *                                                                              *
     *  All notes are saved when leaving the notes area.  So, this shouldn't        *
     *    normally be needed - only when the user explicitly chooses to save notes  *
     *                                                                              *
     ********************************************************************************/
    
    NSUInteger testamentIdx, bookIdx, chapIdx, verseIdx, noOfBooks, noOfChapters, noOfVerses;
    NSString *actualNote, *notesPath, *fileName, *dataStore;
    NSDictionary *bookList;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    
    notesPath = [[NSString alloc] initWithString:[globalVarsNotes notesFolder]];
    fileName = [[NSString alloc] initWithString:[globalVarsNotes notesName]];
    for( testamentIdx = 1; testamentIdx <= 2; testamentIdx++ )
    {
        if( testamentIdx == 1 ) bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsNotes ntListOfBooks]];
        else bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsNotes lxxListOfBooks]];
        noOfBooks = [bookList count];
        for( bookIdx = 0; bookIdx < noOfBooks; bookIdx++ )
        {
            currentBook = [bookList valueForKey:[NSString stringWithFormat:@"%li", bookIdx]];
            noOfChapters = [currentBook noOfChaptersInBook];
            for( chapIdx = 0; chapIdx < noOfChapters; chapIdx++ )
            {
                currentChapter = [currentBook getChapterBySeqNo:chapIdx];
//                currentChapter = [currentBook getChapterBySeqNo:[[NSString alloc] initWithFormat:@"%li", chapIdx]];
                noOfVerses = [currentChapter noOfVersesInChapter];
                for( verseIdx = 0; verseIdx < noOfVerses; verseIdx++)
                {
                    currentVerse = [currentChapter getVerseBySeqNo:verseIdx];
                    if(( [currentVerse noteText] != nil ) && ( [[currentVerse noteText] length] > 0 ) )
                    {
                        actualNote = [[NSString alloc] initWithString:[currentVerse noteText]];
                        dataStore = [[NSString alloc] initWithFormat:@"%@/%@/%li-%li-%@-%@", notesPath, fileName, testamentIdx, bookIdx, [currentBook getChapterIdBySeqNo:chapIdx], [currentChapter getVerseIdBySeqNo:verseIdx]];
                        if( [dataStore length] > 0 )
                        {
                            [dataStore writeToFile:actualNote atomically:YES encoding:NSUTF8StringEncoding error:nil];
                        }
                    }
                }
            }
        }
    }
}

- (void) displayANote: (NSInteger) testamentId forBookId: (NSInteger) bookId chapterSequence: (NSInteger) chapSeq verseSequence: (NSInteger) verseSeq
{
    NSString *notesText;
    NSDictionary *bookList;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    
    if( testamentId == 1 ) bookList = [globalVarsNotes ntListOfBooks];
    else bookList = [globalVarsNotes lxxListOfBooks];
    currentBook = [bookList objectForKey:[[NSString alloc] initWithFormat:@"%li", bookId]];
    currentChapter = [currentBook getChapterBySeqNo:chapSeq];
    currentVerse = [currentChapter getVerseBySeqNo:verseSeq];
    if( [currentVerse noteText] == nil)
    {
        [[globalVarsNotes notesTextView] setString:@""];
    }
    else
    {
        notesText = [[NSString alloc] initWithString:[currentVerse noteText]];
        if( notesText != nil)
        {
            [[globalVarsNotes notesTextView] setString:notesText];
        }
    }
}

-(void) clearAllNotes
{
    NSUInteger testamentIdx, idx, cdx, vdx, noOfBooks, noOfChapters, noOfVerses;
    NSDictionary *bookList;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    
    for( testamentIdx = 1; testamentIdx <= 2; testamentIdx++)
    {
        if( testamentIdx == 1 ) bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsNotes ntListOfBooks]];
        else bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsNotes lxxListOfBooks]];
        noOfBooks = [bookList count];
        for( idx = 0; idx < noOfBooks; idx++ )
        {
            currentBook = [bookList objectForKey:[NSString stringWithFormat:@"%li", idx]];
            noOfChapters = [currentBook noOfChaptersInBook];
            for( cdx = 0; cdx < noOfChapters; cdx++ )
            {
                currentChapter = [currentBook getChapterBySeqNo:cdx];
                noOfVerses = [currentChapter noOfVersesInChapter];
                for( vdx = 0; vdx < noOfVerses; vdx++ )
                {
                    currentVerse = [currentChapter getVerseBySeqNo:vdx];
                    currentVerse.noteText = @"";
                }
            }
        }
    }
}

-(void) storeANote
{
    /********************************************************************************
     *                                                                              *
     *                                storeANote                                    *
     *                                ==========                                    *
     *                                                                              *
     *  This stores the note you are leaving.  It will both:                        *
     *    - store the current note text in the class instance of the verse, and     *
     *    - save the text to file                                                   *
     *                                                                              *
     ********************************************************************************/

    BOOL isDir = true;
    NSUInteger testamentIdx, bookIdx, chapIdx, verseIdx;
    NSString *noteText, *notesPath, *actualNoteName;
    NSDictionary *bookList;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    NSFileManager *fmNotes;
    
    testamentIdx = [[globalVarsNotes topLeftTabView] indexOfTabViewItem:[[globalVarsNotes topLeftTabView] selectedTabViewItem]];
    testamentIdx++;
    if( testamentIdx == 1 )
    {
        bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsNotes ntListOfBooks]];
        bookIdx = [[globalVarsNotes cbNtBook] indexOfSelectedItem];
        currentBook = [bookList valueForKey:[NSString stringWithFormat:@"%li", bookIdx]];
        chapIdx = [[globalVarsNotes cbNtChapter] indexOfSelectedItem];
        currentChapter = [currentBook getChapterBySeqNo:chapIdx];
        verseIdx = [[globalVarsNotes cbNtVerse] indexOfSelectedItem];
        currentVerse = [currentChapter getVerseBySeqNo:verseIdx];
    }
    else
    {
        bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsNotes lxxListOfBooks]];
        bookIdx = [[globalVarsNotes cbLxxBook] indexOfSelectedItem];
        currentBook = [bookList valueForKey:[NSString stringWithFormat:@"%li", bookIdx]];
        chapIdx = [[globalVarsNotes cbLxxChapter] indexOfSelectedItem];
        currentChapter = [currentBook getChapterBySeqNo:chapIdx];
        verseIdx = [[globalVarsNotes cbLxxVerse] indexOfSelectedItem];
        currentVerse = [currentChapter getVerseBySeqNo:verseIdx];
    }
    if( [[globalVarsNotes notesTextView] string] != nil)
    {
        noteText = [[NSString alloc] initWithString:[[globalVarsNotes notesTextView] string]];
        currentVerse.noteText = noteText;
        notesPath = [[NSString alloc] initWithFormat:@"%@/%@", [globalVarsNotes notesFolder], [globalVarsNotes notesName]];
        fmNotes = [NSFileManager defaultManager];
        if( ! [fmNotes fileExistsAtPath:notesPath isDirectory:&isDir]) [fmNotes createDirectoryAtPath:notesPath withIntermediateDirectories:true attributes:nil error:nil];
        actualNoteName = [[NSString alloc] initWithFormat:@"%@/%li-%li-%@-%@", notesPath, testamentIdx, bookIdx,
                          [currentBook getChapterIdBySeqNo:chapIdx], [currentChapter getVerseIdBySeqNo:verseIdx]];
        [noteText writeToFile:actualNoteName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

@end
