/*=======================================================================*
 *                                                                       *
 *                            classGlobal                                *
 *                            ===========                                *
 *                                                                       *
 *  Repository of:                                                       *
 *  a) all variables that are global to the project                      *
 *  b) ant methods that are common to most classes                       *
 *                                                                       *
 *  Created by Len Clark                                                 *
 *  May 2022                                                             *
 *                                                                       *
 *=======================================================================*/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
//#import "classDisplayUtilities.h"
//#import "classRegistry.h"
//#import "classGreekOrthography.h"

NS_ASSUME_NONNULL_BEGIN

@interface classGlobal : NSObject

/*============================================================================================*
 *       General variables (unreleated to any obvious theme).                                 *
 *============================================================================================*/
@property (retain) NSWindow *mainWindow;
//@property (retain) classRegistry *applicationRegistry;
//@property (retain) classGreekOrthography *gkOrthography;

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
@property (retain) NSComboBox *cbBHSBook;
@property (retain) NSComboBox *cbBHSChapter;
@property (retain) NSComboBox *cbBHSVerse;
@property (retain) NSComboBox *cbLXXBook;
@property (retain) NSComboBox *cbLXXChapter;
@property (retain) NSComboBox *cbLXXVerse;
@property (retain) NSComboBox *cbBHSHistory;
@property (retain) NSComboBox *cbLXXHistory;

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
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@property (retain) NSTextView *txtBHSText;
@property (retain) NSTextView *txtLXXText;
@property (retain) NSTextView *txtBHSNotes;
@property (retain) NSTextView *txtLXXNotes;
@property (retain) NSTextView *txtAllParse;
@property (retain) NSTextView *txtAllLexicon;
@property (retain) NSTextView *txtSearchResults;
@property (retain) NSTextView *txtKethibQere;

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
@property (retain) NSTabView *tabMain;
@property (retain) NSTabView *tabUtilities;
@property (retain) NSTabView *tabTopRight;
@property (retain) NSTabView *tabBHSUtilityDetail;
@property (retain) NSTabView *tabLXXUtilityDetail;

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
@property (retain) NSTabViewItem *itemMainBHS;
@property (retain) NSTabViewItem *itemMainLXX;
@property (retain) NSTabViewItem *itemBHSNotes;
@property (retain) NSTabViewItem *itemBHSSearch;
@property (retain) NSTabViewItem *itemBHSVariants;
@property (retain) NSTabViewItem *itemLXXNotes;
@property (retain) NSTabViewItem *itemLXXLS;
@property (retain) NSTabViewItem *itemLXXSearch;
@property (retain) NSTabViewItem *itemParse;
@property (retain) NSTabViewItem *itemLexicon;
@property (retain) NSTabViewItem *itemSearchResults;

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
@property (retain) NSView *viewHebrewKeyboard;
@property (retain) NSView *viewGreekKeyboard;
@property (retain) NSView *viewBHSHistoryPnl;
@property (retain) NSView *viewLXXHistoryPnl;

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
@property (retain) NSButton *btnBHSAdvanced;
@property (retain) NSButton *btnLXXAdvanced;
@property (retain) NSButton *btnStop;

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
@property (retain) NSTextField *txtBHSPrimaryWord;
@property (retain) NSTextField *txtBHSSecondaryWord;
@property (retain) NSTextField *txtLXXPrimaryWord;
@property (retain) NSTextField *txtLXXSecondaryWord;

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
@property (retain) NSSplitView *splitMain;
@property (retain) NSSplitView *splitBHSLeft;
@property (retain) NSSplitView *splitLXXLeft;
@property (retain) NSSplitView *splitRight;

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
@property (retain) NSButton *rbtnBDBRefs;
@property (retain) NSButton *rbtnBHSStrict;
@property (retain) NSButton *rbtnBHSModerate;
@property (retain) NSButton *rbtnLXXRootMatch;
@property (retain) NSButton *rbtnLXXExactMatch;
@property (retain) NSButton *rbtnBHSExclude;
@property (retain) NSButton *rbtnLXXExclude;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Web Browser controls  (group 10)                                                                   *
 *                                                                                                     *
 *    1         webGeneral                                                                             *
 *    2         webAuthors                                                                             *
 *    3         webEpigraphy                                                                           *
 *    4         webPapyrology                                                                          *
 *    5         webPeriodicals                                                                         *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@property (retain) WKWebView *webLandS;

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
@property (retain) NSTextField *labBHSSearchLbl;
@property (retain) NSTextField *labBHSWithinLbl;
@property (retain) NSTextField *labBHSWordsOfLbl;
@property (retain) NSTextField *labLXXSearchLbl;
@property (retain) NSTextField *labLXXWithinLbl;
@property (retain) NSTextField *labLXXWordsOfLbl;
@property (retain) NSTextField *labSearchProgress;

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
@property (retain) NSTableView *lbAvailableBHSBooks;
@property (retain) NSTableView *lbAvailableLXXBooks;

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

@property (retain) NSString *bhsTextEngName;
@property (retain) NSString *bhsTextMainName;
@property (retain) NSString *bhsTextVariantName;
@property (retain) NSString *lxxTextEngName;
@property (retain) NSString *lxxTextMainName;
@property (retain) NSString *parseTitleName;
@property (retain) NSString *parseTextName;
@property (retain) NSString *lexTitleName;
@property (retain) NSString *lexTextName;
@property (retain) NSString *lexPrimaryName;
@property (retain) NSString *searchEngName;
@property (retain) NSString *searchBHSMainName;
@property (retain) NSString *searchBHSPrimaryName;
@property (retain) NSString *searchBHSSecondaryName;
@property (retain) NSString *searchGreekMainName;
@property (retain) NSString *searchGreekPrimaryName;
@property (retain) NSString *searchGreekSecondaryName;
@property (retain) NSString *bhsNotesFontName;
@property (retain) NSString *lxxNotesFontName;
@property (retain) NSString *kqEngName;
@property (retain) NSString *kqMainName;

@property (nonatomic) NSInteger bhsTextEngStyle;
@property (nonatomic) NSInteger bhsTextMainStyle;
@property (nonatomic) NSInteger bhsTextVariantStyle;
@property (nonatomic) NSInteger lxxTextEngStyle;
@property (nonatomic) NSInteger lxxTextMainStyle;
@property (nonatomic) NSInteger parseTitleStyle;
@property (nonatomic) NSInteger parseTextStyle;
@property (nonatomic) NSInteger lexTitleStyle;
@property (nonatomic) NSInteger lexTextStyle;
@property (nonatomic) NSInteger lexPrimaryStyle;
@property (nonatomic) NSInteger searchEngStyle;
@property (nonatomic) NSInteger searchBHSMainStyle;
@property (nonatomic) NSInteger searchBHSPrimaryStyle;
@property (nonatomic) NSInteger searchBHSSecondaryStyle;
@property (nonatomic) NSInteger searchGreekMainStyle;
@property (nonatomic) NSInteger searchGreekPrimaryStyle;
@property (nonatomic) NSInteger searchGreekSecondaryStyle;
@property (nonatomic) NSInteger bhsNotesStyle;
@property (nonatomic) NSInteger lxxNotesStyle;
@property (nonatomic) NSInteger kqEngStyle;
@property (nonatomic) NSInteger kqMainStyle;

@property (nonatomic) CGFloat bhsTextEngSize;
@property (nonatomic) CGFloat bhsTextMainSize;
@property (nonatomic) CGFloat bhsTextVariantSize;
@property (nonatomic) CGFloat lxxTextEngSize;
@property (nonatomic) CGFloat lxxTextMainSize;
@property (nonatomic) CGFloat parseTitleSize;
@property (nonatomic) CGFloat parseTextSize;
@property (nonatomic) CGFloat lexTitleSize;
@property (nonatomic) CGFloat lexTextSize;
@property (nonatomic) CGFloat lexPrimarySize;
@property (nonatomic) CGFloat searchEngSize;
@property (nonatomic) CGFloat searchBHSMainSize;
@property (nonatomic) CGFloat searchBHSPrimarySize;
@property (nonatomic) CGFloat searchBHSSecondarySize;
@property (nonatomic) CGFloat searchGreekMainSize;
@property (nonatomic) CGFloat searchGreekPrimarySize;
@property (nonatomic) CGFloat searchGreekSecondarySize;
@property (nonatomic) CGFloat bhsNotesSize;
@property (nonatomic) CGFloat lxxNotesSize;
@property (nonatomic) CGFloat kqEngSize;
@property (nonatomic) CGFloat kqMainSize;

@property (retain) NSFont *bhsTextEngFont;
@property (retain) NSFont *bhsTextMainFont;
@property (retain) NSFont *bhsTextVariants;
@property (retain) NSFont *lxxTextEngFont;
@property (retain) NSFont *lxxTextMainFont;
@property (retain) NSFont *parseTitleFont;
@property (retain) NSFont *parseTextFont;
@property (retain) NSFont *lexTitleFont;
@property (retain) NSFont *lexTextFont;
@property (retain) NSFont *lexPrimaryFont;
@property (retain) NSFont *searchEngText;
@property (retain) NSFont *searchBHSMainText;
@property (retain) NSFont *searchBHSPrimaryText;
@property (retain) NSFont *searchBHSSecondaryText;
@property (retain) NSFont *searchGreekMainText;
@property (retain) NSFont *searchGreekPrimaryText;
@property (retain) NSFont *searchGreekSecondaryText;
@property (retain) NSFont *bhsNotesText;
@property (retain) NSFont *lxxNotesText;
@property (retain) NSFont *kqEngFont;
@property (retain) NSFont *kqMainFont;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Colours  (group 14)                                                                                *
 *                                                                                                     *
 *    These follow the same pattern as fonts except we have one additional colour for each area, which *
 *      is the area background colour.                                                                 *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/

@property (retain) NSColor *bhsTextEngColour;
@property (retain) NSColor *bhsTextMainColour;
@property (retain) NSColor *bhsTextVariantColour;
@property (retain) NSColor *bhsTextBackgroundColour;
@property (retain) NSColor *lxxTextEngColour;
@property (retain) NSColor *lxxTextMainColour;
@property (retain) NSColor *lxxTextBackgroundColour;
@property (retain) NSColor *parseTitleColour;
@property (retain) NSColor *parseTextColour;
@property (retain) NSColor *parseTextBackgroundColour;
@property (retain) NSColor *lexTitleColour;
@property (retain) NSColor *lexTextColour;
@property (retain) NSColor *lexPrimaryColour;
@property (retain) NSColor *lexTextBackgroundColour;
@property (retain) NSColor *searchEngColour;
@property (retain) NSColor *searchBHSMainColour;
@property (retain) NSColor *searchBHSPrimaryColour;
@property (retain) NSColor *searchBHSSecondaryColour;
@property (retain) NSColor *searchBHSBackgroundColour;
@property (retain) NSColor *searchGreekMainColour;
@property (retain) NSColor *searchGreekPrimaryColour;
@property (retain) NSColor *searchGreekSecondaryColour;
@property (retain) NSColor *searchGreekBackgroundColour;
@property (retain) NSColor *bhsNotesColour;
@property (retain) NSColor *bhsNotesBackgroundColour;
@property (retain) NSColor *lxxNotesColour;
@property (retain) NSColor *lxxNotesBackgroundColour;
@property (retain) NSColor *kqEngColour;
@property (retain) NSColor *kqMainColour;
@property (retain) NSColor *kqBackgroundColour;

/*============================================================================================*
 *       File system variables (paths and directories)                                        *
 *============================================================================================*/

@property (retain) NSString *basePath;
@property (retain) NSString *lfcFolder;
@property (retain) NSString *appFolder;
@property (retain) NSString *iniPath;
@property (retain) NSString *iniFile;

/*--------------------------------------------------
 *
 *  Relating to loading BHS text
 */
@property (retain) NSString *bhsTitlesFile;
@property (retain) NSString *bhsSourceFile;
@property (retain) NSString *kethibQereFile;

/*--------------------------------------------------
 *
 *  Relating to loading LXX text
 */
@property (retain) NSString *lxxTitlesFile;
@property (retain) NSString *lxxTextFolder;

/*--------------------------------------------------
 *
 *  Relating to notes
 */
@property (retain) NSString *notesPath;
@property (retain) NSString *bhsNotesFolder;
@property (retain) NSString *lxxNotesFolder;
@property (retain) NSString *specificBHSNoteFolder;
@property (retain) NSString *specificLXXNoteFolder;
@property (retain) NSString *bhsNotesName;
@property (retain) NSString *lxxNotesName;

/*--------------------------------------------------
 *
 *  Relating to help
 */
@property (retain) NSString *helpPath;
@property (retain) NSString *helpFile;

/*--------------------------------------------------
 *
 *  Relating to lexicon
 */
@property (retain) NSString *lexiconData;
@property (retain) NSString *GkLexicon;
@property (retain) NSString *mainLexFile;

/*--------------------------------------------------
 *
 *  Relating to parsing
 */
@property (retain) NSString *codeFile;
@property (retain) NSString *convertFile;

/*--------------------------------------------------
 *
 *  Relating to keyboard
 */
@property (retain) NSString *keyboardFolder;
@property (nonatomic) NSInteger bhsKeyViewMin;
@property (nonatomic) NSInteger bhsKeyViewMax;
@property (nonatomic) NSInteger lxxKeyViewMin;
@property (nonatomic) NSInteger lxxKeyViewMax;
@property (retain) NSButton *rbtnBHSNotes;
@property (retain) NSButton *rbtnBHSPrimary;
@property (retain) NSButton *rbtnBHSSecondary;
@property (retain) NSButton *rbtnLXXNotes;
@property (retain) NSButton *rbtnLXXPrimary;
@property (retain) NSButton *rbtnLXXSecondary;
@property (nonatomic) NSInteger noOfKeyboardRows;
@property (nonatomic) NSInteger keyGap;
@property (nonatomic) NSInteger keyHeight;
@property (nonatomic) NSInteger keyboardAreaTop;

/*--------------------------------------------------
 *
 *  Relating to Greek processing
 */
@property (retain) NSString *greekControlFolder;
@property (retain) NSString *gkAccute;
@property (retain) NSString *gkCircumflex;
@property (retain) NSString *gkDiaereses;
@property (retain) NSString *gkGrave;
@property (retain) NSString *gkIota;
@property (retain) NSString *gkRough;
@property (retain) NSString *gkSmooth;
@property (retain) NSString *gkConv1;
@property (retain) NSString *gkConv2;

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
@property (nonatomic) NSInteger latestBHSCursorPosition;
@property (nonatomic) NSRange latestBHSLineRange;
@property (retain) NSString *bhsVerseIsolate;
@property (retain) NSString *bhsVerseReferenceNo;
@property (nonatomic) NSInteger latestRevisedBHSCursorPosition;
@property (retain) NSString *latestSelectedBHSWord;
@property (nonatomic) NSInteger sequenceOfLatestBHSWord;

@property (nonatomic) NSInteger latestLXXCursorPosition;
@property (nonatomic) NSRange latestLXXLineRange;
@property (retain) NSString *lxxVerseIsolate;
@property (retain) NSString *lxxVerseReferenceNo;
@property (nonatomic) NSInteger latestRevisedLXXCursorPosition;
@property (retain) NSString *latestSelectedLXXWord;
@property (nonatomic) NSInteger sequenceOfLatestLXXWord;

/*=======================================================================================*
 *                                                                                       *
 *  Variables storing current activity - similar, the last book, chapter, verse seq.     *
 *  ----------------------------------                                                   *
 *                                                                                       *
 *  These variables are gathered and stored every time the verse combobox changes        *
 *                                                                                       *
 *  latestXXBookId         The bookId as generated from cbXXBook combobox index          *
 *  latestXXChapterSeq     Ditto for cbXXChapter                                         *
 *  latestXXVerseSeq       Ditto for cbXXVerse                                           *
 *                                                                                       *
 *======================================================================================*/
@property (nonatomic) NSInteger latestBHSBookId;
@property (nonatomic) NSInteger latestBHSChapterSeq;
@property (nonatomic) NSInteger latestBHSVerseSeq;
@property (nonatomic) NSInteger latestLXXBookId;
@property (nonatomic) NSInteger latestLXXChapterSeq;
@property (nonatomic) NSInteger latestLXXVerseSeq;

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

@property (nonatomic) BOOL isBHSChapterLoadActive;
@property (nonatomic) BOOL isLXXChapterLoadActive;
@property (nonatomic) BOOL isBHSHistoryLoadActive;
@property (nonatomic) BOOL isLXXHistoryLoadActive;

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
@property (nonatomic) NSInteger noOfBHSBooks;
@property (retain) NSDictionary *bhsBookList;
@property (nonatomic) NSInteger noOfLXXBooks;
@property (retain) NSDictionary *lxxBookList;

/*-----------------------------------------------------------------------------------------------*
 *                                                                                               *
 *  StrongRefLookup:                                                                             *
 *  ---------------                                                                              *
 *  Key:   A unique Strong Reference                                                             *
 *  Value: An instance of the class, classStrongToBDBLookup                                      *
 *                                                                                               *
 *-----------------------------------------------------------------------------------------------*/
@property (retain) NSMutableDictionary *strongRefLookup;

/*-----------------------------------------------------------------------------------------------*
 *                                                                                               *
 *    The rest of the related variables deal with current values, which change as the user acts  *
 *                                                                                               *
 *-----------------------------------------------------------------------------------------------*/
@property (nonatomic) NSInteger bhsCurrentBookIndex;
@property (nonatomic) NSInteger lxxCurrentBookIndex;
@property (retain) NSString *bhsCurrentChapter;
@property (retain) NSString *lxxCurrentChapter;

/*-----------------------------------------------------------------------------------------------*
 *                                                                                               *
 *    Data files for Greek Processing                                                            *
 *                                                                                               *
 *-----------------------------------------------------------------------------------------------*/
@property (retain) NSString *fullGkLexiconFile;
@property (retain) NSString *fullGkAccute;
@property (retain) NSString *fullGkCircumflex;
@property (retain) NSString *fullGkDiaereses;
@property (retain) NSString *fullGkGrave;
@property (retain) NSString *fullGkIota;
@property (retain) NSString *fullGkRough;
@property (retain) NSString *fullGkSmooth;
@property (retain) NSString *fullGkConv1;
@property (retain) NSString *fullGkConv2;

/*------------------------------------------------------------------------*
 *                                                                        *
 *               Variables relating to search processing                  *
 *               ---------------------------------------                  *
 *                                                                        *
 *------------------------------------------------------------------------*/
@property (nonatomic) BOOL isAborted;
@property (nonatomic) NSInteger primaryBHSBookId;
@property (nonatomic) NSInteger primaryBHSWordSeq;
@property (nonatomic) NSInteger secondaryBHSBookId;
@property (nonatomic) NSInteger secondaryBHSWordSeq;
@property (nonatomic) NSInteger primaryLXXBookId;
@property (nonatomic) NSInteger primaryLXXWordSeq;
@property (nonatomic) NSInteger secondaryLXXBookId;
@property (nonatomic) NSInteger secondaryLXXWordSeq;
@property (nonatomic) NSInteger noOfBHSBookGroups;
@property (nonatomic) NSInteger noOfLXXBookGroups;
@property (nonatomic) NSInteger noOfSearchObjects;
@property (nonatomic) NSInteger noOfBHSResultsItems;
@property (nonatomic) NSInteger noOfLXXResultsItems;
@property (nonatomic) NSInteger bhsRowIndex;
@property (nonatomic) NSInteger lxxRowIndex;
@property (retain) NSString *primaryBHSWord;
@property (retain) NSString *secondaryBHSWord;
@property (retain) NSString *primaryBHSChapNo;
@property (retain) NSString *primaryBHSVNo;
@property (retain) NSString *secondaryBHSChapNo;
@property (retain) NSString *secondaryBHSVNo;
@property (retain) NSString *primaryLXXWord;
@property (retain) NSString *secondaryLXXWord;
@property (retain) NSString *primaryLXXChapNo;
@property (retain) NSString *primaryLXXVNo;
@property (retain) NSString *secondaryLXXChapNo;
@property (retain) NSString *secondaryLXXVNo;
@property (retain) NSStepper *stepperBHSScan;
@property (retain) NSStepper *stepperLXXScan;
@property (retain) NSButton *btnBHSSearchType;
@property (retain) NSButton *btnLXXSearchType;
@property (retain) NSTextField *bhsSteps;
@property (retain) NSTextField *lxxSteps;
@property (retain) NSTableView *searchResultsTable;
@property (retain) NSButton *btnStopSearch;

/*---------------------------------------------------------------------------------------*
 *                                                                                       *
 *  Variables storing current activity - following those for the main text areas         *
 *  ----------------------------------                                                   *
 *                                                                                       *
 *  These variables are gathered and stored every time a mouse click occurs on the       *
 *    search results area.                                                               *
 *                                                                                       *
 *  latestSearchCursorPosition      The identified cursor position within the whole      *
 *                                    text area.                                         *
 *  latestSearchLineRange           This is an NSRange which would allow you to get the  *
 *                                    individual verse (including reference) from the    *
 *                                    text.                                              *
 *  searchVerseIsolate              A copy of the text, as garnered by latestLineRange   *
 *  searchVerseReferenceNo          The string value of the verse                        *
 *  latestRevisedSearchCursorPstn   The cursor position equivalent of the click in the   *
 *                                    verse (i.e. in verseIsolate).  Note: this is       *
 *                                    calculated.                                        *
 *                                                                                       *
 *---------------------------------------------------------------------------------------*/
@property (nonatomic) NSInteger latestSearchCursorPosition;
@property (nonatomic) NSRange latestSearchLineRange;
@property (retain) NSString *searchVerseIsolate;
@property (retain) NSString *searchVerseReferenceNo;
@property (nonatomic) NSInteger latestRevisedSearchCursorPstn;

/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  Data Sources for the search results                                                                *
 *  -----------------------------------                                                                *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@property (retain) NSArray *searchReferences;
@property (retain) NSArray *searchText;

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
@property (retain) NSArray *bhsAvailableBooksMaster;
@property (retain) NSArray *lxxAvailableBooksMaster;

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

@property (nonatomic) NSInteger noOfCopyOptions;
@property (retain) NSMutableDictionary *destinationCopy;
@property (retain) NSMutableDictionary *referenceOption;
@property (retain) NSMutableDictionary *accentsOption;
@property (retain) NSMutableDictionary *useExistingOption;

/*===============================================================================================*
 *                                                                                               *
 *        Variables used for controling the sizing of right-hand sub-areas                       *
 *        ----------------------------------------------------------------                       *
 *                                                                                               *
 *===============================================================================================*/

@property (nonatomic) CGFloat dividerPstn;


- (void) initialiseGlobal;
- (void) addListBoxGroupItem: (NSString *) item withCode: (NSInteger) code;
- (NSArray *) getListBoxGroupArray: (NSInteger) groupCode;
- (NSString *) convertIntegerToString: (NSInteger) sourceInt;
- (void) setCopyOption: (NSInteger) optionCode forCopyType: (NSInteger) copyType forTextType: (NSInteger) textType withValue: (NSInteger) optionValue;
- (NSInteger) getCopyOption: (NSInteger) optionCode forCopyType: (NSInteger) copyType forTextType: (NSInteger) textType;
- (void) addLXXListBoxGroupItem: (NSString *) item withCode: (NSInteger) code;
- (NSArray *) getLXXListBoxGroupArray: (NSInteger) groupCode;
- (void) reformFontForSetting: (NSInteger) settingCode;
- (void) reformAllFonts;

@end

NS_ASSUME_NONNULL_END
