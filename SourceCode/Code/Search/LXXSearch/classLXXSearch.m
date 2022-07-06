/*==================================================================================================================*
 *                                                                                                                  *
 *                                               classLXXSearch                                                     *
 *                                               ==============                                                     *
 *                                                                                                                  *
 *  All methods relating to performing and managing the search function.                                            *
 *                                                                                                                  *
 *  Since the processing is quite convoluted, this summary constitutes a road-map of methods.                       *
 *                                                                                                                  *
 *  Before calling the search function, searchSetup is invoked, whether the search is on a single word or two words *
 *                                      -----------                                                                 *
 *    within a specified word-distance.  This will initialise key values in the classGlobal instance used for       *
 *    globally available reference data.                                                                            *
 *                                                                                                                  *
 *  Any search starts by calling controlSearch, once all details are entered in the search panel                    *
 *                               -------------                                                                      *
 *                                                                                                                  *
 *  controlSearch will                                                                                              *
 *    a) ensure that a suitable primary and, if necessary, secondary word has been entered                          *
 *    b) populate the code, searchType, as 1 for a simple search and 2 for a complex search                         *
 *    c) populate the code, matchType, as 1 for matching root values and 2 for exact matches.                       *
 *    It does this by calling the procedure, initialLXXMatchProcessing, which is summarised *before* lxxBaseSearch. *
 *                                                                                                                  *
 *    Both searchType and matchType are used throughout the following process.  It will then call the method,       *
 *    lxxBaseSearch, passing the matchType as well as key information.                                              *
 *                                                                                                                  *
 *  initialLXXMatchProcessing                                                                                       *
 *  -------------------------                                                                                       *
 *                                                                                                                  *
 *  This will start by:                                                                                             *
 *    (a) removing any non-Greek characters and any accents from the comparison words;                              *
 *    (b) checking the word(s), using lxxVerifyWord, which returns the following information in a                   *
 *        classLXXSearchVerify instance:                                                                            *
 *        - isWordGiven - a boolean which is true of the word is verified correctly                                 *
 *        - rootWord - the relevant comparison word (which, for exact matches, is *not* the root but a cleaned word *
 *    (c) finally, using results from the verify process, it populates and returns an instance of                   *
 *        classLXXMatchResults, which contains the validated primary and, if suitable, secondary word.              *
 *                                                                                                                  *
 *  lxxBaseSearch                                                                                                   *
 *  -------------                                                                                                   *
 *                                                                                                                  *
 *  This procedure will ensure that the primary and secondary words are structured properly for comparisons.        *
 *    If the match is based on root values of words, the procedure will identify the root of the given primary and, *
 *    as suitable, secondary word.  These may well include accents but will be the same for all forms of the word.  *
 *    If the match is exact, it will return the word with accents removed.                                          *
 *                                                                                                                  *
 *  The validated versions of the search words will be placed in the variables primaryString and secondaryString.   *
 *                                                                                                                  *
 *  Once this is done, processing for simple and complex search now bifurcate: it will call                         *
 *                                                                                                                  *
 *         simple (single word) search                |             complex (two-word) search                       *
 *         ---------------------------                |             -------------------------                       *
 *                                                    |                                                             *
 *  primaryLXXScan                                    |  secondaryLXXScan                                           *
 *  --------------                                    |  ----------------                                           *
 *                                                    |                                                             *
 *  This scans *every* book -> chapter -> verse ->    |  Executes primaryLXXScan first to get a list of all matches *
 *    word for a match to the cleaned primary.        |  of the primary word, whether it is in the vacinity of the  *
 *                                                    |  secondary word or not.  Then, for each result in the list, *
 *  To do this it looks for matches on this word-by-  |  we load an array of the two verses preceding the match,    *
 *    word basis. If a match is found:                |  the matching verse and the two verses following the match. *
 *    a) if it is the firat match for that verse, a   |  Using this array, we scan backwards from the primary match *
 *       new instance of classLXXPrimaryResult is     |  and then forwards.                                         *
 *       created and full reference details           |                                                             *
 *       (including its sequence in the verse) are    |  If this final backward and forward scan finds a match, it  *
 *       entered;                                     |  stored in allLXXMatches, ready for the display process.    *
 *    b) if it is a second, third, etc., the sequence |                                                             *
 *       position of the word is added.               |                                                             *
 *                                                                                                                  *
 *  Once this sequence is complete, lxxBaseSearch finally calls displayLXXResults.  See the header of that method   *
 *    for further details.  Of specific significance is: that the results used for the primary display are found in *
 *                                                                                                                  *
 *               primary display                      |                   secondary display                         *
 *               ---------------                      |                   -----------------                         *
 *                                                    |                                                             *
 *  The results used for the primary display are      |  The results used for the secondary display are found in    *
 *    found in the Dictionary,                        |    the Dictionary, allLXXMatches, which is a sequentially   *
 *    listOfLXXPrimaryResults, which is a             |    eyed list of instances of the class,                     *
 *    sequentially keyed list of instances of the     |    classLXXSearchMatches.                                   *
 *    class, classLXXPrimaryResult.                   |                                                             *
 *                                                                                                                  *
 *  So, there is no congruence between the two processes.                                                           *
 *                                                                                                                  *
 *  Created: Len Clark                                                                                              *
 *  May-June 2022                                                                                                   *
 *                                                                                                                  *
 *==================================================================================================================*/

#import "classLXXSearch.h"

@implementation classLXXSearch

@synthesize lxxSearchLoop;
@synthesize labLXXSearchProgressLbl;

@synthesize primaryLXXWord;
@synthesize secondaryLXXWord;
@synthesize lxxWithin;
@synthesize lxxSteps;
@synthesize lxxStepper;
@synthesize lxxWordsOf;

@synthesize isSearchSuccessful;
@synthesize isWordGiven;
@synthesize isSWordGiven;
@synthesize noOfMatchingLXXVerses;
@synthesize currentVersion;
@synthesize currentSearchType;
@synthesize matchType;
@synthesize noOfRTXLines;
@synthesize noOfAllMatches;
@synthesize listOfLXXPrimaryResults;
@synthesize allLXXMatches;
@synthesize booksToInclude;
@synthesize storeReference;
@synthesize storeText;

classGlobal *globalVarsLXXSearch;
classGkLexicon *searchGreekLexicon;
classLXXText *searchLXXText;
classGreekOrthography *searchGreekOrthography;

/*=======================================================================================*
 *                                                                                       *
 *  The following variables support the use of performing the display as a background    *
 *    process, using NSThread.  (Note: I tried NSOperations but this seems to be         *
 *    designed for multiple processes and how to continue using the main task wasn't     *
 *    obvious, although, I'm sure, with a bit more effort on my part, it would be a      *
 *    better solution.)                                                                  *
 *                                                                                       *
 *  The driver for using a background task is that search tasks can take a long time -   *
 *    especially complex searches.  Using a background task is not only better coding    *
 *    but also allows the creation of a "stop" button to interrupt the search.           *
 *                                                                                       *
 *=======================================================================================*/

NSInteger  lxxDisplayAlignment, lxxLatestResultCount, lxxRunningResultCount;
NSString *lxxProgressMessage;
NSThread *lxxBackgroundThread;
NSTimer *lxxDisplayTimer;
NSMutableDictionary *lxxSearchResults;
NSTextView *lxxResultsTextView;

- (id) init: (classGlobal *) inGlobal forGreekLexicon: (classGkLexicon *) inGkLex withOrthography: (classGreekOrthography *) inOrth forGkText: (classLXXText *) inLXXText andLoop: (NSRunLoop *) inLoop //withNotes: (classNote *) inNote
{
    if( self = [super init])
    {
        globalVarsLXXSearch = inGlobal;
        searchLXXText = inLXXText;
        searchGreekLexicon = inGkLex;
        searchGreekOrthography = inOrth;
        lxxSearchLoop = inLoop;
        
        isSearchSuccessful = false;
        matchType = 0;
        noOfAllMatches = 0;
        listOfLXXPrimaryResults = [[NSMutableDictionary alloc] init];
//        allLXXMatches = [[NSMutableDictionary alloc] init];
        booksToInclude = [[NSMutableArray alloc] init];
        labLXXSearchProgressLbl = [globalVarsLXXSearch labSearchProgress];
    }
    return self;
}

- (void) searchSetup: (NSInteger) tagVal
{
    /*==================================================================================================================*
     *                                                                                                                  *
     *                                                searchSetup                                                       *
     *                                                ===========                                                       *
     *                                                                                                                  *
     *  Additional setup actions, depending on whether Primary or Secondary word.                                       *
     *                                                                                                                  *
     *  tagVal   1 = primary, 2 = secondary                                                                             *
     *                                                                                                                  *
     *==================================================================================================================*/
    NSInteger comboboxIndex;
    NSString *searchWord;
    NSTextField *targetTextField;
    NSTabView *targetTab;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    
    cbBook = [globalVarsLXXSearch cbLXXBook];
    cbChapter = [globalVarsLXXSearch cbLXXChapter];
    cbVerse = [globalVarsLXXSearch cbLXXVerse];
    switch (tagVal)
    {
        case 0:
            // Add the last selected word to the primary text box
            searchWord = [[NSString alloc] initWithString:[searchGreekOrthography reduceToBareGreek:[globalVarsLXXSearch latestSelectedLXXWord] withNonGkRemoved:false]];
            targetTextField = [globalVarsLXXSearch txtLXXPrimaryWord];
            [targetTextField setStringValue:searchWord];
            comboboxIndex = [cbBook indexOfSelectedItem];
            [globalVarsLXXSearch setPrimaryLXXBookId:comboboxIndex];
            comboboxIndex = [cbChapter indexOfSelectedItem];
            [globalVarsLXXSearch setPrimaryLXXChapNo:[[NSString alloc] initWithString:[cbChapter itemObjectValueAtIndex:comboboxIndex]]];
            comboboxIndex = [cbVerse indexOfSelectedItem];
            [globalVarsLXXSearch setPrimaryLXXVNo:[[NSString alloc] initWithString:[cbVerse itemObjectValueAtIndex:comboboxIndex]]];
            [globalVarsLXXSearch setPrimaryLXXWordSeq:[globalVarsLXXSearch sequenceOfLatestLXXWord]];
            [globalVarsLXXSearch setPrimaryLXXWord:[globalVarsLXXSearch latestSelectedLXXWord]];
            break;
        case 1:
            searchWord = [[NSString alloc] initWithString:[searchGreekOrthography reduceToBareGreek:[globalVarsLXXSearch latestSelectedLXXWord] withNonGkRemoved:false]];
            targetTextField = [globalVarsLXXSearch txtLXXSecondaryWord];
            [targetTextField setStringValue:searchWord];
            comboboxIndex = [cbBook indexOfSelectedItem];
            [globalVarsLXXSearch setSecondaryLXXBookId:comboboxIndex];
            comboboxIndex = [cbChapter indexOfSelectedItem];
            [globalVarsLXXSearch setSecondaryLXXChapNo:[[NSString alloc] initWithString:[cbChapter itemObjectValueAtIndex:comboboxIndex]]];
            comboboxIndex = [cbVerse indexOfSelectedItem];
            [globalVarsLXXSearch setSecondaryLXXVNo:[[NSString alloc] initWithString:[cbVerse itemObjectValueAtIndex:comboboxIndex]]];
            [globalVarsLXXSearch setSecondaryLXXWordSeq:[globalVarsLXXSearch sequenceOfLatestLXXWord]];
            [globalVarsLXXSearch setSecondaryLXXWord:[globalVarsLXXSearch latestSelectedLXXWord]];
            [self hideOrShowAdvancedSearch:false];
            break;
    }
    targetTab = [globalVarsLXXSearch tabUtilities];
    [targetTab selectTabViewItemAtIndex:1];
    targetTab = [globalVarsLXXSearch tabLXXUtilityDetail];
    [targetTab selectTabViewItemAtIndex:2];
}

- (void) hideOrShowAdvancedSearch: (bool) isToShow
{
    NSTextField *label, *textBox, *steps;
    NSButton *searchButton;
    NSStepper *stepper;
    
    label = [globalVarsLXXSearch labLXXWordsOfLbl];
    [label setHidden:isToShow];
    [[globalVarsLXXSearch stepperLXXScan] setHidden:isToShow];
    label = [globalVarsLXXSearch labLXXWithinLbl];
    [label setHidden:isToShow];
    textBox = [globalVarsLXXSearch txtLXXSecondaryWord];
    [textBox setHidden:isToShow];
    stepper = [globalVarsLXXSearch stepperLXXScan];
    [stepper setHidden:isToShow];
    steps = [globalVarsLXXSearch lxxSteps];
    [steps setHidden:isToShow];
    searchButton = [globalVarsLXXSearch btnLXXAdvanced];
    if( isToShow) [searchButton setTitle:@"Advanced Search"];
    else [searchButton setTitle:@"Basic Search"];
}

- (void) controlSearch
{
    /*======================================================================================================*
     *                                                                                                      *
     *                                           controlSearch                                              *
     *                                           =============                                              *
     *                                                                                                      *
     *  Key variables used in the procedure:                                                                *
     *  -----------------------------------                                                                 *
     *                                                                                                      *
     *  searchType          Indicates whether the search is "simple" (a single word) or "complex" (one word *
     *                      withing n words of a second). The identification is based on whether lblWithin  *
     *                      is visible or not.                                                              *
     *                      Values of searchType are:                                                       *
     *                        simple:   1                                                                   *
     *                        complex:  2                                                                   *
     *  matchType           The type of matching strategy, as determined by the radio button selected.      *
     *                      Values and significances are:                                                   *
     *                        1    matching is based on the root of the word.                               *
     *                        2    matching is "exact" - i.e. identical in form (except for accents)        *
     *                                                                                                      *
     *  Processing:                                                                                         *
     *  ==========                                                                                          *
     *                                                                                                      *
     *  The ultimate purpose of this method (together with its subsidiary methods) is to populate a series  *
     *    of classSearchResults instances, all of which are stored (temporariy) in the global list,         *
     *    currentSearchResults.  These can then be interrogated by the separate method that actually        *
     *    displays them.                                                                                    *
     *                                                                                                      *
     *======================================================================================================*/

    /*------------------------------------------------------------------------------------------------------*
     *                                                                                                      *
     *  Constants:                                                                                          *
     *  ---------                                                                                           *
     *                                                                                                      *
     *  zeroWidthSpace      Used to mark the start of a word (making identification of words easier)        *
     *  zeroWidthNonJoiner  Separates the base word from prefixed "words" (normally extraneous symbols)     *
     *  noBreakSpace        Used in references to avoid breaking across references and other odd changes    *
     *  ideographicSpace    Used in book names that contain spaces (so we can keep book names intact)       *
     *                                                                                                      *
     *------------------------------------------------------------------------------------------------------*/

    BOOL stateCheck;
    NSInteger idx, noOfBooks = 0;
    NSString *searchWord, *secondarySearchWord;
    NSButton *btnInclude;
    NSTextField *label, *textBox;
    NSButton *radioButton;
    NSArray *listboxData;
    classLXXBook *currentLXXBook;
    classAlert *alert;

    matchType = 0;
    isWordGiven = false;
    isSWordGiven = false;

    /*----------------------------------------------------------------------------------------------*
     * Provide initial progress information in the tool strip below the search results area.        *
     *----------------------------------------------------------------------------------------------*/
    [labLXXSearchProgressLbl setStringValue:@"Performing your search"];
    [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];

    [booksToInclude removeAllObjects];
    booksToInclude = [[NSMutableArray alloc] init];

    /*----------------------------------------------------------------------------------------------*
     * Check whether the search is "simple" or "complex"                                            *
     *   Set searchType accordingly, then invoke lexicon.performSearch as suitable                  *
     *----------------------------------------------------------------------------------------------*/
    textBox = [globalVarsLXXSearch txtLXXPrimaryWord];
    if( [[textBox stringValue] length] == 0)
    {
        alert = [[classAlert alloc] init];
        [alert messageBox:@"You have selected a Search with no Primary word" title:@"Search Error" boxStyle:NSAlertStyleWarning];
        return;
    }
    label = [globalVarsLXXSearch labLXXWordsOfLbl];
    if ([label isHidden]) currentSearchType = 1;
    else
    {
        textBox = [globalVarsLXXSearch txtLXXSecondaryWord];
        if( [[textBox stringValue] length] == 0)
        {
            alert = [[classAlert alloc] init];
            [alert messageBox:@"You have selected an Advanced with no Secondary word" title:@"Search Error" boxStyle:NSAlertStyleWarning];
            return;
        }
        currentSearchType = 2;
    }

    /*----------------------------------------------------------------------------------------------*
     * Record the search type: based on root or exact match criteria.                               *
     *----------------------------------------------------------------------------------------------*/
    radioButton = [globalVarsLXXSearch rbtnLXXRootMatch];
    if( [radioButton state] == NSControlStateValueOn) matchType = 1;
    else
    {
        radioButton = [globalVarsLXXSearch rbtnLXXExactMatch];
        if( [radioButton state] == NSControlStateValueOn) matchType = 2;
    }
    btnInclude = [globalVarsLXXSearch rbtnLXXExclude];
    noOfBooks = [globalVarsLXXSearch noOfLXXBooks];
    for (idx = 0; idx < noOfBooks; idx++)
    {
        // Is the current book in the list to be searched?
        currentLXXBook = nil;
        currentLXXBook = [[globalVarsLXXSearch lxxBookList] objectForKey:[globalVarsLXXSearch convertIntegerToString: idx]];
        listboxData = [[NSArray alloc] initWithArray:(NSArray *)[globalVarsLXXSearch lxxAvailableBooksMaster]];
        if ([btnInclude state] == NSControlStateValueOn)
        {
            if ( [listboxData containsObject:[currentLXXBook commonName]]) [booksToInclude addObject:[currentLXXBook commonName]];
        }
        else
        {
            if ( ! [listboxData containsObject:[currentLXXBook commonName]]) [booksToInclude addObject:[currentLXXBook commonName]];
        }
    }
    switch (currentSearchType)
    {
        case 1:
            searchWord = [[NSString alloc] initWithString:[[globalVarsLXXSearch txtLXXPrimaryWord] stringValue]];
            btnInclude = [globalVarsLXXSearch rbtnLXXExclude];
            stateCheck = [btnInclude state] == NSControlStateValueOn;
            [self lxxBaseSearch:1
                     matchType:matchType
                   primaryBook:[globalVarsLXXSearch primaryLXXBookId]
                primarychapter:[globalVarsLXXSearch primaryLXXChapNo]
                  primaryVerse:[globalVarsLXXSearch primaryLXXVNo]
           primaryWordSequence:[globalVarsLXXSearch primaryLXXWordSeq]
                   primaryWord:searchWord
                 secondaryBook:-1
              secondaryChapter:@""
                secondaryVerse:@""
         secondaryWordSequence:-1
                 secondaryWord:@""
                    searchSpan:0
               whetherToInclude:stateCheck];
            break;
        case 2:
            searchWord = [[NSString alloc] initWithString:[[globalVarsLXXSearch txtLXXPrimaryWord] stringValue]];
            secondarySearchWord = [[NSString alloc] initWithString:[[globalVarsLXXSearch txtLXXSecondaryWord] stringValue]];
            btnInclude = [globalVarsLXXSearch rbtnLXXExclude];
            stateCheck = [btnInclude state] == NSControlStateValueOn;
            [self lxxBaseSearch:2
                     matchType:matchType
                   primaryBook:[globalVarsLXXSearch primaryLXXBookId]
                primarychapter:[globalVarsLXXSearch primaryLXXChapNo]
                  primaryVerse:[globalVarsLXXSearch primaryLXXVNo]
           primaryWordSequence:[globalVarsLXXSearch primaryLXXWordSeq]
                   primaryWord:searchWord
                 secondaryBook:[globalVarsLXXSearch secondaryLXXBookId]
              secondaryChapter:[globalVarsLXXSearch secondaryLXXChapNo]
                secondaryVerse:[globalVarsLXXSearch secondaryLXXVNo]
         secondaryWordSequence:[globalVarsLXXSearch secondaryLXXWordSeq]
                 secondaryWord:secondarySearchWord
                    searchSpan:[[[globalVarsLXXSearch lxxSteps] stringValue] integerValue]
               whetherToInclude:stateCheck];
            break;
    }
}

/*======================================================================================================*
 *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*
 *                                                                                                      *
 *                                      LXX Search Methods                                              *
 *                                      ==================                                              *
 *                                                                                                      *
 *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*
 *======================================================================================================*/

- (void) lxxBaseSearch: (NSInteger) searchType
            matchType: (NSInteger) matchType
          primaryBook: (NSInteger) pBook
       primarychapter: (NSString *) pChap
         primaryVerse: (NSString *) pVerse
  primaryWordSequence: (NSInteger) pSeq
          primaryWord: (NSString *) pWord
        secondaryBook: (NSInteger) sBook
     secondaryChapter: (NSString *) sChap
       secondaryVerse: (NSString *) sVerse
secondaryWordSequence: (NSInteger) sSeq
        secondaryWord: (NSString *) sWord
           searchSpan: (NSInteger) searchSpan
      whetherToInclude: (bool) exclude_include
{
    /*===============================================================================================================*
     *                                                                                                               *
     *                                                lxxBaseSearch                                                  *
     *                                                =============                                                  *
     *                                                                                                               *
     *  Purpose:                                                                                                     *
     *  =======                                                                                                      *
     *                                                                                                               *
     *  To handle the search for both a basic search and an advanced (two-word) search.                              *
     *                                                                                                               *
     *  Parameters:                                                                                                  *
     *  ==========                                                                                                   *
     *    searchType   If this = 1, the search is basic; 2, the search is more complex                               *
     *    matchType    Possible values                                                                               *
     *                 and significance are:                                                                         *
     *                  Value                       Significance                                                     *
     *                    1     Matches are based on root entry (from source data)                                   *
     *                    2     Matches are "exact" - exact match of the word form except for accents                *
     *       If the primary word has been populated from the main text (by a right click), then:                     *
     *    pBook        The bookId of the primary search source word                                                  *
     *    pChap        The chapter reference of the primary search source word                                       *
     *    pVerse       The verse reference of the primary search source word                                         *
     *    pSeq         The sequence in the verse of the primary search source word                                   *
     *    pWord        The actual primary word (without accents, with vowels)                                        *
     *       If the secondary word has been populated from the main text (by a right click), then:                   *
     *    sBook        The bookId of the secondary search source word                                                *
     *    sChap        The chapter reference of the secondary search source word                                     *
     *    sVerse       The verse reference of the secondary search source word                                       *
     *    sSeq         The sequence in the verse of the secondary search source word                                 *
     *    sWord        The actual secondary word (without accents, with vowels)                                      *
     *    searchSpan   An int value; the number of words before and after the matched word in which the secondary    *
     *                   word must occur for a full match.                                                           *
     *    exclude_include                                                                                            *
     *                 If = true, we *include* all in the listed book category                                       *
     *                 if = false, we include those *not* in the category                                            *
     *                                                                                                               *
     *  Returned variable:                                                                                           *
     *  =================                                                                                            *
     *    A String variable containing all/any search results                                                        *
     *                                                                                                               *
     *===============================================================================================================*/

    bool isWorthProgressing = false;
    NSString *primaryString, *secondaryString;
    classLXXMatchResults *confirmWords;
    
    confirmWords = [self initialLXXMatchProcessing:pBook
                     primarychapter:pChap
                       primaryVerse:pVerse
                primaryWordSequence:pSeq
                        primaryWord:pWord
                      secondaryBook:sBook
                   secondaryChapter:sChap
                     secondaryVerse:sVerse
              secondaryWordSequence:sSeq
                      secondaryWord:sWord];
    primaryString = [[NSString alloc] initWithString:[confirmWords primaryWord]];
    secondaryString = [[NSString alloc] initWithString:[confirmWords secondaryWord]];
    isWorthProgressing = isWordGiven;
    if ( (currentSearchType == 2) && (!isSWordGiven)) isWorthProgressing = false;
    if (isWorthProgressing)
    {
        // We now have an assured list of words for comparison.  Now hunt for all occurrences
        [labLXXSearchProgressLbl setStringValue:[[NSString alloc] initWithFormat:@"Scanning the OT for uses of %@", pWord]];
        [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
        if (searchType == 1) [self primaryLXXScan:primaryString forMatchType:matchType];
        else [self secondaryLXXScan:primaryString andSecondaryWord:secondaryString withWordSpan:searchSpan];
        isSearchSuccessful = true;
    }
    else isSearchSuccessful = false;
    [labLXXSearchProgressLbl setStringValue:@"Single word search complete"];
    [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    [self displayLXXResults];
}

- (classLXXMatchResults *) initialLXXMatchProcessing: (NSInteger) pBook
                    primarychapter: (NSString *) pChap
                      primaryVerse: (NSString *) pVerse
               primaryWordSequence: (NSInteger) pSeq
                       primaryWord: (NSString *) pWord
                     secondaryBook: (NSInteger) sBook
                  secondaryChapter: (NSString *) sChap
                    secondaryVerse: (NSString *) sVerse
             secondaryWordSequence: (NSInteger) sSeq
                     secondaryWord: (NSString *) sWord
{
    NSString *primaryString, *secondaryString;
    classGkCleanResults *returnedWordData;
    classLXXSearchVerify *verifyResult;
    classLXXMatchResults *matchResults;
    
    [listOfLXXPrimaryResults removeAllObjects];
    listOfLXXPrimaryResults = [[NSMutableDictionary alloc] init];
    noOfMatchingLXXVerses = 0;
    isSearchSuccessful = false;
    [labLXXSearchProgressLbl setStringValue:@"Analysing the given primary word"];
    [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    // 1  Let's find all primary matches first
    // 1a If the primary word is not set, then we need to find an example
    isWordGiven = false;
    primaryString = @"";
    secondaryString = @"";
    if (pBook >= 0)
    {
        // Okay, we have a word.  But does it match?
        [labLXXSearchProgressLbl setStringValue:[[NSString alloc] initWithFormat:@"%@ found; checking validity", pWord]];
        [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
        returnedWordData = [searchGreekOrthography removeNonGkChars:pWord];
        primaryString = [returnedWordData greekWord];
        primaryString = [searchGreekOrthography reduceToBareGreek:primaryString withNonGkRemoved:true];
        verifyResult = [self lxxVerifyWord:pBook chapterRef:pChap verseRef:pVerse wordSequence:pSeq wordToVerify:primaryString matchType:matchType];
        isWordGiven = [verifyResult isWordGiven];
        if( isWordGiven) primaryString = [[NSString alloc] initWithString:[verifyResult rootWord]];
    }
    // Now we have something
    if (isWordGiven)
    {
        // Step 2: if it is a secondary search, we need to repeat the process
        //         Note: we must strictly partition the responses for primary and secondary words
        isSWordGiven = false;
        if (currentSearchType == 2)
        {
            [labLXXSearchProgressLbl setStringValue:@"Analysing the given secondary word"];
            [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
            if (sBook >= 0)
            {
                // Okay, we have a word.  But does it match?
                returnedWordData = [searchGreekOrthography removeNonGkChars:sWord];
                secondaryString = [returnedWordData greekWord];
                secondaryString = [searchGreekOrthography reduceToBareGreek:secondaryString withNonGkRemoved:true];
                [labLXXSearchProgressLbl setStringValue:[[NSString alloc] initWithFormat:@"%@ found; checking validity", sWord]];
                [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
                verifyResult = [self lxxVerifyWord:sBook chapterRef:sChap verseRef:sVerse wordSequence:sSeq wordToVerify:secondaryString matchType:matchType];
                isSWordGiven = [verifyResult isWordGiven];
                if( isWordGiven) secondaryString = [[NSString alloc] initWithString:[verifyResult rootWord]];
            }
        }
    }
    matchResults = [[classLXXMatchResults alloc] init];
    [matchResults setPrimaryWord:primaryString];
    [matchResults setSecondaryWord:secondaryString];
    return matchResults;
}

- (classLXXSearchVerify *) lxxVerifyWord: (NSInteger) bookNo
                              chapterRef: (NSString *) chapRef
                                verseRef: (NSString *) verseRef
                            wordSequence: (NSInteger) wordSeq
                            wordToVerify: (NSString *) wordToVerify
                               matchType: (NSInteger) matchType
{
    /*======================================================================================================*
     *                                                                                                      *
     *                                         lxxVerifyWord                                                *
     *                                         =============                                                *
     *                                                                                                      *
     *  Purpose:                                                                                            *
     *  =======                                                                                             *
     *                                                                                                      *
     *    (a) to find the root form of the wordToVerify                                                     *
     *    (b) if the word has been entered directly, find the root by matching the word as provided with an *
     *          exact match from the source data.  (Of course, this method is not infallible).              *
     *                                                                                                      *
     *======================================================================================================*/
    NSInteger bdx, cdx, vdx, wdx, noOfBooks, noOfChapters, noOfVerses, noOfWords;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter;
    classLXXVerse *currentVerse;
    classLXXWord *currentWord;
    classLXXSearchVerify *currentVerification;

    if (matchType == 2)
    {
        // We are using exact match comparison.  We have to assume that the words provided are correct,
        //   so there's nothing else to do.
        currentVerification = [[classLXXSearchVerify alloc] init];
        [currentVerification setIsWordGiven:true];
        [currentVerification setRootWord:wordToVerify];
        return currentVerification;
    }
    else
    {
        if (bookNo >= 0)
        {
            currentBook = [[globalVarsLXXSearch lxxBookList] objectForKey:[globalVarsLXXSearch convertIntegerToString:bookNo]];
            currentChapter = [currentBook getChapterByChapterNo:chapRef];
            currentVerse = [currentChapter getVerseByVerseNo:verseRef];
            currentWord = [currentVerse getWord:wordSeq];
            currentVerification = [[classLXXSearchVerify alloc] init];
            [currentVerification setIsWordGiven:true];
            [currentVerification setRootWord:[currentWord rootWord]];
            return currentVerification;
        }
        else
        {
            noOfBooks = [globalVarsLXXSearch noOfLXXBooks];
            for (bdx = 0; bdx < noOfBooks; bdx++)
            {
                currentBook = [[globalVarsLXXSearch lxxBookList] objectForKey:[globalVarsLXXSearch convertIntegerToString:bdx]];
                noOfChapters = [currentBook noOfChaptersInBook];
                for (cdx = 0; cdx < noOfChapters; cdx++)
                {
                    currentChapter = [currentBook getChapterBySequence:cdx];
                    noOfVerses = [currentChapter noOfVersesInChapter];
                    for (vdx = 0; vdx < noOfVerses; vdx++)
                    {
                        currentVerse = [currentChapter getVerseBySequence:vdx];
                        noOfWords = [currentVerse wordCount];
                        for (wdx = 0; wdx < noOfWords; wdx++)
                        {
                            currentWord = [currentVerse getWord:wdx];
                            if ([wordToVerify compare: [currentWord accentlessTextWord]] == NSOrderedSame )
                            {
                                currentVerification = [[classLXXSearchVerify alloc] init];
                                [currentVerification setIsWordGiven:true];
                                [currentVerification setRootWord:[currentWord rootWord]];
                                return currentVerification;
                            }
                        }
                    }
                }
            }
        }
    }
    currentVerification = [[classLXXSearchVerify alloc] init];
    [currentVerification setIsWordGiven:false];
    [currentVerification setRootWord:@""];
    return currentVerification;
}

- (void) primaryLXXScan: (NSString *) targetWord forMatchType: (NSInteger) matchType
{
    bool isAMatchFound, isExisting = false;
    NSInteger noOfBooks, bdx, cdx, vdx, wdx, noOfChaps, noOfVerses, noOfWords;
    NSString *currentRoot, *wordCleaned;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter;
    classLXXVerse *currentVerse;
    classLXXWord *currentWord;
    classLXXPrimaryResult *primaryResult, *prevSearchResult;

    noOfBooks = [globalVarsLXXSearch noOfLXXBooks];
    for (bdx = 0; bdx < noOfBooks; bdx++)
    {
        // Is the current book in the list to be searched?
        
        currentBook = nil;
        currentBook = [[globalVarsLXXSearch lxxBookList] objectForKey:[globalVarsLXXSearch convertIntegerToString:bdx]];
        if( currentBook == nil) continue;
        if (! [booksToInclude containsObject:[currentBook commonName]] ) continue;
        [labLXXSearchProgressLbl setStringValue:[[NSString alloc] initWithFormat:@"Simple scan in process; scanning %@", [currentBook commonName]]];
        [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
        noOfChaps = [currentBook noOfChaptersInBook];
        for (cdx = 0; cdx < noOfChaps; cdx++)
        {
            currentChapter = [currentBook getChapterBySequence:cdx];
            noOfVerses = [currentChapter noOfVersesInChapter];
            for (vdx = 0; vdx < noOfVerses; vdx++)
            {
                currentVerse = [currentChapter getVerseBySequence:vdx];
                noOfWords = [currentVerse wordCount];
                for (wdx = 0; wdx < noOfWords; wdx++)
                {
                    isAMatchFound = false;
                    currentWord = [currentVerse getWord:wdx];
                    currentRoot = [currentWord rootWord];
                    wordCleaned = [currentWord accentlessTextWord];
                    if (matchType == 1) isAMatchFound = ([targetWord compare:currentRoot] == NSOrderedSame);
                    else isAMatchFound = ([targetWord compare:wordCleaned] == NSOrderedSame);
                    if (isAMatchFound)
                    {
                        prevSearchResult = nil;
                        isExisting = false;
                        if (noOfMatchingLXXVerses > 0)
                        {
                            prevSearchResult = [listOfLXXPrimaryResults objectForKey:[globalVarsLXXSearch convertIntegerToString: noOfMatchingLXXVerses - 1]];
                            if (prevSearchResult != nil)
                            {
                                if ((bdx == [prevSearchResult bookId]) && (cdx == [prevSearchResult chapSeq]) && (vdx == [prevSearchResult verseSeq]))
                                {
                                    isExisting = true;
                                }
                            }
                        }

                        if (isExisting) primaryResult = prevSearchResult;
                        else
                        {
                            primaryResult = [[classLXXPrimaryResult alloc] init:globalVarsLXXSearch];
                            [primaryResult setBookId:bdx];
                            [primaryResult setChapSeq:cdx];
                            [primaryResult setVerseSeq:vdx];
                            [primaryResult setChapReference:[currentBook getChapterNoBySequence:cdx]];
                            [primaryResult setVerseReference:[currentChapter getVerseNoBySequence:vdx]];
                            [primaryResult setImpactedVerse:currentVerse];
                        }
                        [primaryResult addWordPosition:wdx];
                        if ( [primaryResult noOfMatchingWords] == 1) [listOfLXXPrimaryResults setObject:primaryResult forKey:[globalVarsLXXSearch convertIntegerToString:noOfMatchingLXXVerses++]];
                    }
                }
            }
        }
    }
}

- (void) secondaryLXXScan: (NSString *) pWord andSecondaryWord: (NSString *) sWord withWordSpan: (NSInteger) searchSpan
{
    BOOL isAMatchFound;
    NSInteger idx, noOfMatches, jdx, noOfMatchingWords, countAway, arrayIndex, seqCount, pWordSeq, noOfCurrentMatches = 0, tdx;
    NSString *referenceString;
    NSMutableArray *versePentad;
    NSMutableDictionary *currentMatches;
    classLXXBook *currentBook;
    classLXXVerse *currentSVerse, *inspectedVerse, *nearVerse, *dummyVerse;
    classLXXPrimaryResult *currentSearchResult;
    classLXXSearchMatches *currentSearchMatch;

    [self primaryLXXScan:pWord forMatchType:matchType];
    versePentad = [[NSMutableArray alloc] initWithCapacity:5];
    dummyVerse = [[classLXXVerse alloc] init:globalVarsLXXSearch];
    [dummyVerse setVerseSeq:-1];
    currentMatches = [[NSMutableDictionary alloc] init];
    noOfMatches = noOfMatchingLXXVerses;
    for (idx = 0; idx < noOfMatches; idx++)
    {
        currentSearchResult = nil;
        currentSearchResult = [listOfLXXPrimaryResults objectForKey:[globalVarsLXXSearch convertIntegerToString: idx]];
        // This gives us a match on the primary word, whether it is near a secondary or not.
        // Populate versePentad with two verses before and two verses after the match verse
        currentBook = [[globalVarsLXXSearch lxxBookList] objectForKey:[globalVarsLXXSearch convertIntegerToString:[currentSearchResult bookId]]];
        referenceString = [[NSString alloc] initWithFormat:@"%@ %@:%@", [currentBook commonName], [currentSearchResult chapReference], [currentSearchResult verseReference]];
        [labLXXSearchProgressLbl setStringValue:[[NSString alloc] initWithFormat:@"Now looking for secondary matches; scanning %@", referenceString]];
        [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
        [versePentad removeAllObjects];
        versePentad = [[NSMutableArray alloc] init];
        for( tdx = 0; tdx < 5; tdx++ ) [versePentad addObject:dummyVerse];
        currentSVerse = [currentSearchResult impactedVerse];
        [versePentad replaceObjectAtIndex:2 withObject:currentSVerse];
        nearVerse = [currentSVerse previousVerse];
        if( nearVerse != nil)
        {
            [versePentad replaceObjectAtIndex:1 withObject:nearVerse];
            nearVerse = [nearVerse previousVerse];
            if( nearVerse != nil) [versePentad replaceObjectAtIndex:0 withObject:nearVerse];
        }
        nearVerse = [currentSVerse nextVerse];
        if( nearVerse != nil)
        {
            [versePentad replaceObjectAtIndex:3 withObject:nearVerse];
            nearVerse = [nearVerse nextVerse];
            if( nearVerse != nil) [versePentad replaceObjectAtIndex:4 withObject:nearVerse];
        }
        // Firstly, scan backwards from the match
        noOfMatchingWords = [currentSearchResult noOfMatchingWords];
        for (jdx = 0; jdx < noOfMatchingWords; jdx++)
        {
            pWordSeq = [[[currentSearchResult matchingWordPositions] objectForKey:[globalVarsLXXSearch convertIntegerToString:jdx]] integerValue];
            inspectedVerse = currentSVerse;
            seqCount = pWordSeq;
            arrayIndex = 2;
            for( countAway = 1; countAway <= searchSpan; countAway++)
            {
                seqCount--;
                if( seqCount < 0)
                {
                    arrayIndex--;
                    if( arrayIndex < 0) break;
                    inspectedVerse = [versePentad objectAtIndex:arrayIndex];
                    seqCount = [inspectedVerse wordCount] - 1;
                }
                isAMatchFound = [self isThereAnLXXMatch:[inspectedVerse getWord:seqCount] matchType:matchType andTargetWord:sWord];
                if (isAMatchFound)
                {
                    currentSearchMatch = [[classLXXSearchMatches alloc] init];
                    [currentSearchMatch setPrimaryScanWord:[currentSVerse getWord:pWordSeq]];
                    [currentSearchMatch setBookId:[currentSearchResult bookId]];
                    [currentSearchMatch setPrimaryChapterRef:[currentSearchResult chapReference]];
                    [currentSearchMatch setPrimaryVerseRef:[currentSearchResult verseReference]];
                    [currentSearchMatch setPrimaryChapterSeq:[currentSearchResult chapSeq]];
                    [currentSearchMatch setPrimaryVerseSeq:[currentSearchResult verseSeq]];
                    [currentSearchMatch setPrimaryWordSeq:pWordSeq];
                    [currentSearchMatch setSecondaryScanWord:[inspectedVerse getWord:seqCount]];
                    [currentSearchMatch setSecondaryChapterRef:[inspectedVerse chapRef]];
                    [currentSearchMatch setSecondaryVerseRef:[inspectedVerse verseRef]];
                    [currentSearchMatch setSecondaryChapterSeq:[inspectedVerse chapSeq]];
                    [currentSearchMatch setSecondaryVerseSeq:[inspectedVerse verseSeq]];
                    [currentSearchMatch setSecondaryWordSeq:seqCount];
                    [currentMatches setObject:currentSearchMatch forKey:[globalVarsLXXSearch convertIntegerToString:noOfCurrentMatches++]];
                    break;
                }
            }
            // Now count up
            inspectedVerse = currentSVerse;
            seqCount = pWordSeq;
            arrayIndex = 2;
            for( countAway = 1; countAway <= searchSpan; countAway++)
            {
                seqCount++;
                if( seqCount > [inspectedVerse wordCount] - 1)
                {
                    arrayIndex++;
                    if( arrayIndex > 4) break;
                    inspectedVerse = [versePentad objectAtIndex:arrayIndex];
                    seqCount = 0;
                }
                isAMatchFound = [self isThereAnLXXMatch:[inspectedVerse getWord:seqCount] matchType:matchType andTargetWord:sWord];
                if (isAMatchFound)
                {
                    currentSearchMatch = [[classLXXSearchMatches alloc] init];
                    [currentSearchMatch setPrimaryScanWord:[currentSVerse getWord:pWordSeq]];
                    [currentSearchMatch setBookId:[currentSearchResult bookId]];
                    [currentSearchMatch setPrimaryChapterRef:[currentSearchResult chapReference]];
                    [currentSearchMatch setPrimaryVerseRef:[currentSearchResult verseReference]];
                    [currentSearchMatch setPrimaryChapterSeq:[currentSearchResult chapSeq]];
                    [currentSearchMatch setPrimaryVerseSeq:[currentSearchResult verseSeq]];
                    [currentSearchMatch setPrimaryWordSeq:pWordSeq];
                    [currentSearchMatch setSecondaryScanWord:[inspectedVerse getWord:seqCount]];
                    [currentSearchMatch setSecondaryChapterRef:[inspectedVerse chapRef]];
                    [currentSearchMatch setSecondaryVerseRef:[inspectedVerse verseRef]];
                    [currentSearchMatch setSecondaryChapterSeq:[inspectedVerse chapSeq]];
                    [currentSearchMatch setSecondaryVerseSeq:[inspectedVerse verseSeq]];
                    [currentSearchMatch setSecondaryWordSeq:seqCount];
                    [currentMatches setObject:currentSearchMatch forKey:[globalVarsLXXSearch convertIntegerToString:noOfCurrentMatches++]];
                    break;
                }
            }
        }
    }
    allLXXMatches = [[NSDictionary alloc] initWithDictionary:currentMatches];
    noOfAllMatches = [allLXXMatches count];
}

- (bool) isThereAnLXXMatch: (classLXXWord *) currentWord matchType: (NSInteger) matchType andTargetWord: (NSString *) targetWord
{
    bool isFound = false;
    NSString *candidateWord;

    switch (matchType)
    {
        case 1:
            candidateWord = [currentWord rootWord];
            if ( [targetWord compare:candidateWord] == NSOrderedSame) isFound = true;
            break;
        case 2:
            candidateWord = [currentWord accentlessTextWord];
            if ( [candidateWord compare:targetWord] == NSOrderedSame) isFound = true;
            break;
    }
    return isFound;
}

- (void) displayLXXResults
{

    [labLXXSearchProgressLbl setStringValue:@"Starting display of results"];
    [lxxSearchLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    lxxResultsTextView = [globalVarsLXXSearch txtSearchResults];
    if (isSearchSuccessful)
    {
        [[lxxResultsTextView textStorage] deleteCharactersInRange:NSMakeRange(0, [[lxxResultsTextView textStorage] length])];
        lxxDisplayAlignment = 0;
        if (currentSearchType == 1) [self displayLXXPrimary];
        else [self displayLXXSecondary];
    }
}

- (void) displayLXXPrimary
{
    lxxBackgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(collatePrimaryDisplayResults) object:nil];
    if( lxxSearchResults == nil) lxxSearchResults = [[NSMutableDictionary alloc] init];
    [lxxSearchResults removeAllObjects];
    lxxResultsTextView = [globalVarsLXXSearch txtSearchResults];
    lxxLatestResultCount = -1;
    lxxRunningResultCount = -1;
    [lxxBackgroundThread start];
    lxxDisplayTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(performPrimaryDisplay:) userInfo:nil repeats:YES];
}

- (void) performPrimaryDisplay: (id) sender
{
    NSTextStorage *textStorage;

    textStorage = [lxxResultsTextView textStorage];
    lxxProgressMessage = @"Displaying results";
    if( lxxLatestResultCount > lxxRunningResultCount)
    {
        for( ++lxxRunningResultCount; lxxRunningResultCount <= lxxLatestResultCount; lxxRunningResultCount++)
        {
            [labLXXSearchProgressLbl setStringValue:lxxProgressMessage];
            [textStorage appendAttributedString:[lxxSearchResults objectForKey:[globalVarsLXXSearch convertIntegerToString:lxxRunningResultCount]]];
        }
    }
    if( [lxxProgressMessage compare:@"Search Results complete"] == NSOrderedSame)
    {
        [lxxDisplayTimer invalidate];
    }
}

- (void) collatePrimaryDisplayResults
{
    /*====================================================================================================*
     *                                                                                                    *
     *                                    collatePrimaryDisplayResults                                    *
     *                                    ============================                                    *
     *                                                                                                    *
     *  This runs as a background thread.  In order to enable this, each search result is stored as an    *
     *    attributed string in a dictionary, which can be accessed by the main thread.  The main thread   *
     *    will inspect this dictionary regularly and display any new results.                             *
     *                                                                                                    *
     *====================================================================================================*/
    // effectively character constants
    NSString *zeroWidthSpace, *zeroWidthNonJoiner, *noBreakSpace, *ideographicSpace;

    NSInteger idx, noOfMatches, wdx, noOfWords = 0, noOfLines;
    NSString *workingText;
    NSMutableString *interimText;
    NSMutableAttributedString *singleResult;
    NSArray *listOfWordPositions;
    classLXXBook *currentBook;
    classLXXVerse *currentVerse;
    classLXXWord *currentWord;
    classLXXPrimaryResult *currentSearchResult;
    classDisplayUtilities *displayUtility;

    zeroWidthSpace = [[NSString alloc] initWithFormat:@"%C", 0x200b];
    zeroWidthNonJoiner = [[NSString alloc] initWithFormat:@"%C", 0x200d];
    noBreakSpace = [[NSString alloc] initWithFormat:@"%C", 0x00a0];
    ideographicSpace = [[NSString alloc] initWithFormat:@"%C", 0x3000];
    lxxResultsTextView = [globalVarsLXXSearch txtSearchResults];
    displayUtility = [[classDisplayUtilities alloc] init:globalVarsLXXSearch];
    lxxProgressMessage = @"Displaying results";
    noOfMatches = noOfMatchingLXXVerses;
    noOfLines = 0;
    for (idx = 0; idx < noOfMatches; idx++)
    {
        singleResult = [[NSMutableAttributedString alloc] initWithString:@""];
        if( idx > 0 )
        {
            [singleResult appendAttributedString:[displayUtility addAttributedText:@"\n\n" offsetCode:0 fontId:13 alignment:0 withAdjustmentFor:lxxResultsTextView]];
        }
        currentSearchResult = nil;
        currentSearchResult = [listOfLXXPrimaryResults objectForKey:[globalVarsLXXSearch convertIntegerToString: idx]];
        currentBook = nil;
        currentBook = [[globalVarsLXXSearch lxxBookList] objectForKey:[globalVarsLXXSearch convertIntegerToString:[currentSearchResult bookId]]];
        currentVerse = [currentSearchResult impactedVerse];
        // Where a book name contains spaces, we don't want this split wierdly because of right-to-left text, so we use "\u3000" as a space
        interimText = [[NSMutableString alloc] initWithString:[currentBook commonName]];
        [interimText replaceOccurrencesOfString:@" " withString:ideographicSpace options:NSLiteralSearch range:NSMakeRange(0, [interimText length])];
        workingText = [[NSString alloc] initWithFormat:@"%@%@%@.%@", interimText, noBreakSpace, [currentSearchResult chapReference], [currentSearchResult verseReference]];
        lxxProgressMessage = [[NSString alloc] initWithFormat:@"Displaying: %@", workingText];
        [singleResult appendAttributedString:[displayUtility addAttributedText:workingText offsetCode:0 fontId:9 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
        [singleResult appendAttributedString:[displayUtility addAttributedText:@": " offsetCode:0 fontId:9 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
        noOfWords = [currentVerse wordCount];
        listOfWordPositions = [[NSArray alloc] initWithArray:[[currentSearchResult matchingWordPositions] allValues]];
        for (wdx = 0; wdx < noOfWords; wdx++)
        {
            currentWord = [currentVerse getWord:wdx];
            [singleResult appendAttributedString:[displayUtility addAttributedText:zeroWidthSpace offsetCode:0 fontId:13 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
            if ( [listOfWordPositions doesContain:[globalVarsLXXSearch convertIntegerToString:wdx]])
            {
                [singleResult appendAttributedString:[displayUtility addAttributedText:[currentWord textWord] offsetCode:0 fontId:14 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
            }
            else
            {
                [singleResult appendAttributedString:[displayUtility addAttributedText:[currentWord textWord] offsetCode:0 fontId:13 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
            }
            [singleResult appendAttributedString:[displayUtility addAttributedText:[[NSString alloc] initWithFormat:@"%@%@%@ ", zeroWidthNonJoiner, [currentWord postWordChars], [currentWord punctuation]] offsetCode:0 fontId:13 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
        }
        [lxxSearchResults setObject:singleResult forKey:[globalVarsLXXSearch convertIntegerToString:idx]];
        lxxLatestResultCount = idx;
   }
    lxxProgressMessage = @"Search Results complete";
}

- (void) displayLXXSecondary
{
    lxxBackgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(collateSecondaryDisplayResults) object:nil];
    if( lxxSearchResults == nil) lxxSearchResults = [[NSMutableDictionary alloc] init];
    [lxxSearchResults removeAllObjects];
    lxxResultsTextView = [globalVarsLXXSearch txtSearchResults];
    lxxLatestResultCount = -1;
    lxxRunningResultCount = -1;
    [lxxBackgroundThread start];
    lxxDisplayTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(performSecondaryDisplay:) userInfo:nil repeats:YES];
}

- (void) performSecondaryDisplay: (id) sender
{
    NSTextStorage *textStorage;

    textStorage = [lxxResultsTextView textStorage];
    [labLXXSearchProgressLbl setStringValue:@"Displaying results"];
    if( lxxLatestResultCount > lxxRunningResultCount)
    {
        for( ++lxxRunningResultCount; lxxRunningResultCount <= lxxLatestResultCount; lxxRunningResultCount++)
        {
            [labLXXSearchProgressLbl setStringValue:lxxProgressMessage];
            [textStorage appendAttributedString:[lxxSearchResults objectForKey:[globalVarsLXXSearch convertIntegerToString:lxxRunningResultCount]]];
        }
    }
    if( [lxxProgressMessage compare:@"Search Results complete"] == NSOrderedSame)
    {
        [lxxDisplayTimer invalidate];
    }
}

- (void) collateSecondaryDisplayResults
{
    /*========================================================================================================================*
     *                                                                                                                        *
     *                                               displayLXXSecondary                                                      *
     *                                               ===================                                                      *
     *                                                                                                                        *
     *  Manage the display of verses satisfying a complex search, consisting of two words within a set number of words of     *
     *    each other.                                                                                                         *
     *                                                                                                                        *
     *  The starting point of this process is a list of class instances, allMatches, which each list a primary and secondary  *
     *    word that satisfy the search criteria.  Note that:                                                                  *
     *                                                                                                                        *
     *    a) the list will be in strict sequence;                                                                             *
     *    b) the determining word, however, may be either a primary or secondary match;                                       *
     *    c) the matching word (either primary or secondary, that comes second) may be within the same verse or the following *
     *         verse or the one after;                                                                                        *
     *    d) additional matches may occur after the first element of the previous match but before the second;                *
     *    e) specifically, we may get:                                                                                        *
     *           match n: primary is chapter 6.4, word 5 while secondary is 6.5, word 2                                       *
     *           match n+1: primary is chapter 6.4, word 7 while secondary is also 6.5, word 2                                *
     *                                                                                                                        *
     *  Processing:                                                                                                           *
     *  ==========                                                                                                            *
     *                                                                                                                        *
     *  In order to convert the individual matches into information that can be displayed sequentially, we will first convert *
     *    each match to a unique reference value.  To do this, we perform the calculation:                                    *
     *                                                                                                                        *
     *                        referenceValue = 1 000 000 * bookId + 1000 * chapterSeq + verseSeq                              *
     *                                                                                                                        *
     *    This will than be used as a key for a verse reference.  If the source record has the second match in a different    *
     *    verse to the first, then the stored verse information will also be marked as "contiguous" with the next.            *
     *                                                                                                                        *
     *========================================================================================================================*/

    // effectively character constants
    NSString *zeroWidthSpace, *zeroWidthNonJoiner, *noBreakSpace, *ideographicSpace;

    NSInteger idx, bdx, primaryChap, primaryVerse, secondaryChap, secondaryVerse, wdx, noOfWords = 0, index = 0, typeCode;
    NSString *referenceText, *primaryReferenceValue, *secondaryReferenceValue, *dictionaryValue, *dictionaryKey;
    NSMutableString *interimText;
    NSMutableAttributedString *singleResult;
    NSMutableDictionary *versesMatched;
    NSArray *unorderedKeys, *orderedKeys;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter;
    classLXXVerse *currentVerse;
    classLXXWord *currentWord;
    classLXXSearchVerse *primarySearchVerse, *secondarySearchVerse;
    classLXXSearchMatches *currentMatch;
    classDisplayUtilities *displayUtility;

    versesMatched = [[NSMutableDictionary alloc] init];
    zeroWidthSpace = [[NSString alloc] initWithFormat:@"%C", 0x200b];
    zeroWidthNonJoiner = [[NSString alloc] initWithFormat:@"%C", 0x200d];
    noBreakSpace = [[NSString alloc] initWithFormat:@"%C", 0x00a0];
    ideographicSpace = [[NSString alloc] initWithFormat:@"%C", 0x3000];
    lxxResultsTextView = [globalVarsLXXSearch txtSearchResults];
    displayUtility = [[classDisplayUtilities alloc] init:globalVarsLXXSearch];

    lxxProgressMessage = @"Displaying results";
    // Step 1: Arrange the list of all matches further
    for (idx = 0; idx < noOfAllMatches; idx++)
    {
        currentMatch = nil;
        currentMatch = [allLXXMatches objectForKey:[globalVarsLXXSearch convertIntegerToString:idx]];
        bdx = [currentMatch bookId];
        currentBook = nil;
        currentBook = [[globalVarsLXXSearch lxxBookList] objectForKey:[globalVarsLXXSearch convertIntegerToString:bdx]];
        primaryChap = [currentMatch primaryChapterSeq];
        primaryVerse = [currentMatch primaryVerseSeq];
        secondaryChap = [currentMatch secondaryChapterSeq];
        secondaryVerse = [currentMatch secondaryVerseSeq];
        primaryReferenceValue = [self createReferenceValue:bdx chapter:primaryChap verse:primaryVerse];
        secondaryReferenceValue = [self createReferenceValue:bdx chapter:secondaryChap verse:secondaryVerse];
        primarySearchVerse = nil;
        primarySearchVerse = [versesMatched objectForKey:primaryReferenceValue];
        if (primarySearchVerse == nil)
        {
            primarySearchVerse = [[classLXXSearchVerse alloc] init:globalVarsLXXSearch];
            [primarySearchVerse setBookId:bdx];
            [primarySearchVerse setChapterNumber:primaryChap];
            [primarySearchVerse setVerseNumber:primaryVerse];
            [primarySearchVerse setChapterReference:[currentMatch primaryChapterRef]];
            [primarySearchVerse setVerseReference:[currentMatch primaryVerseRef]];
            currentChapter = [currentBook getChapterBySequence:primaryChap];
            [primarySearchVerse setImpactedVerse:[currentChapter getVerseBySequence:primaryVerse]];
            [versesMatched setObject:primarySearchVerse forKey:primaryReferenceValue];
        }
        [primarySearchVerse addWordPosition:[currentMatch primaryWordSeq] forWordType:1];
        secondarySearchVerse = nil;
        secondarySearchVerse = [versesMatched objectForKey:secondaryReferenceValue];
        if (secondarySearchVerse == nil)
        {
            secondarySearchVerse = [[classLXXSearchVerse alloc] init:globalVarsLXXSearch];
            [secondarySearchVerse setBookId:bdx];
            [secondarySearchVerse setChapterNumber:secondaryChap];
            [secondarySearchVerse setVerseNumber:secondaryVerse];
            [secondarySearchVerse setChapterReference:[currentMatch secondaryChapterRef]];
            [secondarySearchVerse setVerseReference:[currentMatch secondaryVerseRef]];
            currentChapter = [currentBook getChapterBySequence:secondaryChap];
            [secondarySearchVerse setImpactedVerse:[currentChapter getVerseBySequence:secondaryVerse]];
            [versesMatched setObject:secondarySearchVerse forKey:secondaryReferenceValue];
        }
        [secondarySearchVerse addWordPosition:[currentMatch secondaryWordSeq] forWordType:2];
        if ([primaryReferenceValue integerValue] > [secondaryReferenceValue integerValue]) [secondarySearchVerse setIsFollowed:true];
        else
        {
            if ([secondaryReferenceValue integerValue] > [primaryReferenceValue integerValue]) [primarySearchVerse setIsFollowed:true];
        }
    }
    // We now have information on all relevant matches
    unorderedKeys = [[NSArray alloc] initWithArray:[versesMatched allKeys]];
    orderedKeys = [[NSArray alloc] initWithArray:[unorderedKeys sortedArrayUsingSelector:@selector(compare:)]];
    idx = -1;
    for( dictionaryKey in orderedKeys)
    {
        ++idx;
        singleResult = [[NSMutableAttributedString alloc] initWithString:@""];
        primarySearchVerse = [versesMatched objectForKey:dictionaryKey];
        currentVerse = [primarySearchVerse impactedVerse];
        currentBook = [[globalVarsLXXSearch lxxBookList] objectForKey:[globalVarsLXXSearch convertIntegerToString:[primarySearchVerse bookId]]];
        interimText = [[NSMutableString alloc] initWithString:[currentBook commonName]];
        [interimText replaceOccurrencesOfString:@" " withString:ideographicSpace options:NSLiteralSearch range:NSMakeRange(0, [interimText length])];
        referenceText = [[NSString alloc] initWithFormat:@"%@%@%@.%@", interimText, noBreakSpace, [primarySearchVerse chapterReference], [primarySearchVerse verseReference]];
        lxxProgressMessage = [[NSString alloc] initWithFormat:@"Displaying: %@", referenceText];
        [singleResult appendAttributedString:[displayUtility addAttributedText:referenceText offsetCode:0 fontId:9 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
        [singleResult appendAttributedString:[displayUtility addAttributedText:@": " offsetCode:0 fontId:9 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
        noOfWords = [currentVerse wordCount];
        index = 0;
        for (wdx = 0; wdx < noOfWords; wdx++)
        {
            /*---------------------------------------------------------------------------------------------------------*
            *                                                                                                         *
            *  A reminder:                                                                                            *
            *                                                                                                         *
            *  primarySearchVerse.matchingWordPositions is a dictionary keyed on a sequential integer.  Each entry    *
            *    gives the word sequence position of a word that matches one of the search criteria, whether primary  *
            *    or secondary.                                                                                        *
            *                                                                                                         *
            *  primarySearchVerse.matchingWordType also has an entry for the same integer sequence but the related    *
            *    value tells us whether the match is primary (1) or secondary (2).                                    *
            *                                                                                                         *
            *  So, as we step through the whole verse, we must check whether wdx matches one of the values for        *
            *    matchingWordPosition.  If it does, we then need to get the type code, to tell whether it is primary  *
            *    or secondary, and process it accordingly.                                                            *
            *                                                                                                         *
            *  Note that the sequence number (Key) for both dictionaries starts with zero.                            *
            *                                                                                                         *
            *---------------------------------------------------------------------------------------------------------*/
            currentWord = [currentVerse getWord:wdx];
            [singleResult appendAttributedString:[displayUtility addAttributedText:zeroWidthSpace offsetCode:0 fontId:13 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
            dictionaryValue = nil;
            {
                typeCode = 0;
                for( dictionaryKey in [primarySearchVerse matchingWordPositions])
                {
                    dictionaryValue = [[primarySearchVerse matchingWordPositions] objectForKey:dictionaryKey];
                    if( [dictionaryValue integerValue] == wdx)
                    {
                        typeCode = [[[primarySearchVerse matchingWordType] objectForKey:dictionaryKey] integerValue];
                        break;
                    }
                }
                switch( typeCode )
                {
                    case 0:
                        [singleResult appendAttributedString:[displayUtility addAttributedText:[currentWord textWord]  offsetCode:0 fontId:13 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
                        break;
                    case 1:
                        [singleResult appendAttributedString:[displayUtility addAttributedText:[currentWord textWord]  offsetCode:0 fontId:14 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
                        break;
                    case 2:
                        [singleResult appendAttributedString:[displayUtility addAttributedText:[currentWord textWord]  offsetCode:0 fontId:15 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
                        break;
                }
            }
            [singleResult appendAttributedString:[displayUtility addAttributedText:[[NSString alloc] initWithFormat:@"%@%@%@ ", zeroWidthNonJoiner, [currentWord postWordChars], [currentWord punctuation]] offsetCode:0 fontId:13 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
        }
        if (![primarySearchVerse isFollowed])
        {
            [singleResult appendAttributedString:[displayUtility addAttributedText:@"\n\n"  offsetCode:0 fontId:10 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
        }
        else
        {
            [singleResult appendAttributedString:[displayUtility addAttributedText:@"\n"  offsetCode:0 fontId:10 alignment:lxxDisplayAlignment withAdjustmentFor:lxxResultsTextView]];
        }
        [lxxSearchResults setObject:singleResult forKey:[globalVarsLXXSearch convertIntegerToString:idx]];
        lxxLatestResultCount = idx;
    }
    lxxProgressMessage = @"Search Results complete";
}

- (NSString *) createReferenceValue: (NSInteger) bookId chapter: (NSInteger) chapId verse: (NSInteger) verseId
{
    return [[NSString alloc] initWithFormat:@"%@%@%@", [self zeroPadding:bookId withNoOfPlaces:2], [self zeroPadding:chapId withNoOfPlaces:3], [self zeroPadding:verseId withNoOfPlaces:3]];
}

- (NSString *) zeroPadding: (NSInteger) sourceNumber withNoOfPlaces: (NSInteger) noOfPlaces
{
    NSInteger idx;
    NSMutableString *padding;
    NSString *finalNumber;
    
    padding = [[NSMutableString alloc] initWithString:@""];
    for( idx = 0; idx < noOfPlaces; idx++)
    {
        [padding appendString:@"0"];
    }
    finalNumber = [[NSString alloc] initWithFormat:@"%@%ld", padding, sourceNumber];
    return [[NSString alloc] initWithString:[finalNumber substringFromIndex:[finalNumber length] - noOfPlaces]];
}

@end
