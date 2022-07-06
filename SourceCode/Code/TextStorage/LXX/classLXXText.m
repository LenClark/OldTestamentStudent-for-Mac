//
//  classLXXText.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import "classLXXText.h"

@implementation classLXXText

const unichar zWidthSpace = 0x200b, zWidthNonJoiner = 0x200d;

NSInteger noOfStoredLXXBooks;

classGlobal *globalVarsLXXText;
classGkLexicon *gkLexicon;
@synthesize lxxTextUtilities;

@synthesize lxxNotes;
@synthesize lxxLoop;
@synthesize lxxProgress;

/*===============================================================================================*
 *                                                                                               *
 *                                        bookList                                               *
 *                                        --------                                               *
 *                                                                                               *
 *  Stores references to book names and associated data.                                         *
 *     Key:     Integer sequence (starting from zero);                                           *
 *     Value:   The class instance for Hebrew books                                              *
 *                                                                                               *
 *===============================================================================================*/
@synthesize bookList;

NSString *lastLXXHistoryUpdate;
NSComboBox *cbBook;

- (id) init: (classGlobal *) inGlobal withLexicon: (classGkLexicon *) inLexicon andUtilities: (classDisplayUtilities *) inUtilities
{
    if( self = [super init] )
    {
        globalVarsLXXText = inGlobal;
        gkLexicon = inLexicon;
        lxxTextUtilities = inUtilities;
        bookList = [[NSMutableDictionary alloc] init];
        noOfStoredLXXBooks = 0;
        lxxNotes = [[classLXXNotes alloc] init:globalVarsLXXText];
        lastLXXHistoryUpdate = @"";
    }
    return  self;
}

- (void) loadText
{
    /*---------------------------------------------------------------------------------------------------*
     *                                                                                                   *
     *   Step 1: data load for LXX data                                                                 *
     *   =======                                                                                         *
     *                                                                                                   *
     *   Step 1 will handle information about Septuagint book names and the files containing text data.  *
     *   It is more complex than the equivalent step for NT data because the LXX text is held in         *
     *   files (one for each book).                                                                      *
     *                                                                                                   *
     *   Note also that LXX chapters and verses are not always logically structured and we need to cope  *
     *   with the possibility of:                                                                        *
     *                                                                                                   *
     *     - chapters out of sequence;                                                                   *
     *     - pre-chapter verses (indexed as verse zero in our data;                                      *
     *     - verses identified as e.g. 12a, 12b and so on.                                               *
     *                                                                                                   *
     *---------------------------------------------------------------------------------------------------*/

    NSInteger bdx;
    NSString *titlesFileName, *sourceFileName, *fileBuffer, *bookName, *chapterRef, *prevChapRef = @"?", *verseRef, *prevVerseRef = @"?", *fileName;
    NSArray *fields, *lineContents, *textByLine;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter, *prevChapter;
    classLXXVerse *currentVerse, *previousVerse;
    classLXXWord *currentWord;

    [lxxProgress updateProgressMain:@"Getting titles of Septuagint books" withSecondMsg:@""];
    [lxxLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    cbBook = [globalVarsLXXText cbLXXBook];
    titlesFileName = [globalVarsLXXText lxxTitlesFile];
    sourceFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:titlesFileName ofType:@"txt"]];
    fileBuffer = [[NSString alloc] initWithContentsOfFile:sourceFileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[fileBuffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        if ([lineOfText characterAtIndex:0] != ';')
        {
            fields = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
            currentBook = [[classLXXBook alloc] init:globalVarsLXXText];
            [currentBook setShortName:[fields objectAtIndex:0]];
            [currentBook setCommonName:[fields objectAtIndex:1]];
            [cbBook addItemWithObjectValue:[currentBook commonName]];
            [currentBook setLxxName:[fields objectAtIndex:2]];
            [currentBook setFileName:[fields objectAtIndex:3]];
            [currentBook setCategory:[[fields objectAtIndex:4] integerValue]];
            [bookList setObject:currentBook forKey:[[NSString alloc] initWithFormat:@"%ld", noOfStoredLXXBooks++]];
            [globalVarsLXXText addLXXListBoxGroupItem:[currentBook commonName] withCode:[currentBook category] - 1];
        }
    }
    [cbBook selectItemAtIndex:0];

    /*---------------------------------------------------------------------------------------------------*
     *                                                                                                   *
     *   Step 2:                                                                                         *
     *   ======                                                                                          *
     *                                                                                                   *
     *   Now load the relevant LXX text data.                                                            *
     *                                                                                                   *
     *---------------------------------------------------------------------------------------------------*/

    // Now for the  text data. Let's process and store it
    for (bdx = 0; bdx < noOfStoredLXXBooks; bdx++)
    {
        currentBook = nil;
        currentBook = [bookList objectForKey:[[NSString alloc] initWithFormat:@"%ld", bdx]];
        if( currentBook == nil) continue;
        bookName = [currentBook commonName];
        [lxxProgress updateProgressMain:@"Loading the Septuagint Text for:" withSecondMsg:bookName];
        [lxxLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
        fileName = [currentBook fileName];
        currentChapter = nil;
        currentVerse = nil;
        prevChapRef = @"?";
        sourceFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
        fileBuffer = [[NSString alloc] initWithContentsOfFile:sourceFileName encoding:NSUTF8StringEncoding error:nil];
        textByLine = [[NSArray alloc] initWithArray:[fileBuffer componentsSeparatedByString:@"\n"]];
        for (NSString *lineOfText in textByLine)
        {
             /*====================================================================================*
             *                                                                                    *
             *  Split the line as follows:                                                        *
             *                                                                                    *
             *   Field                    Contents                                                *
             *   -----  ------------------------------------------------------------------------  *
             *     1    Chapter number                                                            *
             *     2    Verse number (note: may = 0 or 12b)                                       *
             *     3    Initial Parse code                                                        *
             *     4    Detailed Parse code                                                       *
             *     5    A unique grammatical identifier                                           *
             *     6    Word as it is to be displayed in the text                                 *
             *     7    Word a) all lower case, b) stripped of accents and related furniture      *
             *     8    Word, as in field 7 but also with breathings and iota subscripts removed  *
             *     9    Immediate root of word in field 6                                         *
             *     10    Pre-word characters                                                      *
             *     11    Post-word non-punctuation characters                                     *
             *     12    Punctuation                                                              *
             *     13    Transliterated version of field 6                                        *
             *     14+    Transliteration of root (with prefixed prepositions separated           *
             *                                                                                    *
             *  However, fields 1 and 2 are as supplied by the source file.  In addition, we will *
             *  create a simple, sequential index for chapters and verses.  This will allow for:  *
             *  a) out-of-sequence chapters (in a few books, there are gaps and, even, chapters   *
             *     transposed;                                                                    *
             *  b) verses that include text as well as digits (e.g. 19b);                         *
             *  c) unnumbered verses (in our data, given the index 0)                             *
             *                                                                                    *
             *====================================================================================*/
            if( [lineOfText length] == 0 ) continue;
            lineContents = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
            chapterRef = [lineContents objectAtIndex:0];
            // Handle the chapter
            if ([chapterRef compare:prevChapRef] != NSOrderedSame)
            {
                prevChapter = currentChapter;
                currentChapter = [currentBook addNewChapterToBook:chapterRef];
                if (prevChapter != nil) [prevChapter setNextChapter:currentChapter];
                [currentChapter setPreviousChapter:prevChapter];
                [currentChapter setBookNo:bdx];
                [currentChapter setChapterRef:chapterRef];
                [currentChapter setChapterNo:[currentBook noOfChaptersInBook] - 1];
                prevChapRef = chapterRef;
                prevVerseRef = @"?";
            }
            // Handle the verse
            verseRef = [lineContents objectAtIndex:1];
            if ( [verseRef compare:prevVerseRef] != NSOrderedSame)
            {
                currentVerse = [currentChapter addVerseToChapter:verseRef];
                if (previousVerse != nil)
                {
                    [previousVerse setNextVerse:currentVerse];
                }
                [currentVerse setPreviousVerse:previousVerse];
                prevVerseRef = verseRef;
                previousVerse = currentVerse;
                [currentVerse setChapSeq:[currentChapter chapterNo]];
                [currentVerse setChapRef:[currentChapter chapterRef]];
                [currentVerse setVerseSeq:[currentChapter noOfVersesInChapter] - 1];
                [currentVerse setVerseRef:[currentChapter getVerseNoBySequence:[currentVerse verseSeq]]];
            }
            currentWord = [currentVerse addWordToVerse];
            [currentWord setCatString:[lineContents objectAtIndex:2]];
            [currentWord setParseString:[lineContents objectAtIndex:3]];
            [currentWord setUniqueValue:[lineContents objectAtIndex:4]];
            [currentWord setTextWord:[lineContents objectAtIndex:5]];
            [currentWord setAccentlessTextWord:[lineContents objectAtIndex:6]];
            [currentWord setBareTextWord:[lineContents objectAtIndex:7]];
            [currentWord setRootWord:[lineContents objectAtIndex:8]];
            [currentWord setPunctuation:[lineContents objectAtIndex:11]];
            [currentWord setPreWordChars:[lineContents objectAtIndex:9]];
            [currentWord setPostWordChars:[lineContents objectAtIndex:10]];
        }
    }
    [globalVarsLXXText setLxxBookList:bookList];
     [globalVarsLXXText setNoOfLXXBooks:noOfStoredLXXBooks];
     [globalVarsLXXText setLxxCurrentBookIndex:0];
     [globalVarsLXXText setLxxCurrentChapter:@""];
}

- (void) displayChapter: (NSString *) chapIdx forBook: (NSInteger) bookIdx
{
    /*================================================================================================*
     *                                                                                                *
     *                                        displayChapter                                          *
     *                                        ==============                                          *
     *                                                                                                *
     *  Controls the display of a specified chapter                                                   *
     *                                                                                                *
     *  Parameters:                                                                                   *
     *    bookIdx:      the book index (a zero based index)                                           *
     *    chapIdx:      chapter number (real chapter, which must be converted to it's equivalent      *
     *                    sequence number                                                             *
     *                                                                                                *
     *================================================================================================*/

    NSInteger idx, cdx, wdx, noOfChapters, noOfVerses, noOfWords, noOfItems, itemIndex;
    NSString *newBookName, *displayString = @"", *realChapNo, *realVNo;
    NSAttributedString *lineFeed, *singleSpace;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter;
    classLXXVerse *currentVerse;
    classLXXWord *currentWord;
    NSTextView *targetTextArea;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSColor *backgroundColour;
    NSTabView *mainTabView;
    NSTabViewItem *expectedItem;
    classDisplayUtilities *lxxDisplayUtils;

    backgroundColour = [globalVarsLXXText lxxTextBackgroundColour];
    lineFeed = [[NSAttributedString alloc] initWithString:@"\n"];
    singleSpace = [[NSAttributedString alloc] initWithString:@" "];
    // Get the Text area in which the text occurs
    targetTextArea = [globalVarsLXXText txtLXXText];
    // Get the combo boxes for the Book, Chapter and Verse
    if([[targetTextArea string] length] > 0) //[[targetTextArea textStorage] deleteCharactersInRange:NSMakeRange(0, [[targetTextArea textStorage] length])];
    {
        [targetTextArea selectAll:self];
        [targetTextArea delete:self];
    }
    cbBook = [globalVarsLXXText cbLXXBook];
    cbChapter = [globalVarsLXXText cbLXXChapter];
    cbVerse = [globalVarsLXXText cbLXXVerse];
    // If any of them don't exist, abort
    if ((cbBook == nil) || (cbChapter == nil) || (cbVerse == nil) || (targetTextArea == nil)) return;
    // Get the name of the new book - and, BTW the class instance for the book
    currentBook = [bookList objectForKey:[[NSString alloc] initWithFormat:@"%ld", bookIdx]];
    newBookName = [currentBook commonName];
    if ([cbBook numberOfItems] == 0) return;
    /*===================================================================================*
     *                                                                                   *
     * The next statement:                                                               *
     *      cbBook.SelectedIndex = bookIdx;                                          *
     * will kick off cbBook_SelectedIndexChanged in frmMain, which, in turn, will invoke *
     * mainText.respondToNewBook.  Since this will finally invoke displayChapter, we are *
     * going to have an unhelpful loop.  So, let's stop it by disabling the call-back.   *
     * We do this by using isChapUpdateActive                                            *
     *                                                                                   *
     *===================================================================================*/
    //            isChapUpdateActive = false;
    [cbBook selectItemAtIndex:bookIdx];
    //            isChapUpdateActive = true;
    if ([currentBook noOfChaptersInBook] == 0) return;
    // Get the specified chapter from the current book -
    currentChapter = [currentBook getChapterByChapterNo:chapIdx];
    /*===================================================================================*
     *                                                                                   *
     * We now want to modify the verse combo box but, given that we're already all set   *
     * populate the text, we don't want it to kick off another round of updating the     *
     * text.  So we will use isChapUpdateActive, much as before.  This time, the         *
     * variable, globalVars.IsTextUpdateActive, will be picked up in the frmMain event   *
     * and handled there                                                                 *
     *                                                                                   *
     *===================================================================================*/
    [cbChapter removeAllItems];
    noOfChapters = [currentBook noOfChaptersInBook];
    for( cdx = 0; cdx < noOfChapters; cdx++)
    {
        realChapNo = [currentBook  getChapterNoBySequence:cdx];
        [cbChapter addItemWithObjectValue:realChapNo];
    }
    // Get the specified chapter from the current book -
    noOfItems = [cbChapter numberOfItems];
    [globalVarsLXXText setIsLXXChapterLoadActive:true];
    itemIndex = [currentBook getSequenceByChapterNo:chapIdx];
    [cbChapter selectItemAtIndex:itemIndex];
    [globalVarsLXXText setIsLXXChapterLoadActive:false];
    // Now modify the verse combo box *and* display the new chapter
    noOfVerses = [currentChapter noOfVersesInChapter];
//    targetTextArea.BackColor = backgroundColour;
//    targetTextArea.Text = "";
    [cbVerse removeAllItems];
    for (idx = 0; idx < noOfVerses; idx++)
    {
        /*--------------------------------------------------------------------------------------------------------------*
         *                                                                                                              *
         *                                        The structure of output text                                          *
         *                                        ----------------------------                                          *
         *                                                                                                              *
         *  Each line is of the form:                                                                                   *
         *      verse number + ": " (in English font and colour)                                                        *
         *      hebrew word = zeroWidthChar + actual word + zeroWidthNonJoiner + any affix                              *
         *         if the word is not a prefix and the affix is not a mappeq, a space is added                          *
         *         if the word has a variant, it is set to red (or option), otherwise black (or option)                 *
         *                                                                                                              *
         *  So, each word can be identified by looking for the zeroWidthChar and ending with the zeroWidthNonJoiner.    *
         *    Note that this makes it easy to identify a word, even when it is part of a larger complex.                *
         *                                                                                                              *
         *--------------------------------------------------------------------------------------------------------------*/
        currentVerse = [currentChapter getVerseBySequence:idx];
        if (currentVerse == nil) continue;
        realVNo = [currentChapter getVerseNoBySequence:idx];
        [cbVerse addItemWithObjectValue:realVNo];
        lxxDisplayUtils = [[classDisplayUtilities alloc] init:globalVarsLXXText];
        if (idx > 0)
        {
            // New, second or subsequent entry, so make sure it's separated
            [[targetTextArea textStorage] appendAttributedString:[lxxDisplayUtils addAttributedText:@"\n" offsetCode:0 fontId:4 alignment:0 withAdjustmentFor:targetTextArea]];
        }
        // Start with a verse number
        [[targetTextArea textStorage] appendAttributedString:[lxxDisplayUtils addAttributedText:[[NSString alloc] initWithFormat:@"%@: ", realVNo] offsetCode:0 fontId:3 alignment:0 withAdjustmentFor:targetTextArea]];
        noOfWords = [currentVerse wordCount];
         for (wdx = 0; wdx < noOfWords; wdx++)
        {
            currentWord = [currentVerse getWord:wdx];
            [[targetTextArea textStorage] appendAttributedString:[lxxDisplayUtils addAttributedText:[[NSString alloc] initWithFormat:@" %@", [currentWord preWordChars]] offsetCode:0 fontId:4 alignment:0 withAdjustmentFor:targetTextArea]];
            [[targetTextArea textStorage] appendAttributedString:[lxxDisplayUtils addAttributedText:[[NSString alloc] initWithFormat:@"%C%@", zWidthSpace, [currentWord textWord]] offsetCode:0 fontId:4 alignment:0 withAdjustmentFor:targetTextArea]];
            [[targetTextArea textStorage] appendAttributedString:[lxxDisplayUtils addAttributedText:[[NSString alloc] initWithFormat:@"%C%@%@", zWidthNonJoiner, [currentWord postWordChars], [currentWord punctuation]] offsetCode:0 fontId:4 alignment:0 withAdjustmentFor:targetTextArea]];
        }
    }
    [cbVerse selectItemAtIndex:0];
    mainTabView = [globalVarsLXXText tabMain];
    expectedItem = [globalVarsLXXText itemMainLXX];
    if( [mainTabView selectedTabViewItem] == expectedItem)
    {
        displayString = [[NSString alloc] initWithFormat:@"%@ %@", newBookName, chapIdx];
        [[globalVarsLXXText mainWindow] setTitle:[[NSString alloc] initWithFormat:@"Old Testament Student - Septuagint: %@", displayString]];
     }
}

- (void) handleComboBoxChange: (NSUInteger) targetCbCode
{
    switch (targetCbCode)
    {
        case 1: [self changeOfBook]; break;
        case 2: [self changeOfChapter]; break;
        case 3: [self changeOfVerse]; break;
        default: break;
    }
}

- (void) changeOfVerse
{
    NSInteger bookId, chapterSeq, verseSeq;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSTextView *noteTextView;
    
    // Get details of the "old" Book-Chapter-verse and save the note, if it exists
    cbBook = [globalVarsLXXText cbLXXBook];
    cbChapter = [globalVarsLXXText cbLXXChapter];
    cbVerse = [globalVarsLXXText cbLXXVerse];
    bookId = [globalVarsLXXText latestLXXBookId];
    chapterSeq = [globalVarsLXXText latestLXXChapterSeq];
    verseSeq = [globalVarsLXXText latestLXXVerseSeq];
    [lxxNotes storeANoteFor:bookId chapterSequence:chapterSeq andVerseSequence:verseSeq];

    // Blank the old note (which makes sure it isn't artificially "saved"
    noteTextView = [globalVarsLXXText txtLXXNotes];
    [noteTextView selectAll:self];
    [noteTextView delete:self];

    // Now register the new Book-Chapter-Verse
    bookId = [cbBook indexOfSelectedItem];
    chapterSeq = [cbChapter indexOfSelectedItem];
    verseSeq = [cbVerse indexOfSelectedItem];
    [globalVarsLXXText setLatestLXXBookId:bookId];
    [globalVarsLXXText setLatestLXXChapterSeq:chapterSeq];
    [globalVarsLXXText setLatestLXXVerseSeq:verseSeq];
    
    // See if there is a note and, if so, display it
    [lxxNotes retrieveANoteFor:bookId chapterSequence:chapterSeq andVerseSequence:verseSeq];
}

- (void) changeOfChapter
{
    BOOL isFirst;
    NSInteger bookId, itemNumber;
    NSString *chapterRef, *fullReference, *historyFile;
    NSMutableString *savedList;
    NSArray *historyList;
    NSComboBox *cbBook, *cbChapter, *cbHistory;
    classLXXBook *currentBook;

    cbBook = [globalVarsLXXText cbLXXBook];
    cbChapter = [globalVarsLXXText cbLXXChapter];
    bookId = [cbBook indexOfSelectedItem];
    if( ! [globalVarsLXXText isLXXChapterLoadActive] )
    {
        itemNumber = [cbChapter indexOfSelectedItem];
        if( itemNumber < 0) return;
        chapterRef = [[NSString alloc] initWithString:[cbChapter objectValueOfSelectedItem]];
        if( (bookId == [globalVarsLXXText lxxCurrentBookIndex]) && ([chapterRef compare:[globalVarsLXXText lxxCurrentChapter]] == NSOrderedSame) ) return;
        [globalVarsLXXText setIsLXXChapterLoadActive:true];
        [self displayChapter:chapterRef forBook:bookId];
        [globalVarsLXXText setIsLXXChapterLoadActive:false];
    }
    else
    {
        // Update the History ComboBox
        if( [cbChapter indexOfSelectedItem] < 0 ) return;
        chapterRef = [[NSString alloc] initWithString:[cbChapter objectValueOfSelectedItem]];
        cbHistory = [globalVarsLXXText cbLXXHistory];
        historyList = [[NSArray alloc] initWithArray:[cbHistory objectValues]];
        currentBook = [[globalVarsLXXText lxxBookList] objectForKey:[globalVarsLXXText convertIntegerToString:bookId]];
        fullReference = [[NSString alloc] initWithFormat:@"%@ %@", [currentBook commonName], chapterRef];
        if( [historyList indexOfObject:fullReference] != NSNotFound)
        {
            [cbHistory removeItemWithObjectValue:fullReference];
        }
        [cbHistory insertItemWithObjectValue:fullReference atIndex:0];
        [cbHistory selectItemAtIndex:0];
        // Now save the information
        historyFile = [[NSString alloc] initWithFormat:@"%@/%@/%@/History.txt", [globalVarsLXXText iniPath], [globalVarsLXXText notesPath], [globalVarsLXXText lxxNotesFolder]];
        // Renew this, now that the new/old reference has been placed
        historyList = [[NSArray alloc] initWithArray:[cbHistory objectValues]];
        isFirst = true;
        for( NSString *individualEntry in historyList)
        {
            if( isFirst)
            {
                savedList = [[NSMutableString alloc] initWithString:individualEntry];
                isFirst = false;
            }
            else [savedList appendFormat:@"\n%@", individualEntry];
        }
        [savedList writeToFile:historyFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void) changeOfBook
{
    NSInteger bookId;
    NSString *chapterRef;
    NSComboBox *cbBook;
    NSDictionary *bookList;
    classLXXBook *currentBook;
    
    cbBook = [globalVarsLXXText cbLXXBook];
    bookId = [cbBook indexOfSelectedItem];
    if( bookId == [globalVarsLXXText lxxCurrentBookIndex] ) return;
    [globalVarsLXXText setLxxCurrentBookIndex:bookId];
    bookList = [[NSDictionary alloc] initWithDictionary:[globalVarsLXXText lxxBookList]];
    currentBook = [bookList objectForKey:[globalVarsLXXText convertIntegerToString: bookId]];
    chapterRef = [currentBook getChapterNoBySequence:0];
    [self displayChapter:chapterRef forBook:bookId];
}

- (NSInteger) findLastSpace: (NSString *) sourceString
{
    NSInteger nPstn = 0, lastPstn = -1;
    NSRange stringRange;
    
    stringRange = NSMakeRange(0, [sourceString length]);
    while (nPstn > -1)
    {
        stringRange = [sourceString rangeOfString:@" " options:NSLiteralSearch range:stringRange];
        nPstn = stringRange.location;
        if( nPstn == NSNotFound) nPstn = -1;
        else
        {
            stringRange = NSMakeRange(nPstn + 1, [sourceString length] - nPstn - 1);
            lastPstn = nPstn;
        }
    }
    return lastPstn;
}

- (void) changeOfHistoryReference
{
    NSInteger idx, noOfBooks, bookId, nPstn;
    NSString *fullReference, *bookName, *chapterRef;
    NSComboBox *cbHistory;
    classLXXBook *currentBook;
    
    cbHistory = [globalVarsLXXText cbLXXHistory];
    fullReference = [cbHistory objectValueOfSelectedItem];
    nPstn = [self findLastSpace:fullReference];
    bookName = [fullReference substringToIndex:nPstn];
    chapterRef = [fullReference substringFromIndex:nPstn + 1];
    noOfBooks = [globalVarsLXXText noOfLXXBooks];
    bookId = -1;
    for( idx = 0; idx < noOfBooks; idx++)
    {
        currentBook = [[globalVarsLXXText lxxBookList] objectForKey:[globalVarsLXXText convertIntegerToString:idx]];
        if( [[currentBook commonName] compare:bookName] == NSOrderedSame )
        {
            bookId = idx;
            break;
        }
    }
    if( bookId > -1)
    {
        if( [fullReference compare:lastLXXHistoryUpdate] != NSOrderedSame )
        {
            lastLXXHistoryUpdate = [[NSString alloc] initWithString:fullReference];
            [self displayChapter:chapterRef forBook:bookId];
        }
    }
}

- (void) analysis
{
    NSInteger bookId;
    NSString *chapNo, *verseNo, *rootWord, *parseString;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSTextView *txtParse;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter;
    classLXXVerse *currentVerse;
    classLXXWord *currentWord;
    classAlert *alert;

    currentBook = nil;
//    backgroundColour = globalVars.getColourSetting(2, 0);
    // First, find the word that has been selected
    if ([[globalVarsLXXText latestSelectedLXXWord] length] == 0)
    {
        alert = [[classAlert alloc] init];
        [alert messageBox:@"You need to actively select a word before this action" title:@"Analyse Word" boxStyle:NSAlertStyleCritical];
        return;
    }
    cbBook = [globalVarsLXXText cbLXXBook];
    cbChapter = [globalVarsLXXText cbLXXChapter];
    cbVerse = [globalVarsLXXText cbLXXVerse];
    bookId = [cbBook indexOfSelectedItem];
    chapNo = [[NSString alloc] initWithString:[cbChapter itemObjectValueAtIndex:[cbChapter indexOfSelectedItem]]];
    verseNo = [[NSString alloc] initWithString:[cbVerse itemObjectValueAtIndex:[cbVerse indexOfSelectedItem]]];
    currentBook = [[globalVarsLXXText lxxBookList] objectForKey:[globalVarsLXXText convertIntegerToString: bookId]];
    if (currentBook == nil) return;
    currentChapter = [currentBook getChapterByChapterNo:chapNo];
    currentVerse = [currentChapter getVerseByVerseNo:verseNo];
    currentWord = [currentVerse getWord:[globalVarsLXXText sequenceOfLatestLXXWord]];
    // Now we have two tasks.  Intially, get and present the parse details
    txtParse = [globalVarsLXXText txtAllParse];
    [txtParse selectAll:self];
    [txtParse delete:self];
//    rtxtParse.BackColor = backgroundColour;
    parseString = [[NSString alloc] initWithFormat:@"%@\n", [currentWord accentlessTextWord]];
    [[txtParse textStorage] appendAttributedString:[lxxTextUtilities addAttributedText:parseString offsetCode:0 fontId:5 alignment:1 withAdjustmentFor:txtParse]];
    [[txtParse textStorage] appendAttributedString:[lxxTextUtilities addAttributedText:@"\n" offsetCode:0 fontId:6 alignment:0 withAdjustmentFor:txtParse]];
    rootWord = [currentWord rootWord];
    parseString = [gkLexicon parseGrammar:[currentWord catString] withSecondCode:[currentWord parseString]];
    if ([parseString length] > 0)
    {
        [[txtParse textStorage] appendAttributedString:[lxxTextUtilities addAttributedText:parseString offsetCode:0 fontId:6 alignment:0 withAdjustmentFor:txtParse]];
    }
    [gkLexicon getLexiconEntry:rootWord];
    // finally, make sure the parse page is visible
    [[globalVarsLXXText tabTopRight] selectTabViewItemAtIndex:0];
}

- (void) prevOrNextChapter: (NSInteger) forwardBack
{
    /*=========================================================================*
     *                                                                         *
     *                           prevOrNextChapter                             *
     *                           =================                             *
     *                                                                         *
     *  Simply handles moving backwards or forwards from the present chapter.  *
     *                                                                         *
     *  Parameters:                                                            *
     *    forwardBack: 1 = previous chapter                                    *
     *                 2 = next chapter                                        *
     *                                                                         *
     ***************************************************************************/
    
    NSInteger bookIdx = 0, actualIdx;
    NSString *chapNo, *chapRef;
    NSComboBox *cbBooks, *cbChapters;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter, *advChapter;
    NSDictionary  *listOfBooks;

    listOfBooks = [globalVarsLXXText lxxBookList];
    cbBooks = [globalVarsLXXText cbLXXBook];
    cbChapters = [globalVarsLXXText cbLXXChapter];
    actualIdx = [cbBooks indexOfSelectedItem];
    chapRef = [cbChapters objectValueOfSelectedItem];
    currentBook = [listOfBooks objectForKey:[globalVarsLXXText convertIntegerToString:actualIdx]];
    currentChapter = [currentBook getChapterByChapterNo:chapRef];
    if( forwardBack == 2) advChapter = [currentChapter nextChapter];
    else advChapter = [currentChapter previousChapter];
    if( advChapter == nil) return;
    bookIdx = [advChapter bookNo];
    chapNo = [currentBook getChapterNoBySequence:[advChapter chapterNo]];
    [self displayChapter:chapNo forBook:bookIdx];
}

- (void) processSearchAction: (NSInteger) actionCode
{
    BOOL isFirst;
    NSInteger referenceLength, bookId, idx, noOfBooks;
    NSRange selectedRange;
    NSString *reference, *wholeVerse, *bookName, *chapterRef, *verseRef, *noBreakSpace, *ideographicSpace;
    NSMutableString *referenceList;
    NSAttributedString *tempText;
    NSMutableAttributedString *relevantText;
    NSArray *resultLines;
    NSTextView *notesTextView, *searchTextView;
    NSPasteboard *standardPasteboard;
    classLXXBook *currentBook;
    classAlert *alert;

    noBreakSpace = [[NSString alloc] initWithFormat:@"%C", 0x00a0];
    switch (actionCode)
    {
        case 1:
            relevantText = [[globalVarsLXXText txtSearchResults] textStorage];
            standardPasteboard = [NSPasteboard generalPasteboard];
            [standardPasteboard clearContents];
            if( ( relevantText != nil ) && ( [relevantText length] > 0 ) )
            {
                [standardPasteboard setString:[relevantText string] forType:NSPasteboardTypeString];
                alert = [classAlert new];
                [alert messageBox:@"Search results have been copied to memory" title:@"Search Results Copy" boxStyle:NSAlertStyleInformational];
            }
            break;
        case 2:
            relevantText = [[globalVarsLXXText txtSearchResults] textStorage];
            notesTextView = [globalVarsLXXText txtLXXNotes];
            if( ( relevantText != nil ) && ( [relevantText length] > 0 ) )
            {
                [[notesTextView textStorage] insertAttributedString:relevantText atIndex:[notesTextView selectedRange].location];
            }
            break;
        case 3:
            reference = [globalVarsLXXText searchVerseReferenceNo];
            wholeVerse = [globalVarsLXXText searchVerseIsolate];
            referenceLength = [reference length];
            relevantText = [[NSMutableAttributedString alloc] initWithString:[wholeVerse substringFromIndex:referenceLength + 2]];
            [relevantText addAttribute:NSFontAttributeName value:[globalVarsLXXText searchGreekMainText] range:NSMakeRange(0, [relevantText length])];
            standardPasteboard = [NSPasteboard generalPasteboard];
            [standardPasteboard clearContents];
            if( ( relevantText != nil ) && ( [relevantText length] > 0 ) )
            {
                [standardPasteboard setString:[relevantText string] forType:NSPasteboardTypeString];
                alert = [classAlert new];
                [alert messageBox:@"Search results have been copied to memory" title:@"Search Results Copy" boxStyle:NSAlertStyleInformational];
            }
            break;
        case 4:
            notesTextView = [globalVarsLXXText txtLXXNotes];
            reference = [globalVarsLXXText searchVerseReferenceNo];
            wholeVerse = [globalVarsLXXText searchVerseIsolate];
            referenceLength = [reference length];
            relevantText = [[NSMutableAttributedString alloc] initWithString:[wholeVerse substringFromIndex:referenceLength + 2]];
            [relevantText addAttribute:NSFontAttributeName value:[globalVarsLXXText searchGreekMainText] range:NSMakeRange(0, [relevantText length])];
            [[notesTextView textStorage] insertAttributedString:relevantText atIndex:[notesTextView selectedRange].location];
            break;
        case 5:
            searchTextView = [globalVarsLXXText txtSearchResults];
            selectedRange = [searchTextView selectedRange];
            tempText = [[searchTextView textStorage] attributedSubstringFromRange:selectedRange];
            standardPasteboard = [NSPasteboard generalPasteboard];
            [standardPasteboard clearContents];
            if( ( relevantText != nil ) && ( [relevantText length] > 0 ) )
            {
                [standardPasteboard setString:[tempText string] forType:NSPasteboardTypeString];
                alert = [classAlert new];
                [alert messageBox:@"Search results have been copied to memory" title:@"Search Results Copy" boxStyle:NSAlertStyleInformational];
            }
            break;
        case 6:
            notesTextView = [globalVarsLXXText txtLXXNotes];
            searchTextView = [globalVarsLXXText txtSearchResults];
            selectedRange = [searchTextView selectedRange];
            tempText = [[searchTextView textStorage] attributedSubstringFromRange:selectedRange];
            [[notesTextView textStorage] insertAttributedString:tempText atIndex:[notesTextView selectedRange].location];
            break;
        case 7:
        case 8:
            relevantText = [[globalVarsLXXText txtSearchResults] textStorage];
            standardPasteboard = [NSPasteboard generalPasteboard];
            [standardPasteboard clearContents];
            resultLines = [[relevantText string] componentsSeparatedByString:@"\n"];
            referenceList = [[NSMutableString alloc] initWithString:@""];
            isFirst = true;
            for( NSString *resultLine in resultLines)
            {
                if( ( resultLine == nil ) || ( [resultLine length] == 0 ) ) continue;
                selectedRange = [resultLine rangeOfString:@": "];
                reference = [[NSString alloc] initWithString:[resultLine substringToIndex:selectedRange.location]];
                if( isFirst )
                {
                    [referenceList appendString:reference];
                    isFirst = false;
                }
                else [referenceList appendFormat:@"\n%@", reference];
            }
            if( ( referenceList != nil ) && ( [referenceList length] > 0 ) )
            {
                if( actionCode == 7 )
                {
                    [standardPasteboard setString:referenceList forType:NSPasteboardTypeString];
                    alert = [classAlert new];
                    [alert messageBox:@"Search results have been copied to memory" title:@"Search Results Copy" boxStyle:NSAlertStyleInformational];
                }
                else
                {
                    notesTextView = [globalVarsLXXText txtLXXNotes];
                    [[notesTextView textStorage] insertAttributedString:[[NSAttributedString alloc] initWithString:referenceList] atIndex:[notesTextView selectedRange].location];
                }
            }
            break;
        case 9:
            reference = [globalVarsLXXText searchVerseReferenceNo];
            wholeVerse = [globalVarsLXXText searchVerseIsolate];
            selectedRange = [reference rangeOfString:noBreakSpace];
            bookName = [[NSString alloc] initWithString:[reference substringToIndex:selectedRange.location]];
            ideographicSpace = [[NSString alloc] initWithFormat:@"%C", 0x3000];
            bookName = [[NSString alloc] initWithString:[bookName stringByReplacingOccurrencesOfString:ideographicSpace withString:@" "]];
            verseRef = [[NSString alloc] initWithString:[reference substringFromIndex:selectedRange.location + 1]];
            selectedRange = [verseRef rangeOfString:@"."];
            chapterRef = [[NSString alloc] initWithString:[verseRef substringToIndex:selectedRange.location]];
            noOfBooks = [globalVarsLXXText noOfLXXBooks];
            bookId = -1;
            for( idx = 0; idx < noOfBooks; idx++ )
            {
                currentBook = [[globalVarsLXXText lxxBookList] objectForKey:[globalVarsLXXText convertIntegerToString:idx]];
                if( [[currentBook commonName] compare:bookName] == NSOrderedSame )
                {
                    bookId = idx;
                    break;
                }
            }
            if( bookId > -1 ) [self displayChapter:chapterRef forBook:bookId];
            break;
        default:
            break;
    }
}

@end
