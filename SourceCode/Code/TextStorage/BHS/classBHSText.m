//
//  classBHSText.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import "classBHSText.h"

@implementation classBHSText

const unichar zeroWidthSpace = 0x200b, zeroWidthNonJoiner = 0x200d;

NSInteger noOfStoredBooks;

classGlobal *globalVarsBHSText;
frmProgress *progressForm;
//classHistory historyProcesses;
classHebLexicon *lexicon;
@synthesize bhsNotes;

@synthesize bhsLoop;
@synthesize bhsProgress;

/*===============================================================================================*
 *                                                                                               *
 *                                      bhsBookList                                              *
 *                                      -----------                                              *
 *                                                                                               *
 *  Stores references to book names and associated data.                                         *
 *     Key:     Integer sequence (starting from zero);                                           *
 *     Value:   The class instance for Hebrew books                                              *
 *                                                                                               *
 *===============================================================================================*/
@synthesize bhsBookList;

/*===============================================================================================*
 *                                                                                               *
 *                                   listOfStrongConversions                                     *
 *                                   -----------------------                                     *
 *                                                                                               *
 *  Allows us to access data relating to information from Strong's Concordance.                  *
 *     Key:     The word from the text (with accents removed);                                   *
 *     Value:   The class instance giving Strongs data.                                          *
 *                                                                                               *
 *===============================================================================================*/
@synthesize listOfStrongConversions;
@synthesize strongConversionRef;

/*===============================================================================================*
 *                                                                                               *
 *                                        codeDecode                                             *
 *                                        ----------                                             *
 *                                                                                               *
 *  A simple code/decode list, storing information derived from the file, Codes.txt.  This       *
 *    relates to codes relating to a variety of elements (mainly grammar).  The source text      *
 *    provides this information in terse, abbreviated form; this expands to (hopefully) more     *
 *    meaningful descriptions.                                                                   *
 *                                                                                               *
 *     Key:     The word from the text (with accents removed);                                   *
 *     Value:   The class instance giving Strongs data.                                          *
 *                                                                                               *
 *===============================================================================================*/
@synthesize codeDecode;
@synthesize codeRef;

/*===============================================================================================*
 *                                                                                               *
 *                                      variantList:                                             *
 *                                      -----------                                              *
 *                                                                                               *
 *  Stores references to Kethib-Qere.                                                            *
 *     Key:     The word code of the variant;                                                    *
 *     Value:   The class instance storing the data                                              *
 *                                                                                               *
 *===============================================================================================*/
@synthesize variantList;
@synthesize variantRef;

NSString *lastHistoryUpdate;
NSComboBox *cbBooks;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init] )
    {
        globalVarsBHSText = inGlobal;
        bhsBookList = [[NSMutableDictionary alloc] init];
        codeDecode = [[NSMutableDictionary alloc] init];
        variantList = [[NSMutableDictionary alloc] init];
        variantRef = [[NSMutableArray alloc] init];
        listOfStrongConversions = [[NSMutableDictionary alloc] init];
        strongConversionRef = [[NSMutableArray alloc] init];
        codeRef = [[NSMutableArray alloc] init];
        noOfStoredBooks = 0;
        bhsNotes = [[classBHSNotes alloc] init:globalVarsBHSText];
        lastHistoryUpdate = @"";
    }
    return  self;
}

- (void) loadText: (classHebLexicon *) inLex
{
    NSInteger bookNo, prevBookNo = 0, fileWordNo, idx, globalWordId;
    NSString *titlesFileName, *sourceFileName, *fileBuffer, *fileName, *bookName, *kethib, *qere,
        *ChapNo = @"", *prevChapNo = @"?", *verseNo = @"", *prevVerseNo = @"?", *workArea;
    NSArray *fields, *strongNos, *textByLine;
    classBHSBook *currentBook;
    classBHSChapter *currentChapter, *prevChapter;
    classBHSVerse *currentVerse, *previousVerse;
    classBHSWord *currentWord;
    classKethib_Qere *currentVariant;
    NSComboBox *cbBook;

    lexicon = inLex;
    /*----------------------------------------------------------------------------------------------------------------*
     *                                                                                                                *
     *  Step 1: Load the Kethib-Qere list                                                                             *
     *  ------  -------------------- ----                                                                             *
     *                                                                                                                *
     *  Load this now so we can integrate it into the word record                                                     *
     *                                                                                                                *
     *----------------------------------------------------------------------------------------------------------------*/
    [bhsProgress updateProgressMain:@"Starting load of Masoretic Text" withSecondMsg:@"Loading Kethib-Qere data"];
    [bhsLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    fileName = [globalVarsBHSText kethibQereFile];
    sourceFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
    fileBuffer = [[NSString alloc] initWithContentsOfFile:sourceFileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[fileBuffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        if ([lineOfText length] > 0)
        {
            fields = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
            if ([fields count] >= 3)
            {
                fileWordNo = [[fields objectAtIndex:0] integerValue];
                kethib = [fields objectAtIndex: 1];
                qere = [fields objectAtIndex:2];
                if (([kethib length] > 0) || ([qere length] > 0))
                {
                    currentVariant = [[classKethib_Qere alloc] init];
                    [currentVariant setKethibText:kethib];
                    [currentVariant setQereText:qere];
                    workArea = [globalVarsBHSText convertIntegerToString: fileWordNo];
                    [variantList setObject:currentVariant forKey:workArea];
                    if( ! [variantRef containsObject:workArea] ) [variantRef addObject:workArea];
                }
            }
        }
    }

    /*--------------------------------------------------------*
     *                                                        *
     *  Step 2: Load the book titles                          *
     *  ------  --------------------                          *
     *                                                        *
     *--------------------------------------------------------*/
    [bhsProgress updateProgressMain:@"Getting titles of Masoretic Text books" withSecondMsg:@""];
    [bhsLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    cbBook = [globalVarsBHSText cbBHSBook];
    titlesFileName = [globalVarsBHSText bhsTitlesFile];
    sourceFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:titlesFileName ofType:@"txt"]];
    fileBuffer = [[NSString alloc] initWithContentsOfFile:sourceFileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[fileBuffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        fields = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
        if ([fields count] >= 3)
        {
            bookNo = [[fields objectAtIndex:0] integerValue];
            currentBook = [[classBHSBook alloc] init:globalVarsBHSText];
            [bhsBookList setObject:currentBook forKey:[globalVarsBHSText convertIntegerToString:(bookNo - 1)]];
            bookName = [fields objectAtIndex:2];
            [cbBook addItemWithObjectValue:bookName];
            [currentBook setBookName:bookName];
            [currentBook setBookId:bookNo];
            [currentBook setShortName:[fields objectAtIndex: 1]];
            [currentBook setCategory:[[fields objectAtIndex:3] integerValue]];
            [globalVarsBHSText addListBoxGroupItem:[currentBook bookName] withCode:[currentBook category] - 1];
            noOfStoredBooks++;
        }
    }
    [cbBook selectItemAtIndex:0];

    /*------------------------------------------------------------------------------------------------------*
     *                                                                                                      *
     *  Step 3: Load the text data                                                                          *
     *  ------  ------------------                                                                          *
     *                                                                                                      *
     *  Fields:                                                                                             *
     *  ======                                                                                              *
     *                                                                                                      *
     *  1    Global word id    A sequential count of all OT words in book, chapter, verse, occurrence order *
     *  2    Global Verse id   Each verse is allocated a unique integer, in the same order                  *
     *  3    Book no.          Int (1 - 39) These are "keys" to Titles.txt in the Source directory          *
     *  4    Chapter no.       Int (1 - n)                                                                  *
     *                           Note: real numbers, not sequence.  So                                      *
     *                           a) not 0-based                                                             *
     *                           b) requires a seperate sequence number when processing chapters            *
     *  5    Verse no.         Int (1 - n) Similar constraints to field 4                                   *
     *  6    Word sequence no. Int (0 - n) (note: zero-based, unlike the other counts)                      *
     *  7    Word              String.  This is the word as used in the text                                *
     *                           Note: there are a small number of "words" that are actually multiple words *
     *                                 and contain spaces.  These have been replaced by non-breaking space  *
     *                                 (hex 0x00a0) so that a normal space can be used as a boundary value  *
     *                                 between words.                                                       *
     *  8    Unaccented Word   I.e. the word in field 7 with accents removed but retaining                  *
     *                           a) vowels                                                                  *
     *                           b) sin/shin dots                                                           *
     *                           c) dagesh (forte and line)                                                 *
     *                           d)                                                                         *
     *                           e) any non-breaking spaces embedded in the text                            *
     *  9    Bare Word         I.e. the word in field 7 with *all* pointing removed but retaining any       *
     *                           embedded non-breaking spaces                                               *
     *  10   Affix             String sequence (if it exists, such as a mappeq) affixed (postfixed) to the  *
     *                           word but not an integral part of the word.                                 *
     *  11   Prefix marker     Code to indicate whether the current "word" is seperated from the following  *
     *                           word by a space or not:                                                    *
     *                           1   This word is prefixed to the following word,                           *
     *                           0   A space follows this word                                              *
     *  12   Internal code     In the original source data, this was prefixed with "E"                      *
     *  13   Strong Reference  The identified Strong reference or references.  In the original data this    *
     *                           was prefixed with "H".                                                     *
     *                           Note that there can be more than one code, in which case subsequent values *
     *                           are seperated by "+".  (I think this indicates that the word is composed   *
     *                           of more than one Hebrew word and each Strongs code relates to each word.   *
     *  14   Gloss             A simple meaning to the word, as provided by Strongs (a bit naive really)    *
     *  15   Morphology        I.e. a summarised grammatical analysis. It remains to be seen just how       *
     *                           accurate this summary is                                                   *
     *                                                                                                      *
     *------------------------------------------------------------------------------------------------------*/
    cbBooks = [globalVarsBHSText cbBHSBook];
    fileName = [globalVarsBHSText bhsSourceFile];
    sourceFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
    fileBuffer = [[NSString alloc] initWithContentsOfFile:sourceFileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[fileBuffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        fields = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
        globalWordId = [[fields objectAtIndex:0] integerValue];
        bookNo = [[fields objectAtIndex:2] integerValue];
        if (bookNo != prevBookNo)
        {
            // New book
            currentBook = [bhsBookList objectForKey:[globalVarsBHSText convertIntegerToString: bookNo - 1]];
            [bhsProgress updateProgressMain:@"Loading the Biblia Hebraica Text for:" withSecondMsg:[currentBook bookName]];
            [bhsLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
            prevChapNo = @"?";
            prevVerseNo = @"?";
            prevBookNo = bookNo;
            previousVerse = nil;
        }
        ChapNo = [fields objectAtIndex:3];
        if ([ChapNo compare:prevChapNo] != NSOrderedSame)
        {
            prevChapter = currentChapter;
            currentChapter = [currentBook addNewChapterToBook:ChapNo];
            if (prevChapter != nil) [prevChapter setNextChapter:currentChapter];
            [currentChapter setPreviousChapter:prevChapter];
            [currentChapter setBookNo:bookNo - 1];
            [currentChapter setChapterRef:ChapNo];
            [currentChapter setChapterSeqNo:[currentBook getSequenceByChapterNo:ChapNo]];
            prevVerseNo = @"?";
            prevChapNo = ChapNo;
        }
        verseNo = fields[4];
        if ([verseNo compare: prevVerseNo] != NSOrderedSame)
        {
            currentVerse = [currentChapter addVerseToChapter:verseNo];
            if (previousVerse != nil) [previousVerse setNextVerse:currentVerse];
            previousVerse = currentVerse;
            [currentVerse setChapSeq:[currentChapter chapterSeqNo]];
            [currentVerse setChapRef:[currentChapter chapterRef]];
            [currentVerse setVerseSeq:[currentChapter noOfVersesInChapter] - 1];
            [currentVerse setVerseRef:[currentChapter getVerseNoBySequence:[currentVerse verseSeq]]];
            prevVerseNo = verseNo;
        }
        currentWord = [currentVerse addWordToVers];
        [currentWord setActualWord:[fields objectAtIndex:6]];
        [currentWord setUnaccentedWord:[fields objectAtIndex:7]];
        [currentWord setBareWord:[fields objectAtIndex:8]];
        if ([[fields objectAtIndex:9] length] > 0) [currentWord setAffix:[fields objectAtIndex:9]];
        else [currentWord setAffix:@""];
        if ([[currentWord affix] compare: @"׀"] == NSOrderedSame) [currentWord setAffix:@""];
        idx = [[fields objectAtIndex:10] integerValue];
        if (idx == 1) [currentWord setIsPrefix:true];
        else [currentWord setIsPrefix:false];
        [currentWord setERef:[[fields objectAtIndex:11] integerValue]];
        strongNos = [[fields objectAtIndex:12] componentsSeparatedByString:@"+"];
        fileWordNo = [strongNos count];
        for (idx = 0; idx < fileWordNo; idx++) [currentWord addStrongRef:[[[strongNos objectAtIndex:idx] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] integerValue]];
        [currentWord setGloss:[fields objectAtIndex:13]];
        [currentWord setMorphology:[fields objectAtIndex:14]];
        if ( [variantRef containsObject:[[NSString alloc] initWithFormat:@"%ld", globalWordId]])
        {
            [currentWord setHasVariant:true];
            currentVariant = nil;
            currentVariant = [variantList objectForKey:[[NSString alloc] initWithFormat:@"%ld", globalWordId]];
            if( currentVariant != nil) [currentWord setWordVariant:currentVariant];
        }
    }
    [globalVarsBHSText setBhsBookList:[bhsBookList copy]];
    [globalVarsBHSText setNoOfBHSBooks:noOfStoredBooks];
    [globalVarsBHSText setBhsCurrentBookIndex:0];
    [globalVarsBHSText setBhsCurrentChapter:@""];

    /*------------------------------------------------------------------------------------------------------*
     *                                                                                                      *
     *  Step 4: Load the code/decode data for the morphology "codes"                                        *
     *  ------  ---- --- ----------- ---- --- --- ---------- -------                                        *
     *                                                                                                      *
     *  This step will load meaningful expressions for each terse code and store them in the Sorted List    *
     *    codeDecode.                                                                                       *
     *                                                                                                      *
     *------------------------------------------------------------------------------------------------------*/

    [bhsProgress updateProgressMain:@"Loading the data for grammar" withSecondMsg:@""];
    [bhsLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    fileName = [globalVarsBHSText codeFile];
    sourceFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
    fileBuffer = [[NSString alloc] initWithContentsOfFile:sourceFileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[fileBuffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        // Split into the main fields
        fields = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@"\t"]];
        if( ! [codeRef containsObject:[fields objectAtIndex:0]])
        {
            [codeDecode setObject:[fields objectAtIndex:1] forKey:[fields objectAtIndex:0]];
            [codeRef addObject:[fields objectAtIndex:0]];
        }
    }
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
    NSMutableAttributedString *attribText;
    classBHSBook *currentBook;
    classBHSChapter *currentChapter;
    classBHSVerse *currentVerse;
    classBHSWord *currentWord;
    NSTextView *targetTextArea;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSTabView *mainTabView;
    NSTabViewItem *expectedItem;
    NSColor *backgroundColour;
    classDisplayUtilities *displayUtils;

    displayUtils = [[classDisplayUtilities alloc] init:globalVarsBHSText];
    backgroundColour = [globalVarsBHSText bhsTextBackgroundColour];
    lineFeed = [[NSAttributedString alloc] initWithString:@"\n"];
    singleSpace = [[NSAttributedString alloc] initWithString:@" "];
//    backgroundColour = globalVars.getColourSetting(0, 0);
    // Get the Rich Text area in which the text occurs
    targetTextArea = [globalVarsBHSText txtBHSText];
    // Get the combo boxes for the Book, Chapter and Verse
    [[targetTextArea textStorage] deleteCharactersInRange:NSMakeRange(0, [[targetTextArea textStorage] length])];
    cbBook = [globalVarsBHSText cbBHSBook];
    cbChapter = [globalVarsBHSText cbBHSChapter];
    cbVerse = [globalVarsBHSText cbBHSVerse];
    // If any of them don't exist, abort
    if ((cbBook == nil) || (cbChapter == nil) || (cbVerse == nil) || (targetTextArea == nil)) return;
    // Get the name of the new book - and, BTW the class instance for the book
    currentBook = [bhsBookList objectForKey:[globalVarsBHSText convertIntegerToString: bookIdx]];
    newBookName = [currentBook bookName];
    if ([cbBook numberOfItems] == 0) return;
    /*===================================================================================*
     *                                                                                   *
     * The next statement:                                                               *
     *      cbBook.SelectedIndex = bookIdx;                                              *
     * will kick off cbBook_SelectedIndexChanged in frmMain, which, in turn, will invoke *
     * mainText.respondToNewBook.  Since this will finally invoke displayChapter, we are *
     * going to have an unhelpful loop.  So, let's stop it by disabling the call-back.   *
     * We do this by using globalVars.IsTextUpdateActive                                 *
     *                                                                                   *
     *===================================================================================*/
//    globalVars.IsTextUpdateActive = true;
    [cbBook selectItemAtIndex:bookIdx];
//    globalVars.IsTextUpdateActive = false;
    if ([currentBook noOfChaptersInBook] == 0) return;
    // Get the specified chapter from the current book -
    currentChapter = [currentBook getChapterByChapterNo:chapIdx];
    // Now modify the verse combo box *and* display the new chapter
    /*===================================================================================*
     *                                                                                   *
     * We now want to modify the verse combo box but, given that we're already all set   *
     * populate the text, we don't want it to kick off another round of updating the     *
     * text.  So we will use isChapUpdateActive, much as before.  This time, the
     * variable, isChapUpdateActive, will be picked up in the frmMain event and handled  *
     * there                                                                             *
     *                                                                                   *
     *===================================================================================*/
    // We *have* to assume that this is a new chapter, so repopulate cbChapter
    noOfChapters = [currentBook noOfChaptersInBook];
    [cbChapter removeAllItems];
    for( cdx = 0; cdx < noOfChapters; cdx++)
    {
        realChapNo = [currentBook  getChapterNoBySequence:cdx];
        [cbChapter addItemWithObjectValue:realChapNo];
    }
    noOfItems = [cbChapter numberOfItems];
    [globalVarsBHSText setIsBHSChapterLoadActive:true];
    itemIndex = [currentBook getSequenceByChapterNo:chapIdx];
    [cbChapter selectItemAtIndex:itemIndex];
    [globalVarsBHSText setIsBHSChapterLoadActive:false];
    noOfVerses = [currentChapter noOfVersesInChapter];
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
        if (idx > 0)
        {
            [[targetTextArea textStorage] appendAttributedString:lineFeed];
        }
//        targetTextArea.SelectionColor = globalVars.getColourSetting(0, 1);
        attribText = [displayUtils addAttributedText:[[NSString alloc] initWithFormat:@"%@: ", realVNo] offsetCode:0 fontId:0 alignment:2 withAdjustmentFor:targetTextArea];
        [[targetTextArea textStorage] appendAttributedString:attribText];
        noOfWords = [currentVerse wordCount];
        for (wdx = 0; wdx < noOfWords; wdx++)
        {
            currentWord = [currentVerse getWord:wdx];
            if ([currentWord hasVariant])
            {
                attribText = [displayUtils addAttributedText:[[NSString alloc] initWithFormat:@"%C%@", zeroWidthSpace, [currentWord  actualWord]] offsetCode:0 fontId:2 alignment:2 withAdjustmentFor:targetTextArea];
            }
            else
            {
                attribText = [displayUtils addAttributedText:[[NSString alloc] initWithFormat:@"%C%@", zeroWidthSpace, [currentWord  actualWord]] offsetCode:0 fontId:1 alignment:2 withAdjustmentFor:targetTextArea];
            }
            [[targetTextArea textStorage] appendAttributedString:attribText];
            if ([[currentWord affix] length] > 0)
            {
                attribText = [displayUtils addAttributedText:[[NSString alloc] initWithFormat:@"%C%@", zeroWidthNonJoiner, [currentWord  affix]] offsetCode:0 fontId:1 alignment:2 withAdjustmentFor:targetTextArea];
                [[targetTextArea textStorage] appendAttributedString:attribText];
            }
            if ((! [currentWord isPrefix]) && ([[currentWord affix] compare: @"־"] != 0)) [[targetTextArea textStorage] appendAttributedString:singleSpace];
        }
    }
    if( [cbVerse numberOfItems] > 0 ) [cbVerse selectItemAtIndex:0];
    mainTabView = [globalVarsBHSText tabMain];
    expectedItem = [globalVarsBHSText itemMainBHS];
    if( [mainTabView selectedTabViewItem] == expectedItem)
    {
        displayString = [[NSString alloc] initWithFormat:@"%@ %@", newBookName, chapIdx];
        [[globalVarsBHSText mainWindow] setTitle:[[NSString alloc] initWithFormat:@"Old Testament Student - Masoretic Text: %@", displayString]];
//        addEntryToHistory(displayString, 0);
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
    cbBook = [globalVarsBHSText cbBHSBook];
    cbChapter = [globalVarsBHSText cbBHSChapter];
    cbVerse = [globalVarsBHSText cbBHSVerse];
    bookId = [globalVarsBHSText latestBHSBookId];
    chapterSeq = [globalVarsBHSText latestBHSChapterSeq];
    verseSeq = [globalVarsBHSText latestBHSVerseSeq];
    [bhsNotes storeANoteFor:bookId chapterSequence:chapterSeq andVerseSequence:verseSeq];

    // Blank the old note (which makes sure it isn't artificially "saved"
    noteTextView = [globalVarsBHSText txtBHSNotes];
    [noteTextView selectAll:self];
    [noteTextView delete:self];

    // Now register the new Book-Chapter-Verse
    bookId = [cbBook indexOfSelectedItem];
    chapterSeq = [cbChapter indexOfSelectedItem];
    verseSeq = [cbVerse indexOfSelectedItem];
    [globalVarsBHSText setLatestBHSBookId:bookId];
    [globalVarsBHSText setLatestBHSChapterSeq:chapterSeq];
    [globalVarsBHSText setLatestBHSVerseSeq:verseSeq];
    
    // See if there is a note and, if so, display it
    [bhsNotes retrieveANoteFor:bookId chapterSequence:chapterSeq andVerseSequence:verseSeq];
}

- (void) changeOfChapter
{
    BOOL isFirst;
    NSInteger bookId, itemNumber;
    NSString *chapterRef, *fullReference, *historyFile;
    NSMutableString *savedList;
    NSArray *historyList;
    NSComboBox *cbBook, *cbChapter, *cbHistory;
    classBHSBook *currentBook;
    
    cbBook = [globalVarsBHSText cbBHSBook];
    cbChapter = [globalVarsBHSText cbBHSChapter];
    bookId = [cbBook indexOfSelectedItem];
    if( ! [globalVarsBHSText isBHSChapterLoadActive] )
    {
        itemNumber = [cbChapter indexOfSelectedItem];
        if( itemNumber < 0) return;
        chapterRef = [[NSString alloc] initWithString:[cbChapter objectValueOfSelectedItem]];
        if( (bookId == [globalVarsBHSText bhsCurrentBookIndex]) && ([chapterRef compare:[globalVarsBHSText bhsCurrentChapter]] == NSOrderedSame) ) return;
        [globalVarsBHSText setIsBHSChapterLoadActive:true];
        [self displayChapter:chapterRef forBook:bookId];
        [globalVarsBHSText setIsBHSChapterLoadActive:false];
    }
    else
    {
        // Update the History ComboBox
        if( [cbChapter indexOfSelectedItem] < 0 ) return;
        chapterRef = [[NSString alloc] initWithString:[cbChapter objectValueOfSelectedItem]];
        cbHistory = [globalVarsBHSText cbBHSHistory];
        historyList = [[NSArray alloc] initWithArray:[cbHistory objectValues]];
        currentBook = [[globalVarsBHSText bhsBookList] objectForKey:[globalVarsBHSText convertIntegerToString:bookId]];
        fullReference = [[NSString alloc] initWithFormat:@"%@ %@", [currentBook bookName], chapterRef];
        if( [historyList indexOfObject:fullReference] != NSNotFound)
        {
            [cbHistory removeItemWithObjectValue:fullReference];
        }
        [cbHistory insertItemWithObjectValue:fullReference atIndex:0];
        [cbHistory selectItemAtIndex:0];
        // Now save the information
        historyFile = [[NSString alloc] initWithFormat:@"%@/%@/%@/History.txt", [globalVarsBHSText iniPath], [globalVarsBHSText notesPath], [globalVarsBHSText bhsNotesFolder]];
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
    NSDictionary *currBookList;
    classBHSBook *currentBook;
    
    cbBook = [globalVarsBHSText cbBHSBook];
    bookId = [cbBook indexOfSelectedItem];
    if( bookId == [globalVarsBHSText bhsCurrentBookIndex] ) return;
    [globalVarsBHSText setBhsCurrentBookIndex:bookId];
    currBookList = [[NSDictionary alloc] initWithDictionary:[globalVarsBHSText bhsBookList]];
    currentBook = [currBookList objectForKey:[[NSString alloc] initWithFormat:@"%ld", bookId]];
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
//    NSRange spaceRange;
    classBHSBook *currentBook;
    
    cbHistory = [globalVarsBHSText cbBHSHistory];
    fullReference = [cbHistory objectValueOfSelectedItem];
    nPstn = [self findLastSpace:fullReference];
//    spaceRange = [fullReference rangeOfString:@" "];
//    bookName = [fullReference substringToIndex:spaceRange.location];
    bookName = [fullReference substringToIndex:nPstn];
    chapterRef = [fullReference substringFromIndex:nPstn + 1];
    noOfBooks = [globalVarsBHSText noOfBHSBooks];
    bookId = -1;
    for( idx = 0; idx < noOfBooks; idx++)
    {
        currentBook = [[globalVarsBHSText bhsBookList] objectForKey:[globalVarsBHSText convertIntegerToString:idx]];
        if( [[currentBook bookName] compare:bookName] == NSOrderedSame )
        {
            bookId = idx;
            break;
        }
    }
    if( bookId > -1)
    {
        if( [fullReference compare:lastHistoryUpdate] != NSOrderedSame )
        {
            lastHistoryUpdate = [[NSString alloc] initWithString:fullReference];
            [self displayChapter:chapterRef forBook:bookId];
        }
    }
}

- (void) analysis
{
    bool isFirstEntry = true, isNewEntry = true;
    NSInteger idx, noOfMorphs, extraCommentCode, bookId, noOfEntries, sdx, noOfStrongBDBEntries, jdx, noOfDetail, strongRefNo, textStyleCode, lineStyleCode, keyCode, startChapter, endChapter, startVerse, endVerse;
    NSString *morphSource, *morphologyString = @"", *ChapNo, *VerseNo, *strongRefCandidate, *simpleText, *bookName;
    NSMutableAttributedString *currentText;
    NSArray *parseList;
    classBHSBook *currentBook = nil;
    classBHSChapter *currentChapter;
    classBHSVerse *currentVerse;
    classBHSWord *currentWord;
    classBDBEntry *currentEntry;
    classBDBEntryDetail *entryDetail;
    classStrongToBDBLookup *strongToBDBEntry;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSTextView *txtParse, *txtLex;
    classAlert *alert;
    classDisplayUtilities *displayUtils;

    // First, find the word that has been selected
    if ([[globalVarsBHSText latestSelectedBHSWord] length] == 0)
    {
        alert = [[classAlert alloc] init];
        [alert messageBox:@"You need to actively select a word before this action" title:@"Analyse Word" boxStyle:NSAlertStyleCritical];
        return;
    }
    cbBook = [globalVarsBHSText cbBHSBook];
    cbChapter = [globalVarsBHSText cbBHSChapter];
    cbVerse = [globalVarsBHSText cbBHSVerse];
    bookId = [cbBook indexOfSelectedItem];
    ChapNo = [[NSString alloc] initWithString:[cbChapter itemObjectValueAtIndex:[cbChapter indexOfSelectedItem]]];
    VerseNo = [[NSString alloc] initWithString:[cbVerse itemObjectValueAtIndex:[cbVerse indexOfSelectedItem]]];
    currentBook = [[globalVarsBHSText bhsBookList] objectForKey:[globalVarsBHSText convertIntegerToString: bookId]];
    if( currentBook == nil) return;
    currentChapter = [currentBook getChapterByChapterNo:ChapNo];
    currentVerse = [currentChapter getVerseByVerseNo:VerseNo];
    currentWord = [currentVerse getWord:[globalVarsBHSText sequenceOfLatestBHSWord]];
    displayUtils = [[classDisplayUtilities alloc] init:globalVarsBHSText];
    // Now we have two tasks.  Intially, get and present the parse details
    txtParse = [globalVarsBHSText txtAllParse];
    [txtParse selectAll:self];
    [txtParse delete:self];
    simpleText = [[NSString alloc] initWithFormat:@"\t\t%@\n", [currentWord unaccentedWord]];
    [[txtParse textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:0 fontId:5 alignment:1 withAdjustmentFor:txtParse]];
    [[txtParse textStorage] appendAttributedString:[displayUtils addAttributedText:@"\n" offsetCode:0 fontId:6 alignment:0 withAdjustmentFor:txtParse]];
    parseList = [[currentWord morphology] componentsSeparatedByString:@"."];
    noOfMorphs = [parseList count];
    for (idx = 0; idx < noOfMorphs; idx++)
    {
        extraCommentCode = 0;
        morphSource = [[NSString alloc] initWithString:[[parseList objectAtIndex:idx] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        morphologyString = nil;
        morphologyString = [codeDecode objectForKey:morphSource];
        if( morphologyString == nil) morphologyString = @"";
        if ([morphologyString length] > 0)
        {
            if ([morphologyString characterAtIndex:0] == '*')
            {
                extraCommentCode = [[morphologyString substringWithRange:NSMakeRange(1, 1)] integerValue];
                morphologyString = [morphologyString substringFromIndex: 2];
            }
            if ([morphologyString compare: @"unknown"] == NSOrderedSame) continue;
            if (isNewEntry)
            {
                simpleText = [[NSString alloc] initWithFormat:@"%@:", morphologyString];
                currentText = [displayUtils addAttributedText:simpleText offsetCode:0 fontId:6 alignment:0 withAdjustmentFor:txtParse];
                [[txtParse textStorage] appendAttributedString:currentText];
                isNewEntry = false;
            }
            else
            {
                simpleText = [[NSString alloc] initWithFormat:@" %@", morphologyString];
                currentText = [displayUtils addAttributedText:simpleText offsetCode:0 fontId:6 alignment:0 withAdjustmentFor:txtParse];
                [[txtParse textStorage] appendAttributedString:currentText];
            }
            if (extraCommentCode > 0)
            {
                currentText = [displayUtils addAttributedText:@"\n\nAramaic verb form" offsetCode:0 fontId:6 alignment:0 withAdjustmentFor:txtParse];
                [[txtParse textStorage] appendAttributedString:currentText];
            }
        }
    }
    /*--------------------------------------------*
     * Now display the lexicon details            *
     *--------------------------------------------*/
    // Get and clear the text view for lexicon entries
    txtLex = [globalVarsBHSText txtAllLexicon];
    [txtLex selectAll:self];
    [txtLex delete:self];
    // Process the list of Strongs References found in the word store
    noOfEntries = [currentWord noOfStrongRefs];
    for (idx = 0; idx < noOfEntries; idx++)
    {
        strongRefCandidate = nil;
        strongRefNo = [currentWord getStrongRefBySeq:idx];
        // Now get the instance of classBDBForStrong for that reference, so that we can identify the word entry or entries
        strongToBDBEntry = nil;
        strongToBDBEntry = [[globalVarsBHSText strongRefLookup] objectForKey:[globalVarsBHSText convertIntegerToString: strongRefNo]];
        if( strongToBDBEntry == nil) continue;
        // Now get the BDB entries for that Strongs reference
        noOfStrongBDBEntries = [strongToBDBEntry noOfEntriesForStrongNo];
        for( sdx = 0; sdx < noOfStrongBDBEntries; sdx++)
        {
            currentEntry = [[strongToBDBEntry bdbEntryList] objectForKey:[globalVarsBHSText convertIntegerToString:sdx]];
            if( currentEntry != nil )
            {
                if( isFirstEntry) isFirstEntry = false;
                else [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:@"\n\n ===========================\n\n" offsetCode:0 fontId:0 alignment:1 withAdjustmentFor:txtLex]];
                noOfDetail = [currentEntry noOfDetailItems];
                for( jdx = 0; jdx < noOfDetail; jdx++)
                {
                    entryDetail = [currentEntry getEntryDetailBySequence:jdx];
                    textStyleCode = [entryDetail textStyleCode];
                    lineStyleCode = [entryDetail lineStyleCode];
                    keyCode = [entryDetail keyCode];
                    simpleText = [entryDetail text];
                    if( (keyCode == 1) || ( keyCode == 2))
                        [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:[[NSString alloc] initWithFormat:@"%@\n", simpleText] offsetCode:0 fontId:7 alignment:1 withAdjustmentFor:txtLex]];
                    switch (keyCode)
                    {
                        case 5:
                        case 7:
                        case 8:
                            [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:0 fontId:18 alignment:0 withAdjustmentFor:txtLex]];
                            break;
                        case 0:
                        case 4:
                        case 6:
                            [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:lineStyleCode fontId:8 alignment:0 withAdjustmentFor:txtLex]];
                            break;
                        case 3:
                            startChapter = [entryDetail startChapter];
                            endChapter = [entryDetail endChapter];
                            startVerse = [entryDetail startVerse];
                            endVerse = [entryDetail endVerse];
                            bookName = [entryDetail bookName];
                             if( startChapter == endChapter )
                             {
                                 simpleText = [[NSString alloc] initWithFormat:@"%@ %ld", bookName, startChapter];
                                 [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:txtLex]];
                                 if ( startVerse == endVerse ) simpleText = [[NSString alloc] initWithFormat:@"%ld", startVerse];
                                 else simpleText = [[NSString alloc] initWithFormat:@"%ld-%ld", startVerse, endVerse];
                                 [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:1 fontId:8 alignment:0 withAdjustmentFor:nil]];
                             }
                             else
                             {
                                 simpleText = [[NSString alloc] initWithFormat:@"%@ %ld", bookName, startChapter];
                                 [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:txtLex]];
                                 simpleText = [[NSString alloc] initWithFormat:@"%ld", startVerse];
                                 [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:1 fontId:8 alignment:0 withAdjustmentFor:nil]];
                                 simpleText = [[NSString alloc] initWithFormat:@"-%ld", endChapter];
                                 [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:nil]];
                                 simpleText = [[NSString alloc] initWithFormat:@"%ld", endVerse];
                                 [[txtLex textStorage] appendAttributedString:[displayUtils addAttributedText:simpleText offsetCode:1 fontId:8 alignment:0 withAdjustmentFor:nil]];

                             }
                             break;
                        default: break;
                    }
                }
            }
        }
    }
    // finally, make sure the parse page is visible
    [[globalVarsBHSText tabTopRight] selectTabViewItemAtIndex:0];
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
    classBHSBook *currentBook;
    classBHSChapter *currentChapter, *advChapter;
    NSDictionary  *listOfBooks;

    listOfBooks = [globalVarsBHSText bhsBookList];
    cbBooks = [globalVarsBHSText cbBHSBook];
    cbChapters = [globalVarsBHSText cbBHSChapter];
    actualIdx = [cbBooks indexOfSelectedItem];
    chapRef = [cbChapters objectValueOfSelectedItem];
    currentBook = [listOfBooks objectForKey:[globalVarsBHSText convertIntegerToString:actualIdx]];
    currentChapter = [currentBook getChapterByChapterNo:chapRef];
    if( forwardBack == 2) advChapter = [currentChapter nextChapter];
    else advChapter = [currentChapter previousChapter];
    if( advChapter == nil) return;
    bookIdx = [advChapter bookNo];
    chapNo = [currentBook getChapterNoBySequence:[advChapter chapterSeqNo]];
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
    classBHSBook *currentBook;
    classAlert *alert;

    noBreakSpace = [[NSString alloc] initWithFormat:@"%C", 0x00a0];
    switch (actionCode)
    {
        case 1:
            relevantText = [[globalVarsBHSText txtSearchResults] textStorage];
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
            relevantText = [[globalVarsBHSText txtSearchResults] textStorage];
            notesTextView = [globalVarsBHSText txtBHSNotes];
            if( ( relevantText != nil ) && ( [relevantText length] > 0 ) )
            {
                [[notesTextView textStorage] insertAttributedString:relevantText atIndex:[notesTextView selectedRange].location];
            }
            break;
        case 3:
            reference = [globalVarsBHSText searchVerseReferenceNo];
            wholeVerse = [globalVarsBHSText searchVerseIsolate];
            referenceLength = [reference length];
            relevantText = [[NSMutableAttributedString alloc] initWithString:[wholeVerse substringFromIndex:referenceLength + 2]];
            [relevantText addAttribute:NSFontAttributeName value:[globalVarsBHSText searchBHSMainText] range:NSMakeRange(0, [relevantText length])];
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
            notesTextView = [globalVarsBHSText txtBHSNotes];
            reference = [globalVarsBHSText searchVerseReferenceNo];
            wholeVerse = [globalVarsBHSText searchVerseIsolate];
            referenceLength = [reference length];
            relevantText = [[NSMutableAttributedString alloc] initWithString:[wholeVerse substringFromIndex:referenceLength + 2]];
            [relevantText addAttribute:NSFontAttributeName value:[globalVarsBHSText searchBHSMainText] range:NSMakeRange(0, [relevantText length])];
            [[notesTextView textStorage] insertAttributedString:relevantText atIndex:[notesTextView selectedRange].location];
            break;
        case 5:
            searchTextView = [globalVarsBHSText txtSearchResults];
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
            notesTextView = [globalVarsBHSText txtBHSNotes];
            searchTextView = [globalVarsBHSText txtSearchResults];
            selectedRange = [searchTextView selectedRange];
            tempText = [[searchTextView textStorage] attributedSubstringFromRange:selectedRange];
            [[notesTextView textStorage] insertAttributedString:tempText atIndex:[notesTextView selectedRange].location];
            break;
        case 7:
        case 8:
            relevantText = [[globalVarsBHSText txtSearchResults] textStorage];
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
                    notesTextView = [globalVarsBHSText txtBHSNotes];
                    [[notesTextView textStorage] insertAttributedString:[[NSAttributedString alloc] initWithString:referenceList] atIndex:[notesTextView selectedRange].location];
                }
            }
            break;
        case 9:
            reference = [globalVarsBHSText searchVerseReferenceNo];
            wholeVerse = [globalVarsBHSText searchVerseIsolate];
            selectedRange = [reference rangeOfString:noBreakSpace];
            bookName = [[NSString alloc] initWithString:[reference substringToIndex:selectedRange.location]];
            ideographicSpace = [[NSString alloc] initWithFormat:@"%C", 0x3000];
            bookName = [[NSString alloc] initWithString:[bookName stringByReplacingOccurrencesOfString:ideographicSpace withString:@" "]];
            verseRef = [[NSString alloc] initWithString:[reference substringFromIndex:selectedRange.location + 1]];
            selectedRange = [verseRef rangeOfString:@"."];
            chapterRef = [[NSString alloc] initWithString:[verseRef substringToIndex:selectedRange.location]];
            noOfBooks = [globalVarsBHSText noOfBHSBooks];
            bookId = -1;
            for( idx = 0; idx < noOfBooks; idx++ )
            {
                currentBook = [[globalVarsBHSText bhsBookList] objectForKey:[globalVarsBHSText convertIntegerToString:idx]];
                if( [[currentBook bookName] compare:bookName] == NSOrderedSame )
                {
                    bookId = idx;
                    break;
                }
            }
            if( bookId > -1 ) [self displayChapter:chapterRef forBook:bookId];
            break;
        default: break;
    }
}

@end
