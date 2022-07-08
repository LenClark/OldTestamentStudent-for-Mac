//
//  classSearch.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 13/01/2021.
//

#import "classSearch.h"

@implementation classSearch

@synthesize listOfRefs;
@synthesize refControl;
@synthesize noOfRefs;
@synthesize noOfMatches;
@synthesize statusLabel;

classConfig *globalVarsSearch;
classGreekProcessing *gkProcessingSearch;

- (id) init: (classConfig *) inConfig greekProcessing: (classGreekProcessing *) inGreek
{
    if( self = [super init] )
    {
        globalVarsSearch = inConfig;
        gkProcessingSearch = inGreek;
        listOfRefs = [[NSMutableDictionary alloc] init];
        refControl = [[NSMutableDictionary alloc] init];
        statusLabel = [globalVarsSearch statusLabel];
    }
    return self;
}


- (NSArray *) performSearch: (NSString *) sourceString primarySource: (NSInteger) primarySource bookCode: (NSInteger) bookCode
                     chapter: (NSString *) chapterCode verse: (NSString *) verseRef
              withSecondWord: (NSString *) secondaryWord secondarySource: (NSInteger) secondarySource last2ryBook: (NSInteger) bookCode2ary
              last2ryChapter: (NSString *) chapRef2ary last2ryVerse: (NSString *) verseRef2ary
            searchComplexity: (bool) isComplex searchType: (NSInteger) rbOption wordDistance: (NSInteger) contextCount
             ntBooksToSearch: (NSArray *) activeNtList lxxBooksToSearch: (NSArray *) activeLxxList
{
    /*************************************************************************************************************************
     *                                                                                                                       *
     *  This procedure creates a string that contains the results of the specified search.  It provides alternative options: *
     *                                                                                                                       *
     *  a) A simple search: all occurrences of a given lexime (i.e                                                           *
     *     i)   Find the root of the chosen word                                                                             *
     *     ii)  Perform a word by word comparison of the *roots* of all NT words for a match                                 *
     *     iii) Store the full text of those verses where a match occurs                                                     *
     *  b) A complex search: much as in a) but where the match occurs within n words (either way) of the root of the second  *
     *          specified word                                                                                               *
     *                                                                                                                       *
     *  It also recognises two types of search:                                                                              *
     *  a) Root comparison ( as described in a) above                                                                        *
     *  b) Exact word comparison, where both simple and comples searches are based on an exact match (including accents) of  *
     *          the word(s) as provided.                                                                                     *
     *                                                                                                                       *
     *  Parameters:                                                                                                          *
     *  ==========                                                                                                           *
     *                                                                                                                       *
     *  sourceString:        The primary word which is the subject of the search                                             *
     *  primarySource:       An integer code to determine whether the source was NT (value = 1) or OT (valaue = 2)           *
     *  bookCode:            The bookId of the source of the word                                                            *
     *  chapterCode:         A string identifying the chapter                                                                *
     *  verseCode            A string identifying the verse                                                                  *
     *  secondaryWord:       A second word; occurrences of the first lexeme must be within contextCount words of the second  *
     *                         lexeme                                                                                        *
     *  secondarySource:     An integer code to determine whether the source was NT (value = 1) or OT (valaue = 2)           *
     *  bookCode2ary:        The bookId of the source of the secondary word                                                  *
     *  chapRef2ary:         A string identifying the chapter                                                                *
     *  verseRef2ary         A string identifying the verse                                                                  *
     *  searchComplexity:    If true, the procedure will perform a "complex search" (see note b) at the head of this comment *
     *                       If false, see the note below the parameters                                                     *
     *  searchType           The selected option in the main Search panel                                                    *
     *                          1 = comparison of all words by root                                                          *
     *                          2 = comparison by exact match of the given occurrence                                        *
     *  contextCount:        See above                                                                                       *
     *  activeNtList:        An array of the NT index numbers of books to be included in the search.  (Nb the data type in   *
     *                       the array is NSNumber, representing NSInteger originals.)                                       *
     *  activeLxxList:       The old testament equivalent of activeNtList.                                                   *
     *                                                                                                                       *
     *  If searchComplexity = false, this means that the search is purely for occurrences of the primary word.  This means   *
     *    that the following parameters are *not* used and may be supplied as nil or 0:                                      *
     *       - secondaryWord                                                                                                 *
     *       - secondarySource                                                                                               *
     *       - bookCode2ary                                                                                                  *
     *       - chapRef2ary                                                                                                   *
     *       - verseRef2ary                                                                                                  *
     *       - contextCount                                                                                                  *
     *                                                                                                                       *
     *************************************************************************************************************************/
    
    NSInteger copyOfContextCount;
    NSString *primaryString, *secondaryString, *alertHeader;
    NSArray *alertMsg;
    classCleanReturn *cleanReturn;
    GBSAlert *alert;
    
    // Validate the provided fields
    copyOfContextCount = contextCount;
    alertHeader = @"Search Error";
    alertMsg = [[NSArray alloc] initWithObjects:@"You must provide a word in which to base the search",
                @"Greek Bible Student can only search for a single word in each text box",
                @"Greek Bible Student can only search for a single word at a time\nConsider using the Advanced Search",
                @"The search facility is limited to a maximum separation of ten words between the primary and secondary words\nThe separation has been reset to 10",
                @"The search facility is limited to a minimum separation of one word between the primary and secondary words\nThe separation has been reset to 1",
                @"Bible Reader can only search for a single word in each text box",
                nil];
    if ((sourceString == nil) || ( [sourceString length] == 0))
    {
        alert = [GBSAlert new];
        [alert messageBox:[alertMsg objectAtIndex:0] title:alertHeader boxStyle:NSAlertStyleCritical];
        return nil;
    }
    if ( [sourceString containsString:@" "])
    {
        alert = [GBSAlert new];
        if (isComplex) [alert messageBox:[alertMsg objectAtIndex:1] title:alertHeader boxStyle:NSAlertStyleCritical];
        else [alert messageBox:[alertMsg objectAtIndex:2] title:alertHeader boxStyle:NSAlertStyleCritical];
        return nil;
    }
    if (isComplex)
    {
        if (copyOfContextCount > 10)
        {
            alert = [GBSAlert new];
            [alert messageBox:[alertMsg objectAtIndex:3] title:alertHeader boxStyle:NSAlertStyleWarning];
            copyOfContextCount = 10;
        }
        if (copyOfContextCount < 1)
        {
            alert = [GBSAlert new];
            [alert messageBox:[alertMsg objectAtIndex:4] title:alertHeader boxStyle:NSAlertStyleWarning];
            copyOfContextCount = 1;
        }
        if ( [secondaryWord containsString:@" "] )
        {
            alert = [GBSAlert new];
            [alert messageBox:[alertMsg objectAtIndex:5] title:alertHeader boxStyle:NSAlertStyleCritical];
            return nil;
        }
    }
    // Get rid of any spurious characters
    cleanReturn = [gkProcessingSearch removeNonGkChars:sourceString];
    primaryString = [cleanReturn cleanedWord];
    cleanReturn = [gkProcessingSearch removeNonGkChars:secondaryWord];
    secondaryString = [cleanReturn cleanedWord];
    // Now get rid of accents, etc
    primaryString = [gkProcessingSearch reduceToBareGreek:primaryString isRemovedAlready:true];
    if( ( secondaryString == nil ) || ( [secondaryString length] == 0 ) ) secondaryString = @"";
    else secondaryString = [gkProcessingSearch reduceToBareGreek:secondaryString isRemovedAlready:true];
    // If the search is not for an exact match of provided word(s), we must find the root of the provided word(s)
    if (rbOption != 2)
    {
        primaryString = [self findRoot:primaryString source:primarySource bookCode:bookCode chapter:chapterCode verse:verseRef];
        if( [primaryString length] == 0)
        {
            [[globalVarsSearch statusLabel] setStringValue:@"Root not found - abandoning search"];
            [[globalVarsSearch statusLabel2] setHidden:true];
            return nil;
        }
        if( isComplex ) secondaryString = [self findRoot:secondaryString source:secondarySource bookCode:bookCode2ary chapter:chapRef2ary verse:verseRef2ary];
        else secondaryString = @"";
    }
    // Now we are in a position to perform the search - basically, simply scan
    //   Note: the word sequence(s) passed to simpleScan will either be the roots or the actual occurrences, depending on rbOption
    if (isComplex) return [self complexScan:primaryString secondaryString:secondaryString ntBooksToSearch:activeNtList lxxBooksToSearch:activeLxxList searchType:rbOption wordSpread:contextCount];
//    else return [self simpleScan:primaryString ntBooksToSearch:activeNtList lxxBooksToSearch:activeLxxList searchType:rbOption];
    else return [[self simpleScan:primaryString ntBooksToSearch:activeNtList lxxBooksToSearch:activeLxxList searchType:rbOption] copy];
//    return @"";
}

- (NSString *) findRoot: (NSString *) originalWord source: (NSInteger) sourceCode bookCode: (NSInteger) bookCode chapter: (NSString *) chapterCode verse: (NSString *) verseRef
{
    /************************************************************************************************
     *                                                                                              *
     *                                         findRoot                                             *
     *                                         ========                                             *
     *                                                                                              *
     *  Purpose: to find the root form of the supplied word                                         *
     *                                                                                              *
     *  Parameters:                                                                                 *
     *  ==========                                                                                  *
     *                                                                                              *
     *  originalWord:             The source word                                                   *
     *  sourceCode:               This determines whether the source was NT (value 1) or OT (value  *
     *                            2).  If it has a value < 1, then the word was entered from the    *
     *                            virtual keyboard (or by some other means) and we will need to     *
     *                            the root by scanning our text until we find it (or fail to do so) *
     *  bookCode:                 the relevant bookId                                               *
     *  chapterCode:              the relevant chapter code                                         *
     *  verseRef:                 the relevant verse code                                           *
     *                                                                                              *
     *  If sourceCode is 1 or 2, we would expect bookCode, chapterCode and verseCode to have        *
     *    meaningful values.  Conversely, if sourceCode < 1, then they are not reliable and may be  *
     *    bookCode = 0 or -1, chapterCode and verseCode = nil.                                      *
     *                                                                                              *
     *  This method is *only* called if a root value is required.                                   *
     *                                                                                              *
     ************************************************************************************************/
    
    NSInteger idx, noOfBooks, noOfChapters, noOfVerses, noOfWords, bookIdx, chapIdx, verseIdx, wordIdx;
    NSString *candidateWord;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    classWord *currentWord;
    NSTextView *activeTextView;
    NSDictionary *listOfBooks;
    
    if (sourceCode > 0)
    {
        // We are provided the source reference for the word
        if (sourceCode == 1)
        {
            activeTextView = [globalVarsSearch ntTextView];
            currentBook = [[globalVarsSearch ntListOfBooks] objectForKey:[[NSString alloc] initWithFormat:@"%li", bookCode]];
        }
        else
        {
            activeTextView = [globalVarsSearch lxxTextView];
            currentBook = [[globalVarsSearch lxxListOfBooks] objectForKey:[[NSString alloc] initWithFormat:@"%li", bookCode]];
        }
        currentChapter = [currentBook getChapterByChapterId:chapterCode];
        currentVerse = [currentChapter getVerseByVerseNo:verseRef];
        noOfWords = [currentVerse wordCount];
        for (idx = 0; idx < noOfWords; idx++)
        {
            currentWord = [currentVerse getwordBySeqNo:idx];
            candidateWord = [[NSString alloc] initWithString:[currentWord accentlessTextWord]];
            if ( [candidateWord compare:originalWord] == NSOrderedSame )
            {
                return [[NSString alloc] initWithString:[currentWord rootWord]];
            }
        }
    }
    // If we reach here either there was no source reference or the source reference didn't work
    [[globalVarsSearch statusLabel] setStringValue:[[NSString alloc] initWithFormat:@"Finding a root for: %@", originalWord]];
    [[globalVarsSearch statusLabel2] setHidden:false];
    for (idx = 0; idx < 2; idx++)
    {
        // Two scans: idx = 0 -> NT scan
        //            idx = 1 -> Lxx scan
        if (idx == 0) listOfBooks = [globalVarsSearch ntListOfBooks];
        else listOfBooks = [globalVarsSearch lxxListOfBooks];
        noOfBooks = [listOfBooks count];
        for (bookIdx = 0; bookIdx < noOfBooks; bookIdx++)
        {
            currentBook = [listOfBooks objectForKey:[[NSString alloc]  initWithFormat:@"%li", bookIdx]];
            [[globalVarsSearch statusLabel2] setStringValue:[[NSString alloc] initWithFormat:@"Searching usage in: %@", [currentBook bookName]]];
            [globalVarsSearch topRightTabView].needsDisplay = true;
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
            noOfChapters = [currentBook noOfChaptersInBook];
            for (chapIdx = 0; chapIdx < noOfChapters; chapIdx++)
            {
                currentChapter = [currentBook getChapterBySeqNo:chapIdx];
                noOfVerses = [currentChapter noOfVersesInChapter];
                for (verseIdx = 0; verseIdx < noOfVerses; verseIdx++)
                {
                    currentVerse = [currentChapter getVerseBySeqNo:verseIdx];
                    noOfWords = [currentVerse wordCount];
                    for (wordIdx = 0; wordIdx < noOfWords; wordIdx++)
                    {
                        currentWord = [currentVerse getwordBySeqNo:wordIdx];
                        candidateWord = [currentWord accentlessTextWord];
                        if( [candidateWord compare:originalWord] == NSOrderedSame )
                        {
                            return [currentWord rootWord];
                        }
                    }
                }
            }
        }
    }
    return @"";
}

- (void) primaryScan: (NSString *) primaryString ntBooksToSearch: (NSArray *) activeNtList lxxBooksToSearch: (NSArray *) activeLxxList exactOrNot: (NSInteger) rbOption
{
    /**************************************************************************************************************
     *                                                                                                            *
     *                                               primaryScan                                                  *
     *                                               ===========                                                  *
     *                                                                                                            *
     *  The purpose of this method is to scan for all occurrences of the primary word and populate a "list" of    *
     *    references where the word is found (including repeats).                                                 *
     *                                                                                                            *
     *  Parameters:                                                                                               *
     *  ==========                                                                                                *
     *                                                                                                            *
     *    ntBooksToSearch    A list of NT books to be included in the search                                      *
     *    lxxBooksToSearch   A list of LXX books to be included in the search                                     *
     *    primaryString      The word to be searched for                                                          *
     *    rbOption           Specifies whether we are looking fo an exact match or a root match                   *
     *                          1 = root match                                                                    *
     *                          2 = exact match                                                                   *
     *                                                                                                            *
     **************************************************************************************************************/
    
    BOOL isInList = false;
    NSInteger idx, bookIdx, chapIdx, verseIdx, wordIdx, noOfBooks, noOfChapters, noOfVerses, noOfWords, refNo, matchCount;
    NSNumber *numberEquivalent;
    NSString *copyOfPrimary, *candidateWord, *refKey;
    NSArray *bookMasterCopy;
    NSDictionary *listOfBooks;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    classWord *currentWord;
    classReference *currentReference;
    
    // Prepare information storage
    noOfRefs = 0;
    [listOfRefs removeAllObjects];
    [refControl removeAllObjects];
    copyOfPrimary = [[NSString alloc] initWithString:primaryString];
    bookMasterCopy = [[NSArray alloc] initWithArray:[globalVarsSearch booksMaster]];

    [[globalVarsSearch statusLabel] setStringValue:[[NSString alloc] initWithFormat:@"Finding all matches for: %@", primaryString]];
    [[globalVarsSearch statusLabel2] setHidden:false];
    matchCount = 0;
    for( idx = 0; idx < 2; idx++)
    {
        // Two passes, idx = 0 for NT, idx = 1 for OT
        if( idx == 0 ) listOfBooks = [[NSDictionary alloc] initWithDictionary:[globalVarsSearch ntListOfBooks]];
        else listOfBooks = [[NSDictionary alloc] initWithDictionary:[globalVarsSearch lxxListOfBooks]];
        noOfBooks = [listOfBooks count];
        for( bookIdx = 0; bookIdx < noOfBooks; bookIdx++)
        {
            numberEquivalent = [NSNumber numberWithInteger:bookIdx];
            if( idx == 0 ) isInList = [activeNtList containsObject: numberEquivalent];
            else isInList = [activeLxxList containsObject:numberEquivalent];
            if( isInList )
            {
                // So this is one of the books included in the search
                currentBook = [listOfBooks objectForKey:[[NSString alloc] initWithFormat:@"%li", bookIdx]];
                noOfChapters = [currentBook noOfChaptersInBook];
                for( chapIdx = 0; chapIdx < noOfChapters; chapIdx++)
                {
                    currentChapter = [currentBook getChapterBySeqNo:chapIdx];
                    noOfVerses = [currentChapter noOfVersesInChapter];
                    for( verseIdx = 0; verseIdx < noOfVerses; verseIdx++)
                    {
                        currentVerse = [currentChapter getVerseBySeqNo:verseIdx];
                        noOfWords = [currentVerse wordCount];
                        for( wordIdx = 0; wordIdx < noOfWords; wordIdx++)
                        {
                            currentWord = [currentVerse getwordBySeqNo:wordIdx];
                            if( rbOption == 2) candidateWord = [[NSString alloc] initWithString:[currentWord accentlessTextWord]];
                            else candidateWord = [[NSString alloc] initWithString:[currentWord rootWord]];
                            if( [candidateWord compare:copyOfPrimary] == NSOrderedSame)
                            {
                                refKey = [[NSString alloc] initWithFormat:@"%li-%li-%li-%li", idx, bookIdx, chapIdx, verseIdx];
                                [[globalVarsSearch statusLabel2] setStringValue:[[NSString alloc] initWithFormat:@"Matches found: %li", ++matchCount]];
                                [globalVarsSearch topRightTabView].needsDisplay = true;
                                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
                                numberEquivalent = nil;
                                numberEquivalent = [refControl objectForKey:refKey];
                                if( numberEquivalent == nil)
                                {
                                    currentReference = [classReference new];
                                    currentReference.testamentCode = idx;
                                    currentReference.bookIdx = bookIdx;
                                    currentReference.chapIdx = chapIdx;
                                    currentReference.verseIdx = verseIdx;
                                    currentReference.noOfMatches = 1;
                                    [listOfRefs setObject:currentReference forKey:[NSNumber numberWithInteger:noOfRefs]];
                                    [refControl setObject:[NSNumber numberWithInteger:noOfRefs] forKey:refKey];
                                    noOfRefs++;
                                }
                                else
                                {
                                    refNo = [[refControl objectForKey:refKey] integerValue];
                                    currentReference = [listOfRefs objectForKey:[NSNumber numberWithInteger:refNo]];
                                    currentReference.noOfMatches++;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSMutableArray *) simpleScan: (NSString *) primaryString ntBooksToSearch: (NSArray *) activeNtList lxxBooksToSearch: (NSArray *) activeLxxList searchType: (NSInteger) rbOption
{
    /**************************************************************************************************************
     *                                                                                                            *
     *                                               simpleScan                                                   *
     *                                               ==========                                                   *
     *                                                                                                            *
     *  This method actually performs the scan.                                                                   *
     *                                                                                                            *
     *  Parameters:                                                                                               *
     *  ==========                                                                                                *
     *                                                                                                            *
     *  primaryString              The word in the main search textfield, which has had accents and all other     *
     *                             furniture (other than breathings) removed.                                     *
     *  activeNtList               This is an array of NSNumbers where each number corresponds to the absolute    *
     *                             index of a NT book.  This allows us to identify what books are (and are not)   *
     *                             currently listed in the Search listbox.                                        *
     *  activeLxxList              As activeNtList but for the LXX books,                                         *
     *  rbOption                   This is 1 if the search is on roots and 2 if an exact match of the text word.  *
     *                                                                                                            *
     **************************************************************************************************************/
    
    NSInteger idx, wdx, wordCount;
    NSString *copyOfPrimary, *textWord, *referenceString, *candidateWord, *bareWord;
    NSMutableString *progressMsg;
    NSMutableArray *textSequence;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    classWord *currentWord;
    classReference *currentRef;
    
    // Two scans, one for NT and one for LXX
    noOfMatches = 0;
    textSequence = [[NSMutableArray alloc] init];
    copyOfPrimary = [gkProcessingSearch reduceToBareGreek:[[NSString alloc] initWithString:primaryString] isRemovedAlready:true];
    progressMsg = [[NSMutableString alloc] initWithString:@""];
    [self primaryScan:primaryString ntBooksToSearch:activeNtList lxxBooksToSearch:activeLxxList exactOrNot:rbOption];
    [[globalVarsSearch statusLabel] setStringValue:@"Getting the full text for all matches"];
    for (idx = 0; idx < noOfRefs; idx++)
    {
        currentRef = [listOfRefs objectForKey:[NSNumber numberWithInteger:idx]];
        if ( [currentRef testamentCode] == 0) currentBook = [[globalVarsSearch ntListOfBooks] objectForKey:[[NSString alloc] initWithFormat:@"%li", [currentRef bookIdx]]];
        else currentBook = [[globalVarsSearch lxxListOfBooks] objectForKey:[[NSString alloc] initWithFormat:@"%li", [currentRef bookIdx]]];
        currentChapter = [currentBook getChapterBySeqNo:[currentRef chapIdx]];
        currentVerse = [currentChapter getVerseBySeqNo:[currentRef verseIdx]];
        if( idx > 0 )
        {
            [textSequence addObject:@"\r\r"];
            [textSequence addObject:@"0"];
        }
        referenceString = [[NSString alloc] initWithFormat:@"%@ %@.%@: ", [currentBook bookName], [currentBook getChapterIdBySeqNo:[currentRef chapIdx]], [currentChapter getVerseIdBySeqNo:[currentRef verseIdx]]];
        [[globalVarsSearch statusLabel2] setStringValue:[[NSString alloc] initWithFormat:@"Working on %@", referenceString]];
        [globalVarsSearch topRightTabView].needsDisplay = true;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
        [textSequence addObject:referenceString];
        [textSequence addObject:@"0"];
        wordCount = [currentVerse WordCount];
        for( wdx = 0; wdx < wordCount; wdx++)
        {
            currentWord = [currentVerse getwordBySeqNo:wdx];
            textWord = [currentWord textWord];
            candidateWord = [currentWord accentlessTextWord];
            [textSequence addObject:[[NSString alloc] initWithFormat:@" %@", textWord]];
            if( rbOption == 1)
            {
                bareWord = [[NSString alloc] initWithString:[gkProcessingSearch reduceToBareGreek:[currentWord rootWord] isRemovedAlready:true]];
                if( [bareWord compare:copyOfPrimary] == 0) [textSequence addObject:@"1"];
                else [textSequence addObject:@"0"];
            }
            else
            {
                if( [candidateWord compare:copyOfPrimary] == 0) [textSequence addObject:@"1"];
                else [textSequence addObject:@"0"];
            }
        }
    }
    noOfMatches = 0;
    return textSequence;
}

- (NSMutableArray *) complexScan: (NSString *) primaryString secondaryString: (NSString *) secondaryString ntBooksToSearch: (NSArray *) activeNtList lxxBooksToSearch: (NSArray *) activeLxxList searchType: (NSInteger) rbOption wordSpread: (NSInteger) contextCount
{
    /*************************************************************************************************************
     *                                                                                                           *
     *                                         complexScan                                                       *
     *                                         ===========                                                       *
     *                                                                                                           *
     *   This method will look for all occurrences of secondaryWord within contextCount words (either way) of    *
     *     primaryWord (derived using currVerse and vIdx).                                                       *
     *                                                                                                           *
     *   This may require retrieving either the verse prior to the current one or the verse following the        *
     *     current one (or, in extreme, both).  No attempt will be made to cross into prior or following books.  *
     *                                                                                                           *
     *   This is, in effect, an integral part of performSearch but has been separated to relieve visual pressure *
     *     on that method and because it is of a particularly complex nature.                                    *
     *                                                                                                           *
     *   currBook:       The Book object holding data for the book currently in view                             *
     *   cIdx:           The chapter sequencenumber.  (Note, the related Chapters object can be derived, using   *
     *                       currBook and this value.)                                                           *
     *   vIdx:           The verse sequence number. (The Verses object can also be derived.)                     *
     *   wIdx:           This is the index of the identified word in the verse matching the primary search word. *
     *   spanNo:         The value set as a maximum separation between the primary and secondary search words to *
     *                       qualify as matching.                                                                *
     *   secondaryWord:  The secondary word                                                                      *
     *   isExact:        A flag indicating whether the search is simple (the occurrence of the primary word      *
     *                       only) or complex (searching for the co-occurrence of two words within a defined     *
     *                       range).  The variables, spanNo and secondaryWord are only needed if isExact is      *
     *                       true.                                                                               *
     *                                                                                                           *
     *   It will return:                                                                                         *
     *          a) true, if a complex match has been found, otherwise false;                                     *
     *          b) if true, the returnedText output parameter will contain any verses that contain the two       *
     *               source words.                                                                               *
     *                                                                                                           *
     *************************************************************************************************************/
    
    bool isMatch, isMatch2, isFinal, isFirstInRef;
    NSInteger idx, jdx, wdx, wordCount, verseIdx, wordIdx, noOfWords, occurrences, countDown, proximityCount, matchCount;
    NSNumber *altVerseSeqNo;
    NSString *copyOfPrimary, *copyOfSecondary, *candidateWord, *candidateSecondary, *textWord, *referenceString, *bareWord;
    NSMutableString *progressMsg;
    NSArray *decompRef;
    NSMutableArray *textSequence;
    NSMutableDictionary *impactedVerse, *impactedVerse2, *finalCollection;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse, *otherVerse;
    classWord *currentWord, *otherWord;
    classReference *currentRef;
    
    // Two scans, one for NT and one for LXX
    noOfMatches = 0;
    impactedVerse = [[NSMutableDictionary alloc] init];
    impactedVerse2 = [[NSMutableDictionary alloc] init];
    finalCollection = [[NSMutableDictionary alloc] init];
    textSequence = [[NSMutableArray alloc] init];
//    resultingText = [[NSMutableString alloc] initWithString:@""];
    progressMsg = [[NSMutableString alloc] init];
    copyOfPrimary = [gkProcessingSearch reduceToBareGreek:[[NSString alloc] initWithString:primaryString] isRemovedAlready:true];
    copyOfSecondary = [gkProcessingSearch reduceToBareGreek:[[NSString alloc] initWithString:secondaryString] isRemovedAlready:true];
    isFinal = false;
    proximityCount = 0;
    [self primaryScan:primaryString ntBooksToSearch:activeNtList lxxBooksToSearch:activeLxxList exactOrNot:rbOption];
    [[globalVarsSearch statusLabel] setStringValue:[[NSString alloc] initWithFormat:@"Finding which of the %li matches also match %@", noOfRefs, secondaryString]];
    matchCount = 0;
    for (idx = 0; idx < noOfRefs; idx++)
    {
        // This will refer to each of the found primary matches, one at a time
        isMatch = false;
        isMatch2 = false;
        [impactedVerse removeAllObjects];
        [impactedVerse2 removeAllObjects];
        [finalCollection removeAllObjects];
        currentRef = [listOfRefs objectForKey:[NSNumber numberWithInteger:idx]];
        if ( [currentRef testamentCode] == 0) currentBook = [[globalVarsSearch ntListOfBooks] objectForKey:[[NSString alloc] initWithFormat:@"%li", [currentRef bookIdx]]];
        else currentBook = [[globalVarsSearch lxxListOfBooks] objectForKey:[[NSString alloc] initWithFormat:@"%li", [currentRef bookIdx]]];
        currentChapter = [currentBook getChapterBySeqNo:[currentRef chapIdx]];
        currentVerse = [currentChapter getVerseBySeqNo:[currentRef verseIdx]];
        occurrences = [currentRef noOfMatches];  // What if the primary word occurs more than once?
        // Within the verse, find the primary word
        noOfWords = [currentVerse wordCount];
        for (jdx = 0; jdx < noOfWords; jdx++)
        {
            otherVerse = currentVerse;
            currentWord = [currentVerse getwordBySeqNo:jdx];
            if (rbOption == 1) candidateWord = [currentWord rootWord];
            else candidateWord = [currentWord accentlessTextWord];
            if (occurrences > 0)
            {
                if ( [primaryString compare:candidateWord] == NSOrderedSame)
                {
                    // We've found a match.  So, start scanning back
                    countDown = contextCount - 1;
                    wordIdx = jdx - 1;
                    verseIdx = 10;
                    occurrences--;  // Make sure we register each find
                    altVerseSeqNo = [impactedVerse objectForKey:[NSNumber numberWithInteger:verseIdx]];
                    if (altVerseSeqNo == nil) [impactedVerse setObject:otherVerse forKey:[NSNumber numberWithInteger:verseIdx]];
                    while (countDown >= 0)
                    {
                        if (wordIdx < 0)
                        {
                            otherVerse = [otherVerse previousVerse];
                            if (otherVerse == nil) break;
                            if ([otherVerse bookId] != [currentVerse bookId] ) break;
                            wordIdx = [otherVerse wordCount] - 1;
                            altVerseSeqNo = [impactedVerse objectForKey:[NSNumber numberWithInteger:--verseIdx]];
                            if (altVerseSeqNo == nil) [impactedVerse setObject:otherVerse forKey:[NSNumber numberWithInteger:verseIdx]];
                        }
                        otherWord = [otherVerse getwordBySeqNo:wordIdx];
                        if (rbOption == 1) candidateSecondary = [otherWord rootWord];
                        else candidateSecondary = [otherWord  accentlessTextWord];
                        if ( [secondaryString compare:candidateSecondary] == NSOrderedSame )
                        {
                            isMatch = true;
                            break;
                        }
                        wordIdx--;
                        countDown--;
                    }
                    if (!isMatch) [impactedVerse removeAllObjects];
                    // So, we've scanned backwards, now scan forward
                    otherVerse = currentVerse;
                    countDown = contextCount - 1;
                    wordIdx = jdx + 1;
                    verseIdx = 10;
                    altVerseSeqNo = [impactedVerse2 objectForKey:[NSNumber numberWithInteger:verseIdx]];
                    if (altVerseSeqNo == nil) [impactedVerse2 setObject:otherVerse forKey:[NSNumber numberWithInteger:verseIdx]];
                    while (countDown >= 0)
                    {
                        if (wordIdx >= [otherVerse wordCount])
                        {
                            otherVerse = [otherVerse nextVerse];
                            if (otherVerse == nil) break;
                            if ( [otherVerse bookId] != [currentVerse bookId] ) break;
                            wordIdx = 0;
                            altVerseSeqNo = [impactedVerse2 objectForKey:[NSNumber numberWithInteger:++verseIdx]];
                            if (altVerseSeqNo == nil) [impactedVerse2 setObject:otherVerse forKey:[NSNumber numberWithInteger:verseIdx]];
                        }
                        otherWord = [otherVerse getwordBySeqNo:wordIdx];
                        if (rbOption == 1) candidateSecondary = [otherWord  rootWord];
                        else candidateSecondary = [otherWord accentlessTextWord];
                        if ( [secondaryString compare:candidateSecondary] == NSOrderedSame)
                        {
                            isMatch2 = true;
                            break;
                        }
                        wordIdx++;
                        countDown--;
                    }
                    if (!isMatch2) [impactedVerse2 removeAllObjects];
                    if( isMatch || isMatch2)
                    {
                        /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
                         *                                                       *
                         *  This extra level of complexity is required to handle *
                         *  multiple occurrences of the primary (and, possibly,  *
                         *  secondary) word in a single verse.  See 2 Cor 1:4 as *
                         *  a good example and work through the logic.           *
                         *                                                       *
                         *!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
                        
                        for( NSNumber *interimKey in impactedVerse)
                        {
                            altVerseSeqNo = [finalCollection objectForKey:interimKey];
                            if( altVerseSeqNo == nil) [finalCollection setObject:[impactedVerse objectForKey:interimKey] forKey:interimKey];
                        }
                        for( NSNumber *interimKey in impactedVerse2)
                        {
                            altVerseSeqNo = [finalCollection objectForKey:interimKey];
                            if( altVerseSeqNo == nil) [finalCollection setObject:[impactedVerse2 objectForKey:interimKey] forKey:interimKey];
                        }
                        isMatch = false;
                        isMatch2 = false;
                        isFinal = true;
                    }
                }
            }
        }
        if (isFinal)
        {
            [[globalVarsSearch statusLabel2] setStringValue:[[NSString alloc] initWithFormat:@"Secondary match count: %li", ++matchCount]];
            [globalVarsSearch topRightTabView].needsDisplay = true;
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
            isFirstInRef = true;
            if( idx > 0 )
            {
                [textSequence addObject:@"\r\r"];
                [textSequence addObject:@"0"];
            }
            for (jdx = 0; jdx <= 20; jdx++)
            {
                otherVerse = [finalCollection objectForKey:[NSNumber numberWithInteger:jdx]];
                if (otherVerse != nil)
                {
                    if( isFirstInRef )
                    {
                        isFirstInRef = false;
                    }
                    else
                    {
                        [textSequence addObject:@"\n"];
                        [textSequence addObject:@"0"];
                    }
                    decompRef = [[otherVerse bibleReference] componentsSeparatedByString:@" "];
                    referenceString = [[NSString alloc] initWithFormat:@"%@ %@", [currentBook bookName], [decompRef objectAtIndex:1]];
                    [textSequence addObject:referenceString];
                    [textSequence addObject:@"0"];
                    wordCount = [otherVerse WordCount];
                    for( wdx = 0; wdx < wordCount; wdx++)
                    {
                        currentWord = [otherVerse getwordBySeqNo:wdx];
                        textWord = [currentWord textWord];
                        candidateWord = [currentWord accentlessTextWord];
                        [textSequence addObject:[[NSString alloc] initWithFormat:@" %@", textWord]];
                        if( rbOption == 1)
                        {
                            bareWord = [[NSString alloc] initWithString:[gkProcessingSearch reduceToBareGreek:[currentWord rootWord] isRemovedAlready:true]];
                            if( [bareWord compare:copyOfPrimary] == 0) [textSequence addObject:@"1"];
                            else
                            {
                                if( [bareWord compare:copyOfSecondary] == 0) [textSequence addObject:@"2"];
                                else [textSequence addObject:@"0"];
                            }
                        }
                        else
                        {
                            if( [candidateWord compare:copyOfPrimary] == 0) [textSequence addObject:@"1"];
                            else
                            {
                                if( [candidateWord compare:copyOfSecondary] == 0) [textSequence addObject:@"2"];
                                else [textSequence addObject:@"0"];
                            }
                        }
                    }
                }
            }
            proximityCount++;
            isFinal = false;
        }
    }
    noOfMatches = 0;
    return textSequence;
}

@end
