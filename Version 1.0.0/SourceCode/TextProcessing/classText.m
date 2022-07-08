//
//  classText.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import "classText.h"

@implementation classText

@synthesize isChapUpdateActive;
@synthesize noOfNtBooks;
@synthesize noOfLxxBooks;

classConfig *globalVarsText;
classGreekProcessing *greekProcessingText;
classLexicon *lexiconText;
AppDelegate *textAppDelegate;

NSMutableDictionary *listOfNtBooks, *listOfLxxBooks;

- (id) init: (classConfig *) inConfig greekProcessing: (classGreekProcessing *) inGkProc withLexicon: (classLexicon *) inLexicon
{
    if( self = [super init])
    {
        globalVarsText = inConfig;
        greekProcessingText = inGkProc;
        lexiconText = inLexicon;
        textAppDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    }
    return self;
}

- (NSInteger) NoOfNtBooks
{
    return noOfNtBooks;
}

- (NSInteger) NoOfLxxBooks
{
    return noOfLxxBooks;
}

- (NSArray *) storeAllText
{
    /*-----------------------------------------------------------------------------*
     *                                                                             *
     *                           storeAllText                                      *
     *                           ============                                      *
     *                                                                             *
     *  Handles the initial transfer of NT text from files to memory (i.e. the     *
     *  class hierarchy).                                                          *
     *                                                                             *
     *  Indexing:                                                                  *
     *  --------                                                                   *
     *  Books will be indexed from 0 onwards.  (The file book code starts at 1, so *
     *     be careful when handling data from the files.)                          *
     *  Chapters and Verses will be indexed sequentially on a zero based count     *
     *     also but the "real" chapter and verse number will also be retained      *
     *     and key accesses will be provided by both sequence number and           *
     *     chapter/verse number.  (This allows simple access - by sequence - and   *
     *     real world access - by chapter/verse = even where the chapters or [more *
     *     likely] verses are *not* sequential - i.e. one or more are omitted.)    *
     *                                                                             *
     *-----------------------------------------------------------------------------*/
    
    NSComboBox *cbNtBook, *cbLxxBook;
    NSMutableArray *booksForListbox = [[NSMutableArray alloc] init];
    NSRunLoop *mainLoop;
    
    mainLoop = [globalVarsText mainLoop];

    /*********************************************************************************
     *
     *   Step 1: Get NT details from the file:
     *
     *********************************************************************************/
    
    {
        NSString *fullFileName, *fullText;
        NSArray *textByLine, *lineBreakdown;
        classBook *currentBook;
        
        [textAppDelegate remotePause:@"Retrieving New Testament book details" withSecondMsg:@" " andOption:true withOptionValue:false];
        cbNtBook = [globalVarsText cbNtBook];
        fullFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:@"NTTitles" ofType:@"txt"]];
        fullText = [[NSString alloc] initWithContentsOfFile:fullFileName encoding:NSUTF8StringEncoding error:nil];
        listOfNtBooks = [[NSMutableDictionary alloc] init];
        textByLine = [[NSArray alloc] initWithArray:[fullText componentsSeparatedByString:@"\n"]];
        for( NSString *lineOfText in textByLine)
        {
            lineBreakdown = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
            currentBook = [classBook new];
            [currentBook initialise:globalVarsText forBook:[lineBreakdown objectAtIndex:0]];
            [listOfNtBooks setObject:currentBook forKey:[[NSString alloc] initWithFormat:@"%li", noOfNtBooks]];
            noOfNtBooks++;
            currentBook.bookName = [lineBreakdown objectAtIndex:0];
            currentBook.shortName = [lineBreakdown objectAtIndex:1];
            currentBook.fileName = [lineBreakdown objectAtIndex:2];
            [cbNtBook addItemWithObjectValue:[currentBook bookName]];
            [booksForListbox addObject:[currentBook bookName]];
        }
    }

    /*********************************************************************************
     *
     *   Step 2: Now recurse through the NT files to load all text
     *
     *   File Structure:
     *   --------------
     *     Field          Significance
     *        1     Chapter (there is no book code; it can be generated at run-time)
     *        2     Verse
     *        3     Parse Code 1
     *        4     Parse code 2
     *        3     Abbreviated part of speech Id
     *        4     Blank field
     *        5     Unique code id (when combined with field 3)
     *        6     Word, as used in the text
     *        7     Word used with accents and iota subscripts removed
     *        8     Word used, as field 7, but breathings and diereses also removed
     *        9     Root word
     *       10     Pre-word non-Greek characters (if any)
     *       11     Post-word non-Greek non-punctuation characters (if any)
     *       12     Final punctuation (if any)
     *
     *********************************************************************************/
    
    {
        NSInteger idx;
        NSString *verseId, *prevVerseId, *chapterId, *prevChapterId, *fullFileName, *nameWithoutExt, *fullText;
        NSArray *textByLine, *lineBreakdown;
        classBook *currentBook;
        classChapter *currentChapter, *prevChapter;
        classVerse *currentVerse, *previousVerse;
        classWord *currentWord;
        
        currentChapter = nil;
        currentVerse = nil;
        prevChapter = nil;
        for (idx = 0; idx < noOfNtBooks; idx++)
        {
            currentBook = nil;
            currentBook = [listOfNtBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
            if (currentBook == nil) continue;
            [textAppDelegate remotePause:@"Retrieving New Testament book details" withSecondMsg:[currentBook bookName] andOption:false withOptionValue:false];
            nameWithoutExt = [[NSString alloc] initWithString:[[currentBook fileName] substringToIndex:[[currentBook fileName] length] - 4]];
            fullFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:nameWithoutExt ofType:@"txt"]];
            fullText = [[NSString alloc] initWithContentsOfFile:fullFileName encoding:NSUTF8StringEncoding error:nil];
            textByLine = [[NSArray alloc] initWithArray:[fullText componentsSeparatedByString:@"\n"]];
            prevChapterId = @"";
            prevVerseId = @"x";
            previousVerse = nil;
            for( NSString *lineOfText in textByLine)
            {
                lineBreakdown = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
                // Handle the chapter
                chapterId = [[[NSString alloc] initWithString:[lineBreakdown objectAtIndex:0]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if( [chapterId length] == 0) continue;
                if( [chapterId compare:prevChapterId] != NSOrderedSame)
                {
                    /*----------------------------------------------------------------*
                     *                                                                *
                     *  The next mini-section (and all marked this way) are required  *
                     *    because Objective-C does something odd to class management  *
                     *    of Dictionaries.  It explains the variation from the code   *
                     *    in Windows.                                                 *
                     *                                                                *
                     *  Populate the various Dictionaries allowing navigation of      *
                     *    chapters (stored in the Books class).                       *
                     *                                                                *
                     *----------------------------------------------------------------*/
                    currentChapter = [classChapter new];
                    [currentChapter initialise:idx forChapter:chapterId];
                    [[currentBook chaptersInBook] setObject:currentChapter forKey:chapterId];
                    [[currentBook chapterLookup] setObject:chapterId forKey:[[NSString alloc] initWithFormat:@"%li", [currentBook noOfChaptersInBook]]];
                    [[currentBook chapterSequence] setObject:[[NSString alloc] initWithFormat:@"%li", [currentBook noOfChaptersInBook]] forKey:chapterId];
                    currentBook.noOfChaptersInBook++;
                    /*----------------------------------------------------------------*
                     *                                                                *
                     *  End of code variation.                                        *
                     *                                                                *
                     *----------------------------------------------------------------*/
                    if( prevChapter != nil) [prevChapter setNextChapter:currentChapter];
                    [currentChapter setPreviousChapter:prevChapter];
                    [currentChapter setNextChapter:nil];
                    [currentChapter setBookId:idx];
                    [currentChapter setChapterId:chapterId];
                    prevChapterId = chapterId;
                    prevChapter = currentChapter;
                    prevVerseId = @"x";
                }
                // Handle the verse
                verseId = [[NSString alloc] initWithString:[lineBreakdown objectAtIndex:1]];
                if( [verseId compare:prevVerseId] != NSOrderedSame)
                {
                    /*----------------------------------------------------------------*
                     *                                                                *
                     *  Populate the various Dictionaries allowing navigation of      *
                     *    verses (stored in the Chapters class).                      *
                     *                                                                *
                     *----------------------------------------------------------------*/
                    currentVerse = [classVerse new];
                    [currentVerse initialise:idx];
                    [[currentChapter versesInChapter] setObject:currentVerse forKey:[[NSString alloc] initWithFormat:@"%li", [currentChapter noOfVersesInChapter]]];
                    [[currentChapter verseLookup] setObject:verseId forKey:[[NSString alloc] initWithFormat:@"%li", [currentChapter noOfVersesInChapter]]];
                    [[currentChapter verseSequence] setObject:[[NSString alloc] initWithFormat:@"%li", [currentChapter noOfVersesInChapter]] forKey:verseId];
                    currentChapter.noOfVersesInChapter++;
                    /*----------------------------------------------------------------*
                     *                                                                *
                     *  End of code variation.                                        *
                     *                                                                *
                     *----------------------------------------------------------------*/
                    if( previousVerse != nil) previousVerse.nextVerse = currentVerse;
                    currentVerse.previousVerse = previousVerse;
                    [currentVerse setBookId:idx];
                    prevVerseId = verseId;
                    previousVerse = currentVerse;
                    [currentVerse setBibleReference:[[NSString alloc] initWithFormat:@"%@ %@:%@", [currentBook shortName], chapterId, verseId]];
                }
                // Normal processing
                /*----------------------------------------------------------------*
                 *                                                                *
                 *  Populate the various Dictionaries allowing navigation of      *
                 *    words (stored in the Verses class).                         *
                 *                                                                *
                 *----------------------------------------------------------------*/
                currentWord = [classWord new];
                [[currentVerse wordIndex] setObject:currentWord forKey:[[NSString alloc] initWithFormat:@"%li", [currentVerse wordCount]]];
                currentVerse.wordCount++;
                /*----------------------------------------------------------------*
                 *                                                                *
                 *  End of code variation.                                        *
                 *                                                                *
                 *----------------------------------------------------------------*/
                currentWord.catString = [lineBreakdown objectAtIndex:2];
                currentWord.parseString = [lineBreakdown objectAtIndex:3];
                currentWord.uniqueValue = [lineBreakdown objectAtIndex:4];
                currentWord.textWord = [lineBreakdown objectAtIndex:5];
                currentWord.accentlessTextWord = [lineBreakdown objectAtIndex:6];
                currentWord.bareTextWord = [lineBreakdown objectAtIndex:7];
                currentWord.rootWord = [lineBreakdown objectAtIndex:8];
                currentWord.punctuation = [lineBreakdown objectAtIndex:9];
                currentWord.preWordChars = [lineBreakdown objectAtIndex:10];
                currentWord.postWordChars = [lineBreakdown objectAtIndex:11];
            }
        }
    }
    /*********************************************************************************
     *
     *   Step 3: Get LXX details from the file:
     *
     *********************************************************************************/
    
    {
        NSString *fullFileName, *fullText, *cleanedLine;
        NSArray *textByLine, *lineBreakdown;
        classBook *currentBook;
        NSError *eMsg;

        [textAppDelegate remotePause:@"Retrieving Old Testament (Septuagint) book details" withSecondMsg:@" " andOption:false withOptionValue:false];
        cbLxxBook = [globalVarsText cbLxxBook];
        currentBook = nil;
        fullFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:@"LXXTitles" ofType:@"txt"]];
        fullText = [[NSString alloc] initWithContentsOfFile:fullFileName encoding:NSUTF8StringEncoding error:&eMsg];
        listOfLxxBooks = [[NSMutableDictionary alloc] init];
        textByLine = [[NSArray alloc] initWithArray:[fullText componentsSeparatedByString:@"\n"]];
        for( NSString *lineOfText in textByLine)
        {
            cleanedLine = [[ NSString alloc] initWithString:[lineOfText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            if( [cleanedLine length] == 0 ) continue;
            lineBreakdown = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
            currentBook = [classBook new];
            [currentBook initialise:globalVarsText forBook:[lineBreakdown objectAtIndex:0]];
            [listOfLxxBooks setObject:currentBook forKey:[[NSString alloc] initWithFormat:@"%li", noOfLxxBooks]];
            noOfLxxBooks++;
            currentBook.bookName = [lineBreakdown objectAtIndex:1];
            currentBook.shortName = [lineBreakdown objectAtIndex:2];
            currentBook.fileName = [lineBreakdown objectAtIndex:3];
            [cbLxxBook addItemWithObjectValue:[currentBook bookName]];
            [booksForListbox addObject:[currentBook bookName]];
        }
    }

    /*********************************************************************************
     *
     *   Step 4: Now recurse through the LXX files to load all text
     *
     *********************************************************************************/
    
    {
        NSInteger idx;
        NSString *verseId, *prevVerseId, *chapterId, *prevChapterId, *fullFileName, *nameWithoutExt, *fullText, *substituteChapterId, *testId;
        NSArray *textByLine, *lineBreakdown, *chap24, *chap30, *chap31;
        NSMutableDictionary *secondLowerBound;
        classBook *currentBook;
        classChapter *currentChapter, *prevChapter;
        classVerse *currentVerse, *previousVerse;
        classWord *currentWord;

        currentChapter = nil;
        prevChapter = nil;
        currentVerse = nil;
        previousVerse = nil;
        for (idx = 0; idx < noOfLxxBooks; idx++)
        {
            if( idx == 28 )
            {
                chap24 = [[NSArray alloc] initWithObjects:@"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", nil];
                chap30 = [[NSArray alloc] initWithObjects:@"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", nil];
                chap31 = [[NSArray alloc] initWithObjects:@"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28",
                          @"29", @"30", @"31", nil];
                secondLowerBound = [[NSMutableDictionary alloc] init];
                [secondLowerBound setObject:chap24 forKey:@"24"];
                [secondLowerBound setObject:chap30 forKey:@"30"];
                [secondLowerBound setObject:chap31 forKey:@"31"];
            }
            currentBook = nil;
            currentBook = [listOfLxxBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
            if (currentBook == nil) continue;
            [textAppDelegate remotePause:@"Retrieving Old Testament (Septuagint) book details" withSecondMsg:[currentBook bookName] andOption:false withOptionValue:false];
            nameWithoutExt = [[NSString alloc] initWithString:[[currentBook fileName] substringToIndex:[[currentBook fileName] length] - 4]];
            fullFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:nameWithoutExt ofType:@"txt"]];
            fullText = [[NSString alloc] initWithContentsOfFile:fullFileName encoding:NSUTF8StringEncoding error:nil];
            textByLine = [[NSArray alloc] initWithArray:[fullText componentsSeparatedByString:@"\n"]];
            prevChapterId = @"";
            prevVerseId = @"x";
            previousVerse = nil;
            for( NSString *lineOfText in textByLine)
            {
                lineBreakdown = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
                // Handle the chapter
                chapterId = [[[NSString alloc] initWithString:[lineBreakdown objectAtIndex:0]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if( [chapterId length] == 0 ) continue;
                // ChapterId will be a string, not an integer; it can = @"0" or even @"16b"
                if( [chapterId compare:prevChapterId] != NSOrderedSame)
                {
                    /*----------------------------------------------------------------*
                     *                                                                *
                     *  The next mini-section (and all marked this way) are required  *
                     *    because Objective-C does something odd to class management  *
                     *    of Dictionaries.  It explains the variation from the code   *
                     *    in Windows.                                                 *
                     *                                                                *
                     *  Populate the various Dictionaries allowing navigation of      *
                     *    chapters (stored in the Books class).                       *
                     *                                                                *
                     *----------------------------------------------------------------*/

                    currentChapter = [classChapter new];
                    if (idx == 28)
                    {
                        substituteChapterId = chapterId;
                        testId = nil;
                        testId = [[currentBook chapterSequence] objectForKey:chapterId];
                        if( testId != nil)
                        {
                            substituteChapterId = [[NSString alloc] initWithFormat:@"%@b", chapterId];
                        }
                        [currentChapter initialise:idx forChapter:substituteChapterId];
                        [[currentBook chaptersInBook] setObject:currentChapter forKey:substituteChapterId];
                        [[currentBook chapterLookup] setObject:substituteChapterId forKey:[[NSString alloc] initWithFormat:@"%li", [currentBook noOfChaptersInBook]]];
                        [[currentBook chapterSequence] setObject:[[NSString alloc] initWithFormat:@"%li", [currentBook noOfChaptersInBook]] forKey:substituteChapterId];
                        [currentChapter setChapterId:substituteChapterId];
                    }
                    else
                    {
                        [currentChapter initialise:idx forChapter:chapterId];
                        [[currentBook chaptersInBook] setObject:currentChapter forKey:chapterId];
                        [[currentBook chapterLookup] setObject:chapterId forKey:[[NSString alloc] initWithFormat:@"%li", [currentBook noOfChaptersInBook]]];
                        [[currentBook chapterSequence] setObject:[[NSString alloc] initWithFormat:@"%li", [currentBook noOfChaptersInBook]] forKey:chapterId];
                        [currentChapter setChapterId:chapterId];
                    }
                    currentBook.noOfChaptersInBook++;
                    /*----------------------------------------------------------------*
                     *                                                                *
                     *  End of code variation.                                        *
                     *                                                                *
                     *----------------------------------------------------------------*/
                    if( prevChapter != nil) prevChapter.nextChapter = currentChapter;
                    currentChapter.previousChapter = prevChapter;
                    [currentChapter setBookId:idx];
                    prevChapterId = chapterId;
                    prevChapter = currentChapter;
                    prevVerseId = @"x";
                }
            // Handle the verse
            verseId = [[NSString alloc] initWithString:[lineBreakdown objectAtIndex:1]];
            if( [verseId compare:prevVerseId] != NSOrderedSame)
            {
                /*----------------------------------------------------------------*
                 *                                                                *
                 *  Populate the various Dictionaries allowing navigation of      *
                 *    verses (stored in the Chapters class).                      *
                 *                                                                *
                 *----------------------------------------------------------------*/
                currentVerse = [classVerse new];
                [currentVerse initialise:idx];
                [[currentChapter versesInChapter] setObject:currentVerse forKey:[[NSString alloc] initWithFormat:@"%li", [currentChapter noOfVersesInChapter]]];
                [[currentChapter verseLookup] setObject:verseId forKey:[[NSString alloc] initWithFormat:@"%li", [currentChapter noOfVersesInChapter]]];
                [[currentChapter verseSequence] setObject:[[NSString alloc] initWithFormat:@"%li", [currentChapter noOfVersesInChapter]] forKey:verseId];
                currentChapter.noOfVersesInChapter++;
                /*----------------------------------------------------------------*
                 *                                                                *
                 *  End of code variation.                                        *
                 *                                                                *
                 *----------------------------------------------------------------*/
                if( previousVerse != nil) previousVerse.nextVerse = currentVerse;
                currentVerse.previousVerse = previousVerse;
                [currentVerse setBookId:idx];
                prevVerseId = verseId;
                previousVerse = currentVerse;
                [currentVerse setBibleReference:[[NSString alloc] initWithFormat:@"%@ %@:%@", [currentBook shortName], chapterId, verseId]];
            }
            // Normal processing
                /*----------------------------------------------------------------*
                 *                                                                *
                 *  Populate the various Dictionaries allowing navigation of      *
                 *    words (stored in the Verses class).                         *
                 *                                                                *
                 *----------------------------------------------------------------*/
                currentWord = [classWord new];
                [[currentVerse wordIndex] setObject:currentWord forKey:[[NSString alloc] initWithFormat:@"%li", [currentVerse wordCount]]];
                currentVerse.wordCount++;
                /*----------------------------------------------------------------*
                 *                                                                *
                 *  End of code variation.                                        *
                 *                                                                *
                 *----------------------------------------------------------------*/
            currentWord.catString = [lineBreakdown objectAtIndex:2];
            currentWord.parseString = [lineBreakdown objectAtIndex:3];
            currentWord.uniqueValue = [lineBreakdown objectAtIndex:4];
            currentWord.textWord = [lineBreakdown objectAtIndex:5];
            currentWord.accentlessTextWord = [lineBreakdown objectAtIndex:6];
            currentWord.bareTextWord = [lineBreakdown objectAtIndex:7];
                currentWord.rootWord = [lineBreakdown objectAtIndex:8];
            currentWord.punctuation = [lineBreakdown objectAtIndex:9];
            currentWord.preWordChars = [lineBreakdown objectAtIndex:10];
            currentWord.postWordChars = [lineBreakdown objectAtIndex:11];
            }
        }
    }
    // Make sure the text areas of the comboboxes are populated
    [cbNtBook selectItemAtIndex:0];
    [cbLxxBook selectItemAtIndex:0];
    [self displayNTChapter:0 forChapter:@"1" withNewBookFlag:true];
    [self displayLxxChapter:0 forChapter:@"1" withNewBookFlag:true];
    globalVarsText.ntListOfBooks = [[NSDictionary alloc] initWithDictionary:listOfNtBooks];
    globalVarsText.lxxListOfBooks = [[NSDictionary alloc] initWithDictionary:listOfLxxBooks];
    [[globalVarsText labProgress2] setHidden:true];
    return [booksForListbox copy];
}

- (void) displayNTChapter: (NSInteger) bookIdx forChapter: (NSString *) chapIdx withNewBookFlag: (BOOL) isNewBook
{
    /********************************************************************
     *                                                                  *
     *                        displayNTChapter                          *
     *                        ==============                            *
     *                                                                  *
     *  Controls the display of a specified chapter                     *
     *                                                                  *
     *  Parameters:                                                     *
     *    bookIdx: the book index (a zero based index)                  *
     *    chapIdx: chapter number (real chapter, which must be          *
     *             converted to it's equivalent sequence number         *
     *                                                                  *
     ********************************************************************/
    
    NSInteger idx, noOfVerses, noOfChapters, chapNo;
    NSString *newBookName, *displayString, *realVNo;
    NSMutableString *readyForOutput;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    NSTextView *targetTextArea;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSTabViewItem *tabNewTestament;

    targetTextArea = [globalVarsText ntTextView];
    cbBook = [globalVarsText cbNtBook];
    cbChapter = [globalVarsText cbNtChapter];
    cbVerse = [globalVarsText cbNtVerse];
    // Get the name of the new book
    
    // Get the book instance for the provided bookIdx
    currentBook = [listOfNtBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", bookIdx]];
    newBookName = [currentBook bookName];
    if( [cbBook numberOfItems] == 0) return;
    [cbBook selectItemAtIndex:bookIdx];
    // Recreate cbChapters if it is a new book
    if (isNewBook)
    {
        // Inhibit duplicate updates
        isChapUpdateActive = false;
        noOfChapters = [currentBook noOfChaptersInBook];
        if (noOfChapters == 0) return;
        [cbChapter removeAllItems];
        for (idx = 0; idx < noOfChapters; idx++)
        {
            [cbChapter addItemWithObjectValue:[currentBook getChapterIdBySeqNo:idx]];
        }
        // The real chapter must be submitted, so make sure we select the *sequence*
        if ([cbChapter numberOfItems] > 0)
        {
            chapNo = [currentBook getSeqNoByChapterId:chapIdx];
            [cbChapter selectItemAtIndex:chapNo];
        }
        isChapUpdateActive = true;
    }
    // Get the specified chapter from the current book -
    //   which will be the new book, if it has changed
    currentChapter = nil;
    currentChapter = [[currentBook chaptersInBook] objectForKey:chapIdx];
    // Now modify the verse combo box *and* display the new chapter
    noOfVerses = [currentChapter NoOfVersesInChapter];
    readyForOutput = [[NSMutableString alloc] initWithString:@""];
    [cbVerse removeAllItems];
    for (idx = 0; idx < noOfVerses; idx++)
    {
        currentVerse = nil;
        currentVerse = [[currentChapter versesInChapter] objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
        if (currentVerse == nil) continue;
        realVNo = [[currentChapter verseLookup] objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
        [cbVerse addItemWithObjectValue:realVNo];
        if (idx > 0)
        {
            [readyForOutput appendString:@"\n"];
        }
        [readyForOutput appendString:[[NSString alloc] initWithFormat:@"%@:  %@", realVNo, [currentVerse getWholeText]]];
    }
    [cbVerse selectItemAtIndex:0];
    [targetTextArea setString:readyForOutput];
    displayString = [[NSString alloc] initWithFormat:@"%@ %@", newBookName, chapIdx];
    tabNewTestament = [globalVarsText tabNewTestament];
    [tabNewTestament setLabel:[[NSString alloc] initWithFormat:@"New Testament - %@", displayString]];
    [self addEntryToHistory:displayString forTestament:0 atPosition:0];
}


- (void) displayLxxChapter: (NSInteger) bookIdx forChapter: (NSString *) chapIdx withNewBookFlag: (BOOL) isNewBook
{
    /********************************************************************
     *                                                                  *
     *                       displayLxxChapter                          *
     *                       =================                          *
     *                                                                  *
     *  Controls the display of a specified chapter                     *
     *                                                                  *
     *  Parameters:                                                     *
     *    bookIdx: the book index (a zero based index)                  *
     *    chapIdx: chapter number (real chapter, which must be          *
     *             converted to it's equivalent sequence number         *
     *                                                                  *
     ********************************************************************/
    
    NSInteger idx, noOfVerses, noOfChapters, chapNo;
    NSString *newBookName, *displayString, *realVNo;
    NSMutableString *readyForOutput;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    NSTextView *targetTextArea;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSTabViewItem *tabSeptuagint;

    targetTextArea = [globalVarsText lxxTextView];
    cbBook = [globalVarsText cbLxxBook];
    cbChapter = [globalVarsText cbLxxChapter];
    cbVerse = [globalVarsText cbLxxVerse];
    // Get the name of the new book
    
    // Get the book instance for the provided bookIdx
    currentBook = [listOfLxxBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", bookIdx]];
    newBookName = [currentBook bookName];
    if( [cbBook numberOfItems] == 0) return;
   [cbBook selectItemAtIndex:bookIdx];
    // Recreate cbChapters if it is a new book
    if (isNewBook)
    {
        // Inhibit duplicate updates
        isChapUpdateActive = false;
        noOfChapters = [currentBook noOfChaptersInBook];
        if (noOfChapters == 0) return;
        [cbChapter removeAllItems];
        for (idx = 0; idx < noOfChapters; idx++)
        {
            [cbChapter addItemWithObjectValue:[currentBook getChapterIdBySeqNo:idx]];
        }
        // The real chapter must be submitted, so make sure we select the *sequence*
        if ([cbChapter numberOfItems] > 0)
        {
            chapNo = [currentBook getSeqNoByChapterId:chapIdx];
            [cbChapter selectItemAtIndex:chapNo];
        }
        isChapUpdateActive = true;
    }
    // Get the specified chapter from the current book -
    //   which will be the new book, if it has changed
    currentChapter = nil;
    currentChapter = [[currentBook chaptersInBook] objectForKey:chapIdx];
    // Now modify the verse combo box *and* display the new chapter
    noOfVerses = [currentChapter NoOfVersesInChapter];
    readyForOutput = [[NSMutableString alloc] initWithString:@""];
    [cbVerse removeAllItems];
    for (idx = 0; idx < noOfVerses; idx++)
    {
        currentVerse = nil;
        currentVerse = [[currentChapter versesInChapter] objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
        if (currentVerse == nil) continue;
        realVNo = [[currentChapter verseLookup] objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
        //        realVNo = [currentChapter getVerseIdBySeqNo:idx];
        [cbVerse addItemWithObjectValue:realVNo];
        if (idx > 0)
        {
            [readyForOutput appendString:@"\n"];
        }
        [readyForOutput appendString:[[NSString alloc] initWithFormat:@"%@:  %@", realVNo, [currentVerse getWholeText]]];
    }
    [cbVerse selectItemAtIndex:0];
    [targetTextArea setString:readyForOutput];
    displayString = [[NSString alloc] initWithFormat:@"%@ %@", newBookName, chapIdx];
    tabSeptuagint = [globalVarsText tabSeptuagint];
    [tabSeptuagint setLabel:[[NSString alloc] initWithFormat:@"Septuagint (Old Testament) - %@", displayString]];
    [self addEntryToHistory:displayString forTestament:1 atPosition:0];
}

- (void) displayNewNote: (NSInteger) testamentId withSelectedItem: (NSString *) selectedValue
{
    NSInteger bookId;
    NSString *chapterId, *noteText;
    NSComboBox *cbBook, *cbChapter;
    NSDictionary *bookList;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    
    if( testamentId == 1 )
    {
        cbBook = [globalVarsText cbNtBook];
        cbChapter = [globalVarsText cbNtChapter];
        bookList = [globalVarsText ntListOfBooks];
    }
    else
    {
        cbBook = [globalVarsText cbLxxBook];
        cbChapter = [globalVarsText cbLxxChapter];
        bookList = [globalVarsText lxxListOfBooks];
    }
    bookId = [cbBook indexOfSelectedItem];
    chapterId = [cbChapter objectValueOfSelectedItem];
    currentBook = [bookList objectForKey:[[NSString alloc] initWithFormat:@"%li", bookId]];
    currentChapter = [currentBook getChapterByChapterId:chapterId];
    currentVerse = [currentChapter getVerseByVerseNo:selectedValue];
    if( [currentVerse noteText] == nil)
    {
        [[globalVarsText notesTextView] setString:@""];
    }
    else
    {
        noteText = [[NSString alloc] initWithString:[currentVerse noteText]];
        [[globalVarsText notesTextView] setString:noteText];
    }
}

- (void) handleComboBoxChange: (NSInteger) targetCbCode withListIndex: (NSInteger) listIndex andSelectedItem: (NSString *) selectedItem andBookCode: (NSInteger) bookCode
{
    switch (targetCbCode)
    {
        case 1: [self displayNTChapter:listIndex forChapter:@"1" withNewBookFlag:true]; break;
        case 2: [self displayNTChapter:bookCode forChapter:selectedItem withNewBookFlag:false]; break;
        case 3: [self displayNewNote:1 withSelectedItem:selectedItem]; break;
        case 4: [self displayLxxChapter:listIndex forChapter:@"1" withNewBookFlag:true]; break;
        case 5: [self displayLxxChapter:bookCode forChapter:selectedItem withNewBookFlag:false]; break;
        case 6: [self displayNewNote:2 withSelectedItem:selectedItem]; break;
        default: break;
    }
}

- (void) performAnalysis: (NSString *) verseLine withCursorPosition: (NSInteger) currPstn oldOrNew: (NSUInteger) textViewIndicator
               forBookId: (NSInteger) bookId andChapterId: (NSString *) chapId andVerseId: (NSString *) verseId
{
    /***********************************************************************************************
     *                                                                                             *
     *  The purpose of this method is to identify the word being clicked on (then provide its      *
     *     meaning)                                                                                *
     *                                                                                             *
     *  Parameters:                                                                                *
     *  ==========                                                                                 *
     *                                                                                             *
     *  textViewIndicator    Indicates whether the textView activated is NT or OT:                 *
     *                          1 = NT                                                             *
     *                          2 = OT                                                             *
     *  currPstn             Cursor position in total text                                         *
     *                                                                                             *
     ***********************************************************************************************/

    NSInteger idx, wordCount, idOfFoundWord, wordLength;
    NSString *clickedOnWord, *rootWord;
    NSMutableString *outputText;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    classWord *currentWord;
    classScanReturn *scanReturn;
    GBSAlert *alert;
    NSTextView *parseTextArea, *lexiconTextArea;
    NSTabView *targetTabView;
    
    /*----------------------------------------------------------------------------------------------*
     *                                                                                              *
     *    1. Identify the word at the cursor                                                        *
     *                                                                                              *
     *----------------------------------------------------------------------------------------------*/
    
    scanReturn = [self findCurrentWord:verseLine atPstn:currPstn];
    if( scanReturn == nil)
    {
        alert = [GBSAlert new];
        [alert messageBox:@"Either you selected the verse number or a blank line" title:@"Analysis Error" boxStyle:NSAlertStyleWarning];
        return;
    }
    clickedOnWord = [[NSString alloc] initWithString:[scanReturn wordUnderCursor]];
    wordCount = [scanReturn noOfWords];
    idOfFoundWord = [scanReturn selectedWordNo];
    
    /*..............................................................................................*
     *                                                                                              *
     *   2. Set the verse number in the verse combo box and get the "word index" value (We'll need  *
     *        this for section 2).                                                                  *
     *                                                                                              *
     *..............................................................................................*/
    
    if( textViewIndicator == 1 )
    {
        currentBook = [listOfNtBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", bookId]];
    }
    else
    {
        currentBook = [listOfLxxBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", bookId]];
    }
    currentChapter = [currentBook getChapterByChapterId:chapId];
    currentVerse = [currentChapter getVerseByVerseNo:verseId];
    currentWord = [currentVerse getwordBySeqNo:idOfFoundWord];

    /*----------------------------------------------------------------------------------------------*
     *                                                                                              *
     *    2. Record the meaning and grammatical details of the selected word                        *
     *                                                                                              *
     *----------------------------------------------------------------------------------------------*/

    // Get the Book name and the currentChapter
    rootWord = [currentWord rootWord];
    outputText = [[NSMutableString alloc] initWithFormat:@"%@:\n", clickedOnWord];
    wordLength = [clickedOnWord length];
    for (idx = 0; idx < wordLength; idx++)
    {
        [outputText appendString:@"="];
    }
    [outputText appendString:@"\n\n"];
    [outputText appendString:[lexiconText parseGrammar:[currentWord catString] withFullerCode:[currentWord parseString] isNT:(textViewIndicator == 1)]];
    [outputText appendFormat:@"\n\nRoot of word: %@", rootWord];
    parseTextArea = [globalVarsText parseTextView];
    lexiconTextArea = [globalVarsText lexiconTextView];
    targetTabView = [globalVarsText topRightTabView];
    [targetTabView selectTabViewItemAtIndex:0];
    parseTextArea.string = outputText;
    outputText = [[NSMutableString alloc] initWithString:[lexiconText getLexiconEntry: rootWord]];
    [targetTabView selectTabViewItemAtIndex:1];
    lexiconTextArea.string = outputText;
    [targetTabView selectTabViewItemAtIndex:0];
}

- (classScanReturn *) findCurrentWord: (NSString *) verseText atPstn: (NSInteger) cursorPosition
{
    /*****************************************************************************************************
     *                                                                                                   *
     *  Given a specific position in the text, find the word in which the position occurs.               *
     *                                                                                                   *
     *  Parameters:                                                                                      *
     *  ==========                                                                                       *
     *                                                                                                   *
     *  verseText        The text of the verse currently under the mouse click                           *
     *  cursorPosition   The position in the verse identified as being clicked                           *
     *                                                                                                   *
     *  returns an instance of classScanReturn, which contains:                                          *
     *    a) wordUnderCursor   the word actually selected                                                *
     *    b) noOfWords         a count of the total number of words in the verse                         *
     *                                                                                                   *
     *****************************************************************************************************/
    
    NSInteger idx, lastSpace, nextSpace, verseLength, wordCount, selectedWord = -1;
    unichar currentChar;
    NSString *foundWord;
    NSRange wordRange;
    classCleanReturn *cleanReturn;
    classScanReturn *scanReturn;
    
    if ([verseText length] == 0) return nil;
    // Is the character under the mouse click a space?
    verseLength = [verseText length];
    lastSpace = 0;
    for( idx = 0; idx < verseLength; idx++)
    {
        // First of all, scan for ':'
        // If we don't find it, the verse is badly formed and we should abort
        currentChar = [verseText characterAtIndex:idx];
        if( currentChar == ':')
        {
            lastSpace = idx + 1;
            break;
        }
    }
    if( lastSpace == 0 )
    {
        // No ':' was found
        return nil;
    }
    wordCount = 0;
    nextSpace = -1;
    foundWord = @"";
    for( idx = lastSpace; idx < verseLength; idx++ )
    {
        currentChar = [verseText characterAtIndex:idx];
        if( currentChar == ' ' )
        {
            if( nextSpace > -1 )
            {
                //This is a space following a non-space
                if( ( cursorPosition >= lastSpace ) && ( cursorPosition < idx ) )
                {
                    // This is the word containing the cursor
                    wordRange = NSMakeRange(lastSpace, idx - lastSpace);
                    foundWord = [[NSString alloc] initWithString:[verseText substringWithRange:wordRange]];
                    selectedWord = wordCount;
                }
                lastSpace = idx;
                nextSpace = -1;
                wordCount++;
            }
        }
        else
        {
            nextSpace = 0; // To mark that a character has been encountered
        }
    }
    if( nextSpace == 0 )
    {
        // This indicates that we have encountered a non-space but no final space.  So, the last word is terminated by an eol
        if( cursorPosition >= lastSpace )
        {
            // This is the word containing the cursor
            foundWord = [[NSString alloc] initWithString:[verseText substringFromIndex:lastSpace]];
            selectedWord = wordCount;
        }
        wordCount++;
    }
    // The word we have found almost certainly begins with a space
    foundWord = [[NSString alloc] initWithString:[foundWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    cleanReturn = [greekProcessingText removeNonGkChars:foundWord];
    scanReturn = [classScanReturn new];
    scanReturn.wordUnderCursor = foundWord;
    scanReturn.noOfWords = wordCount;
    scanReturn.selectedWordNo = selectedWord;
    return scanReturn;
}

- (NSString *) getVerseNumberOfLine: (NSString *) sourceLine
{
    NSString *verseString;
    NSRange colonLocation, verseRange;
    
    colonLocation = [sourceLine rangeOfString:@":"];
    if( colonLocation.location == NSNotFound) return @"";
    verseRange = NSMakeRange(0, colonLocation.location);
    verseString = [[sourceLine substringWithRange:verseRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return verseString;
}

- (void) addEntryToHistory: (NSString *) newEntry forTestament: (NSInteger) whichHistoryCode atPosition: (NSInteger) actionCode
{
    /*****************************************************************************************************
     *                                                                                                   *
     *                                     addEntryToHistory                                             *
     *                                     =================                                             *
     *                                                                                                   *
     *  This adds an entry to either of the history combo boxes.                                         *
     *                                                                                                   *
     *  Parameters:                                                                                      *
     *  ----------                                                                                       *
     *                                                                                                   *
     *  newEntry          The string that will be entered                                                *
     *  whichHistoryCode  An integer value specifying whether NT or LXX:                                 *
     *                      0 = NT           1 = LXX                                                     *
     *  actionCode        An integer value specifying whether to add the entry at the head of the list   *
     *                    or at the tail;                                                                *
     *                      0 = head         1 - tail                                                    *
     *                                                                                                   *
     *****************************************************************************************************/
    
    NSInteger foundIndex;
    NSComboBox *cbHistory;
    
    if (whichHistoryCode == 0) cbHistory = [globalVarsText cbNtHistory];
    else cbHistory = [globalVarsText cbLxxHistory];
    foundIndex = [cbHistory indexOfItemWithObjectValue:newEntry];
    if( foundIndex != NSNotFound ) [cbHistory removeItemAtIndex:foundIndex];
    if ( [cbHistory numberOfItems] >= [globalVarsText historyMax] ) [cbHistory removeItemAtIndex:[cbHistory numberOfItems] - 1];
    if (actionCode == 0) [cbHistory insertItemWithObjectValue:newEntry atIndex:0];
    else [cbHistory addItemWithObjectValue:newEntry];
    [cbHistory selectItemAtIndex:0];
}

- (void) loadHistory
{
    NSInteger idx, jdx, bookIdx, epochCode = 0, nPstn, noOfBooks;
    NSString *historyFileName, *fileBuffer;
    NSMutableString *bookName;
    NSArray *fileContents;
    NSComboBox *cbHistory;
    classBook *currentBook;
    NSDictionary *listOfBooks;
    NSFileManager *fmHistory;
    
    fmHistory = [NSFileManager defaultManager];
    historyFileName = [[NSString alloc] initWithFormat:@"%@%@%@/%@/history.txt", [fmHistory homeDirectoryForCurrentUser], [globalVarsText basePath], [globalVarsText lfcFolder], [globalVarsText appFolder]];
    if( [historyFileName containsString:@"file:///"] )
    {
        historyFileName = [[NSString alloc] initWithString:[historyFileName substringFromIndex:7]];
    }
    if ([fmHistory fileExistsAtPath:historyFileName])
    {
        cbHistory = [globalVarsText cbNtHistory];
        fileBuffer = [[NSString alloc] initWithContentsOfFile:historyFileName encoding:NSUTF8StringEncoding error:nil];
        fileContents = [[NSArray alloc] initWithArray:[fileBuffer componentsSeparatedByString:@"\n"]];
        for (NSString *fileLine in fileContents)
        {
            if( fileLine == nil ) continue;
            if( [fileLine length] == 0 ) continue;
            if( [fileLine characterAtIndex:0] == ';' ) continue;
            if( [fileLine characterAtIndex:0] == '+' )
            {
                epochCode++;
                cbHistory = [globalVarsText cbLxxHistory];
                continue;
            }
            [self addEntryToHistory:fileLine forTestament:epochCode atPosition:1];
        }
        // Now set the active text in each testament to the 0th entry
        for (jdx = 0; jdx < 2; jdx++)
        {
            if(jdx == 0 )
            {
                cbHistory = [globalVarsText cbNtHistory];
                listOfBooks = [globalVarsText ntListOfBooks];
            }
            else
            {
                cbHistory = [globalVarsText cbLxxHistory];
                listOfBooks = [globalVarsText lxxListOfBooks];
            }
            if( [cbHistory numberOfItems] > 0)
            {
                fileBuffer = [[NSString alloc] initWithString:[cbHistory itemObjectValueAtIndex:0]];
                fileContents = [[NSArray alloc] initWithArray:[fileBuffer componentsSeparatedByString:@" "]];
                nPstn = [fileContents count];
                bookName = [[NSMutableString alloc] initWithString:@""];
                for( idx = 0; idx < nPstn - 1; idx++)
                {
                    if( idx == 0) [bookName appendString:[fileContents objectAtIndex:0]];
                    else [bookName appendFormat:@" %@", [fileContents objectAtIndex:idx]];
                }
                noOfBooks = [listOfBooks count];
                bookIdx = -1;
                for( idx = 0; idx < noOfBooks; idx++)
                {
                    currentBook = [listOfBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
                    if( [[currentBook bookName] compare:bookName] == NSOrderedSame)
                    {
                        bookIdx = idx;
                        break;
                    }
                }
                if( bookIdx > -1)
                {
                    if( jdx == 0 ) [self displayNTChapter:bookIdx forChapter:fileContents[nPstn - 1] withNewBookFlag:true];
                    else [self displayLxxChapter:bookIdx forChapter:fileContents[nPstn - 1] withNewBookFlag:true];
                }
            }
        }
    }
}

- (void) saveHistory
{
    NSInteger idx, jdx, noOfItems;
    NSString *historyFileName;
    NSMutableString *outputString;
    NSArray *headerText = @[ @"; New Testament history\n", @"; Septuagint history\n"];
    NSComboBox *cbHistory;
    NSFileManager *fmHistory;
    
    fmHistory = [NSFileManager defaultManager];
    outputString = [[NSMutableString alloc] initWithString:@""];
    historyFileName = [[NSString alloc] initWithFormat:@"%@%@%@/%@/history.txt", [fmHistory homeDirectoryForCurrentUser], [globalVarsText basePath], [globalVarsText lfcFolder], [globalVarsText appFolder]];
    if( [historyFileName containsString:@"file:///"] )
    {
        historyFileName = [[NSString alloc] initWithString:[historyFileName substringFromIndex:7]];
    }
    for( jdx = 0; jdx < 2; jdx++)
    {
        [outputString appendString:[headerText objectAtIndex:jdx]];
        if( jdx == 0 ) cbHistory = [globalVarsText cbNtHistory];
        else cbHistory = [globalVarsText cbLxxHistory];
        noOfItems = [cbHistory numberOfItems];
        for( idx = 0; idx < noOfItems; idx++)
        {
            [outputString appendFormat:@"%@\n", [cbHistory itemObjectValueAtIndex:idx]];
        }
        if( jdx == 0 ) [outputString appendString:@"+\n"];
    }
    if( [fmHistory fileExistsAtPath:historyFileName]) [fmHistory removeItemAtPath:historyFileName error:nil];
    [outputString writeToFile: historyFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void) processSelectedHistory: (NSInteger) historyCode
{
    NSInteger idx, noOfBooks, noOfComponents, bookIdx, foundIndex;
    NSString *historyEntry, *chapNo;
    NSMutableString *bookName;
    NSArray *entryDecomp;
    NSComboBox *cbBooks, *cbChapters, *cbHistory;
    classBook *currentBook;
    NSDictionary *listOfBooks;
    
    if (historyCode == 1)
    {
        listOfBooks = [globalVarsText ntListOfBooks];
        cbBooks = [globalVarsText cbNtBook];
        cbChapters = [globalVarsText cbNtChapter];
        cbHistory = [globalVarsText cbNtHistory];
// ?        lastHistoryEntry = lastNTHistoryEntry;
    }
    else
    {
        listOfBooks = [globalVarsText lxxListOfBooks];
        cbBooks = [globalVarsText cbLxxBook];
        cbChapters = [globalVarsText cbLxxChapter];
        cbHistory = [globalVarsText cbLxxHistory];
//  ?        lastHistoryEntry = lastLxxHistoryEntry;
    }
    noOfBooks = [listOfBooks count];
    if( [cbHistory numberOfItems] == 0 ) return;
    historyEntry = [cbHistory objectValueOfSelectedItem];
    foundIndex = [cbHistory indexOfSelectedItem];
    [cbHistory removeItemAtIndex:foundIndex];
    [cbHistory insertItemWithObjectValue:historyEntry atIndex:0];
    [cbHistory selectItemAtIndex:0];
    entryDecomp = [[NSArray alloc] initWithArray:[historyEntry componentsSeparatedByString:@" "]];
    noOfComponents = [entryDecomp count];
    bookName = [[NSMutableString alloc] initWithString:@""];
    for( idx = 0; idx <= noOfComponents - 2; idx++)
    {
        if( idx == 0 ) [bookName appendString:[entryDecomp objectAtIndex:0]];
        else [bookName appendFormat:@" %@", [entryDecomp objectAtIndex:idx]];
    }
    chapNo = [entryDecomp objectAtIndex:noOfComponents - 1];
    bookIdx = -1;
    for (idx = 0; idx < noOfBooks; idx++)
    {
        currentBook = [listOfBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
        if( currentBook == nil) continue;
        if ( [bookName compare:[currentBook bookName]] == NSOrderedSame )
        {
            bookIdx = idx;
            break;
        }
    }
    if (bookIdx > -1)
    {
        if( historyCode == 1) [self displayNTChapter:bookIdx forChapter:chapNo withNewBookFlag:YES];
        else [self displayLxxChapter:bookIdx forChapter:chapNo withNewBookFlag:YES];
    }
}

- (void) prevOrNextChapter: (NSInteger) forwardBack forTestament: (NSInteger) ntLxxCode
{
    /***************************************************************************
     *                                                                         *
     *                             advanceHistory                              *
     *                             ==============                              *
     *                                                                         *
     *  Simply handles moving backwards or forwards from the present chapter.  *
     *                                                                         *
     *  Parameters:                                                            *
     *    forwardBack: 1 = previous chapter                                    *
     *                 2 = next chapter                                        *
     *                                                                         *
     *    ntLxxCode:   1 = NT, 2 = Lxx                                         *
     *                                                                         *
     ***************************************************************************/
    
    NSInteger bookIdx = 0, actualIdx;
    NSString *chapNo, *chapRef;
    NSComboBox *cbBooks, *cbChapters;
    classBook *currentBook;
    classChapter *currentChapter, *advChapter;
    NSDictionary  *listOfBooks;
    
    if (ntLxxCode == 1)
    {
        listOfBooks = [globalVarsText ntListOfBooks];
        cbBooks = [globalVarsText cbNtBook];
        cbChapters = [globalVarsText cbNtChapter];
    }
    else
    {
        listOfBooks = [globalVarsText lxxListOfBooks];
        cbBooks = [globalVarsText cbLxxBook];
        cbChapters = [globalVarsText cbLxxChapter];
    }
    actualIdx = [cbBooks indexOfSelectedItem];
    chapRef = [cbChapters objectValueOfSelectedItem];
    currentBook = [listOfBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", actualIdx]];
    currentChapter = [currentBook getChapterByChapterId:chapRef];
    if( forwardBack == 2) advChapter = [currentChapter getNextChapter];
    else advChapter = [currentChapter getPreviousChapter];
    if( advChapter == nil) return;
    bookIdx = [advChapter getBookId];
    chapNo = [advChapter getChapterId];
    if( ntLxxCode == 1 ) [self displayNTChapter:bookIdx forChapter:chapNo withNewBookFlag:true];
    else [self displayLxxChapter:bookIdx forChapter:chapNo withNewBookFlag:true];
}

@end
