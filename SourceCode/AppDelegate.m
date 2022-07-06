//
//  AppDelegate.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 20/05/2022.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

/*============================================================================================*
 *       Global class variables                                                               *
 *============================================================================================*/

@synthesize globalVars;
@synthesize appRegistry;
@synthesize greekOrthography;
@synthesize bhsText;
@synthesize lxxText;
@synthesize hebKeyboard;
@synthesize gkKeyboard;
@synthesize hebrewLexicon;
@synthesize greekLexicon;
@synthesize mainDispUtilities;
@synthesize bhsSearch;
@synthesize lxxSearch;
@synthesize bhsNotes;
@synthesize lxxNotes;

// forms/windows
@synthesize progressDialog;
@synthesize manageNotes;
@synthesize optionsForCopy;
@synthesize preferenceForm;
@synthesize appHelp;
//@synthesize  resetCopyOptions;

@synthesize mainLoop;

@synthesize mainWindow;

/*==============================================*
 *           Menus                              *
 *==============================================*/

@synthesize mainTextContextMenu;
@synthesize searchResultsContextMenu;
@synthesize mnuKethibQere;

/*============================================================================================*
 *       Outlets for the main window, defined in AppDelegate but available to all classes     *
 *============================================================================================*/
@synthesize cbBHSBook;
@synthesize cbBHSChapter;
@synthesize cbBHSVerse;
@synthesize cbLXXBook;
@synthesize cbLXXChapter;
@synthesize cbLXXVerse;
@synthesize cbBHSHistory;
@synthesize cbLXXHistory;

@synthesize txtBHSText;
@synthesize txtLXXText;
@synthesize txtBHSNotes;
@synthesize txtLXXNotes;
@synthesize txtAllParse;
@synthesize txtAllLexicon;
@synthesize txtSearchResults;
@synthesize txtKethibQere;

@synthesize tabMain;
@synthesize tabUtilities;
@synthesize tabTopRight;
@synthesize tabBHSUtilityDetail;
@synthesize tabLXXUtilityDetail;

@synthesize itemMainBHS;
@synthesize itemMainLXX;
@synthesize itemBHSNotes;
@synthesize itemBHSSearch;
@synthesize itemBHSVariants;
@synthesize itemLXXNotes;
@synthesize itemLXXLS;
@synthesize itemLXXSearch;
@synthesize itemParse;
@synthesize itemLexicon;
@synthesize itemSearchResults;

/*----------------------------------------------*
 *   Virtual keyboards                          *
 *----------------------------------------------*/

@synthesize viewHebrewKeyboard;
@synthesize viewGreekKeyboard;
@synthesize viewBHSHistory;
@synthesize viewLXXHistory;

@synthesize btnBHSShowKeyboard;
@synthesize btnLXXShowKeyboard;

BOOL isInLoadState;
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

NSInteger bhsHeightIndicator, lxxHeightIndicator, bhsOverrideSlide, lxxOverrideSlide, bhshighWaterMark, lxxhighWaterMark, buttonCode, bhsPstnControl, lxxPstnControl, bhsPstnControlMaster, lxxPstnControlMaster;
NSTimer *generalPurposeTimer, *tabCheckTimer;

@synthesize btnBHSAdvanced;
@synthesize btnLXXAdvanced;
@synthesize btnStop;

@synthesize txtBHSPrimaryWord;
@synthesize txtBHSSecondaryWord;
@synthesize txtLXXPrimaryWord;
@synthesize txtLXXSecondaryWord;

@synthesize splitMain;
@synthesize splitBHSLeft;
@synthesize splitLXXLeft;
@synthesize splitRight;

@synthesize rbtnBDBRefs;
@synthesize rbtnBHSStrict;
@synthesize rbtnBHSModerate;
@synthesize rbtnLXXRootMatch;
@synthesize rbtnLXXExactMatch;
@synthesize rbtnBHSExclude;
@synthesize rbtnLXXExclude;
@synthesize rbtnLandSGeneral;
@synthesize rbtnLandSAuthors;
@synthesize rbtnLandSEpigraphy;
@synthesize rbtnLandSPapyri;
@synthesize rbtnLandSPeriodicals;

@synthesize webLandS;

@synthesize labBHSSearchLbl;
@synthesize labBHSWithinLbl;
@synthesize labBHSWordsOfLbl;
@synthesize labLXXSearchLbl;
@synthesize labLXXWithinLbl;
@synthesize labLXXWordsOfLbl;
@synthesize labSearchProgress;

@synthesize lbAvailableBHSBooks;
@synthesize lbAvailableLXXBooks;
@synthesize bhsAvailableBooksMaster;
@synthesize lxxAvailableBooksMaster;

/*=========================================================*
 *       Search setup and processing                       *
 *=========================================================*/

@synthesize bhsSteps;
@synthesize bhsStepper;
@synthesize lxxSteps;
@synthesize lxxStepper;
@synthesize cbBHSPentateuch;
@synthesize cbBHSFormerProphets;
@synthesize cbBHSMajorProphets;
@synthesize cbBHSMinorProphets;
@synthesize cbBHSKethubimPoetry;
@synthesize cbBHSKethubimHistory;
@synthesize cbLXXPentateuch;
@synthesize cbLXXFormerProphets;
@synthesize cbLXXMajorProphets;
@synthesize cbLXXMinorProphets;
@synthesize cbLXXKethubimPoetry;
@synthesize cbLXXKethubimHistory;
@synthesize cbLXXPsedepigrapha;

/*=========================================================*
 *       Areas on the right                                *
 *=========================================================*/

@synthesize maximiseTop;
@synthesize maximiseBottom;
@synthesize equaliseBoth;

/*=========================================================*
 *      Setting and resetting copy options                 *
 *=========================================================*/
@synthesize mnuChangeRemember;

NSInteger rightPstnControl;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRange spaceRange;
    NSInteger idx, jdx, noOfBooks, bookId;
    NSString *locationOfHistoryFile, *historyFileContents, *fullReference, *bookName, *chapterRef;
    NSArray *historyEntryList;
    NSFileManager *fmHistory;
    classBHSBook *currentBook;
    classLXXBook *currentLXXBook;
    
    // Keyboard Sizing
    NSInteger noOfRows = 4, keyGap = 4, keyHeight = 30, keyboardAreaTop;

    [mainWindow setIsVisible:false];
    mainLoop = [NSRunLoop mainRunLoop];
    progressDialog = [[frmProgress alloc] initWithWindowNibName:@"frmProgress"];
    globalVars = [[classGlobal alloc] init];
    [progressDialog showWindow:nil];
    [progressDialog updateProgressMain:@"Starting the initialisation process" withSecondMsg:@""];
    [mainLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
    [self registerFormVariablesInGlobal];
    [globalVars initialiseGlobal];
    mainDispUtilities = [[classDisplayUtilities alloc] init:globalVars];
    [self setupRegistry];

    /*-------------------------------------------------------------------*
     *  Initialise the methods for manipulating Greek characters         *
     *-------------------------------------------------------------------*/
    greekOrthography = [[classGreekOrthography alloc] init];
    [greekOrthography initialiseGreekOrthography:globalVars];
//    [globalVars setGkOrthography:greekOrthography];
    
    /*-------------------------------------------------------------------*
     * We need to define some classes early so that a non-null value is  *
     *   stored in the text classes - the sequence is vital.             *
     *-------------------------------------------------------------------*/
    bhsText = [[classBHSText alloc] init:globalVars];
    /*-------------------------------------------------------------------*
     *  Note that we actually load the lexicon _before_ the MT           *
     *-------------------------------------------------------------------*/
    hebrewLexicon = [[classHebLexicon alloc] init:globalVars withLoop:mainLoop forProgressForm:progressDialog];
    greekLexicon = [[classGkLexicon alloc] init:globalVars withOrthography:greekOrthography usingUtils:mainDispUtilities];
    [greekLexicon setGkLexLoop:mainLoop];
    [greekLexicon setGkLexProgress:progressDialog];
    [greekLexicon loadLexiconData];

    /*===================================================================*
     *                                                                   *
     *  Load the MT text                                                 *
     *                                                                   *
     *===================================================================*/

    [bhsText setBhsLoop:mainLoop];
    [bhsText setBhsProgress:progressDialog];
    [bhsText loadText:hebrewLexicon];
//    [bhsText displayChapter:@"1" forBook:0];
    
    /*-------------------------------------------------------------------*
    *  Load the history data and set the currently displayed page using  *
    *    the entry, if one exists.                                       *
    *--------------------------------------------------------------------*/

    locationOfHistoryFile = [[NSString alloc] initWithFormat:@"%@/%@/%@/History.txt", [globalVars iniPath], [globalVars notesPath], [globalVars bhsNotesFolder]];
    fmHistory = [NSFileManager defaultManager];
    if( [fmHistory fileExistsAtPath:locationOfHistoryFile])
    {
        historyFileContents = [[NSString alloc] initWithContentsOfFile:locationOfHistoryFile encoding:NSUTF8StringEncoding error:nil];
        historyEntryList = [historyFileContents componentsSeparatedByString:@"\n"];
        if( [historyEntryList count] > 0)
        {
            [cbBHSHistory addItemsWithObjectValues:historyEntryList];
            [cbBHSHistory selectItemAtIndex:0];
            fullReference = [[NSString alloc] initWithString:[cbBHSHistory itemObjectValueAtIndex:0]];
            spaceRange = [fullReference rangeOfString:@" "];
            bookName = [fullReference substringToIndex:spaceRange.location];
            chapterRef = [fullReference substringFromIndex:spaceRange.location + 1];
            noOfBooks = [globalVars noOfBHSBooks];
            bookId = -1;
            for( idx = 0; idx < noOfBooks; idx++)
            {
                currentBook = [[globalVars bhsBookList] objectForKey:[globalVars convertIntegerToString:idx]];
                if( [[currentBook bookName] compare:bookName] == NSOrderedSame )
                {
                    bookId = idx;
                    break;
                }
            }
            if( bookId > -1)
            {
                [bhsText displayChapter:chapterRef forBook:bookId];
            }
            else [bhsText displayChapter:@"1" forBook:0];
        }
        else [bhsText displayChapter:@"1" forBook:0];
    }
    else [bhsText displayChapter:@"1" forBook:0];

    /*===================================================================*
     *                                                                   *
     *  Load the LXX text                                                *
     *                                                                   *
     *===================================================================*/

    lxxText = [[classLXXText alloc] init:globalVars withLexicon:greekLexicon andUtilities:mainDispUtilities];
//    lxxText.initialiseText(globalVars, progressForm, historyProcessing, greekLexicon);
    [lxxText setLxxLoop:mainLoop];
    [lxxText setLxxProgress:progressDialog];
    [lxxText loadText];
//    [lxxText displayChapter:@"1" forBook:0];
    
    /*-------------------------------------------------------------------*
    *  Load the history data and set the currently displayed page using  *
    *    the entry, if one exists.                                       *
    *--------------------------------------------------------------------*/

    locationOfHistoryFile = [[NSString alloc] initWithFormat:@"%@/%@/%@/History.txt", [globalVars iniPath], [globalVars notesPath], [globalVars lxxNotesFolder]];
    if( [fmHistory fileExistsAtPath:locationOfHistoryFile])
    {
        historyFileContents = [[NSString alloc] initWithContentsOfFile:locationOfHistoryFile encoding:NSUTF8StringEncoding error:nil];
        historyEntryList = [historyFileContents componentsSeparatedByString:@"\n"];
        if( [historyEntryList count] > 0)
        {
            [cbLXXHistory addItemsWithObjectValues:historyEntryList];
            [cbLXXHistory selectItemAtIndex:0];
            fullReference = [[NSString alloc] initWithString:[cbLXXHistory itemObjectValueAtIndex:0]];
            spaceRange = [fullReference rangeOfString:@" "];
            bookName = [fullReference substringToIndex:spaceRange.location];
            chapterRef = [fullReference substringFromIndex:spaceRange.location + 1];
            noOfBooks = [globalVars noOfLXXBooks];
            bookId = -1;
            for( idx = 0; idx < noOfBooks; idx++)
            {
                currentLXXBook = [[globalVars lxxBookList] objectForKey:[globalVars convertIntegerToString:idx]];
                if( [[currentLXXBook commonName] compare:bookName] == NSOrderedSame )
                {
                    bookId = idx;
                    break;
                }
            }
            if( bookId > -1)
            {
                [lxxText displayChapter:chapterRef forBook:bookId];
            }
            else [lxxText displayChapter:@"1" forBook:0];
        }
        else [lxxText displayChapter:@"1" forBook:0];
    }
    else [lxxText displayChapter:@"1" forBook:0];

    /*===================================================================*
     *                                                                   *
     *  Set up the virtual keyboards                                     *
     *                                                                   *
     *===================================================================*/
    /*--------------------------------------------------------*
    *         Set up variables to manage keyboard slide      *
    *--------------------------------------------------------*/
   
    bhsHeightIndicator = 0;
    lxxHeightIndicator = 0;
    bhsOverrideSlide = 1;
    lxxOverrideSlide = 1;
    bhshighWaterMark = 0;
    lxxhighWaterMark = 0;
    lxxPstnControl = 0;
    keyboardAreaTop = (keyGap + keyHeight) * ( noOfRows - 1) - keyGap;
    [globalVars setNoOfKeyboardRows:noOfRows];
    [globalVars setKeyGap:keyGap];
    [globalVars setKeyHeight:keyHeight];
    [globalVars setKeyboardAreaTop:keyboardAreaTop];
    hebKeyboard = [[classHebKeyboard alloc] init:globalVars];
    [globalVars setBhsKeyViewMin:[splitBHSLeft frame].size.height - [viewBHSHistory frame].size.height - 10];
    [globalVars setBhsKeyViewMax:[splitBHSLeft frame].size.height - [viewBHSHistory frame].size.height - keyboardAreaTop - keyGap - keyHeight - 10];
    [hebKeyboard setShowBHSHideButon:btnBHSShowKeyboard];
    [hebKeyboard setupHebKeyboard];
    bhsPstnControlMaster = [globalVars bhsKeyViewMin];
    bhsPstnControl = bhsPstnControlMaster;
    [splitBHSLeft setPosition:[globalVars bhsKeyViewMin] ofDividerAtIndex:0];
    
    gkKeyboard = [[classGkKeyboard alloc] init:globalVars withGkOthography:greekOrthography];
    [globalVars setLxxKeyViewMin:[splitLXXLeft frame].size.height - [viewLXXHistory frame].size.height - 10];
    [globalVars setLxxKeyViewMax:[splitLXXLeft frame].size.height - [viewLXXHistory frame].size.height - keyboardAreaTop - keyGap - keyHeight * 2 - 10];
    [gkKeyboard setShowLXXHideButton:btnLXXShowKeyboard];
    [gkKeyboard setupGkKeyboard];
    lxxPstnControlMaster = [globalVars lxxKeyViewMin];
    lxxPstnControl = lxxPstnControlMaster;
    [splitLXXLeft setPosition:[globalVars lxxKeyViewMin] ofDividerAtIndex:0];
    
     /*--------------------------------------------------------*
     *                                                        *
     *            Prepare the search setup area               *
     *            -----------------------------               *
     *                                                        *
     *--------------------------------------------------------*/

    bhsSearch = [[classBHSSearch alloc] init:globalVars forHebLexicon:hebrewLexicon forHebText:bhsText andLoop:mainLoop];
    [self searchOptionCheckedChanged:lbAvailableBHSBooks];
    [globalVars setStepperBHSScan:bhsStepper];
    [globalVars setBhsSteps:bhsSteps];
    [globalVars setLabSearchProgress:labSearchProgress];
    lxxSearch = [[classLXXSearch alloc] init:globalVars forGreekLexicon:greekLexicon withOrthography:greekOrthography forGkText:lxxText andLoop:mainLoop];
    [self searchOptionCheckedChanged:lbAvailableLXXBooks];
    [globalVars setStepperLXXScan:lxxStepper];
    [globalVars setLxxSteps:lxxSteps];
//    [globalVars setLabSearchProgress:labSearchProgress];

    /*--------------------------------------------------------*
    *                                                        *
    *         Modify the main textview context menu          *
    *         -------------------------------------          *
    *                                                        *
    *--------------------------------------------------------*/
   
    bhsNotes = [[classBHSNotes alloc] init:globalVars];
    lxxNotes = [[classLXXNotes alloc] init:globalVars];
    [txtBHSText setMenu:mainTextContextMenu];
    [txtLXXText setMenu:mainTextContextMenu];
    [txtSearchResults setMenu:searchResultsContextMenu];

    /*--------------------------------------------------------*
    *                                                        *
    *         Set the background colours for all Text Views  *
    *         -------------------------------------          *
    *                                                        *
    *--------------------------------------------------------*/

    [txtBHSText setBackgroundColor:[globalVars bhsTextBackgroundColour]];
    [txtLXXText setBackgroundColor:[globalVars lxxTextBackgroundColour]];
    [txtAllParse setBackgroundColor:[globalVars parseTextBackgroundColour]];
    [txtAllLexicon setBackgroundColor:[globalVars lexTextBackgroundColour]];
    [txtSearchResults setBackgroundColor:[globalVars searchBHSBackgroundColour]];
    [txtBHSNotes setBackgroundColor:[globalVars bhsNotesBackgroundColour]];
    [txtLXXNotes setBackgroundColor:[globalVars lxxNotesBackgroundColour]];

    /*---------------------------------------------------------*
     *       Areas on the right                                *
     *---------------------------------------------------------*/

    rightPstnControl = [[globalVars tabTopRight] frame].size.height;
    globalVars.dividerPstn = rightPstnControl;

    /*---------------------------------------------------------*
     *       Initialise the copy options                       *
     *---------------------------------------------------------*/

    for( idx = 0; idx < 4; idx++)
    {
        for( jdx = 0; jdx < 4; jdx++)
        {
            [globalVars setCopyOption:jdx forCopyType:idx forTextType:0 withValue:1];
            [globalVars setCopyOption:jdx forCopyType:idx forTextType:1 withValue:1];
        }
    }
    [mnuChangeRemember setHidden:true];

    [globalVars setIsBHSHistoryLoadActive:false];
    [globalVars setIsLXXHistoryLoadActive:false];

    [progressDialog close];
    [mainWindow setIsVisible:true];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [bhsNotes storeANoteFor:[cbBHSBook indexOfSelectedItem] chapterSequence:[cbBHSChapter indexOfSelectedItem] andVerseSequence:[cbBHSVerse indexOfSelectedItem]];
    [lxxNotes storeANoteFor:[cbLXXBook indexOfSelectedItem] chapterSequence:[cbLXXChapter indexOfSelectedItem] andVerseSequence:[cbLXXVerse indexOfSelectedItem]];
    [appRegistry saveIniValues];
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void) registerFormVariablesInGlobal
{
    [globalVars setMainWindow:mainWindow];
    
    /*-----------------------------------------------------------------------------------------------------*
     *  Combo boxes                                                                                        *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setCbBHSBook:cbBHSBook];
    [globalVars setCbBHSChapter:cbBHSChapter];
    [globalVars setCbBHSVerse:cbBHSVerse];
    [globalVars setCbBHSHistory:cbBHSHistory];
    [globalVars setCbLXXBook:cbLXXBook];
    [globalVars setCbLXXChapter:cbLXXChapter];
    [globalVars setCbLXXVerse:cbLXXVerse];
    [globalVars setCbLXXHistory:cbLXXHistory];

    /*-----------------------------------------------------------------------------------------------------*
     *  Declare main text boxes to global configuration class                                              *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setTxtBHSText:txtBHSText];
    [globalVars setTxtLXXText:txtLXXText];
    [globalVars setTxtBHSNotes:txtBHSNotes];
    [globalVars setTxtLXXNotes:txtLXXNotes];
    [globalVars setTxtAllParse:txtAllParse];
    [globalVars setTxtAllLexicon:txtAllLexicon];
    [globalVars setTxtSearchResults:txtSearchResults];
    [globalVars setTxtKethibQere:txtKethibQere];

    /*-----------------------------------------------------------------------------------------------------*
     *  Declare tab controls:                                                                              *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setTabMain:tabMain];
    [globalVars setTabUtilities:tabUtilities];
    [globalVars setTabBHSUtilityDetail:tabBHSUtilityDetail];
    [globalVars setTabLXXUtilityDetail:tabLXXUtilityDetail];
    [globalVars setTabTopRight:tabTopRight];

    /*-----------------------------------------------------------------------------------------------------*
     *  Tab control pages                                                                                  *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setItemMainBHS:itemMainBHS];
    [globalVars setItemMainLXX:itemMainLXX];
    [globalVars setItemBHSNotes:itemBHSNotes];
    [globalVars setItemBHSSearch:itemBHSSearch];
    [globalVars setItemBHSVariants:itemBHSVariants];
    [globalVars setItemLXXNotes:itemLXXNotes];
    [globalVars setItemLXXLS:itemLXXLS];
    [globalVars setItemLXXSearch:itemLXXSearch];
    [globalVars setItemParse:itemParse];
    [globalVars setItemLexicon:itemLexicon];
    [globalVars setItemSearchResults:itemSearchResults];

    /*-----------------------------------------------------------------------------------------------------*
     *  Panels (virtual keyboards)                                                                         *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setViewHebrewKeyboard:viewHebrewKeyboard];
    [globalVars setViewGreekKeyboard:viewGreekKeyboard];
    [globalVars setViewBHSHistoryPnl:viewBHSHistory];
    [globalVars setViewLXXHistoryPnl:viewLXXHistory];

    /*-----------------------------------------------------------------------------------------------------*
     *  Buttons (needing global access)                                                                    *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setBtnBHSAdvanced:btnBHSAdvanced];
    [globalVars setBtnLXXAdvanced:btnLXXAdvanced];
    [globalVars setBtnLXXAdvanced:btnStop];

    /*-----------------------------------------------------------------------------------------------------*
     *  Text boxes (needing global access)                                                                 *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setTxtBHSPrimaryWord:txtBHSPrimaryWord];
    [globalVars setTxtBHSSecondaryWord:txtBHSSecondaryWord];
    [globalVars setTxtLXXPrimaryWord:txtLXXPrimaryWord];
    [globalVars setTxtLXXSecondaryWord:txtLXXSecondaryWord];

    /*-----------------------------------------------------------------------------------------------------*
     *  Split Containers                                                                                   *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setSplitMain:splitMain];
    [globalVars setSplitBHSLeft:splitBHSLeft];
    [globalVars setSplitLXXLeft:splitLXXLeft];
    [globalVars setSplitRight:splitRight];

    /*-----------------------------------------------------------------------------------------------------*
     *  RadioButtons (needing global access)                                                               *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setRbtnBDBRefs:rbtnBDBRefs];
    [globalVars setRbtnBHSStrict:rbtnBHSStrict];
    [globalVars setRbtnBHSModerate:rbtnBHSModerate];
    [globalVars setRbtnLXXRootMatch:rbtnLXXRootMatch];
    [globalVars setRbtnLXXExactMatch:rbtnLXXExactMatch];
    [globalVars setRbtnBHSExclude:rbtnBHSExclude];
    [globalVars setRbtnLXXExclude:rbtnLXXExclude];

    /*-----------------------------------------------------------------------------------------------------*
     *  Web Browser controls                                                                               *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setWebLandS:webLandS];

    /*-----------------------------------------------------------------------------------------------------*
     *  Labels (needing global access)                                                                     *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setLabBHSSearchLbl:labBHSSearchLbl];
    [globalVars setLabBHSWithinLbl:labBHSWithinLbl];
    [globalVars setLabBHSWordsOfLbl:labBHSWordsOfLbl];
    [globalVars setLabLXXSearchLbl:labLXXSearchLbl];
    [globalVars setLabLXXWithinLbl:labLXXWithinLbl];
    [globalVars setLabLXXWordsOfLbl:labLXXWordsOfLbl];
    [globalVars setLabSearchProgress:labSearchProgress];

    /*-----------------------------------------------------------------------------------------------------*
     *  Listboxes (needing global access)                                                                  *
     *-----------------------------------------------------------------------------------------------------*/
    [globalVars setLbAvailableBHSBooks:lbAvailableBHSBooks];
    [globalVars setLbAvailableLXXBooks:lbAvailableLXXBooks];

    /*-----------------------------------------------------------------------------------------------------*
     *  Liddell & Scott Appendices                                                                         *
     *-----------------------------------------------------------------------------------------------------*/
    
    [self doLandSAppendices:rbtnLandSGeneral];
    [globalVars setLatestBHSBookId:0];
    [globalVars setLatestBHSChapterSeq:0];
    [globalVars setLatestBHSVerseSeq:0];
    [globalVars setLatestLXXBookId:0];
    [globalVars setLatestLXXChapterSeq:0];
    [globalVars setLatestLXXVerseSeq:0];
}

- (void) setupRegistry
{
    /*============================================================================================*
     *                                                                                            *
     *                                     setupRegistry                                          *
     *                                     =============                                          *
     *                                                                                            *
     * We're calling it the rather grand name of "Registry" but it is really an old fashioned ini *
     *   file.                                                                                    *
     *                                                                                            *
     *============================================================================================*/
    
    BOOL isDir = true;
    NSFileManager *fmInit = [NSFileManager defaultManager];
    NSString *initFileName;
    NSString *initPath;
    
    /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     *
     *  File paths and names
     *
     */
    
    globalVars.basePath = @"/Library/";
    globalVars.lfcFolder = @"LFCConsulting";
    globalVars.appFolder = @"OTS";
    
    initPath = [[NSString alloc] initWithFormat:@"%@%@%@/%@",
                             [fmInit homeDirectoryForCurrentUser], [globalVars basePath], [globalVars lfcFolder], [globalVars appFolder]];
    if( [initPath containsString:@"file:///"] )
    {
        initPath = [[NSString alloc] initWithString:[initPath substringFromIndex:7]];
    }
    if( ! [fmInit fileExistsAtPath:initPath isDirectory:&isDir]) [fmInit createDirectoryAtPath:initPath withIntermediateDirectories:YES attributes:nil error:nil];
    initFileName = [[NSString alloc] initWithFormat:@"%@/init.dat", initPath];
    globalVars.iniPath = initPath;
    globalVars.iniFile = initFileName;
    appRegistry = [[classRegistry alloc] init];
    [appRegistry initialiseRegistry:globalVars];
//    [globalVars setApplicationRegistry:appRegistry];
}

- (void) comboBoxSelectionDidChange:(NSNotification *)notification
{
    NSUInteger switchControl = 0;
    NSComboBox *cbResult;

    cbResult = (NSComboBox *) [notification object];
    switchControl = [cbResult tag];
    switch (switchControl)
    {
        case 1:
        case 2:
        case 3:
            if( [globalVars isBHSHistoryLoadActive] ) return;
            [bhsText handleComboBoxChange:switchControl]; break;
        case 4:
        case 5:
            if( [globalVars isLXXHistoryLoadActive] ) return;
        case 6:[lxxText handleComboBoxChange:switchControl - 3]; break;
        case 7:
            if( [globalVars isBHSHistoryLoadActive] ) return;
            [globalVars setIsBHSHistoryLoadActive:true];
            [bhsText changeOfHistoryReference];
            [globalVars setIsBHSHistoryLoadActive:false];
            break;
        case 8:
            if( [globalVars isLXXHistoryLoadActive] ) return;
            [globalVars setIsLXXHistoryLoadActive:true];
            [lxxText changeOfHistoryReference];
            [globalVars setIsLXXHistoryLoadActive:false];
            break;
        default: break;
    }
}

/*===================================================================================*
 *                                                                                   *
 *                           Table Population and handling                           *
 *                           =============================                           *
 *                                                                                   *
 * Suite of methods to populate the various tables.                                  *
 *                                                                                   *
 *  Table Id                           Function                                      *
 *  ========                           ========                                      *
 *     1          BHS "listbox" in Search Setup                                      *
 *     2          LXX "listbox" in Search setup                                      *
 *                                                                                   *
 *===================================================================================*/

- (NSString *) getRequiredData: (NSString *) keyName forRow: (NSUInteger) row andTableId: (NSInteger) tableId
{
    switch (tableId)
    {
        case 1:
            if( [keyName isEqualToString:@"books"])
            {
                return [bhsAvailableBooksMaster objectAtIndex:row];
            }
            break;
        case 2:
            if( [keyName isEqualToString:@"books"])
            {
                return [lxxAvailableBooksMaster objectAtIndex:row];
            }
            break;
        default: break;
    }
    return nil;
}

#pragma mark - Table View Data Source

- (NSInteger) numberOfRowsInTableView: (NSTableView *)tableView
{
    NSInteger tagVal;
    
    tagVal = [tableView tag];
    switch (tagVal)
    {
        case 1: return bhsAvailableBooksMaster.count;
        case 2: return lxxAvailableBooksMaster.count;
        default: break;
    }
    return -1;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSInteger tagVal;
    
    tagVal = [tableView tag];
    return [self getRequiredData: tableColumn.identifier forRow: row andTableId: tagVal];
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
     *  It deals with the Hebrew/Aramaic text separately from the Septuagint.  Both        *
     *    have almost the same groups of books except that the LXX has an additional group *
     *    that have been lumped together under "Pseudepigrapha".                           *
     *                                                                                     *
     *=====================================================================================*/

    NSInteger tagVal;
    NSMutableArray *bhsAvailableBooksArray, *lxxAvailableBooksArray;
    NSTableView *tvSource;
    NSTabView *targetTabView;
    
    tvSource = (NSTableView *)sender;
    tagVal = [tvSource tag];
    if( tagVal == 0)
    {
        targetTabView = [globalVars tabUtilities];
        switch ([targetTabView indexOfTabViewItem:[targetTabView selectedTabViewItem]])
        {
            case 0: tagVal = 1; tvSource = lbAvailableBHSBooks; break;
            case 1: tagVal = 2; tvSource = lbAvailableLXXBooks; break;
            default: break;
        }
    }
    switch( tagVal)
    {
        case 1:
            if( bhsAvailableBooksArray != nil ) [bhsAvailableBooksArray removeAllObjects];
            bhsAvailableBooksArray = [[NSMutableArray alloc] init];
            if ( [rbtnBHSExclude state] == NSControlStateValueOn )
            {
                if ( [cbBHSPentateuch state] == NSControlStateValueOff ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:0]];
                if ( [cbBHSFormerProphets state] == NSControlStateValueOff ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:1]];
                if ( [cbBHSMajorProphets state] == NSControlStateValueOff ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:2]];
                if ( [cbBHSMinorProphets state] == NSControlStateValueOff ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:3]];
                if ( [cbBHSKethubimPoetry state] == NSControlStateValueOff ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:4]];
                if ( [cbBHSKethubimHistory state] == NSControlStateValueOff ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:5]];
            }
            else
            {
                if ( [cbBHSPentateuch state] == NSControlStateValueOn ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:0]];
                if ( [cbBHSFormerProphets state] == NSControlStateValueOn ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:1]];
                if ( [cbBHSMajorProphets state] == NSControlStateValueOn ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:2]];
                if ( [cbBHSMinorProphets state] == NSControlStateValueOn ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:3]];
                if ( [cbBHSKethubimPoetry state] == NSControlStateValueOn ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:4]];
                if ( [cbBHSKethubimHistory state] == NSControlStateValueOn ) [bhsAvailableBooksArray addObjectsFromArray:[globalVars getListBoxGroupArray:5]];
            }
            bhsAvailableBooksMaster = [[NSArray alloc] initWithArray:bhsAvailableBooksArray];
            [globalVars setBhsAvailableBooksMaster:bhsAvailableBooksMaster];
            [tvSource reloadData];
            break;
        case 2:
            if( lxxAvailableBooksArray != nil ) [lxxAvailableBooksArray removeAllObjects];
            lxxAvailableBooksArray = [[NSMutableArray alloc] init];
            if ( [rbtnLXXExclude state] == NSControlStateValueOn )
            {
                if ( [cbLXXPentateuch state] == NSControlStateValueOff ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:0]];
                if ( [cbLXXFormerProphets state] == NSControlStateValueOff ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:1]];
                if ( [cbLXXMajorProphets state] == NSControlStateValueOff ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:2]];
                if ( [cbLXXMinorProphets state] == NSControlStateValueOff ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:3]];
                if ( [cbLXXKethubimPoetry state] == NSControlStateValueOff ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:4]];
                if ( [cbLXXKethubimHistory state] == NSControlStateValueOff ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:5]];
                if ( [cbLXXPsedepigrapha state] == NSControlStateValueOff ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:6]];
            }
            else
            {
                if ( [cbLXXPentateuch state] == NSControlStateValueOn ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:0]];
                if ( [cbLXXFormerProphets state] == NSControlStateValueOn ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:1]];
                if ( [cbLXXMajorProphets state] == NSControlStateValueOn ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:2]];
                if ( [cbLXXMinorProphets state] == NSControlStateValueOn ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:3]];
                if ( [cbLXXKethubimPoetry state] == NSControlStateValueOn ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:4]];
                if ( [cbLXXKethubimHistory state] == NSControlStateValueOn ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:5]];
                if ( [cbLXXPsedepigrapha state] == NSControlStateValueOn ) [lxxAvailableBooksArray addObjectsFromArray:[globalVars getLXXListBoxGroupArray:6]];
            }
            lxxAvailableBooksMaster = [[NSArray alloc] initWithArray:lxxAvailableBooksArray];
            [globalVars setLxxAvailableBooksMaster:lxxAvailableBooksMaster];
            [tvSource reloadData];
    }
}

/*=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=*
 *                                         End of Table Management Section                                         *
 *=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=*/

- (IBAction)doCopy:(id)sender
{
    /*================================================================================================================================*
     *                                                                                                                                *
     *                                                       doCopy                                                                   *
     *                                                       ======                                                                   *
     *                                                                                                                                *
     *  This handles the process of copying words, verses, whole chapters and selected text for both BHS and LXX text.                *
     *                                                                                                                                *
     *  The type of copy is set by the tag (here: tagVal):                                                                            *
     *                                                                                                                                *
     *    word = 0, verse = 1, chapter = 2, selection = 3                                                                             *
     *                                                                                                                                *
     *  If the selection is from BHS, then versionFlag = 0; if from LXX, versionFlag = 1                                              *
     *                                                                                                                                *
     *  See the global classes: destinationCopy, referenceOption, accentsOption and useExistingOption                                 *
     *                                                                                                                                *
     *================================================================================================================================*/
    NSInteger idx, jdx, tagVal, versionFlag, selectedOption, count = 0;
    NSMenuItem *currentMenuItem;
    NSTabView *mainTab;
    
    currentMenuItem = (NSMenuItem *)sender;
    tagVal = [currentMenuItem tag];
    mainTab = [globalVars tabMain];
    versionFlag = [mainTab indexOfTabViewItem:[mainTab selectedTabViewItem]];
    optionsForCopy = [[frmCopyOptions alloc] initWithWindowNibName:@"frmCopyOptions"];
    selectedOption = [globalVars getCopyOption:3 forCopyType:tagVal forTextType:versionFlag];
    if ( selectedOption == 0 ) // i.e. do _not_ use the options dialog
    {
        [optionsForCopy setDestCode:[globalVars getCopyOption:0 forCopyType:tagVal forTextType:versionFlag]];
        [optionsForCopy setRefCode:[globalVars getCopyOption:1 forCopyType:tagVal forTextType:versionFlag]];
        [optionsForCopy setAccentCode:[globalVars getCopyOption:2 forCopyType:tagVal forTextType:versionFlag]];
        [optionsForCopy setRememberCode:[globalVars getCopyOption:3 forCopyType:tagVal forTextType:versionFlag]];
    }
    if( versionFlag == 0) [optionsForCopy initialise:tagVal forVersion:versionFlag withGlobalClass:globalVars hebLexicon:hebrewLexicon andGkOrthog:greekOrthography withNote:bhsNotes];
    else [optionsForCopy initialise:tagVal forVersion:versionFlag withGlobalClass:globalVars hebLexicon:hebrewLexicon andGkOrthog:greekOrthography withNote:lxxNotes];
    if (selectedOption == 0 ) [optionsForCopy performCopy];
    else
    {
        [NSApp runModalForWindow:[optionsForCopy window]];
        for( idx = 0; idx < 4; idx++)
        {
            for( jdx = 0; jdx < 2; jdx++)
            {
                if( [globalVars getCopyOption:3 forCopyType:idx forTextType:jdx] == 0 ) count++;
            }
        }
        if( count > 0) [mnuChangeRemember setHidden:false];
        else [mnuChangeRemember setHidden:true];
    }
}

- (IBAction)doResetCopyOptions:(id)sender
{
    NSInteger idx, jdx, modalResult, count = 0;
    frmResetCopyOptions *resetCopyOptions;
    
    resetCopyOptions = [[frmResetCopyOptions alloc] initWithWindowNibName:@"frmResetCopyOptions"];
//    [resetCopyOptions setup:globalVars];
    modalResult = [NSApp runModalForWindow:[resetCopyOptions window]];
    if( modalResult == NSModalResponseOK)
    {
        for( idx = 0; idx < 4; idx++)
        {
            for( jdx = 0; jdx < 2; jdx++)
            {
                if( [globalVars getCopyOption:3 forCopyType:idx forTextType:jdx] == 0 ) count++;
            }
        }
        if( count > 0) [mnuChangeRemember setHidden:false];
        else [mnuChangeRemember setHidden:true];
    }
}

- (IBAction)doSearchSetup:(NSMenuItem *)sender
{
    NSInteger tagVal, hebOrGk;
    NSMenuItem *selectedItem;
    NSTabView *mainTabView;
    
    selectedItem = (NSMenuItem *)sender;
    tagVal = [selectedItem tag];
    mainTabView = [globalVars tabMain];
    hebOrGk = [mainTabView indexOfTabViewItem:[mainTabView selectedTabViewItem]] ;
    switch (tagVal)
    {
        case 6:
            switch (hebOrGk)
            {
                case 0: [bhsSearch searchSetup:0]; break;
                case 1: [lxxSearch searchSetup:0]; break;
                default: break;
            }
            break;
        case 7:
            switch (hebOrGk)
            {
                case 0: [bhsSearch searchSetup:1]; break;
                case 1: [lxxSearch searchSetup:1]; break;
                default: break;
            }
            break;
        default: break;
    }
}

- (IBAction)doAnalysis:(id)sender
{
    if( [tabMain selectedTabViewItem] == itemMainBHS) [bhsText analysis];
    else [lxxText analysis];
}

- (IBAction)doBHSSearchType:(id)sender
{
    
}

- (IBAction)doLXXSearchType:(id)sender
{
    
}

- (IBAction)changeSearchType:(NSButton *)sender
{
    BOOL isHidden;
    NSInteger tagVal;
    NSString *buttonText;
    
    tagVal = [sender tag];
    buttonText = [[NSString alloc] initWithString:[sender title]];
    if( [buttonText compare:@"Advanced Search"] == NSOrderedSame) isHidden = false;
    else isHidden = true;
    switch (tagVal)
    {
        case 1:
            [labBHSWithinLbl setHidden:isHidden];
            [labBHSWordsOfLbl setHidden:isHidden];
            [bhsSteps setHidden:isHidden];
            [bhsStepper setHidden:isHidden];
            [txtBHSSecondaryWord setHidden:isHidden];
            break;
        case 2:
            [labLXXWithinLbl setHidden:isHidden];
            [labLXXWordsOfLbl setHidden:isHidden];
            [lxxSteps setHidden:isHidden];
            [lxxStepper setHidden:isHidden];
            [txtLXXSecondaryWord setHidden:isHidden];
            break;
        default: break;
    }
    if( isHidden) [sender setTitle:@"Advanced Search"];
    else [sender setTitle:@"Simple Search"];
}

- (IBAction)doSearch:(id)sender
{
    NSInteger tagVal;
    NSButton *sourceButton;
    NSTabView *topRightTabView;
    
    sourceButton = (NSButton *) sender;
    tagVal = [sourceButton tag];
    topRightTabView = [globalVars tabTopRight];
    [topRightTabView selectTabViewItemAtIndex:2];
    switch (tagVal)
    {
        case 1: [bhsSearch controlSearch]; break;
        case 2: [lxxSearch controlSearch]; break;
        default: break;
    }
}

- (IBAction)doKethibQere:(NSMenuItem *)sender
{
    NSInteger bookNo;
    NSTextStorage *kqStore;
    classBHSBook *currentBook;
    classBHSChapter *currentChapter;
    classBHSVerse *currentVerse;
    classBHSWord *currentWord;
    classKethib_Qere *currentVariant;

    bookNo = [cbBHSBook indexOfSelectedItem];
    currentBook = [[globalVars bhsBookList] objectForKey:[globalVars convertIntegerToString:bookNo]];
    currentChapter = [currentBook getChapterBySequence:[cbBHSChapter indexOfSelectedItem]];
    currentVerse = [currentChapter getVerseBySequence:[cbBHSVerse indexOfSelectedItem]];
    currentWord = [currentVerse getWord:[globalVars sequenceOfLatestBHSWord]];
    if( [currentWord hasVariant])
    {
        [tabUtilities selectTabViewItem:[tabUtilities tabViewItemAtIndex:0]];
        [tabBHSUtilityDetail selectTabViewItem:[tabBHSUtilityDetail tabViewItemAtIndex:2]];
        currentVariant = [currentWord wordVariant];
        [txtKethibQere selectAll:self];
        [txtKethibQere delete:self];
        kqStore = [txtKethibQere textStorage];
        [kqStore appendAttributedString:[mainDispUtilities addAttributedText:@"Kethib: " offsetCode:0 fontId:0 alignment:0 withAdjustmentFor:txtKethibQere]];
        [kqStore appendAttributedString:[mainDispUtilities addAttributedText:[currentVariant kethibText] offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:txtKethibQere]];
        [kqStore appendAttributedString:[mainDispUtilities addAttributedText:@"\n" offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:txtKethibQere]];
        [kqStore appendAttributedString:[mainDispUtilities addAttributedText:@"Qere: " offsetCode:0 fontId:0 alignment:0 withAdjustmentFor:txtKethibQere]];
        [kqStore appendAttributedString:[mainDispUtilities addAttributedText:[currentVariant qereText] offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:txtKethibQere]];
    }
}

- (IBAction)doLandSAppendices:(id)sender
{
    NSInteger tagVal;
    NSString *appendixName, *appendixFileName;
    NSURL *appendixURL;
    NSArray *appendixNames;
    NSButton *checkboxSelected;
    NSURLRequest *newRequest;
    
    appendixNames = [[NSArray alloc] initWithObjects:@"L5_general_abbreviations", @"L1_authors_and_works", @"L2_epigraphical_publications", @"L3_papyrological_publications", @"L4_periodicals", nil];
    checkboxSelected = (NSButton *) sender;
    if( [checkboxSelected state] == NSControlStateValueOn)
    {
        tagVal = [checkboxSelected tag];
        appendixName = [[NSString alloc] initWithString:[appendixNames objectAtIndex:tagVal - 1]];
        appendixFileName = [[NSBundle mainBundle] pathForResource:appendixName ofType:@"html"];
        appendixURL = [NSURL fileURLWithPath: appendixFileName];
        newRequest = [[NSURLRequest alloc] initWithURL:appendixURL];
        [webLandS loadRequest:newRequest];
    }
}

- (IBAction)doPrevOrNextChapter:(NSButton *)sender
{
    NSInteger tagVal;
    
    tagVal = [sender tag];
    if( tagVal < 3) [bhsText prevOrNextChapter:tagVal];
    else
    {
        tagVal -= 2;
        [lxxText prevOrNextChapter:tagVal];
    }
}

- (IBAction)doBHSRemoveBooksFromListbox:(id)sender
{
    NSInteger idx, noOfBooksInList;
    NSTableView *listboxTable;
    NSIndexSet *selectedBooks;
    NSMutableArray *tempTableStore;

    listboxTable = [globalVars lbAvailableBHSBooks];
    selectedBooks = [[NSIndexSet alloc] initWithIndexSet:[listboxTable selectedRowIndexes]];
    noOfBooksInList = [bhsAvailableBooksMaster count];
    tempTableStore = [[NSMutableArray alloc] init];
    for( idx = 0; idx < noOfBooksInList; idx++)
    {
        if( [selectedBooks containsIndex:idx]) continue;
        [tempTableStore addObject:[bhsAvailableBooksMaster objectAtIndex:idx]];
    }
    bhsAvailableBooksMaster = [[NSArray alloc] initWithArray:tempTableStore];
    [globalVars setBhsAvailableBooksMaster:bhsAvailableBooksMaster];
    [listboxTable reloadData];
}

- (IBAction)doReinstateBookList:(id)sender
{
    NSInteger tagVal;
    NSButton *sourceButton;
    
    sourceButton = (NSButton *) sender;
    tagVal = [sourceButton tag];
    switch (tagVal)
    {
        case 1:
            [cbBHSPentateuch setState:NSControlStateValueOff];
            [cbBHSFormerProphets setState:NSControlStateValueOff];
            [cbBHSMajorProphets setState:NSControlStateValueOff];
            [cbBHSMinorProphets setState:NSControlStateValueOff];
            [cbBHSKethubimPoetry setState:NSControlStateValueOff];
            [cbBHSKethubimHistory setState:NSControlStateValueOff];
            [self searchOptionCheckedChanged:lbAvailableBHSBooks];
            break;
        case 2:
            [cbLXXPentateuch setState:NSControlStateValueOff];
            [cbLXXFormerProphets setState:NSControlStateValueOff];
            [cbLXXMajorProphets setState:NSControlStateValueOff];
            [cbLXXMinorProphets setState:NSControlStateValueOff];
            [cbLXXKethubimPoetry setState:NSControlStateValueOff];
            [cbLXXKethubimHistory setState:NSControlStateValueOff];
            [cbLXXPsedepigrapha setState:NSControlStateValueOff];
            [self searchOptionCheckedChanged:lbAvailableLXXBooks];
            break;

        default:
            break;
    }
}

- (IBAction)doLXXRemoveBooksFromListbox:(id)sender
{
    NSInteger idx, noOfBooksInList;
    NSTableView *listboxTable;
    NSIndexSet *selectedBooks;
    NSMutableArray *tempTableStore;

    listboxTable = [globalVars lbAvailableLXXBooks];
    selectedBooks = [[NSIndexSet alloc] initWithIndexSet:[listboxTable selectedRowIndexes]];
    noOfBooksInList = [lxxAvailableBooksMaster count];
    tempTableStore = [[NSMutableArray alloc] init];
    for( idx = 0; idx < noOfBooksInList; idx++)
    {
        if( [selectedBooks containsIndex:idx]) continue;
        [tempTableStore addObject:[lxxAvailableBooksMaster objectAtIndex:idx]];
    }
    lxxAvailableBooksMaster = [[NSArray alloc] initWithArray:tempTableStore];
    [globalVars setLxxAvailableBooksMaster:lxxAvailableBooksMaster];
    [listboxTable reloadData];
}

- (IBAction)doManageNotes:(id)sender
{
    NSInteger tagVal;
    NSString *windowTitle, *mainLabel, *secondaryLabel;
    NSMenuItem *currentMenuItem;
    frmNotesReport *notesReport;
    
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
            secondaryLabel = @"(Note: this will also set the new Note Set as the currently active set.)";
            break;
        case 3:
            windowTitle = @"Delete a Note Set";
            mainLabel = @"Select an existing Notes Set you want to delete:";
            secondaryLabel = @"(Note that this will remove all notes in the Note Set and that the action cannot be reversed.)";
            break;
        case 4:
            notesReport = [[frmNotesReport alloc] initWithWindowNibName:@"frmNotesReport"];
            [notesReport window];
            [[[notesReport window] windowController] dialogSetup:globalVars];
            [NSApp runModalForWindow:[notesReport window]];
            return;
        default: break;
    }
    manageNotes = [[frmManageNotes alloc] initWithWindowNibName:@"frmManageNotes"];
    [manageNotes showWindow:nil];
    [manageNotes setContent:windowTitle configuration:globalVars notesMethodsforBHS:bhsNotes notesMethodsforLXX:lxxNotes mainLabel:mainLabel secondaryLabel:secondaryLabel action:tagVal];
}

- (IBAction)doKeyboardManagement:(id)sender
{
    NSButton *activeButton;
    
    activeButton = (NSButton *)sender;
    buttonCode = [activeButton tag];
    if( [[activeButton title] compare:@"Show Virtual Keyboard"] == NSOrderedSame)
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
    /*==========================================================================================*
     *                                                                                          *
     *                                    showKeyboard                                          *
     *                                    ============                                          *
     *                                                                                          *
     *  This should increase the size of the lower left view to reveal the keyboard.  In fact,  *
     *    it will raise the splitView divider from [globalVars keyViewMin] to                   *
     *     [globalVars keyViewMax]                                                              *
     *                                                                                          *
     *==========================================================================================*/
    switch (buttonCode)
    {
        case 1:
            bhsOverrideSlide = 1;
            isInLoadState = true;
            bhsPstnControl -= 2;
            [splitBHSLeft setPosition:bhsPstnControl ofDividerAtIndex:0];
            if( bhsPstnControl <= [globalVars bhsKeyViewMax])
            {
                [generalPurposeTimer invalidate];
                [btnBHSShowKeyboard setTitle:@"Hide Virtual Keyboard"];
                bhsOverrideSlide = 0;
                isInLoadState = false;
            }
            break;
        case 2:
            lxxOverrideSlide = 1;
            isInLoadState = true;
            lxxPstnControl -= 2;
            [splitLXXLeft setPosition:lxxPstnControl ofDividerAtIndex:0];
            if( lxxPstnControl <= [globalVars lxxKeyViewMax])
            {
                [generalPurposeTimer invalidate];
                [btnLXXShowKeyboard setTitle:@"Hide Virtual Keyboard"];
                lxxOverrideSlide = 0;
                isInLoadState = false;
            }
            break;
        default: break;
    }
}

- (void) hideKeyboard: (id) sender
{
    switch (buttonCode)
    {
        case 1:
            bhsOverrideSlide = 1;
            isInLoadState = true;
            bhsPstnControl += 2;
            [splitBHSLeft setPosition:bhsPstnControl ofDividerAtIndex:0];
            if( bhsPstnControl >= [globalVars bhsKeyViewMin])
            {
                [generalPurposeTimer invalidate];
                [btnBHSShowKeyboard setTitle:@"Show Virtual Keyboard"];
                bhsOverrideSlide = 0;
                isInLoadState = false;
            }
            break;
        case 2:
            lxxOverrideSlide = 1;
            isInLoadState = true;
            lxxPstnControl += 2;
            [splitLXXLeft setPosition:lxxPstnControl ofDividerAtIndex:0];
            if( lxxPstnControl >= [globalVars lxxKeyViewMin])
            {
                [generalPurposeTimer invalidate];
                [btnLXXShowKeyboard setTitle:@"Show Virtual Keyboard"];
                lxxOverrideSlide = 0;
                isInLoadState = false;
            }
            break;
        default: break;
    }

}

- (IBAction)doSearchActions:(id)sender
{
    BOOL isBHS;
    NSInteger tagVal;
    NSMenuItem *currentItem;
    
    currentItem = (NSMenuItem *) sender;
    tagVal = [currentItem tag];
    if( [tabUtilities indexOfTabViewItem:[tabUtilities selectedTabViewItem]] == 0) isBHS = true;
    else isBHS = false;
    if( isBHS) [bhsText processSearchAction:tagVal];
    else [lxxText processSearchAction:tagVal];
}

- (IBAction)doResize:(id)sender
{
    NSInteger tagVal;
    NSMenuItem *menuItem;
    
    menuItem = (NSMenuItem *) sender;
    tagVal = [menuItem tag];
    switch (tagVal)
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
    [splitRight setPosition:rightPstnControl ofDividerAtIndex:0];
    if( rightPstnControl >= [splitRight maxPossiblePositionOfDividerAtIndex:0] )
    {
        [generalPurposeTimer invalidate];
        [maximiseTop setHidden:true];
        [maximiseBottom setHidden:false];
        [equaliseBoth setHidden:false];
    }
}

- (void) actResize1: (id) sender
{
    rightPstnControl -= 2;
    [splitRight setPosition:rightPstnControl ofDividerAtIndex:0];
    if( rightPstnControl <= [splitRight minPossiblePositionOfDividerAtIndex:0] )
    {
        [generalPurposeTimer invalidate];
        [maximiseTop setHidden:false];
        [maximiseBottom setHidden:true];
        [equaliseBoth setHidden:false];
    }
}

- (void) actResize2: (id) sender
{
    if( rightPstnControl < [globalVars dividerPstn])
    {
        rightPstnControl += 2;
        [splitRight setPosition:rightPstnControl ofDividerAtIndex:0];
        if( rightPstnControl >= [globalVars dividerPstn] )
        {
            [generalPurposeTimer invalidate];
            [maximiseTop setHidden:false];
            [maximiseBottom setHidden:false];
            [equaliseBoth setHidden:true];
        }
    }
    else
    {
        rightPstnControl -= 2;
        [splitRight setPosition:rightPstnControl ofDividerAtIndex:0];
        if( rightPstnControl <= [globalVars dividerPstn] )
        {
            [generalPurposeTimer invalidate];
            [maximiseTop setHidden:false];
            [maximiseBottom setHidden:false];
            [equaliseBoth setHidden:true];
        }
    }
}

- (IBAction)doPreferences:(id)sender
{
    NSInteger modalResponse, idx, bookId;
    NSString *chapterRef;
    
    preferenceForm = [[frmPreferences alloc] initWithWindowNibName:@"frmPreferences"];
    [[[preferenceForm window] windowController] initialiseWindow:globalVars];
    modalResponse = [NSApp runModalForWindow:[preferenceForm window]];
    if(modalResponse == NSModalResponseOK)
    {
        [globalVars reformAllFonts];
        for( idx = 0; idx < [preferenceForm noOfViews]; idx++ )
        {
            if( [[[preferenceForm changeRecord] objectAtIndex:idx] length] > 0)
            {
                switch (idx)
                {
                    case 0:
                        [txtBHSText setBackgroundColor:[globalVars bhsTextBackgroundColour]];
                        bookId = [cbBHSBook indexOfSelectedItem];
                        chapterRef = [[NSString alloc] initWithString:[cbBHSChapter objectValueOfSelectedItem]];
                        [bhsText displayChapter:chapterRef forBook:bookId];
                        break;
                    case 1:
                        [txtLXXText setBackgroundColor:[globalVars lxxTextBackgroundColour]];
                        bookId = [cbLXXBook indexOfSelectedItem];
                        chapterRef = [[NSString alloc] initWithString:[cbLXXChapter objectValueOfSelectedItem]];
                        [lxxText displayChapter:chapterRef forBook:bookId];
                        break;
                    case 2:
                    case 3:
                        [txtAllParse setBackgroundColor:[globalVars parseTextBackgroundColour]];
                        [txtAllLexicon setBackgroundColor:[globalVars lexTextBackgroundColour]];
                        [self doAnalysis:nil];
                        break;
                    case 4:
                        [txtSearchResults setBackgroundColor:[globalVars searchBHSBackgroundColour]];
                        [bhsText processSearchAction:1];
                        break;
                    case 5:
                        [bhsText processSearchAction:2];
                        break;
                    case 6:
                        [txtBHSNotes setBackgroundColor:[globalVars bhsNotesBackgroundColour]];
                        [bhsText handleComboBoxChange:3];
                        break;
                    case 7:
                        [txtLXXNotes setBackgroundColor:[globalVars lxxNotesBackgroundColour]];
                        [lxxText handleComboBoxChange:3];
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

- (IBAction)doAbout:(id)sender
{
    classAbout *about;
    
    about = [[classAbout alloc] initWithWindowNibName:@"classAbout"];
    [NSApp runModalForWindow:[about window]];
}

- (IBAction)doHelp:(id)sender
{
    appHelp = [[frmHelp alloc] initWithWindowNibName:@"frmHelp"];
    [appHelp showWindow:nil];
}

- (IBAction)doClose:(id)sender
{
    [mainWindow close];
}
@end
