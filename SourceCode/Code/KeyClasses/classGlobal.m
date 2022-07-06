//
//  classGlobal.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 20/05/2022.
//

#import "classGlobal.h"

@implementation classGlobal

/*============================================================================================*
 *       General variables (unreleated to any obvious theme).                                 *
 *============================================================================================*/
@synthesize mainWindow;
//@synthesize applicationRegistry;
//@synthesize gkOrthography;

/*============================================================================================*
 *       Outlets for the main window, defined in AppDelegate but available to all classes     *
 *============================================================================================*/

/*-----------------------------------------------------------------------------------------------------*
 *  Combo boxes  (group 1)                                                                             *
 *                                                                                                     *
 *  All these comboboxes are found on the left side of the main form.                                  *
 *                                                                                                     *
 *        BHS Side                                      Septuagint Side                                *
 *  Index     Specific Combobox                        Index     Specific Combobox                     *
 *                                                                                                     *
 *    0         cbBHSBook     }                          3         cbLXXBook     }                     *
 *    1         cbBHSChapter  } above the main text      4         cbLXXChapter  } above the main text *
 *    2         cbBHSVerse    }                          5         cbLXXVerse    }                     *
 *    6         cbBHSHistory    above the v. keyboard    7         cbLXXHistory    above the v. keybrd *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize cbBHSBook;
@synthesize cbBHSChapter;
@synthesize cbBHSVerse;
@synthesize cbLXXBook;
@synthesize cbLXXChapter;
@synthesize cbLXXVerse;
@synthesize cbBHSHistory;
@synthesize cbLXXHistory;

/*-----------------------------------------------------------------------------------------------------*
 *  Main text areas  (group 2)                                                                         *
 *                                                                                                     *
 *        Masoretic Side                                      Septuagint Side                          *
 *  Index     Specific Richtext Control                Index     Specific Richtext Control             *
 *                                                                                                     *
 *    0         txtMainBHSText                          1         txtMainLXXText                       *
 *    2         txtBHSNotes                             3         txtLXXNotes                          *
 *                                                                                                     *
 *                              Combined                                                               *
 *                 Index     Specific Richtext Control                                                 *
 *                                                                                                     *
 *                   4         txtAllParse                                                             *
 *                   5         txtAllLexicon                                                           *
 *                   6         txtSearchResults                                                        *
 *                   7         txtKethibQere                                                           *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize txtBHSText;
@synthesize txtLXXText;
@synthesize txtBHSNotes;
@synthesize txtLXXNotes;
@synthesize txtAllParse;
@synthesize txtAllLexicon;
@synthesize txtSearchResults;
@synthesize txtKethibQere;

/*-----------------------------------------------------------------------------------------------------*
 *  Tab Views (sometimes called Tab Controls)  (group 3)                                               *
 *                                                                                                     *
 *  Index     Specific Page                                                                            *
 *                                                                                                     *
 *    0         Main Tab Control - Languages                                                           *
 *    1         Secondary Tab Control - Utiliies (I couldn't think of a better group name)             *
 *    2         Top Right Tab Control                                                                  *
 *    3         Utilities specific to BHS Text Tab Control - cf control 1                              *
 *    4         Utilities specific to Septuagint Text Tab Control - cf control 1                       *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize tabMain;
@synthesize tabUtilities;
@synthesize tabTopRight;
@synthesize tabBHSUtilityDetail;
@synthesize tabLXXUtilityDetail;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Tab View Items (sometimes referred to as Tab Control Pages)  (group 4}                             *
 *                                                                                                     *
 *  Index     Specific Page                                                                            *
 *                                                                                                     *
 *    0         Main Control - BHS Text                                                                *
 *    1         Main Control - Septuagint Text                                                         *
 *    2         BHS Text utilities - notes page                                                        *
 *    3         BHS Text utilities - search setup page                                                 *
 *    4         BHS Text utilities - variant readings page                                             *
 *    5         Septuagint utilities - notes page                                                      *
 *    6         Septuagint utilities - Liddell & Scott appendices                                      *
 *    7         Septuagint utilities - search setup page                                               *
 *    8         tabPgeParse - top right, parse (grammatical information) tab                           *
 *    9         tabPgeLexicon - top right, lexical information tab                                     *
 *   10         tabPgeSearchResults - top right, search results tab                                    *
 *                                                                                                     *
 *   The tabs within the Liddell & Scott appendices do not need to be stored globally.                 *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
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

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Panels for Virtual Keyboards  {group 5)                                                            *
 *                                                                                                     *
 *  Index     Specific Page                                                                            *
 *                                                                                                     *
 *    0         Panel for Hebrew/Aramaic keyboard                                                      *
 *    1         Panel for Greek keyboard                                                               *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize viewHebrewKeyboard;
@synthesize viewGreekKeyboard;
@synthesize viewBHSHistoryPnl;
@synthesize viewLXXHistoryPnl;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Buttons (needing global access) (group 6)                                                          *
 *                                                                                                     *
 *        Masoretic Side                                      Septuagint Side                          *
 *        --------------                                      ---------------                          *
 *  Index     Specific Button                          Index     Specific Button                       *
 *                                                                                                     *
 *    0         btnBHSAdvanced (Search function)         1         btnLXXAdvanced                      *
 *                                                                                                     *
 *                                Common to both                                                       *
 *                                --------------                                                       *
 *                               2         btnStop                                                     *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize btnBHSAdvanced;
@synthesize btnLXXAdvanced;
@synthesize btnStop;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Text boxes (specific to the search setup area)  (group 7)                                          *

 *                                                                                                     *
 *        Masoretic Side                                      Septuagint Side                          *
 *        --------------                                      ---------------                          *
 *  Index     Specific Textbox                         Index     Specific Textbox                      *
 *                                                                                                     *
 *    0      txtBHSPrimaryWord                           2         txtLXXPrimaryWord                   *
 *    1      txtBHSSecondaryWord                         3         txtLXXSecondaryWord                 *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize txtBHSPrimaryWord;
@synthesize txtBHSSecondaryWord;
@synthesize txtLXXPrimaryWord;
@synthesize txtLXXSecondaryWord;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Split Containers  (group 8)                                                                        *
 *                                                                                                     *
 *    0         splitMain (Covers effectively the whole form)                                          *
 *    1         splitBHSLeft (within the BHS tab, left main area)                                        *
 *    2         splitLXXLeft (within the LXX tab, left main area)                                      *
 *    3         splitRight                                                                             *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize splitMain;
@synthesize splitBHSLeft;
@synthesize splitLXXLeft;
@synthesize splitRight;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  RadioButtons  (group 9)                                                                            *
 *                                                                                                     *
 *        Masoretic Side                                      Septuagint Side                          *
 *        --------------                                      ---------------                          *
 *  Index     Specific Textbox                         Index     Specific Textbox                      *
 *  -----     ----------------                         -----     ----------------                      *
 *                                                                                                     *
 *    0      rbtnBdbRefs (under "Search for ...")        3         rbtnLXXRootMatch                    *
 *    1      rbtnBHSStrict (under "Search for ...")      4         rbtnLXXExactMatch                   *
 *    2      rbtnBHSModerate (under "Search for ...")                                                  *
 *    5      rbtnBHSExclude                              6         rbtnLXXExclude                      *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize rbtnBDBRefs;
@synthesize rbtnBHSStrict;
@synthesize rbtnBHSModerate;
@synthesize rbtnLXXRootMatch;
@synthesize rbtnLXXExactMatch;
@synthesize rbtnBHSExclude;
@synthesize rbtnLXXExclude;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Web Browser controls  (group 10)                                                                   *
 *                                                                                                     *
 *    We only need a single variable; it is reused as the user changes appendix.                       *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize webLandS;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Labels  (group 11)                                                                                 *
 *                                                                                                     *
 *  (We need to emphasise here that this is not _all_ labels, only those that other classes need to    *
 *   access.)                                                                                          *
 *                                                                                                     *
 *        Masoretic Side                                      Septuagint Side                          *
 *        --------------                                      ---------------                          *
 *  Index     Specific Label                           Index     Specific Label                        *
 *                                                                                                     *
 *    0      labBHSSearchLbl                              3         labLXXSearchLbl                     *
 *    1      labBHSWithinLbl                              4         labLXXWithinLbl                     *
 *    2      labBHSWordsOfLbl                             5         labLXXWordsOfLbl                    *
 *                                                                                                     *
 *                                       Combined                                                      *
 *                     Index     Labels serving the Search Results                                     *
 *                                                                                                     *
 *                       6         labSearchProgress                                                   *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize labBHSSearchLbl;
@synthesize labBHSWithinLbl;
@synthesize labBHSWordsOfLbl;
@synthesize labLXXSearchLbl;
@synthesize labLXXWithinLbl;
@synthesize labLXXWordsOfLbl;
@synthesize labSearchProgress;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Table Views used as Listboxes (group 12)                                                           *
 *                                                                                                     *
 *        Masoretic Side                                      Septuagint Side                          *
 *        --------------                                      ---------------                          *
 *  Index     Specific Listbox                         Index     Specific Listbox                      *
 *  -----     ----------------                         -----     ----------------                      *
 *                                                                                                     *
 *    0      lbAvailableBHSBooks                          1     lbAvailableLXXBooks                    *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize lbAvailableBHSBooks;
@synthesize lbAvailableLXXBooks;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *                                              Fonts                                                  *
 *                                              -----                                                  *
 *                                                                                                     *
 *  Final forms are outlined here:                                                                     *
 *                                                                                                     *
 *                  BHS Text                                      LXX Text      Parse Area             *
 *                  --------                                      --------      ----------             *
 *  0  English Text (i.e. used for verse numbers)    3  English text (as BHS)   5 Title text           *
 *  1  Main Hebrew/Aramaic text                      4  Greek main text         6 Normal text          *
 *  2  Text indicating the word has a variant form                                                     *
 *                                                                                                     *
 *  Lexical Area   Search Results area (used by BHS)   Search Results area (used by LXX)     Notes     *
 *  ------------   ---------------------------------   ---------------------------------     -----     *
 *  7 Title text    9 English Text (for references)    9 English Text (as BHS)             16 BHSFont  *
 *  8 Normal text  10 BHS main text                   13 Greek main Text                   17 LXXFont  *
 *                 11 Text for Primary Match words    14 Text for Primary Match words                  *
 *                 12 Text for Secondary Match words  15 Text for Secondary Match words                *
 *                                                                                                     *
 *  Bottom right tabs:                                                                                 *
 *                                                                                                     *
 *      Notes             Kethib/Qere Area                                                             *
 *      -----             ----------------                                                             *
 *    16 BHSFont           18 English Text                                                             *
 *    17 LXXFont           19 Hebrew/Aramaic Text                                                      *
 *                                                                                                     *
 *  Each font is composed of:                                                                          *
 *    a) a font name (e.g. "Times New Roman"                                                           *
 *    b) a "style" (regular, bold, italic, bold and italic)                                            *
 *    c) a size                                                                                        *
 *                                                                                                     *
 *  (Note: a and b are combined - e.g. "Times New Roman bold".)                                        *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/

@synthesize bhsTextEngName;
@synthesize bhsTextMainName;
@synthesize bhsTextVariantName;
@synthesize lxxTextEngName;
@synthesize lxxTextMainName;
@synthesize parseTitleName;
@synthesize parseTextName;
@synthesize lexTitleName;
@synthesize lexTextName;
@synthesize lexPrimaryName;
@synthesize searchEngName;
@synthesize searchBHSMainName;
@synthesize searchBHSPrimaryName;
@synthesize searchBHSSecondaryName;
@synthesize searchGreekMainName;
@synthesize searchGreekPrimaryName;
@synthesize searchGreekSecondaryName;
@synthesize bhsNotesFontName;
@synthesize lxxNotesFontName;
@synthesize kqEngName;
@synthesize kqMainName;

@synthesize bhsTextEngStyle;
@synthesize bhsTextMainStyle;
@synthesize bhsTextVariantStyle;
@synthesize lxxTextEngStyle;
@synthesize lxxTextMainStyle;
@synthesize parseTitleStyle;
@synthesize parseTextStyle;
@synthesize lexTitleStyle;
@synthesize lexTextStyle;
@synthesize lexPrimaryStyle;
@synthesize searchEngStyle;
@synthesize searchBHSMainStyle;
@synthesize searchBHSPrimaryStyle;
@synthesize searchBHSSecondaryStyle;
@synthesize searchGreekMainStyle;
@synthesize searchGreekPrimaryStyle;
@synthesize searchGreekSecondaryStyle;
@synthesize bhsNotesStyle;
@synthesize lxxNotesStyle;
@synthesize kqEngStyle;
@synthesize kqMainStyle;

@synthesize bhsTextEngSize;
@synthesize bhsTextMainSize;
@synthesize bhsTextVariantSize;
@synthesize lxxTextEngSize;
@synthesize lxxTextMainSize;
@synthesize parseTitleSize;
@synthesize parseTextSize;
@synthesize lexTitleSize;
@synthesize lexTextSize;
@synthesize lexPrimarySize;
@synthesize searchEngSize;
@synthesize searchBHSMainSize;
@synthesize searchBHSPrimarySize;
@synthesize searchBHSSecondarySize;
@synthesize searchGreekMainSize;
@synthesize searchGreekPrimarySize;
@synthesize searchGreekSecondarySize;
@synthesize bhsNotesSize;
@synthesize lxxNotesSize;
@synthesize kqEngSize;
@synthesize kqMainSize;

@synthesize bhsTextEngFont;
@synthesize bhsTextMainFont;
@synthesize bhsTextVariants;
@synthesize lxxTextEngFont;
@synthesize lxxTextMainFont;
@synthesize parseTitleFont;
@synthesize parseTextFont;
@synthesize lexTitleFont;
@synthesize lexTextFont;
@synthesize lexPrimaryFont;
@synthesize searchEngText;
@synthesize searchBHSMainText;
@synthesize searchBHSPrimaryText;
@synthesize searchBHSSecondaryText;
@synthesize searchGreekMainText;
@synthesize searchGreekPrimaryText;
@synthesize searchGreekSecondaryText;
@synthesize bhsNotesText;
@synthesize lxxNotesText;
@synthesize kqEngFont;
@synthesize kqMainFont;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Colours  (group 14)                                                                                *
 *                                                                                                     *
 *    These follow the same pattern as fonts except we have one additional colour for each area, which *
 *      is the area background colour.                                                                 *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/

@synthesize bhsTextEngColour;
@synthesize bhsTextMainColour;
@synthesize bhsTextVariantColour;
@synthesize bhsTextBackgroundColour;
@synthesize lxxTextEngColour;
@synthesize lxxTextMainColour;
@synthesize lxxTextBackgroundColour;
@synthesize parseTitleColour;
@synthesize parseTextColour;
@synthesize parseTextBackgroundColour;
@synthesize lexTitleColour;
@synthesize lexTextColour;
@synthesize lexPrimaryColour;
@synthesize lexTextBackgroundColour;
@synthesize searchEngColour;
@synthesize searchBHSMainColour;
@synthesize searchBHSPrimaryColour;
@synthesize searchBHSSecondaryColour;
@synthesize searchBHSBackgroundColour;
@synthesize searchGreekMainColour;
@synthesize searchGreekPrimaryColour;
@synthesize searchGreekSecondaryColour;
@synthesize searchGreekBackgroundColour;
@synthesize bhsNotesColour;
@synthesize bhsNotesBackgroundColour;
@synthesize lxxNotesColour;
@synthesize lxxNotesBackgroundColour;
@synthesize kqEngColour;
@synthesize kqMainColour;
@synthesize kqBackgroundColour;

/*============================================================================================*
 *       File system variables (paths and directories)                                        *
 *============================================================================================*/

@synthesize basePath;
@synthesize lfcFolder;
@synthesize appFolder;
@synthesize iniPath;
@synthesize iniFile;

/*--------------------------------------------------
 *
 *  Relating to loading BHS text
 */
@synthesize bhsTitlesFile;
@synthesize bhsSourceFile;
@synthesize kethibQereFile;

/*--------------------------------------------------
 *
 *  Relating to loading LXX text
 */
@synthesize lxxTitlesFile;
@synthesize lxxTextFolder;

/*--------------------------------------------------
 *
 *  Relating to notes
 */
@synthesize notesPath;
@synthesize bhsNotesFolder;
@synthesize lxxNotesFolder;
@synthesize specificBHSNoteFolder;
@synthesize specificLXXNoteFolder;
@synthesize bhsNotesName;
@synthesize lxxNotesName;

/*--------------------------------------------------
 *
 *  Relating to help
 */
@synthesize helpPath;
@synthesize helpFile;

/*--------------------------------------------------
 *
 *  Relating to lexicon
 */
@synthesize lexiconData;
@synthesize GkLexicon;
@synthesize mainLexFile;

/*--------------------------------------------------
 *
 *  Relating to parsing
 */
@synthesize codeFile;
@synthesize convertFile;

/*--------------------------------------------------
 *
 *  Relating to keyboard
 */
@synthesize keyboardFolder;
@synthesize bhsKeyViewMin;
@synthesize bhsKeyViewMax;
@synthesize lxxKeyViewMin;
@synthesize lxxKeyViewMax;
@synthesize rbtnBHSNotes;
@synthesize rbtnBHSPrimary;
@synthesize rbtnBHSSecondary;
@synthesize rbtnLXXNotes;
@synthesize rbtnLXXPrimary;
@synthesize rbtnLXXSecondary;
@synthesize noOfKeyboardRows;
@synthesize keyGap;
@synthesize keyHeight;
@synthesize keyboardAreaTop;

/*--------------------------------------------------
 *
 *  Relating to Greek processing
 */
@synthesize greekControlFolder;
@synthesize gkAccute;
@synthesize gkCircumflex;
@synthesize gkDiaereses;
@synthesize gkGrave;
@synthesize gkIota;
@synthesize gkRough;
@synthesize gkSmooth;
@synthesize gkConv1;
@synthesize gkConv2;

/*=======================================================================================*
 *                                                                                       *
 *  Variables storing current activity                                                   *
 *  ----------------------------------                                                   *
 *                                                                                       *
 *  These variables are gathered and stored every time a mouse click occurs on either of *
 *    the maintext areas.                                                                *
 *                                                                                       *
 *  latestXXCursorPosition            The identified cursor position within the whole    *
 *                                      text area.                                       *
 *  latestXXLineRange                 This is an NSRange which would allow you to get    *
 *                                      individual verse (including reference) from the  *
 *                                      text.                                            *
 *  XXVerseIsolate                    A copy of the text, as garnered by                 *
 *                                      latestLineRange                                  *
 *  XXVerseReferenceNo                The string value of the verse                      *
 *  latestRevisedXXCursorPosition     The cursor position equivalent of the click in the *
 *                                      verse (i.e. in verseIsolate).  Note: this is     *
 *                                      calculated.                                      *
 *  latestSelectedXXWord              The word last identified as clicked                *
 *  sequenceOfLatestXXWord            The sequence of latestSelectedXXWord in the verse  *
 *                                                                                       *
 *======================================================================================*/
@synthesize latestBHSCursorPosition;
@synthesize latestBHSLineRange;
@synthesize bhsVerseIsolate;
@synthesize bhsVerseReferenceNo;
@synthesize latestRevisedBHSCursorPosition;
@synthesize latestSelectedBHSWord;
@synthesize sequenceOfLatestBHSWord;

@synthesize latestLXXCursorPosition;
@synthesize latestLXXLineRange;
@synthesize lxxVerseIsolate;
@synthesize lxxVerseReferenceNo;
@synthesize latestRevisedLXXCursorPosition;
@synthesize latestSelectedLXXWord;
@synthesize sequenceOfLatestLXXWord;

@synthesize latestBHSBookId;
@synthesize latestBHSChapterSeq;
@synthesize latestBHSVerseSeq;
@synthesize latestLXXBookId;
@synthesize latestLXXChapterSeq;
@synthesize latestLXXVerseSeq;

/*===============================================================================================*
 *                                                                                               *
 *                           Variables controlling access to comboboxes                          *
 *                           ------------------------------------------                          *
 *                                                                                               *
 *  These variables are used to indicate whether a chapter is currently being loaded so as to    *
 *    avoid loading the same text twice (which manifests itself as a kind of bounce in the load  *
 *    process).                                                                                  *
 *                                                                                               *
 *===============================================================================================*/

@synthesize isBHSChapterLoadActive;
@synthesize isLXXChapterLoadActive;
@synthesize isBHSHistoryLoadActive;
@synthesize isLXXHistoryLoadActive;

/*===============================================================================================*
 *                                                                                               *
 *                           Book lists and related variables                                    *
 *                           --------------------------------                                    *
 *                                                                                               *
 *  The main book lists have the following keys and values:                                      *
 *     Key:     Integer sequence (starting from zero in each case);                              *
 *     Value:   The class instance for Hebrew/Aramaic books (MT) or Greek books (LXX)            *
 *                                                                                               *
 *===============================================================================================*/
@synthesize noOfBHSBooks;
@synthesize bhsBookList;
@synthesize noOfLXXBooks;
@synthesize lxxBookList;
@synthesize strongRefLookup;

/*-----------------------------------------------------------------------------------------------*
 *                                                                                               *
 *    The rest of the related variables deal with current values, which change as the user acts  *
 *                                                                                               *
 *-----------------------------------------------------------------------------------------------*/
@synthesize bhsCurrentBookIndex;
@synthesize lxxCurrentBookIndex;
@synthesize bhsCurrentChapter;
@synthesize lxxCurrentChapter;

/*-----------------------------------------------------------------------------------------------*
 *                                                                                               *
 *    Data files for Greek Processing                                                            *
 *                                                                                               *
 *-----------------------------------------------------------------------------------------------*/
@synthesize fullGkLexiconFile;
@synthesize fullGkAccute;
@synthesize fullGkCircumflex;
@synthesize fullGkDiaereses;
@synthesize fullGkGrave;
@synthesize fullGkIota;
@synthesize fullGkRough;
@synthesize fullGkSmooth;
@synthesize fullGkConv1;
@synthesize fullGkConv2;

/*------------------------------------------------------------------------*
 *                                                                        *
 *               Variables relating to search processing                  *
 *               ---------------------------------------                  *
 *                                                                        *
 *------------------------------------------------------------------------*/
@synthesize isAborted;
@synthesize primaryBHSBookId;
@synthesize primaryBHSWordSeq;
@synthesize secondaryBHSBookId;
@synthesize secondaryBHSWordSeq;
@synthesize primaryLXXBookId;
@synthesize primaryLXXWordSeq;
@synthesize secondaryLXXBookId;
@synthesize secondaryLXXWordSeq;
@synthesize noOfBHSBookGroups;
@synthesize noOfLXXBookGroups;
@synthesize noOfSearchObjects;
@synthesize noOfBHSResultsItems;
@synthesize noOfLXXResultsItems;
@synthesize bhsRowIndex;
@synthesize lxxRowIndex;
@synthesize primaryBHSWord;
@synthesize secondaryBHSWord;
@synthesize primaryBHSChapNo;
@synthesize primaryBHSVNo;
@synthesize secondaryBHSChapNo;
@synthesize secondaryBHSVNo;
@synthesize primaryLXXWord;
@synthesize secondaryLXXWord;
@synthesize primaryLXXChapNo;
@synthesize primaryLXXVNo;
@synthesize secondaryLXXChapNo;
@synthesize secondaryLXXVNo;
@synthesize stepperBHSScan;
@synthesize stepperLXXScan;
@synthesize btnBHSSearchType;
@synthesize btnLXXSearchType;
@synthesize bhsSteps;
@synthesize lxxSteps;
@synthesize searchResultsTable;
@synthesize btnStopSearch;

/*---------------------------------------------------------------------------------------*
 *  Variables storing current activity - following those for the main text areas         *
 *  ----------------------------------                                                   *
 *---------------------------------------------------------------------------------------*/
@synthesize latestSearchCursorPosition;
@synthesize latestSearchLineRange;
@synthesize searchVerseIsolate;
@synthesize searchVerseReferenceNo;
@synthesize latestRevisedSearchCursorPstn;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Data Sources for the search results                                                                *
 *  -----------------------------------                                                                *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize searchReferences;
@synthesize searchText;

/*===============================================================================================*
 *                                                                                               *
 *        Variable relating to the Table Views used as "listboxes"                               *
 *        --------------------------------------------------------                               *
 *                                                                                               *
 *===============================================================================================*/

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Data Sources for the listbox                                                                       *
 *  ----------------------------                                                                       *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@synthesize bhsAvailableBooksMaster;
@synthesize lxxAvailableBooksMaster;

/*===============================================================================================*
 *                                                                                               *
 *        Variables used for configuring copy options                                            *
 *        -------------------------------------------                                            *
 *                                                                                               *
 *  Each of the dictionaries below are keyed as follows:                                         *
 *                                                                                               *
 *                                   referring to BHS Text        referring to LXX Text          *
 *                                   ---------------------        ---------------------          *
 *   relating to word copy                    0                            4                     *
 *   relating to verse copy                   1                            5                     *
 *   relating to chapter copy                 2                            6                     *
 *   relating to selection copy               3                            7                     *
 *                                                                                               *
 *  The dictionaries perform the following functions:                                            *
 *                                                                                               *
 *                              value is "Y"                        value is "N"                 *
 *                              ------------                        ------------                 *
 *   destinationCopy      Copied text will go to Pasteboard  Copied text will go to active Note  *
 *   referenceOption      The reference will be included     The reference will not be included  *
 *   accentsOption        Original accents will be included  Accents will not be included        *
 *   useExistingOption    I.e. the options dialog will be    The options dialog will not be      *
 *                          displayed                          displayed and inherited options   *
 *                                                             will be used                      *
 *                                                                                               *
 *===============================================================================================*/

@synthesize noOfCopyOptions;
@synthesize destinationCopy;
@synthesize referenceOption;
@synthesize accentsOption;
@synthesize useExistingOption;

/*===============================================================================================*
 *        Variables used for controling the sizing of right-hand sub-areas                       *
 *===============================================================================================*/

@synthesize dividerPstn;

NSMutableArray *bhsPentateuchArray, *bhsFormerProphetsArray, *bhsMajorProphetsArray, *bhsMinorProphetsArray, *bhsKethubimPoetryArray, *bhsKethubimHistoryArray;
NSInteger bhsPentateuchCount, bhsFormerProphetsCount, bhsMajorProphetsCount, bhsMinorProphetsCount, bhsKethubimPoetryCount, bhsKethubimHistoryCount;
NSMutableArray *lxxPentateuchArray, *lxxFormerProphetsArray, *lxxMajorProphetsArray, *lxxMinorProphetsArray, *lxxKethubimPoetryArray, *lxxKethubimHistoryArray, *lxxPseudepigraphaArray;
NSInteger lxxPentateuchCount, lxxFormerProphetsCount, lxxMajorProphetsCount, lxxMinorProphetsCount, lxxKethubimPoetryCount, lxxKethubimHistoryCount, lxxPseudepigraphaCount;

- (void) initialiseGlobal
{
    isAborted = false;
    
    bhsPentateuchCount = 0;
    bhsFormerProphetsCount = 0;
    bhsMajorProphetsCount = 0;
    bhsMinorProphetsCount = 0;
    bhsKethubimPoetryCount = 0;
    bhsKethubimHistoryCount = 0;
    lxxPentateuchCount = 0;
    lxxFormerProphetsCount = 0;
    lxxMajorProphetsCount = 0;
    lxxMinorProphetsCount = 0;
    lxxKethubimPoetryCount = 0;
    lxxKethubimHistoryCount = 0;
    lxxPseudepigraphaCount = 0;

    bhsPentateuchArray = [[NSMutableArray alloc] init];
    bhsFormerProphetsArray = [[NSMutableArray alloc] init];
    bhsMajorProphetsArray = [[NSMutableArray alloc] init];
    bhsMinorProphetsArray = [[NSMutableArray alloc] init];
    bhsKethubimPoetryArray = [[NSMutableArray alloc] init];
    bhsKethubimHistoryArray = [[NSMutableArray alloc] init];
    lxxPentateuchArray = [[NSMutableArray alloc] init];
    lxxFormerProphetsArray = [[NSMutableArray alloc] init];
    lxxMajorProphetsArray = [[NSMutableArray alloc] init];
    lxxMinorProphetsArray = [[NSMutableArray alloc] init];
    lxxKethubimPoetryArray = [[NSMutableArray alloc] init];
    lxxKethubimHistoryArray = [[NSMutableArray alloc] init];
    lxxPseudepigraphaArray = [[NSMutableArray alloc] init];

    bhsTitlesFile = @"Titles";
    lxxTitlesFile = @"LXX_Titles";
    bhsSourceFile = @"OTText";  // lxxTextFolder = "LXX_Text";
    notesPath = @"Notes";
    bhsNotesFolder = @"BHS";
    lxxNotesFolder = @"LXX";
    bhsNotesName = @"Default";
    lxxNotesName = @"Default";
    specificBHSNoteFolder = @"B000001";
    specificLXXNoteFolder = @"L000001";
    
    helpFile = @"Help";  // .html  String helpPath = "Help",
    lexiconData = @"BDBData";
    convertFile = @"WordToBdb";
    codeFile = @"Codes";
    kethibQereFile = @"Kethib_Qere";
    mainLexFile = @"LandSSummary";  // String gkLexiconFolder = "GkLexicon",
    fullGkLexiconFile = @"LandSSummary";
    
    fullGkAccute = @"gkAccute";
    fullGkCircumflex = @"gkCircumflex";
    fullGkDiaereses = @"gkDiaereses";
    fullGkGrave = @"gkGrave";
    fullGkIota = @"gkIota";
    fullGkRough = @"gkRough";
    fullGkSmooth = @"gkSmooth";
    fullGkConv1 = @"gkConv1";
    fullGkConv2 = @"gkConv2";
   //  String keyboardFolder = "Keyboard", greekControlFolder = "Greek";
    
    gkAccute = @"accuteAccents";
    gkCircumflex = @"circumflexAccents";
    gkDiaereses = @"diaereses";
    gkGrave = @"graveAccents";
    gkIota = @"iotaSubscripts";
    gkRough = @"roughBreathings";
    gkSmooth = @"smoothBreathings";
    gkConv1 = @"breathingConversion1";
    gkConv2 = @"breathingConversion2";

    noOfCopyOptions = 0;
    destinationCopy = [[NSMutableDictionary alloc] init];
    referenceOption = [[NSMutableDictionary alloc] init];
    accentsOption = [[NSMutableDictionary alloc] init];
    useExistingOption = [[NSMutableDictionary alloc] init];
    strongRefLookup = [[NSMutableDictionary alloc] init];
}

- (void) reformFontForSetting: (NSInteger) settingCode
{
    /*==========================================================================================*
     *                                                                                          *
     *                                reformFontForSetting                                      *
     *                                ====================                                      *
     *                                                                                          *
     * Creates the full font from name, style and size for a specific processing are.  These    *
     *   defined by the code, as follows:                                                       *
     *                                                                                          *
     *   0   BHS Text       3   Lexical area                 6   BHS Notes                      *
     *   1   LXX Text       4   Search results for BHS       7   LXX Notes                      *
     *   2   Parse area     5   Search results for LXX       8   Kethib/Qere Text               *
     *                                                                                          *
     *==========================================================================================*/
    
    switch (settingCode)
    {
        case 0:
            bhsTextEngFont = [NSFont fontWithName:[self reformFontName:bhsTextEngName withStyle:bhsTextEngStyle] size:bhsTextEngSize];
            bhsTextMainFont = [NSFont fontWithName:[self reformFontName:bhsTextMainName withStyle:bhsTextMainStyle] size:bhsTextMainSize];
            bhsTextVariants = [NSFont fontWithName:[self reformFontName:bhsTextVariantName withStyle:bhsTextVariantStyle] size:bhsTextVariantSize];
            break;
        case 1:
            lxxTextEngFont = [NSFont fontWithName:[self reformFontName:lxxTextEngName withStyle:lxxTextEngStyle] size:lxxTextEngSize];
            lxxTextMainFont = [NSFont fontWithName:[self reformFontName:lxxTextMainName withStyle:lxxTextMainStyle] size:lxxTextMainSize];
            break;
        case 2:
            parseTitleFont = [NSFont fontWithName:[self reformFontName:parseTitleName withStyle:parseTitleStyle] size:parseTitleSize];
            parseTextFont = [NSFont fontWithName:[self reformFontName:parseTextName withStyle:parseTextStyle] size:parseTextSize];
            break;
        case 3:
            lexTitleFont = [NSFont fontWithName:[self reformFontName:lexTitleName withStyle:lexTitleStyle] size:lexTitleSize];
            lexTextFont = [NSFont fontWithName:[self reformFontName:lexTextName withStyle:lexTextStyle] size:lexTextSize];
            lexPrimaryFont = [NSFont fontWithName:[self reformFontName:lexPrimaryName withStyle:lexPrimaryStyle] size:lexPrimarySize];
            break;
        case 4:
            searchEngText = [NSFont fontWithName:[self reformFontName:searchEngName withStyle:searchEngStyle] size:searchEngSize];
            searchBHSMainText = [NSFont fontWithName:[self reformFontName:searchBHSMainName withStyle:searchBHSMainStyle] size:searchBHSMainSize];
            searchBHSPrimaryText = [NSFont fontWithName:[self reformFontName:searchBHSPrimaryName withStyle:searchBHSPrimaryStyle] size:searchBHSPrimarySize];
            searchBHSSecondaryText = [NSFont fontWithName:[self reformFontName:searchBHSSecondaryName withStyle:searchBHSSecondaryStyle] size:searchBHSSecondarySize];
            break;
        case 5:
            searchEngText = [NSFont fontWithName:[self reformFontName:searchEngName withStyle:searchEngStyle] size:searchEngSize];
            searchGreekMainText = [NSFont fontWithName:[self reformFontName:searchGreekMainName withStyle:searchGreekMainStyle] size:searchGreekMainSize];
            searchGreekPrimaryText = [NSFont fontWithName:[self reformFontName:searchGreekPrimaryName withStyle:searchGreekPrimaryStyle] size:searchGreekPrimarySize];
            searchGreekSecondaryText = [NSFont fontWithName:[self reformFontName:searchGreekSecondaryName withStyle:searchGreekSecondaryStyle] size:searchGreekSecondarySize];
            break;
        case 6:
            bhsNotesText = [NSFont fontWithName:[self reformFontName:bhsNotesFontName withStyle:bhsNotesStyle] size:bhsNotesSize];
            break;
        case 7:
            lxxNotesText = [NSFont fontWithName:[self reformFontName:lxxNotesFontName withStyle:lxxNotesStyle] size:lxxNotesSize];
            break;
        case 8:
            kqEngFont = [NSFont fontWithName:[self reformFontName:kqEngName withStyle:kqEngStyle] size:kqEngSize];
            kqMainFont = [NSFont fontWithName:[self reformFontName:kqMainName withStyle:kqMainStyle] size:kqMainSize];
            break;

        default:
            break;
    }
}

- (NSString *) reformFontName: (NSString *) startingName withStyle: (NSInteger) styleCode
{
    switch (styleCode)
    {
        case 0: return [[NSString alloc] initWithString:startingName];
        case 1: return [[NSString alloc] initWithFormat:@"%@ Bold", startingName];
        case 2: return [[NSString alloc] initWithFormat:@"%@ Italic", startingName];
        case 3: return [[NSString alloc] initWithFormat:@"%@ Bold Italic", startingName];
        default: return @"";
    }
}

- (void) reformAllFonts
{
    NSInteger idx;
    
    for( idx = 0; idx < 9; idx++) [self reformFontForSetting:idx];
}


- (void) addListBoxGroupItem: (NSString *) item withCode: (NSInteger) code
{
    switch (code)
    {
        case 0: { [bhsPentateuchArray addObject:(NSString *)item]; bhsPentateuchCount++; } break;
        case 1: { [bhsFormerProphetsArray addObject:(NSString *)item]; bhsFormerProphetsCount++; } break;
        case 2: { [bhsMajorProphetsArray addObject:(NSString *)item]; bhsMajorProphetsCount++; } break;
        case 3: { [bhsMinorProphetsArray addObject:(NSString *)item]; bhsMinorProphetsCount++; } break;
        case 4: { [bhsKethubimPoetryArray addObject:(NSString *)item]; bhsKethubimPoetryCount++; } break;
        case 5: { [bhsKethubimHistoryArray addObject:(NSString *)item]; bhsKethubimHistoryCount++; } break;
        default: break;
    }
}

- (NSArray *) getListBoxGroupArray: (NSInteger) groupCode
{
    switch (groupCode)
    {
        case 0: return [[NSArray alloc] initWithArray:bhsPentateuchArray];
        case 1: return [[NSArray alloc] initWithArray:bhsFormerProphetsArray];
        case 2: return [[NSArray alloc] initWithArray:bhsMajorProphetsArray];
        case 3: return [[NSArray alloc] initWithArray:bhsMinorProphetsArray];
        case 4: return [[NSArray alloc] initWithArray:bhsKethubimPoetryArray];
        case 5: return [[NSArray alloc] initWithArray:bhsKethubimHistoryArray];
        default: return nil;
    }
}

- (void) addLXXListBoxGroupItem: (NSString *) item withCode: (NSInteger) code
{
    switch (code)
    {
        case 0: { [lxxPentateuchArray addObject:(NSString *)item]; lxxPentateuchCount++; } break;
        case 1: { [lxxFormerProphetsArray addObject:(NSString *)item]; lxxFormerProphetsCount++; } break;
        case 2: { [lxxMajorProphetsArray addObject:(NSString *)item]; lxxMajorProphetsCount++; } break;
        case 3: { [lxxMinorProphetsArray addObject:(NSString *)item]; lxxMinorProphetsCount++; } break;
        case 4: { [lxxKethubimPoetryArray addObject:(NSString *)item]; lxxKethubimPoetryCount++; } break;
        case 5: { [lxxKethubimHistoryArray addObject:(NSString *)item]; lxxKethubimHistoryCount++; } break;
        case 6: { [lxxPseudepigraphaArray addObject:(NSString *)item]; lxxPseudepigraphaCount++; } break;
        default: break;
    }
}

- (NSArray *) getLXXListBoxGroupArray: (NSInteger) groupCode
{
    switch (groupCode)
    {
        case 0: return [[NSArray alloc] initWithArray:lxxPentateuchArray];
        case 1: return [[NSArray alloc] initWithArray:lxxFormerProphetsArray];
        case 2: return [[NSArray alloc] initWithArray:lxxMajorProphetsArray];
        case 3: return [[NSArray alloc] initWithArray:lxxMinorProphetsArray];
        case 4: return [[NSArray alloc] initWithArray:lxxKethubimPoetryArray];
        case 5: return [[NSArray alloc] initWithArray:lxxKethubimHistoryArray];
        case 6: return [[NSArray alloc] initWithArray:lxxPseudepigraphaArray];
        default: return nil;
    }
}

- (NSString *) convertIntegerToString: (NSInteger) sourceInt
{
    return [[NSString alloc] initWithFormat:@"%ld", sourceInt];
}

- (void) setCopyOption: (NSInteger) optionCode forCopyType: (NSInteger) copyType forTextType: (NSInteger) textType withValue: (NSInteger) optionValue
{
    /*===============================================================================================*
     *                                                                                               *
     *        Variables used for configuring copy options                                            *
     *        -------------------------------------------                                            *
     *                                                                                               *
     *  Each of the dictionaries below are keyed as follows:                                         *
     *                                                                                               *
     *        copyType                   referring to BHS Text        referring to LXX Text          *
     *        --------                   ---------------------        ---------------------          *
     *   relating to word copy                    0                            4                     *
     *   relating to verse copy                   1                            5                     *
     *   relating to chapter copy                 2                            6                     *
     *   relating to selection copy               3                            7                     *
     *                                                                                               *
     *  The dictionaries perform the following functions:                                            *
     *                                                                                               *
     *                              value is "Y"                        value is "N"                 *
     *                              ------------                        ------------                 *
     *   destinationCopy      Copied text will go to Pasteboard  Copied text will go to active Note  *
     *   referenceOption      The reference will be included     The reference will not be included  *
     *   accentsOption        Original accents will be included  Accents will not be included        *
     *   useExistingOption    I.e. the options dialog will be    The options dialog will not be      *
     *                          displayed                          displayed and inherited options   *
     *                                                             will be used                      *
     *                                                                                               *
     *   Parameters:                                                                                 *
     *   ==========                                                                                  *
     *                           Value                      Meaning                                  *
     *   optionCode                0           Update the value of copy destination for the text     *
     *                             1           referenceOption                                       *
     *                             2           accentOption                                          *
     *                             3           useExistingOption                                     *
     *                                                                                               *
     *   textType                  0           BHS                                                   *
     *                             1           LXX (i.e. add 4 to optionCode)                        *
     *                                                                                               *
     *   optionValue               0           "N"                                                   *
     *                             1           "Y"                                                   *
     *                                                                                               *
     *===============================================================================================*/

    NSInteger revisedCopyType;
    
    revisedCopyType = copyType;
    if( textType == 1) revisedCopyType += 4;
    switch (optionCode)
    {
        case 0: [self updateOptionDictionary:destinationCopy withKey:revisedCopyType andValue:optionValue]; break;
        case 1: [self updateOptionDictionary:referenceOption withKey:revisedCopyType andValue:optionValue]; break;
        case 2: [self updateOptionDictionary:accentsOption withKey:revisedCopyType andValue:optionValue]; break;
        case 3: [self updateOptionDictionary:useExistingOption withKey:revisedCopyType andValue:optionValue]; break;
        default: break;
    }
}

- (void) updateOptionDictionary: (NSMutableDictionary *) dictionary withKey: (NSInteger) key andValue: (NSInteger) value
{
    NSString *valueCandidate, *keyString, *valueString;

    keyString = [self convertIntegerToString:key];
    if( value == 0) valueString = @"N";
    else valueString = @"Y";
    valueCandidate = nil;
    valueCandidate = [dictionary objectForKey:keyString];
    if( valueCandidate != nil) [dictionary removeObjectForKey:keyString];
    [dictionary setObject:valueString forKey:keyString];
}

- (NSInteger) getCopyOption: (NSInteger) optionCode forCopyType: (NSInteger) copyType forTextType: (NSInteger) textType
{
    NSInteger revisedCopyType;
    NSString *valueCandidate, *keyString;

    revisedCopyType = copyType;
    if( textType == 1) revisedCopyType += 4;
    keyString = [self convertIntegerToString:revisedCopyType];
    valueCandidate = nil;
    switch (optionCode)
    {
        case 0: valueCandidate = [destinationCopy objectForKey:keyString]; break;
        case 1: valueCandidate = [referenceOption objectForKey:keyString]; break;
        case 2: valueCandidate = [accentsOption objectForKey:keyString]; break;
        case 3: valueCandidate = [useExistingOption objectForKey:keyString]; break;
        default: break;
    }
    if( valueCandidate != nil)
    {
        if( [valueCandidate compare:@"Y"] == NSOrderedSame ) return 1;
        else return 0;
    }
    return -1;
}

@end
