//
//  AppDelegate.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 04/01/2021.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

/*=================================
 *
 *  Global class variables
 *
 */

@synthesize globalVars;
classRegistry *appRegistry;
classGreekProcessing *greekProcessing;
classLexicon *lexicon;
classText *mainTextHandler;
classKeyboard *keyboard;
classSearch *searchProcedures;
classSearchRecord *searchRecord;
classNotes *notesProcessing;
classVocab *vocabLists;

@synthesize mainWindow;
@synthesize initialView;

/*************************************************
 *
 *              Main Text Areas
 *              ===============
 */

@synthesize ntTextView;
@synthesize lxxTextView;
@synthesize parseTextView;
@synthesize lexiconTextView;
@synthesize searchTextView;
@synthesize vocabTextView;
@synthesize notesTextView;

/*************************************************
 *
 *           Text Area Header Panels
 *           =======================
 */

/**------------------------------------------------
 *
 *           New Testament
 *           =============
 */

@synthesize cbNtBook;
@synthesize cbNtChapter;
@synthesize cbNtVerse;
@synthesize cbNtHistory;
@synthesize btnNtPrevChapter;
@synthesize btnNtNextChapter;

/**------------------------------------------------
 *
 *           Old Testament
 *           =============
 */

@synthesize cbLxxBook;
@synthesize cbLxxChapter;
@synthesize cbLxxVerse;
@synthesize cbLxxHistory;
@synthesize btnLxxPrevChapter;
@synthesize btnLxxNextChapter;

/*************************************************
 *
 *           Main Screen, overall Views
 *           ==========================
 */

@synthesize topLeftTabView;
@synthesize topRightTabView;
@synthesize bottomRightTabView;
@synthesize tabNewTestament;
@synthesize tabSeptuagint;
@synthesize tabParse;
@synthesize tabLexicon;
@synthesize tabSearch;
@synthesize tabVocab;
@synthesize tabNotes;
@synthesize mainSplitView;
@synthesize rightSplitView;
@synthesize leftUpperSubView;
@synthesize leftSplitView;
@synthesize keyboardHeader;

/*************************************************
 *
 *           Web Views, for Lexicon Appendix
 *           ===============================
 */

@synthesize webComments;
@synthesize webAuthors;
@synthesize webEpigraphical;
@synthesize webPapyrologicl;
@synthesize webPeriodicals;
@synthesize webAbbreviations;

/*************************************************
 *
 *           Outlets and Variables for Search
 *           ================================
 */

/*------------------------------------------------
 *      Variables for the listbox
 *      -------------------------
 */

@synthesize booksOfBible;
@synthesize booksOfBibleColumn;
@synthesize booksMaster;

/*------------------------------------------------
 *      Variables for the various options
 *      ---------------------------------
 */

@synthesize chkMoses;
@synthesize chkHistory;
@synthesize chkWisdom;
@synthesize chkProphets;
@synthesize chkGospels;
@synthesize chkPaul;
@synthesize chkRest;
@synthesize rbtnExclude;
@synthesize rbtnInclude;

/*------------------------------------------------
 *      Other Controls
 *      --------------
 */

@synthesize primarySearchWord;
@synthesize secondarySearchWord;
@synthesize secondarySuperView;
@synthesize performSearch;
@synthesize advancedSearch;
@synthesize btnRemove;
@synthesize btnReinstate;
@synthesize btnRoot;
@synthesize btnExact;
@synthesize labWithin;
@synthesize labWordsOf;
@synthesize txtWordSeperation;
@synthesize stepperWordSeperation;
@synthesize statusLabel;
@synthesize statusLabel2;

/*************************************************
 *
 *           Outlets and Variables for Keyboard
 *           ================================
 */

@synthesize keyboardView;
@synthesize btnKeyboard;
@synthesize rbtnNotes;
@synthesize rbtnPrimary;
@synthesize rbtnSecondary;

/*************************************************************************
 *                                                                       *
 *                  Variables for TextView Delegates                     *
 *                  ================================                     *
 *                                                                       *
 *  All variables described here are created when the mouse enters a     *
 *    textView.  Since there is no modification when the mouse *exits*,  *
 *    these values will remain, even if the mouse is elsewhere in the    *
 *    application.  However, the reflect the values in either the text   *
 *    area currently being visited or the last one to have been          *
 *    visited.                                                           *
 *                                                                       *
 *  Description of variables:                                            *
 *  ------------------------                                             *
 *                                                                       *
 *  textViewIndicator            This is an integer code that tells us   *
 *                               which textView is the last registered   *
 *                                  1   ntTextView                       *
 *                                  2   lxxTextView                      *
 *                                  3   parseTextView                    *
 *                                  4   lexiconTextView                  *
 *                                  5   searchResultsTextView            *
 *                                  6   vocabTextView                    *
 *                                  7   notesTextView                    *
 *  currentlyVisibleText    Indicates which testament is currently  *
 *                              on view.  Possible values:               *
 *                                  1  ntTextView                        *
 *                                  2  lxxTextView                       *
 *                              (Note, this apparently duplicates        *
 *                               textViewIndicator but it ensures that   *
 *                               we can identify the currently active    *
 *                               testament, even when we are processing  *
 *                               other textViews.                        *
 *  latestCursorPosition         This is the cursor position within the  *
 *                               total text of the textView.  It is only *
 *                               of relevence to the two Biblical Text   *
 *                               areas.                                  *
 *  latestLineRange              This is a range that defines the full   *
 *                               line in which latestCursorPosition is   *
 *                               found.  The line can be isolated using  *
 *                               this range.                             *
 *  latestRevisedCursorPosition  This is the cursor position in the      *
 *                               *line*.  If you have retrieved the      *
 *                               line using latestLineRange, this will   *
 *                               tell you where in the line the cursor   *
 *                               is.                                     *
 *  latestMouseButton            Values are:                             *
 *                                  1   left mouse button clicked        *
 *                                  2   right mouse button clicked       *
 *                                  3   an other mouse button clicked    *
 *  latestClickCount             Tells how many clicks were identified.  *
 *                               (Currently not working: it's always 1)  *
 *                                                                       *
 *************************************************************************/

@synthesize textViewIndicator;
@synthesize latestCursorPosition;
@synthesize latestLineRange;
@synthesize latestRevisedCursorPosition;
@synthesize latestMouseButton;
@synthesize latestClickCount;
@synthesize currentlyVisibleText;

/*************************************************
 *
 *           Variables for Setting Vocab Lists
 *           =================================
 *
 */

@synthesize rbtnListVerse;
@synthesize rbtnListChapter;
@synthesize rbtnDisplayTypeAlpha;
@synthesize rbtnDisplayTypeOrder;
@synthesize rbtnDisplayMixedAlpha;
@synthesize rbtnDisplayMixedOrder;
@synthesize rbtnActualWords;
@synthesize rbtnRootWords;
@synthesize rbtnActualAndRoot;
@synthesize chkNouns;
@synthesize chkVerbs;
@synthesize chkAdjectives;
@synthesize chkAdverbs;
@synthesize chkPrepositions;
@synthesize chkOther;

/*************************************************
 *
 *           Menus
 *           =====
 *
 */

@synthesize mainTextContextMenu;
@synthesize parseLexiconContextMenu;
@synthesize searchContextMenu;
@synthesize notesContextMenu;
@synthesize vocabListContextMenu;

/*************************************************
 *
 *           Progress Window - Initialisation
 *           ======== ======   ==============
 *
 */

@synthesize initialisationProgress;
@synthesize labProgress1;
@synthesize labProgress2;
@synthesize mainLoop;

/*++++++++++++++++++++++++++++++++++++++++++++++++
 *
 *      Non-synthesised variables
 *      -------------------------
 */

BOOL isInLoadState;
NSInteger pstnControl, rightPstnControl, pstnControlMaster = 99;
NSString *const colBooks = @"books";

/*------------------------------------------------
 *
 *      Variables to Control virtual keyboard presentation
 *      --------------------------------------------------
 *
 *  heightIndicator 0 = Virtual keyboard is hidden
 *                  1 = Virtual keyboard is displayed
 *  overrideSlide   0 = use heightOfSlider
 *                  1 = don't use it
 */

NSInteger heightIndicator, overrideSlide, highWaterMark;;
NSTimer *generalPurposeTimer, *tabCheckTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    isInLoadState = true;
    frmStart *startForm;
    
    mainLoop = [NSRunLoop mainRunLoop];
    startForm = [[frmStart alloc] initWithWindowNibName:@"frmStart"];
    [startForm showWindow:nil];
    [labProgress1 setStringValue:@"Setting up Greek Processing capability"];
    [initialisationProgress incrementBy:1.0];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];

    /*----------------------------------------------------------------
     *
     *  Process global settings first
     *
     */

    globalVars = [classConfig new];
    greekProcessing = [[classGreekProcessing alloc] init:globalVars];
    [labProgress1 setStringValue:@"Populating the Greek Lexicon"];
    [initialisationProgress incrementBy:1.0];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
    lexicon = [[classLexicon alloc] init:globalVars];
    mainTextHandler = [[classText alloc] init:globalVars greekProcessing:greekProcessing withLexicon:lexicon];

    /*----------------------------------------------------------------
     *
     *  Global variables - set up in the config class
     *
     */
    
    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     *
     *  Basic variables: window and textviews
     *
     */
    
    globalVars.mainWindow = mainWindow;
    globalVars.appDelegate = self;
    globalVars.ntTextView = ntTextView;
    globalVars.lxxTextView = lxxTextView;
    globalVars.parseTextView = parseTextView;
    globalVars.lexiconTextView = lexiconTextView;
    globalVars.searchTextView = searchTextView;
    globalVars.vocabTextView = vocabTextView;
    globalVars.notesTextView = notesTextView;
    globalVars.mainLoop = mainLoop;

    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     *
     *  File paths and names
     *
     */
    
    globalVars.basePath = @"/Library/";
    globalVars.lfcFolder = @"LFCConsulting";
    globalVars.appFolder = @"GBS";
    globalVars.notesFolder = @"notes";
    globalVars.notesName = @"default";
    
    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     *
     *  Main windows objects
     *
     */
    
    globalVars.cbNtBook = cbNtBook;
    globalVars.cbNtChapter = cbNtChapter;
    globalVars.cbNtVerse = cbNtVerse;
    globalVars.cbLxxBook = cbLxxBook;
    globalVars.cbLxxChapter = cbLxxChapter;
    globalVars.cbLxxVerse = cbLxxVerse;
    globalVars.cbNtHistory = cbNtHistory;
    globalVars.cbLxxHistory = cbLxxHistory;
    globalVars.topLeftTabView = topLeftTabView;
    globalVars.topRightTabView = topRightTabView;
    globalVars.bottomRightTabView = bottomRightTabView;
    globalVars.tabNewTestament = tabNewTestament;
    globalVars.tabSeptuagint = tabSeptuagint;

    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     *
     *  Collections to be made available to other classes
     *
     */
    
    globalVars.collectionOfWebViews = [[NSArray alloc] initWithObjects:webComments, webAuthors, webEpigraphical, webPapyrologicl, webPeriodicals, webAbbreviations, nil];
    globalVars.statusLabel = statusLabel;
    globalVars.statusLabel2 = statusLabel2;
    globalVars.keyboardView = keyboardView;
    rbtnNotes = [[NSButton alloc] init];
    rbtnPrimary = [[NSButton alloc] init];
    rbtnSecondary = [[NSButton alloc] init];
    globalVars.rbtnNotes = rbtnNotes;
    globalVars.rbtnPrimary = rbtnPrimary;
    globalVars.rbtnSecondary = rbtnSecondary;
    globalVars.historyMax = 99;

    [labProgress1 setStringValue:@"Setting up the Virtual Greek Keyboard"];
    [initialisationProgress incrementBy:1.0];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
    keyboard = [[classKeyboard alloc] init:globalVars greekInfo:greekProcessing];
    notesProcessing = [[classNotes alloc] init:globalVars];
    vocabLists = [[classVocab alloc] init:globalVars];
    globalVars.prefsTextViews = [[NSMutableArray alloc] init];
    [globalVars.prefsTextViews addObject:ntTextView];
    [globalVars.prefsTextViews addObject:lxxTextView];
    [globalVars.prefsTextViews addObject:parseTextView];
    [globalVars.prefsTextViews addObject:lexiconTextView];
    [globalVars.prefsTextViews addObject:searchTextView];
    [globalVars.prefsTextViews addObject:vocabTextView];
    [globalVars.prefsTextViews addObject:notesTextView];

    searchProcedures = [[classSearch alloc] init:globalVars greekProcessing:greekProcessing];
    searchRecord = [[classSearchRecord alloc] init];
    globalVars.primarySearchWord = primarySearchWord;
    globalVars.secondarySearchWord = secondarySearchWord;

    // *** The following lines of code have been deferred *** //
    
    globalVars.gospels = [[NSArray alloc] initWithObjects: @"Matthew", @"Mark", @"Luke", @"John", @"Acts of the Apostles", nil];
    globalVars.paul = [[NSArray alloc] initWithObjects:@"Romans", @"1 Corinthians", @"2 Corinthians", @"Galatians", @"Ephesians", @"Philippians", @"Colossians",
                     @"1 Thessalonians", @"2 Thessalonians", @"1 Timothy", @"2 Timothy", @"Titus", @"Philemon", nil];
    globalVars.restOfNT = [[NSArray alloc] initWithObjects:@"Hebrews", @"James", @"1 Peter", @"2 Peter", @"1 John", @"2 John", @"3 John", @"Jude", @"Revelation", nil];
    globalVars.Pent = [[NSArray alloc] initWithObjects:@"Genesis", @"Exodus", @"Leviticus", @"Numbers", @"Deuteronomy", nil];
    globalVars.history = [[NSArray alloc] initWithObjects:@"Joshua (Codex Vaticanus)", @"Joshua (Codex Alexandrinus)", @"Judges (Codex Alexandrinus)", @"Judges (Codex Vaticanus)",
                        @"Ruth", @"1 Samuel", @"2 Samuel", @"1 Kings", @"2 Kings", @"1 Chronicles", @"2 Chronicles", @"1 Esdras", @"Ezra and Nehemiah",
                        @"Esther", @"Judith", @"Tobit (Codices Vaticanus and Alexandrinus)", @"Tobit (Codex Sinaiticus)", @"1 Macabees", @"2 Macabees",
                        @"3 Macabees", @"4 Macabees", nil];
    globalVars.wisdom = [[NSArray alloc] initWithObjects:@"Psalms", @"Odes", @"Proverbs", @"Ecclesiastes", @"Song of Songs", @"Job", @"Wisdom of Solomon", @"Ecclesiasticus",
                       @"Psalms of Solomon", nil];
    globalVars.prophets = [[NSArray alloc] initWithObjects:@"Hosea", @"Amos", @"Micah", @"Joel", @"Obadiah", @"Jonah", @"Nahum", @"Habakkuk", @"Zephaniah", @"Haggai", @"Zechariah",
                         @"Malachi", @"Isaiah", @"Jeremiah", @"Baruch", @"Lamentations", @"Epistle of Jeremiah", @"Ezekiel",
                         @"Bel and the Dragon (Old Greek)", @"Bell and the Dragon (Theodotion)", @"Daniel (Old Greek)", @"Daniel (Theodotion)",
                         @"Susanna (Old Greek)", @"Susanna (Theodotion)", nil];

         /*-----------------------------------------------------------------------------------------------------*
     *                                                                                                     *
     *  Main source/storage locations                                                                      *
     *  -----------------------------                                                                      *
     *                                                                                                     *
     *  Configuration data will be located in the main bundle and the user will not be given the option to *
     *    relocate it.                                                                                     *
     *                                                                                                     *
     *  Source files and help files will also be located in the main  bundle and, there will be no benifit *
     *    in moving them.                                                                                  *
     *                                                                                                     *
     *  The notes location will _not_ be located in the main bundle and, by default, will be stored in     *
     *    "~/LFCConsulting/GBS.                                                                            *
     *    This location can be changed.                                                                    *
     *                                                                                                     *
     *-----------------------------------------------------------------------------------------------------*/

    BOOL isDir = true;
    NSFileManager *fmInit = [NSFileManager defaultManager];
    NSString *initFileName;
    NSString *initPath = [[NSString alloc] initWithFormat:@"%@%@%@/%@",
                             [fmInit homeDirectoryForCurrentUser], [globalVars basePath], [globalVars lfcFolder], [globalVars appFolder]];
    
    if( [initPath containsString:@"file:///"] )
    {
        initPath = [[NSString alloc] initWithString:[initPath substringFromIndex:7]];
    }
    if( ! [fmInit fileExistsAtPath:initPath isDirectory:&isDir]) [fmInit createDirectoryAtPath:initPath withIntermediateDirectories:YES attributes:nil error:nil];
    initFileName = [[NSString alloc] initWithFormat:@"%@/init.dat", initPath];
    globalVars.iniPath = initPath;
    globalVars.iniFile = initFileName;
    appRegistry = [[classRegistry alloc] init:globalVars];
    if( [globalVars mainX] > -1) [mainWindow setFrameOrigin:NSMakePoint([globalVars mainX], [globalVars mainY])];
    if( [globalVars mainWidth] > -1) [mainWindow setFrame:NSMakeRect([globalVars mainX], [globalVars mainY], [globalVars mainWidth], [globalVars mainHeight]) display:YES ];
    if( [globalVars mainDividerPosition] > -1) [mainSplitView setPosition:[globalVars mainDividerPosition] ofDividerAtIndex:0];

     /*--------------------------------------------------------*
     *                                                        *
     *         Set up variables to manage keyboard slide      *
     *         -----------------------------------------      *
     *                                                        *
     *--------------------------------------------------------*/
    
    heightIndicator = 0;
    overrideSlide = 1;
    highWaterMark = 0;
    pstnControlMaster = [leftSplitView frame].size.height - 1.7 * [keyboardHeader frame].size.height;
//    pstnControl = pstnControlMaster;
    pstnControl = 0;
    [leftSplitView setPosition:[leftSplitView frame].size.height - 60 ofDividerAtIndex:0];
    overrideSlide = 0;
    
     /*--------------------------------------------------------*
     *                                                        *
     *         Modify the main textview context menu          *
     *         -------------------------------------          *
     *                                                        *
     *--------------------------------------------------------*/
    
    ntTextView.menu = mainTextContextMenu;
    lxxTextView.menu = mainTextContextMenu;
    parseTextView.menu = parseLexiconContextMenu;
    lexiconTextView.menu = parseLexiconContextMenu;
    searchTextView.menu = searchContextMenu;
    notesTextView.menu = notesContextMenu;
    vocabTextView.menu = vocabListContextMenu;

    [labProgress1 setStringValue:@"Loading and storing Greek Text"];
    [initialisationProgress incrementBy:1.0];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
    globalVars.booksMaster = [[NSArray alloc] initWithArray: [mainTextHandler storeAllText]];
    booksOfBibleColumn = [[NSMutableArray alloc] initWithArray:[globalVars booksMaster]];
    [booksOfBible reloadData];

    // Set up the comboboxes for response
    self.cbNtBook.delegate = self;
    self.cbNtChapter.delegate = self;
    self.cbNtVerse.delegate = self;
    self.cbLxxBook.delegate = self;
    self.cbLxxChapter.delegate = self;
    self.cbLxxVerse.delegate = self;

    [labProgress1 setStringValue:@"Populating the Lexicon Appendix"];
    [initialisationProgress incrementBy:1.0];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
    [lexicon populateAppendice];

    /*----------------------------------------------------------------*
     *                                                                *
     *  Initialise History                                            *
     *                                                                *
     *----------------------------------------------------------------*/
    
    [labProgress1 setStringValue:@"Retrieving and processing history"];
    [initialisationProgress incrementBy:1.0];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
    [mainTextHandler loadHistory];

    /*----------------------------------------------------------------*
     *                                                                *
     *  Initialise Notes                                              *
     *                                                                *
     *----------------------------------------------------------------*/
    
    [labProgress1 setStringValue:@"Retrieving and storing notes"];
    [initialisationProgress incrementBy:1.0];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
    notesProcessing = [[classNotes alloc] init:globalVars];
    [notesProcessing retrieveAllNotes];
    [mainTextHandler displayNewNote:1 withSelectedItem:[cbNtVerse objectValueOfSelectedItem]];

    rightPstnControl = [topRightTabView frame].size.height;
    globalVars.dividerPstn = rightPstnControl;
    textViewIndicator = 1;
    currentlyVisibleText = 1;
    [_window setAcceptsMouseMovedEvents:YES];
    
    [startForm close];
    [_window setIsVisible:true];
    isInLoadState = false;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {

    globalVars.mainX = [mainWindow frame].origin.x;
    globalVars.mainY = [mainWindow frame].origin.y;
    globalVars.mainWidth = [mainWindow frame].size.width;
    globalVars.mainHeight = [mainWindow frame].size.height;
    globalVars.mainDividerPosition = [[[mainSplitView arrangedSubviews] objectAtIndex:0] frame].size.width;
    [appRegistry saveInitData];
    [mainTextHandler saveHistory];
}

- (void) thisWorksInClear
{
    NSMutableAttributedString *presentationString, *mutableAttribute;
    
    presentationString = [[NSMutableAttributedString alloc] initWithString:@"Here is a simple string"];
    [[ntTextView textStorage] setAttributedString:presentationString];
    mutableAttribute = [[NSMutableAttributedString alloc] initWithString:@"\nAnd here is another"];
    [mutableAttribute addAttribute:NSForegroundColorAttributeName value: [NSColor redColor] range:NSMakeRange(0, [mutableAttribute length])];
    [[ntTextView textStorage] appendAttributedString:mutableAttribute];

}

/*************************************************************************************
 *                                                                                   *
 *                             listbox: booksOfBible                                 *
 *                             =====================                                 *
 *                                                                                   *
 * Suite of methods to populate the search listbox.                                  *
 *                                                                                   *
 *************************************************************************************/

- (NSString *) getRequiredData: (NSString *) keyName forRow: (NSUInteger) row
{
    if( [keyName isEqualToString:colBooks])
    {
        return [booksOfBibleColumn objectAtIndex:row];
    }
    else
    {
        return nil;
    }
}

#pragma mark - Table View Data Source

- (NSInteger) numberOfRowsInTableView: (NSTableView *)tableView
{
    return booksOfBibleColumn.count;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [self getRequiredData: tableColumn.identifier forRow: row];
}


-(void)comboBoxSelectionDidChange: (NSNotification *)notification
{
    NSUInteger switchControl = 0, selectedItem, bookItem;
    NSString *returnedString;
    NSComboBox *cbResult;
 
    cbResult = (NSComboBox *)[notification object];
    selectedItem = [cbResult indexOfSelectedItem];
    bookItem = selectedItem;
    if( cbResult == cbNtBook ) switchControl = 1;
    if( cbResult == cbNtChapter )
    {
        bookItem = [cbNtBook indexOfSelectedItem];
        switchControl = 2;
    }
    if( cbResult == cbNtVerse ) switchControl = 3;
    if( cbResult == cbLxxBook ) switchControl = 4;
    if( cbResult == cbLxxChapter )
    {
        bookItem = [cbLxxBook indexOfSelectedItem];
        switchControl = 5;
    }
    if( cbResult == cbLxxVerse ) switchControl = 6;
    returnedString = [cbResult objectValueOfSelectedItem];
    if( [returnedString length] > 0 ) [mainTextHandler handleComboBoxChange:switchControl withListIndex:selectedItem andSelectedItem:returnedString andBookCode:bookItem];
}

- (void) locateCurrentTextView: (NSInteger) textViewCode forTextView: (NSInteger) testamentCode
{
    /**********************************************************************************************
     *                                                                                                             *
     *                                     locateCurrentTextView                                        *
     *                                     =====================                                        *
     *                                                                                                             *
     *  This is activated from classXXXXXTextView and records:                                     *
     *    a) which textView has currently experienced a mouse click;                               *
     *    b) if that is ntTextView or lxxTextView, then which testament                            *
     *                                                                                                             *
     *  The impacted variables are:                                                                *
     *                                                                                                             *
     *  textViewIndicator            This is an integer code that tells us which textView is the   *
     *                                    last registered and has possible values/significance:         *
     *                                       1   ntTextView                                             *
     *                                       2   lxxTextView                                            *
     *                                       3   parseTextView                                          *
     *                                       4   lexiconTextView                                        *
     *                                       5   searchResultsTextView                                  *
     *                                       6   vocabTextView                                          *
     *                                       7   notesTextView                                          *
     *  currentlyVisibleText         Indicates which testament is currently on view.  Possible    *
     *                                    values:                                                       *
     *                                       1  ntTextView                                              *
     *                                       2  lxxTextView                                             *
     *                                    (Note, this apparently duplicates textViewIndicator but it    *
     *                                     ensures that we can identify the currently active            *
     *                                     testament, even when we are processing other textViews.      *
     *                                                                                                             *
     **********************************************************************************************/
    
    if( testamentCode > 0 ) currentlyVisibleText = testamentCode;
    textViewIndicator = textViewCode;
}

- (void) mouseDownCursorRecord: (NSInteger) cursorPosition targetCode: (NSInteger) targetCode inVerse: (NSString *) verseRef containingLineRange: (NSRange) lineRange
     withRevisedCursorPosition: (NSInteger) revCsrPstn whichMouseButton: (NSInteger) mouseButton howManyClicks: (NSInteger) clickCount
{
    /***********************************************************************************************
     *                                                                                             *
     *                                     mouseDownCursorRecord                                   *
     *                                     =====================                                   *
     *                                                                                             *
     *  This method is called by classNtTextView and classLxxTextView and communicates back        *
     *    information about a mouse click.                                                         *
     *                                                                                             *
     *  Parameters:                                                                                *
     *  ----------                                                                                 *
     *                                                                                             *
     *  initial parameter     The absolute curso position within the whole text page               *
     *  targetCode            An integer value indicating the source textView                      *
     *                          1 = NT                                                             *
     *                          2 = LXX                                                            *
     *                          5 = Search Results                                                 *
     *  verseRef              The string verse "number", picked up from the text (zero-length      *
     *                          if not NT or LXX)                                                  *
     *  lineRange             The NSRange defining the line for the verse only                     *
     *  revisedCursorPosition (revCsrPstn) The cursor position in the line (as opposed to the      *
     *                                     entire text                                             *
     *  mouseButton           Which mouse button has been pressed:                                 *
     *                          0 = no information available                                       *
     *                          1 = left                                                           *
     *                          2 = right                                                          *
     *                          3 = any other button                                               *
     *  clickCount            How many times the button was clicked (0, if of no interest).        *
     *                                                                                             *
     ***********************************************************************************************/
    
    latestMouseButton = mouseButton;
    latestClickCount = clickCount;
    if( targetCode == 1)
    {
        if( [[cbNtVerse objectValues] containsObject:verseRef] ) [cbNtVerse selectItemWithObjectValue:verseRef];
        currentlyVisibleText = 1;
    }
    else
    {
        if( [[cbLxxVerse objectValues] containsObject:verseRef] ) [cbLxxVerse selectItemWithObjectValue:verseRef];
        currentlyVisibleText = 2;
    }
    latestCursorPosition = cursorPosition;
    latestLineRange = lineRange;
    latestRevisedCursorPosition = revCsrPstn;
}

-(void) remotePause: (NSString *) lab1Message withSecondMsg: (NSString *) lab2Message andOption: (BOOL) isChanged withOptionValue: (BOOL) isHidden
{
    [labProgress1 setStringValue:lab1Message];
    if( [lab2Message length] > 0) [labProgress2 setStringValue:lab2Message];
    if( isChanged) [labProgress2 setHidden:isHidden];
    [initialisationProgress incrementBy:1.0];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
}

- (void) splitViewDidResizeSubviews:(NSNotification *)notification
{
    if( notification.object == leftSplitView)
    {
        NSInteger splitPstn;
        
        if( isInLoadState) return;
        if( overrideSlide == 1)
        {
            [generalPurposeTimer invalidate];
            overrideSlide = 0;
        }
        isInLoadState = true;
        pstnControl = 0;
        splitPstn = [leftSplitView frame].size.height - 60;
        heightIndicator = 0;
        [leftSplitView setPosition:splitPstn ofDividerAtIndex:0];
        [btnKeyboard setTitle:@"Show Virtual Keyboard"];
        isInLoadState = false;
/*        if( heightIndicator == 0)
        {
            overrideSlide = 1;
            [leftSplitView setPosition:[leftSplitView frame].size.height - 1.7 * [keyboardHeader frame].size.height ofDividerAtIndex:0];
            overrideSlide = 0;
        } */
    }
}

- (void) tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    NSInteger bookId = 0, chapSeq = 0, verseSeq = 0;
    
    if( tabView == topLeftTabView )
    {
        if( tabViewItem == tabNewTestament)
        {
            currentlyVisibleText = 1;
            bookId = [cbNtBook indexOfSelectedItem];
            chapSeq = [cbNtChapter indexOfSelectedItem];
            verseSeq = [cbNtVerse indexOfSelectedItem];
        }
        if( tabViewItem == tabSeptuagint )
        {
            currentlyVisibleText = 2;
            bookId = [cbLxxBook indexOfSelectedItem];
            chapSeq = [cbLxxChapter indexOfSelectedItem];
            verseSeq = [cbLxxVerse indexOfSelectedItem];
        }
        [notesProcessing displayANote:currentlyVisibleText forBookId:bookId chapterSequence:chapSeq verseSequence:verseSeq];
        textViewIndicator = currentlyVisibleText;
    }
    if( tabView == topRightTabView)
    {
        if( tabViewItem == tabParse) textViewIndicator = 3;
        if( tabViewItem == tabLexicon) textViewIndicator = 4;
        if( tabViewItem == tabSearch) textViewIndicator = 5;
        if( tabViewItem == tabVocab) textViewIndicator = 6;
    }
    if( tabView == bottomRightTabView)
    {
        if( tabViewItem == tabNotes) textViewIndicator = 7;
    }
}

- (void) textDidEndEditing:(NSNotification *)notification
{
    NSTextView *currentTextView;
    
    currentTextView = (NSTextView *) [notification object];
    if (currentTextView == notesTextView)
    {
        [notesProcessing storeANote];
    }
}

/********************************************************************************
 *                                                                                            *
 *                      IBActions                                                  *
 *                      =========                                                  *
 *                                                                                            *
 ********************************************************************************/

- (IBAction)handleAnalyseMenuSelection:(NSMenuItem *)sender
{
    NSInteger bookId;
    NSString *verseLine, *chapterId, *verseId;
    NSTextView *targetTextSource;
    
    if( currentlyVisibleText == 1)
    {
        targetTextSource = ntTextView;
        bookId = [cbNtBook indexOfSelectedItem];
        chapterId = [[NSString alloc] initWithString:[cbNtChapter objectValueOfSelectedItem]];
        verseId = [[NSString alloc] initWithString:[cbNtVerse objectValueOfSelectedItem]];
    }
    else
    {
        targetTextSource = lxxTextView;
        bookId = [cbLxxBook indexOfSelectedItem];
        chapterId = [[NSString alloc] initWithString:[cbLxxChapter objectValueOfSelectedItem]];
        verseId = [[NSString alloc] initWithString:[cbLxxVerse objectValueOfSelectedItem]];
    }
    verseLine = [[NSString alloc] initWithString:[[targetTextSource string] substringWithRange:latestLineRange]];
    [mainTextHandler performAnalysis:verseLine withCursorPosition:latestRevisedCursorPosition oldOrNew:(currentlyVisibleText == 1) forBookId:bookId andChapterId:chapterId andVerseId:verseId];
}

- (IBAction)doShowKeyboard:(id)sender;
{
    if( [[btnKeyboard title] compare:@"Show Virtual Keyboard"] == NSOrderedSame)
    {
        generalPurposeTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(showKeyboard:) userInfo:nil repeats:YES];
    }
    else
    {
        generalPurposeTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(hideKeyboard:) userInfo:nil repeats:YES];
    }
}

- (void) showKeyboard: (id) sender
{
    NSInteger splitPstn;
    
    overrideSlide = 1;
    isInLoadState = true;
    pstnControl += 2;
    splitPstn = [leftSplitView frame].size.height - (pstnControl + 60);
    [leftSplitView setPosition:splitPstn ofDividerAtIndex:0];
    if( pstnControl >= 215)
    {
        [generalPurposeTimer invalidate];
        [btnKeyboard setTitle:@"Hide Virtual Keyboard"];
        overrideSlide = 0;
        isInLoadState = false;
    }
/*    NSInteger positionMarker, obverallMarker;
    
    heightIndicator = 1;
    overrideSlide = 1;
    pstnControl += 2;
    if( highWaterMark == 0 ) highWaterMark = [leftSplitView maxPossiblePositionOfDividerAtIndex:0] - pstnControlMaster;
    positionMarker = [leftSplitView maxPossiblePositionOfDividerAtIndex:0] - pstnControl;
    obverallMarker = [leftSplitView maxPossiblePositionOfDividerAtIndex:0] - pstnControlMaster;
    [leftSplitView setPosition:[leftSplitView maxPossiblePositionOfDividerAtIndex:0] - pstnControl ofDividerAtIndex:0];
    if( pstnControl >= highWaterMark + 150 )
    {
        [generalPurposeTimer invalidate];
        [btnKeyboard setTitle:@"Hide Virtual Keyboard"];
        overrideSlide = 0;
    } */
}

- (void) hideKeyboard: (id) sender
{
    NSInteger splitPstn;
    
    overrideSlide = 1;
    isInLoadState = true;
    pstnControl -= 2;
    splitPstn = [leftSplitView frame].size.height - (pstnControl + 60);
    [leftSplitView setPosition:splitPstn ofDividerAtIndex:0];
    if( pstnControl <= 0)
    {
        [generalPurposeTimer invalidate];
        [btnKeyboard setTitle:@"Show Virtual Keyboard"];
        overrideSlide = 0;
        isInLoadState = false;
    }
/*    NSInteger positionMarker, obverallMarker;
    
    heightIndicator = 0;
    overrideSlide = 1;
    pstnControl -= 2;
    positionMarker = [leftSplitView maxPossiblePositionOfDividerAtIndex:0] - pstnControl;
    obverallMarker = [leftSplitView maxPossiblePositionOfDividerAtIndex:0] - pstnControlMaster;
    [leftSplitView setPosition:[leftSplitView maxPossiblePositionOfDividerAtIndex:0] - pstnControl ofDividerAtIndex:0];
    if( pstnControl <= [leftSplitView maxPossiblePositionOfDividerAtIndex:0] - pstnControlMaster )
    {
        [generalPurposeTimer invalidate];
        [btnKeyboard setTitle:@"Show Virtual Keyboard"];
        overrideSlide = 0;
    } */
//    pstnControlMaster = [leftSplitView frame].size.height - 1.7 * [keyboardHeader frame].size.height;
//    [leftSplitView setPosition:pstnControlMaster ofDividerAtIndex:0];
}

- (IBAction)basicOrAdvancedOption:(id)sender
{
    [self basicOrAdvancedSlave:true];
}

-(IBAction)doSendWordToSearch:(id)sender
{
    NSInteger bookId;
    NSString *startingText, *requiredItem, *chapterCode, *verseCode;
    NSRange lineRange, itemRange, csrRange;
    NSTextView *sourceOfText;

    csrRange = NSMakeRange(latestRevisedCursorPosition, 0);
    lineRange = latestLineRange;
    switch (currentlyVisibleText)
    {
        case 1:
            sourceOfText = ntTextView;
            startingText = [[sourceOfText string] substringWithRange:lineRange];
            break;
        case 2:
            sourceOfText = lxxTextView;
            startingText = [[sourceOfText string] substringWithRange:lineRange];
            break;
        default: break;
    }
    itemRange = [self manufactureRange:csrRange inText:startingText];
    requiredItem = [[NSString alloc] initWithString:[startingText substringWithRange:itemRange]];
    [bottomRightTabView selectTabViewItemAtIndex:2];
    [primarySearchWord setString:requiredItem];
    // Now store the source of the word
    if( currentlyVisibleText == 1)
    {
        bookId = [cbNtBook indexOfSelectedItem];
        chapterCode = [cbNtChapter objectValueOfSelectedItem];
        verseCode = [cbNtVerse objectValueOfSelectedItem];
    }
    else
    {
        bookId = [cbLxxBook indexOfSelectedItem];
        chapterCode = [cbLxxChapter objectValueOfSelectedItem];
        verseCode = [cbLxxVerse objectValueOfSelectedItem];
    }
    searchRecord.primaryTestament = currentlyVisibleText;
    searchRecord.primaryBookId = bookId;
    searchRecord.primaryChapterCode = [[NSString alloc] initWithString:chapterCode];
    searchRecord.primaryVerseCode = [[NSString alloc] initWithString:verseCode];
}

- (IBAction)doSendSecondaryToSearch:(id)sender
{
    NSInteger bookId;
    NSString *startingText, *requiredItem, *chapterCode, *verseCode;
    NSRange lineRange, itemRange, csrRange;
    NSTextView *sourceOfText;
    
    csrRange = NSMakeRange(latestRevisedCursorPosition, 0);
    lineRange = latestLineRange;
    switch (currentlyVisibleText)
    {
        case 1:
            sourceOfText = ntTextView;
            startingText = [[sourceOfText string] substringWithRange:lineRange];
            break;
        case 2:
            sourceOfText = lxxTextView;
            startingText = [[sourceOfText string] substringWithRange:lineRange];
            break;
        default: break;
    }
    itemRange = [self manufactureRange:csrRange inText:startingText];
    requiredItem = [[NSString alloc] initWithString:[startingText substringWithRange:itemRange]];
    [bottomRightTabView selectTabViewItemAtIndex:2];
    [self basicOrAdvancedSlave:false];
    [secondarySearchWord setString:requiredItem];
    // Now store the source of the word
    if( currentlyVisibleText == 1)
    {
        bookId = [cbNtBook indexOfSelectedItem];
        chapterCode = [cbNtChapter objectValueOfSelectedItem];
        verseCode = [cbNtVerse objectValueOfSelectedItem];
    }
    else
    {
        bookId = [cbLxxBook indexOfSelectedItem];
        chapterCode = [cbLxxChapter objectValueOfSelectedItem];
        verseCode = [cbLxxVerse objectValueOfSelectedItem];
    }
    searchRecord.secondaryTestament = currentlyVisibleText;
    searchRecord.secondaryBookId = bookId;
    searchRecord.secondaryChapterCode = [[NSString alloc] initWithString:chapterCode];
    searchRecord.secondaryVerseCode = [[NSString alloc] initWithString:verseCode];
}

-(NSRange) manufactureRange: (NSRange) selectionRange inText: (NSString *) sourceText
{
    NSUInteger startPstn, endPstn;
    NSRange startRange, endRange;
    
    startRange = [sourceText rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
                                                        options:NSLiteralSearch | NSBackwardsSearch range:NSMakeRange(0, selectionRange.location)];
    endRange = [sourceText rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
                                                      options:NSLiteralSearch range:NSMakeRange(selectionRange.location, [sourceText length] - selectionRange.location)];
    if( startRange.location == NSNotFound ) startPstn = 0;
    else startPstn = startRange.location + 1;
    if( endRange.location == NSNotFound ) endPstn = [sourceText length] - 1;
    else endPstn = endRange.location - 1;
    return NSMakeRange(startPstn, endPstn - startPstn + 1);    
}

- (void) basicOrAdvancedSlave: (BOOL) isButtonPress
{
    NSString *buttonTitle;
    
    if( isButtonPress ) buttonTitle = [advancedSearch title];
    else buttonTitle = @"Advanced Search";
    if( [buttonTitle compare:@"Advanced Search"] == NSOrderedSame)
    {
        [advancedSearch setTitle:@"Basic Search"];
        [labWithin setHidden:NO];
        [txtWordSeperation setHidden:NO];
        [stepperWordSeperation setHidden:NO];
        [labWordsOf setHidden:NO];
        [secondarySuperView setHidden:NO];
    }
    else
    {
        [advancedSearch setTitle:@"Advanced Search"];
        [labWithin setHidden:YES];
        [txtWordSeperation setHidden:YES];
        [stepperWordSeperation setHidden:YES];
        [labWordsOf setHidden:YES];
        [secondarySuperView setHidden:YES];
    }
}

- (IBAction)removeSelected:(id)sender
{
    NSIndexSet *listboxIndexes;
    
    listboxIndexes = [booksOfBible selectedRowIndexes];
    [booksOfBible removeRowsAtIndexes:listboxIndexes withAnimation:(NSTableViewAnimationEffectFade)];
}

- (IBAction)reinstateListbox:(id)sender
{
//    booksOfBibleColumn = [[NSMutableArray alloc] initWithArray:booksMaster];
    [self searchOptionCheckedChanged:sender];
    [booksOfBible reloadData];
}

- (IBAction)searchOptionCheckedChanged:(id)sender
{
    /*=====================================================================================*
     *                                                                                     *
     *                           searchOptionCheckedChanged                                *
     *                           ==========================                                *
     *                                                                                     *
     *  This is all about managing selection of the radio buttons and check boxes that     *
     *    limit/activate groups of books.  A key control are the following constants and   *
     *    their explanations are:                                                          *
     *                                                                                     *
     *  The first three relate to groups of works in the New Testament, as follows:        *
     *    maxGospelsIdx  The *maximum* value for this group (i.e. the range from 1 to 5)   *
     *    maxPaulIdx     The *maximum* value for Paul's letters (so this, in effect, goes  *
     *                   from 6 (defined by maxGospelIdx) to 18)                           *
     *    maxRestIdx     Up to noOfNTBooks                                                 *
     *                                                                                     *
     *  Similarly, the following four define groups for the Septuagint:                    *
     *    maxMosesIdx    The maximum book value for the Pentateuch                         *
     *    maxHistoryIdx  Books designated as "history"                                     *
     *    maxWisdomIdx   Books in the Wisdom category                                      *
     *    maxProphetsIds The rest                                                          *
     *                                                                                     *
     *=====================================================================================*/
    
    [booksOfBibleColumn removeAllObjects];
    if ( [rbtnExclude state] == NSControlStateValueOn )
    {
        if ( [chkGospels state] == NSControlStateValueOff ) [booksOfBibleColumn addObjectsFromArray:[globalVars gospels]];
        if ( [chkPaul state] == NSControlStateValueOff ) [booksOfBibleColumn addObjectsFromArray:[globalVars paul]];
        if ( [chkRest state] == NSControlStateValueOff ) [booksOfBibleColumn addObjectsFromArray:[globalVars restOfNT]];
        if ( [chkMoses state] == NSControlStateValueOff ) [booksOfBibleColumn addObjectsFromArray:[globalVars Pent]];
        if ( [chkHistory state] == NSControlStateValueOff ) [booksOfBibleColumn addObjectsFromArray:[globalVars history]];
        if ( [chkWisdom state] == NSControlStateValueOff ) [booksOfBibleColumn addObjectsFromArray:[globalVars wisdom]];
        if ( [chkProphets state] == NSControlStateValueOff ) [booksOfBibleColumn addObjectsFromArray:[globalVars prophets]];
    }
    else
    {
        if ( [chkGospels state] == NSControlStateValueOn ) [booksOfBibleColumn addObjectsFromArray:[globalVars gospels]];
        if ( [chkPaul state] == NSControlStateValueOn ) [booksOfBibleColumn addObjectsFromArray:[globalVars paul]];
        if ( [chkRest state] == NSControlStateValueOn ) [booksOfBibleColumn addObjectsFromArray:[globalVars restOfNT]];
        if ( [chkMoses state] == NSControlStateValueOn ) [booksOfBibleColumn addObjectsFromArray:[globalVars Pent]];
        if ( [chkHistory state] == NSControlStateValueOn ) [booksOfBibleColumn addObjectsFromArray:[globalVars history]];
        if ( [chkWisdom state] == NSControlStateValueOn ) [booksOfBibleColumn addObjectsFromArray:[globalVars wisdom]];
        if ( [chkProphets state] == NSControlStateValueOn ) [booksOfBibleColumn addObjectsFromArray:[globalVars prophets]];
    }
    [booksOfBible reloadData];
}

- (IBAction)doSearch:(id)sender
{
    bool complexityFlag;
    NSInteger testamentCode, bookIdx, idx, noInListbox, noOfArrayEntries, searchCode, sourceForSecondary, finalSecondaryBookCode;
    NSString *chapCode, *verseCode, *tableEntry, *secondWord, *finalSecondaryChapterCode, *finalSecondaryVerseCode, *arrayElement;
    NSMutableAttributedString *interimText;
    NSArray *searchResults;
    NSMutableArray *ntList, *lxxList;
    NSTableCellView *cellForInspection;
    NSTextField *resultingText;
    NSColor *fgColour, *primaryColour, *secondaryColour;
    
    testamentCode = currentlyVisibleText;
    if( testamentCode == 1 )
    {
        bookIdx = [cbNtBook indexOfSelectedItem];
        chapCode = [cbNtChapter objectValueOfSelectedItem];
        verseCode = [cbNtVerse objectValueOfSelectedItem];
    }
    if( testamentCode == 2 )
    {
        bookIdx = [cbLxxBook indexOfSelectedItem];
        chapCode = [cbLxxChapter objectValueOfSelectedItem];
        verseCode = [cbLxxVerse objectValueOfSelectedItem];
    }
    if( testamentCode > 2 )
    {
        bookIdx = -1;
        chapCode = nil;
        verseCode = nil;
    }
    if( [btnRoot state] == NSControlStateValueOn) searchCode = 1;
    else searchCode = 2;
    noInListbox = [booksOfBible numberOfRows];
    ntList = [[NSMutableArray alloc] init];
    lxxList = [[NSMutableArray alloc] init];
    for( idx = 0; idx < noInListbox; idx++)
    {
        cellForInspection = [booksOfBible viewAtColumn:0 row:idx makeIfNecessary:YES];
        resultingText = [cellForInspection textField];
        tableEntry = [[NSString alloc] initWithString:[resultingText stringValue]];
        if( [[globalVars gospels] containsObject:tableEntry]) [ntList addObject:[NSNumber numberWithInteger:[[globalVars gospels] indexOfObject:tableEntry]]];
        if( [[globalVars paul] containsObject:tableEntry]) [ntList addObject:[NSNumber numberWithInteger:([[globalVars paul] indexOfObject:tableEntry] + 5 )]];
        if( [[globalVars restOfNT] containsObject:tableEntry]) [ntList addObject:[NSNumber numberWithInteger:([[globalVars restOfNT] indexOfObject:tableEntry] + 18 )]];
        if( [[globalVars Pent] containsObject:tableEntry]) [lxxList addObject:[NSNumber numberWithInteger:[[globalVars Pent] indexOfObject:tableEntry]]];
        if( [[globalVars history] containsObject:tableEntry]) [lxxList addObject:[NSNumber numberWithInteger:([[globalVars history] indexOfObject:tableEntry] + 5 )]];
        if( [[globalVars wisdom] containsObject:tableEntry]) [lxxList addObject:[NSNumber numberWithInteger:([[globalVars wisdom] indexOfObject:tableEntry] + 27 )]];
        if( [[globalVars prophets] containsObject:tableEntry]) [lxxList addObject:[NSNumber numberWithInteger:([[globalVars prophets] indexOfObject:tableEntry] + 36 )]];
    }
    if( [[advancedSearch title] compare:@"Advanced Search"] == NSOrderedSame)
    {
        complexityFlag = false;
        secondWord = nil;
        sourceForSecondary = 0;
        finalSecondaryBookCode = -1;
        finalSecondaryChapterCode = nil;
        finalSecondaryVerseCode = nil;
    }
    else
    {
        complexityFlag = true;
        secondWord = [[NSString alloc] initWithString:[secondarySearchWord string]];
        sourceForSecondary = [searchRecord secondaryTestament];
        finalSecondaryBookCode = [searchRecord secondaryBookId];
        finalSecondaryChapterCode = [searchRecord secondaryChapterCode];
        finalSecondaryVerseCode = [searchRecord secondaryVerseCode];
    }
    [topRightTabView selectTabViewItemAtIndex:2];
    [topRightTabView setNeedsDisplay:YES];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
    searchResults = [searchProcedures performSearch:[primarySearchWord string] primarySource:[searchRecord primaryTestament] bookCode:[searchRecord primaryBookId] chapter:[searchRecord primaryChapterCode] verse:[searchRecord primaryVerseCode] withSecondWord:secondWord secondarySource:sourceForSecondary last2ryBook:finalSecondaryBookCode last2ryChapter:finalSecondaryChapterCode last2ryVerse:finalSecondaryVerseCode searchComplexity:complexityFlag searchType:searchCode wordDistance:[[txtWordSeperation stringValue] integerValue] ntBooksToSearch:ntList lxxBooksToSearch:lxxList];
    fgColour = [[globalVars fgColour] objectAtIndex:4];
    primaryColour = [globalVars searchPrimaryColour];
    secondaryColour = [globalVars searchSecondaryColour];
    noOfArrayEntries = [searchResults count];
    [statusLabel setStringValue:@"Populating Search Results with matches found"];
    for( idx = 0; idx < noOfArrayEntries; idx += 2)
    {
        arrayElement = [[NSString alloc] initWithString:[searchResults objectAtIndex:idx]];
        if( [arrayElement containsString:@":"] )
        {
            [statusLabel2 setStringValue:[[NSString alloc] initWithFormat:@"Current record: %@", arrayElement]];
            topRightTabView.needsDisplay = true;
            [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
        }
        interimText = [[NSMutableAttributedString alloc] initWithString:arrayElement];
        arrayElement = [[NSString alloc] initWithString:[searchResults objectAtIndex:(idx + 1)]];
        if( [arrayElement compare:@"0"] == 0) [interimText addAttribute:NSForegroundColorAttributeName value:fgColour range:NSMakeRange(0, [interimText length])];
        else
        {
            if( [arrayElement compare:@"1"] == 0) [interimText addAttribute:NSForegroundColorAttributeName value:primaryColour range:NSMakeRange(0, [interimText length])];
            else [interimText addAttribute:NSForegroundColorAttributeName value:secondaryColour range:NSMakeRange(0, [interimText length])];
        }
        if( idx == 0 ) [[searchTextView textStorage] setAttributedString:interimText];
        else [[searchTextView textStorage] appendAttributedString:interimText];
    }
    [statusLabel setStringValue:@"Search completed successfully"];
    [statusLabel2 setHidden:true];
}

- (IBAction)doCreateVocabList:(id)sender
{
    NSInteger vocabCheckCount = 0;
    NSInteger idx, displayCode = 0, listCode = 0, wordTypeCode = 0;
    NSMutableArray *selectedVocabTypes;

    selectedVocabTypes = [[NSMutableArray alloc] init];
    if( [self actionSelection: chkNouns withControl:selectedVocabTypes] ) vocabCheckCount++;
    if( [self actionSelection: chkVerbs withControl:selectedVocabTypes] ) vocabCheckCount++;
    if( [self actionSelection: chkAdjectives withControl:selectedVocabTypes] ) vocabCheckCount++;
    if( [self actionSelection: chkAdverbs withControl:selectedVocabTypes] ) vocabCheckCount++;
    if( [self actionSelection: chkPrepositions withControl:selectedVocabTypes] ) vocabCheckCount++;
    if( [self actionSelection: chkOther withControl:selectedVocabTypes] ) vocabCheckCount++;
    if( vocabCheckCount == 6)
    {
        [selectedVocabTypes removeAllObjects];
        for( idx = 0; idx < 6; idx++) [selectedVocabTypes addObject:@1]; // Set it as if all had been checked
    }
    if( [rbtnDisplayTypeAlpha state] == NSControlStateValueOn) displayCode = 1;
    if( [rbtnDisplayTypeOrder state] == NSControlStateValueOn) displayCode = 2;
    if( [rbtnDisplayMixedAlpha state] == NSControlStateValueOn) displayCode = 3;
    if( [rbtnDisplayMixedOrder state] == NSControlStateValueOn) displayCode = 4;
    if( [rbtnListVerse state] == NSControlStateValueOn) listCode = 1;
    if( [rbtnListChapter state] == NSControlStateValueOn) listCode = 2;
    if( [rbtnActualWords state] == NSControlStateValueOn ) wordTypeCode = 1;
    if( [rbtnRootWords state] == NSControlStateValueOn ) wordTypeCode = 2;
    if( [rbtnActualAndRoot state] == NSControlStateValueOn ) wordTypeCode = 3;
    [topRightTabView selectTabViewItemAtIndex:3];
    [vocabLists makeVocabList:currentlyVisibleText checkedPos:selectedVocabTypes listCode:listCode displayCode:displayCode typeCode:wordTypeCode];
    [vocabTextView setFont:[NSFont fontWithName:@"Lucida Console" size:13.0]];
}

- (BOOL) actionSelection: (NSButton *) inspectedRButton withControl: (NSMutableArray *) selectedVocabTypes
{
    if( [inspectedRButton state] == NSControlStateValueOn )
    {
        [selectedVocabTypes addObject:@1];
        return true;
    }
    [selectedVocabTypes addObject:@0];
    return false;
}

- (IBAction)resetTextDetails:(id)sender
{
    NSInteger idx, noOfDecompUnits, testamentCode = 0, bookId;
    NSRange colonRange;
    NSString *searchText, *currentResultLine, *chapRef, *vRef;
    NSMutableString *bookRef;
    NSArray *vDecomp, *refDecomp;
    
    currentResultLine = [[searchTextView string] substringWithRange:latestLineRange];
    colonRange = [currentResultLine rangeOfString:@":"];
    if( colonRange.location == NSNotFound) return;
    searchText = [[NSString alloc] initWithString:[currentResultLine substringToIndex:colonRange.location]];
    vDecomp = [searchText componentsSeparatedByString:@"."];
    if( [vDecomp count] < 2) return;
    vRef = [[NSString alloc] initWithString:[vDecomp objectAtIndex:1]];
    searchText = [[NSString alloc] initWithString:[vDecomp objectAtIndex:0]];
    refDecomp = [[NSArray alloc] initWithArray:[searchText componentsSeparatedByString:@" "]];
    noOfDecompUnits = [refDecomp count];
    if( noOfDecompUnits < 2 ) return;
    if( noOfDecompUnits == 2 )
    {
        bookRef = [[NSMutableString alloc] initWithString:[refDecomp objectAtIndex:0]];
        chapRef = [[NSString alloc] initWithString:[refDecomp objectAtIndex:1]];
    }
    else
    {
        bookRef = [[NSMutableString alloc] init];
        for( idx = 0; idx < noOfDecompUnits - 1; idx++)
        {
            if( idx == 0 ) [bookRef appendString:[refDecomp objectAtIndex:0]];
            else [bookRef appendFormat:@" %@", [refDecomp objectAtIndex:idx]];
        }
        chapRef = [refDecomp objectAtIndex:noOfDecompUnits - 1];
    }
    // So, bookRef = book name, chapRef is the text version of the chapter
    while (1)
    {
        if( [[globalVars gospels] containsObject:bookRef])
        {
            testamentCode = 1;
            bookId = [[globalVars gospels] indexOfObject:bookRef];
            break;
        }
        if( [[globalVars paul] containsObject:bookRef])
        {
            testamentCode = 1;
            bookId = [[globalVars paul] indexOfObject:bookRef] + 5;
            break;
        }
        if( [[globalVars restOfNT] containsObject:bookRef])
        {
            testamentCode = 1;
            bookId = [[globalVars restOfNT] indexOfObject:bookRef] + 18;
            break;
        }
        if( [[globalVars Pent] containsObject:bookRef])
        {
            testamentCode = 2;
            bookId = [[globalVars Pent] indexOfObject:bookRef];
            break;
        }
        if( [[globalVars history] containsObject:bookRef])
        {
            testamentCode = 2;
            bookId = [[globalVars history] indexOfObject:bookRef] + 5;
            break;
        }
        if( [[globalVars wisdom] containsObject:bookRef])
        {
            testamentCode = 2;
            bookId = [[globalVars wisdom] indexOfObject:bookRef] + 26;
            break;
        }
        if( [[globalVars prophets] containsObject:bookRef])
        {
            testamentCode = 2;
            bookId = [[globalVars prophets] indexOfObject:bookRef] + 35;
            break;
        }
        return;
    }
    if( testamentCode == 1)
    {
        [topLeftTabView selectTabViewItemAtIndex:0];
        [mainTextHandler displayNTChapter:bookId forChapter:chapRef withNewBookFlag:YES];
        [cbNtVerse selectItemWithObjectValue:vRef];
    }
    if( testamentCode == 2)
    {
        [topLeftTabView selectTabViewItemAtIndex:1];
        [mainTextHandler displayLxxChapter:bookId forChapter:chapRef withNewBookFlag:YES];
        [cbLxxVerse selectItemWithObjectValue:vRef];
    }
}

- (IBAction)doResize:(id)sender
{
    NSInteger popupItem;
    NSPopUpButton *popupButton;
    
    popupButton = (NSPopUpButton *) sender;
    popupItem = [popupButton indexOfSelectedItem];
    switch (popupItem)
    {
        case 0: generalPurposeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(actResize0:) userInfo:nil repeats:YES]; break;
        case 1: generalPurposeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(actResize1:) userInfo:nil repeats:YES]; break;
        case 2: generalPurposeTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(actResize2:) userInfo:nil repeats:YES]; break;
        default:break;
    }
}

- (void) actResize0: (id) sender
{
    rightPstnControl += 2;
    [rightSplitView setPosition:rightPstnControl ofDividerAtIndex:0];
    if( rightPstnControl >= [rightSplitView maxPossiblePositionOfDividerAtIndex:0] )
    {
        [generalPurposeTimer invalidate];
    }
}

- (void) actResize1: (id) sender
{
    rightPstnControl -= 2;
    [rightSplitView setPosition:rightPstnControl ofDividerAtIndex:0];
    if( rightPstnControl <= [rightSplitView minPossiblePositionOfDividerAtIndex:0] )
    {
        [generalPurposeTimer invalidate];
    }
}

- (void) actResize2: (id) sender
{
    if( rightPstnControl < [globalVars dividerPstn])
    {
        rightPstnControl += 2;
        [rightSplitView setPosition:rightPstnControl ofDividerAtIndex:0];
        if( rightPstnControl >= [globalVars dividerPstn] )
        {
            [generalPurposeTimer invalidate];
        }
    }
    else
    {
        rightPstnControl -= 2;
        [rightSplitView setPosition:rightPstnControl ofDividerAtIndex:0];
        if( rightPstnControl <= [globalVars dividerPstn] )
        {
            [generalPurposeTimer invalidate];
        }
    }
}

- (IBAction)doPrevOrNextChapter:(NSButton *)sender
{
    NSInteger tagVal;
    
    tagVal = [sender tag];
    [mainTextHandler prevOrNextChapter:tagVal forTestament:currentlyVisibleText];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*
 *                                                                               *
 *                              copyToPasteboard                                 *
 *                              ================                                 *
 *                                                                               *
 *  Despite the name, this handles the copy of text to both the Pasteboard (aka  *
 *    clipboard, or, in my language, "memory") and to the notes area.  The       *
 *    different case actions (based on textViewIndicator) manage handling by     *
 *    different textViews.                                                       *
 *                                                                               *
 *+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

-(IBAction)copyToPasteboard:(id)sender
{
    NSInteger tagVal;
    NSString *startingText, *resultingText, *displayRef, *alertMessage, *requiredItem, *parseText, *lexiconText, *searchText;
    NSRange lineRange, itemRange, csrRange;
    NSTextView *sourceOfText;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    
    tagVal = [sender tag];
    csrRange = NSMakeRange(latestRevisedCursorPosition, 0);
    lineRange = latestLineRange;
    switch (textViewIndicator)
    {
        case 1:
            sourceOfText = ntTextView;
            cbBook = cbNtBook;
            cbChapter = cbNtChapter;
            cbVerse = cbNtVerse;
            startingText = [[sourceOfText string] substringWithRange:lineRange];
            break;
        case 2:
            sourceOfText = lxxTextView;
            cbBook = cbLxxBook;
            cbChapter = cbLxxChapter;
            cbVerse = cbLxxVerse;
            startingText = [[sourceOfText string] substringWithRange:lineRange];
            break;
        case 3:
        case 4:
            sourceOfText = parseTextView;
            parseText = [[NSString alloc] initWithString:[sourceOfText string]];
            sourceOfText = lexiconTextView;
            lexiconText = [[NSString alloc] initWithString:[sourceOfText string]];
            break;
        case 5:
            sourceOfText = searchTextView;
            searchText = [[NSString alloc] initWithString:[sourceOfText string]];
            startingText = [[sourceOfText string] substringWithRange:lineRange];
            break;
        default:
            break;
    }
    switch (tagVal)
    {
        case 1:
        case 2:
        case 3:
        case 4:
            displayRef = [[NSString alloc] initWithFormat:@"%@ %@.%@: ", [cbBook objectValueOfSelectedItem], [cbChapter objectValueOfSelectedItem], [cbVerse objectValueOfSelectedItem]];
            itemRange = [self manufactureRange:csrRange inText:startingText];
            requiredItem = [[NSString alloc] initWithString:[startingText substringWithRange:itemRange]];
            if(( tagVal == 1 ) || ( tagVal == 3 ) ) resultingText = [[NSString alloc] initWithFormat:@"%@ %@", displayRef, requiredItem];
            else resultingText = [[NSString alloc] initWithFormat:@"%@", requiredItem];
            alertMessage = [[NSString alloc] initWithFormat:@"The word, %@, was successfully copied", requiredItem];
            if( ( tagVal == 1 ) || ( tagVal == 2 ) ) [self pasteText:resultingText AlertMessage:alertMessage AlertTitle:@"Copy a Word"];
            else [self pasteIntoNotes:resultingText];
            break;
        case 5:
        case 6:
        case 7:
        case 8:
            displayRef = [[NSString alloc] initWithFormat:@"%@ %@.%@: ", [cbBook objectValueOfSelectedItem], [cbChapter objectValueOfSelectedItem], [cbVerse objectValueOfSelectedItem]];
            requiredItem = [[NSString alloc] initWithString:startingText];
            if(( tagVal == 5 ) || ( tagVal == 7 ) ) resultingText = [[NSString alloc] initWithFormat:@"%@ %@", displayRef, requiredItem];
            else resultingText = [[NSString alloc] initWithFormat:@"%@", requiredItem];
            alertMessage = [[NSString alloc] initWithFormat:@"The verse, %@, was successfully copied", displayRef];
            if( ( tagVal == 5 ) || ( tagVal == 6 ) ) [self pasteText:resultingText AlertMessage:alertMessage AlertTitle:@"Copy a Verse"];
            else [self pasteIntoNotes:resultingText];
            break;
        case 9:
        case 10:
        case 11:
        case 12:
            displayRef = [[NSString alloc] initWithFormat:@"%@ %@\n\n", [cbBook objectValueOfSelectedItem], [cbChapter objectValueOfSelectedItem]];
            requiredItem = [sourceOfText string];
            if(( tagVal == 9 ) || ( tagVal == 11 ) ) resultingText = [[NSString alloc] initWithFormat:@"%@%@", displayRef, requiredItem];
            else resultingText = [[NSString alloc] initWithFormat:@"%@", requiredItem];
            alertMessage = [[NSString alloc] initWithFormat:@"The chapter, %@, was successfully copied", displayRef];
            if( ( tagVal == 9 ) || ( tagVal == 10 ) ) [self pasteText:resultingText AlertMessage:alertMessage AlertTitle:@"Copy a Chapter"];
            else [self pasteIntoNotes:resultingText];
            break;
        case 13:
        case 14:
            csrRange = [sourceOfText selectedRange];
            if( csrRange.location == NSNotFound ) return;
            if( csrRange.length == 0 ) return;
            resultingText = [[NSString alloc] initWithString:[[sourceOfText string] substringWithRange:csrRange]];
            alertMessage = [[NSString alloc] initWithFormat:@"The selected text was successfully copied"];
            if( tagVal == 13 ) [self pasteText:resultingText AlertMessage:alertMessage AlertTitle:@"Copy selected text"];
            else [self pasteIntoNotes:resultingText];
            break;
        case 17:
            [self pasteText:parseText AlertMessage:@"Parse information was successfully copied" AlertTitle:@"Copy Parse Information"]; break;
        case 18:
            [self pasteIntoNotes:parseText]; break;
        case 19:
            [self pasteText:lexiconText AlertMessage:@"Lexicon information was successfully copied" AlertTitle:@"Copy Lexicon Information"]; break;
        case 20:
            [self pasteIntoNotes:lexiconText]; break;
        case 21:
            resultingText = [[NSString alloc] initWithFormat:@"%@\n\n%@", parseText, lexiconText];
            [self pasteText:resultingText AlertMessage:@"Parse and Lexicon information was successfully copied" AlertTitle:@"Copy Parse and Lexicon Information"]; break;
        case 22:
            alertMessage = @"Parse and Lexicon information was successfully copied";
            resultingText = [[NSString alloc] initWithFormat:@"%@\n\n%@", parseText, lexiconText];
            [self pasteIntoNotes:resultingText]; break;
        case 23:
        case 24:
            alertMessage = @"All search results were successfully copied";
            if( tagVal == 23 ) [self pasteText:searchText AlertMessage:alertMessage AlertTitle:@"Copy All Search Results"];
            else [self pasteIntoNotes:searchText];
            break;
        case 25:
        case 26:
            alertMessage = @"The selected result was successfully copied";
            if( tagVal == 25 ) [self pasteText:startingText AlertMessage:alertMessage AlertTitle:@"Copy Specific Search Result"];
            else [self pasteIntoNotes:startingText];
            break;
        default:
            break;
    }
}

/*******************************************************************************
 *                                                                             *
 *                               pasteText                                     *
 *                               =========                                     *
 *                                                                             *
 *  Handles inserting text (copied from Bible Text or other areas) into the    *
 *    "Pasteboard" (i.e. memory)                                               *
 *                                                                             *
 *******************************************************************************/

-(void) pasteText: (NSString *) textToPaste AlertMessage: (NSString *) alertMessageText AlertTitle: (NSString *) alertInfoText
{
    NSPasteboard *standardPasteboard;
    GBSAlert *alert;
    
    standardPasteboard = [NSPasteboard generalPasteboard];
    [standardPasteboard clearContents];
    if( ( textToPaste != nil ) && ( [textToPaste length] > 0 ) )
    {
        [standardPasteboard setString:textToPaste forType:NSPasteboardTypeString];
        alert = [GBSAlert new];
        [alert messageBox:alertMessageText title:alertInfoText boxStyle:NSAlertStyleInformational];
    }
}

/*******************************************************************************
 *                                                                             *
 *                             pasteIntoNotes                                  *
 *                             ==============                                  *
 *                                                                             *
 *  Handles inserting text (copied from Bible Text or other areas) into the    *
 *    current note.  The only real complexity is if the current cursor is in   *
 *    the middle of text.                                                      *
 *                                                                             *
 *******************************************************************************/

- (void) pasteIntoNotes: (NSString *) textToPaste
{
    NSRange selRange;
    NSString *notesText, *leftText, *rightText;
    
    if( ( textToPaste == nil ) || ( [textToPaste length] == 0 ) ) return;
    [bottomRightTabView selectTabViewItemAtIndex:0];
    selRange = [notesTextView selectedRange];
    notesText = [notesTextView string];
    if( [notesText length] == 0 )
    {
        [notesTextView setString:textToPaste];
        [notesTextView setSelectedRange:(NSMakeRange([textToPaste length] - 1, 0))];
    }
    else
    {
        if( selRange.location == 0 )
        {
            [notesTextView setString:[[NSString alloc] initWithFormat:@"%@%@", textToPaste, notesText]];
            [notesTextView setSelectedRange:(NSMakeRange([textToPaste length] - 1, 0))];
        }
        else
        {
            if( selRange.location == ([notesText length] -1 ) )
            {
                [notesTextView setString:[[NSString alloc] initWithFormat:@"%@%@", notesText, textToPaste]];
                [notesTextView setSelectedRange:(NSMakeRange([[notesTextView string] length] - 1, 0))];
            }
            else
            {
                leftText = [notesText substringToIndex:selRange.location];
                rightText = [notesText substringFromIndex:selRange.location];
                [notesTextView setString:[[NSString alloc] initWithFormat:@"%@%@%@", leftText, textToPaste, rightText]];
                [notesTextView setSelectedRange:(NSMakeRange([leftText length] + [textToPaste length] - 1, 0))];
            }
        }
    }
    [notesProcessing storeANote];
}

-(IBAction)copyNoteToPasteboard:(id)sender
{
    NSString *alertMessage, *searchText;
    NSTextView *sourceOfText;
    
    sourceOfText = notesTextView;
    searchText = [[NSString alloc] initWithString:[sourceOfText string]];
    alertMessage = @"The current note was successfully copied";
    [self pasteText:searchText AlertMessage:alertMessage AlertTitle:@"Copy Note"];
}

- (IBAction)doVocabTextCopy:(id)sender
{
    NSString *alertMessage, *searchText;
    NSTextView *sourceOfText;
    
    sourceOfText = vocabTextView;
    searchText = [[NSString alloc] initWithString:[sourceOfText string]];
    alertMessage = @"The current Vocab list was successfully copied";
    [self pasteText:searchText AlertMessage:alertMessage AlertTitle:@"Copy Vocab List"];
}

- (IBAction)doHistorySelection:(NSComboBox *)sender
{
    NSInteger tagValue;
    
    tagValue = [sender tag];
    [mainTextHandler processSelectedHistory:tagValue];
}

- (IBAction)doPreferences:(id)sender
{
    /*************************************************************************
     *                                                                       *
     *                           doPreferences                               *
     *                           =============                               *
     *                                                                       *
     *  Prepares and opens the menu option: Preferences.                     *
     *                                                                       *
     *  This will provide the option for the user to change the font size,   *
     *    text colour and background colour of the (currently) seven text    *
     *    areas containing textual display.                                  *
     *                                                                       *
     *  The current values are stored in the Configuration variables:        *
     *    - fontSize;                                                        *
     *    - fgColour;                                                        *
     *    - bgColour;                                                        *
     *                                                                       *
     *  Other key information is the memory addresses of the text areas,     *
     *    stored in the Configuration variable: prefsTextViews.              *
     *                                                                       *
     *  As a consequence, it is important that these values are correct      *
     *    when calling the showWindow method.                                *
     *                                                                       *
     *  Note also that the parallel Configuration variables:                 *
     *    - prefsFontSize                                                    *
     *    - prefsFgColours                                                   *
     *    - prefsBgColours                                                   *
     *    are used as temporary storage during the processing and should     *
     *    *not* be accessed directly.                                        *
     *                                                                       *
     *************************************************************************/

    frmPreferences *prefWindow;
    
    prefWindow = [[frmPreferences alloc] initWithWindowNibName:@"frmPreferences"];
    [prefWindow showWindow:nil];
    [prefWindow initialiseWindow:globalVars forWindow:prefWindow];
}

- (IBAction)doManageNotes:(id)sender
{
    NSInteger tagVal;
    NSString *windowTitle, *mainLabel, *secondaryLabel;
    NSMenuItem *currentMenuItem;
    frmManageNotes *manageNotes;
    GBSAlert *alert;
    
    currentMenuItem = (NSMenuItem *) sender;
    tagVal = [currentMenuItem tag];
    switch (tagVal)
    {
        case 1:
            windowTitle = @"New Note Set";
            mainLabel = @"Provide a name for the new Notes Set:";
            secondaryLabel = @"(Note: avoid spaces and symbols.  This name will be used as part of a file name.)";
            break;
        case 2:
            windowTitle = @"Change Current Note Set";
            mainLabel = @"Select an existing Notes Set you want to use:";
            secondaryLabel = @"(Note: this will also set the new Nte Set as the currently active set.)";
            break;
        case 3:
            windowTitle = @"Delete a Note Set";
            mainLabel = @"Select an existing Notes Set you want to delete:";
            secondaryLabel = @"(Note that this will remove all notes in the Note Set and that the action cannot be reversed.)";
            break;
        case 4:
            alert = [GBSAlert new];
            [alert messageBox:[[NSString alloc] initWithFormat:@"The current Notes Set name is: %@", [globalVars notesName]] title:@"Current Notes Set" boxStyle:NSAlertStyleInformational];
            return;
        default: break;
    }
    manageNotes = [[frmManageNotes alloc] initWithWindowNibName:@"frmManageNotes"];
    [manageNotes showWindow:nil];
    [manageNotes setContent:windowTitle formInstance:manageNotes configuration:globalVars notesMethods:notesProcessing mainLabel:mainLabel secondaryLabel:secondaryLabel action:tagVal];
}

- (IBAction)doHelp:(id)sender
{
    frmHelp *appHelp;
    
    appHelp = [[frmHelp alloc] initWithWindowNibName:@"frmHelp"];
    [appHelp showWindow:nil];
}

- (IBAction)doAbout:(id)sender
{
    frmAbout *aboutBox;
    
    aboutBox = [[frmAbout alloc] initWithWindowNibName:@"frmAbout"];
    [aboutBox simpleInitialisation:aboutBox];
    [[NSApplication sharedApplication] runModalForWindow:[aboutBox window]];
}

- (IBAction)rootOrExact:(id)sender
{
    
}

- (IBAction)doListSelection:(NSButton *)sender
{
    
}

- (IBAction)doDisplaySelection:(NSButton *)sender
{
    
}

- (IBAction)doWordTypeSelection:(NSButton *)sender
{
    
}

- (IBAction)doExit:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

@end
