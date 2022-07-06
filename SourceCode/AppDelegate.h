//
//  AppDelegate.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 20/05/2022.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "classGlobal.h"
#import "classRegistry.h"
#import "classGreekOrthography.h"
#import "classBHSText.h"
#import "classLXXText.h"
#import "frmProgress.h"
#import "classHebKeyboard.h"
#import "classGkKeyboard.h"
//#import "classMTTextView.h"
#import "classHebLexicon.h"
#import "classGkLexicon.h"
#import "classDisplayUtilities.h"
#import "classBHSSearch.h"
#import "classLXXSearch.h"
#import "frmCopyOptions.h"
#import "classBHSBook.h"
#import "classBHSChapter.h"
#import "classBHSVerse.h"
#import "classBHSWord.h"
#import "classKethib_Qere.h"
#import "classAlert.h"
#import "classBHSNotes.h"
#import "classLXXNotes.h"
#import "frmManageNotes.h"
#import "frmNotesReport.h"
#import "frmPreferences.h"
#import "frmResetCopyOptions.h"
#import "frmHelp.h"
#import "classAbout.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSComboBoxDelegate, NSTextViewDelegate, NSTableViewDelegate, NSWindowDelegate>

/*==============================================*
 *             Class Definitions                *
 *==============================================*/
@property (retain) classGlobal *globalVars;
@property (retain) classRegistry *appRegistry;
@property (retain) classGreekOrthography *greekOrthography;
@property (retain) classBHSText *bhsText;
@property (retain) classLXXText *lxxText;
@property (retain) classHebKeyboard *hebKeyboard;
@property (retain) classGkKeyboard *gkKeyboard;
@property (retain) classHebLexicon *hebrewLexicon;
@property (retain) classGkLexicon *greekLexicon;
@property (retain) classDisplayUtilities *mainDispUtilities;
@property (retain) classBHSSearch *bhsSearch;
@property (retain) classLXXSearch *lxxSearch;
@property (retain) classBHSNotes *bhsNotes;
@property (retain) classLXXNotes *lxxNotes;

// Forms/Windows
@property (retain) frmProgress *progressDialog;
@property (retain) frmManageNotes *manageNotes;
@property (retain) frmCopyOptions *optionsForCopy;
@property (retain) frmPreferences *preferenceForm;
@property (retain) frmHelp *appHelp;
// @property (retain) frmResetCopyOptions *resetCopyOptions;

@property (retain) NSRunLoop *mainLoop;

/*==============================================*
 *       Outlets for the main window            *
 *==============================================*/

@property (retain) IBOutlet NSWindow *mainWindow;

/*==============================================*
 *           Menus                              *
 *==============================================*/

@property (retain) IBOutlet NSMenu *mainTextContextMenu;
@property (retain) IBOutlet NSMenu *searchResultsContextMenu;
@property (retain) IBOutlet NSMenuItem *mnuKethibQere;

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
@property (retain) IBOutlet NSComboBox *cbBHSBook;
@property (retain) IBOutlet NSComboBox *cbBHSChapter;
@property (retain) IBOutlet NSComboBox *cbBHSVerse;
@property (retain) IBOutlet NSComboBox *cbLXXBook;
@property (retain) IBOutlet NSComboBox *cbLXXChapter;
@property (retain) IBOutlet NSComboBox *cbLXXVerse;
@property (retain) IBOutlet NSComboBox *cbBHSHistory;
@property (retain) IBOutlet NSComboBox *cbLXXHistory;

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
@property (retain) IBOutlet NSTextView *txtBHSText;
@property (retain) IBOutlet NSTextView *txtLXXText;
@property (retain) IBOutlet NSTextView *txtBHSNotes;
@property (retain) IBOutlet NSTextView *txtLXXNotes;
@property (retain) IBOutlet NSTextView *txtAllParse;
@property (retain) IBOutlet NSTextView *txtAllLexicon;
@property (retain) IBOutlet NSTextView *txtSearchResults;
@property (retain) IBOutlet NSTextView *txtKethibQere;

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
@property (retain) IBOutlet NSTabView *tabMain;
@property (retain) IBOutlet NSTabView *tabUtilities;
@property (retain) IBOutlet NSTabView *tabTopRight;
@property (retain) IBOutlet NSTabView *tabBHSUtilityDetail;
@property (retain) IBOutlet NSTabView *tabLXXUtilityDetail;

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
@property (retain) IBOutlet NSTabViewItem *itemMainBHS;
@property (retain) IBOutlet NSTabViewItem *itemMainLXX;
@property (retain) IBOutlet NSTabViewItem *itemBHSNotes;
@property (retain) IBOutlet NSTabViewItem *itemBHSSearch;
@property (retain) IBOutlet NSTabViewItem *itemBHSVariants;
@property (retain) IBOutlet NSTabViewItem *itemLXXNotes;
@property (retain) IBOutlet NSTabViewItem *itemLXXLS;
@property (retain) IBOutlet NSTabViewItem *itemLXXSearch;
@property (retain) IBOutlet NSTabViewItem *itemParse;
@property (retain) IBOutlet NSTabViewItem *itemLexicon;
@property (retain) IBOutlet NSTabViewItem *itemSearchResults;

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
@property (retain) IBOutlet NSView *viewHebrewKeyboard;
@property (retain) IBOutlet NSView *viewGreekKeyboard;
@property (retain) IBOutlet NSView *viewBHSHistory;
@property (retain) IBOutlet NSView *viewLXXHistory;

@property (retain) IBOutlet NSButton *btnBHSShowKeyboard;
@property (retain) IBOutlet NSButton *btnLXXShowKeyboard;

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
@property (retain) IBOutlet NSButton *btnBHSAdvanced;
@property (retain) IBOutlet NSButton *btnLXXAdvanced;
@property (retain) IBOutlet NSButton *btnStop;

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
@property (retain) IBOutlet NSTextField *txtBHSPrimaryWord;
@property (retain) IBOutlet NSTextField *txtBHSSecondaryWord;
@property (retain) IBOutlet NSTextField *txtLXXPrimaryWord;
@property (retain) IBOutlet NSTextField *txtLXXSecondaryWord;

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
@property (retain) IBOutlet NSSplitView *splitMain;
@property (retain) IBOutlet NSSplitView *splitBHSLeft;
@property (retain) IBOutlet NSSplitView *splitLXXLeft;
@property (retain) IBOutlet NSSplitView *splitRight;

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
@property (retain) IBOutlet NSButton *rbtnBDBRefs;
@property (retain) IBOutlet NSButton *rbtnBHSStrict;
@property (retain) IBOutlet NSButton *rbtnBHSModerate;
@property (retain) IBOutlet NSButton *rbtnLXXRootMatch;
@property (retain) IBOutlet NSButton *rbtnLXXExactMatch;
@property (retain) IBOutlet NSButton *rbtnBHSExclude;
@property (retain) IBOutlet NSButton *rbtnLXXExclude;
@property (retain) IBOutlet NSButton *rbtnLandSGeneral;
@property (retain) IBOutlet NSButton *rbtnLandSAuthors;
@property (retain) IBOutlet NSButton *rbtnLandSEpigraphy;
@property (retain) IBOutlet NSButton *rbtnLandSPapyri;
@property (retain) IBOutlet NSButton *rbtnLandSPeriodicals;


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
@property (retain) IBOutlet WKWebView *webLandS;

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
@property (retain) IBOutlet NSTextField *labBHSSearchLbl;
@property (retain) IBOutlet NSTextField *labBHSWithinLbl;
@property (retain) IBOutlet NSTextField *labBHSWordsOfLbl;
@property (retain) IBOutlet NSTextField *labLXXSearchLbl;
@property (retain) IBOutlet NSTextField *labLXXWithinLbl;
@property (retain) IBOutlet NSTextField *labLXXWordsOfLbl;
@property (retain) IBOutlet NSTextField *labSearchProgress;

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
@property (retain) IBOutlet NSTableView *lbAvailableBHSBooks;
@property (retain) IBOutlet NSTableView *lbAvailableLXXBooks;
@property (retain) NSArray *bhsAvailableBooksMaster;
@property (retain) NSArray *lxxAvailableBooksMaster;

/*============================================================================================*
 *       Outlets relating to the setup and processing of search requests                      *
 *============================================================================================*/
/*-----------------------------------------------------------------------------------------------------*
 *                                                                                                     *
 *  BHS Search Outlets                                                                                 *
 *  ------------------                                                                                 *
 *                                                                                                     *
 *-----------------------------------------------------------------------------------------------------*/
@property (retain) IBOutlet NSTextField *bhsSteps;
@property (retain) IBOutlet NSStepper *bhsStepper;
@property (retain) IBOutlet NSTextField *lxxSteps;
@property (retain) IBOutlet NSStepper *lxxStepper;
@property (retain) IBOutlet NSButton *cbBHSPentateuch;
@property (retain) IBOutlet NSButton *cbBHSFormerProphets;
@property (retain) IBOutlet NSButton *cbBHSMajorProphets;
@property (retain) IBOutlet NSButton *cbBHSMinorProphets;
@property (retain) IBOutlet NSButton *cbBHSKethubimPoetry;
@property (retain) IBOutlet NSButton *cbBHSKethubimHistory;
@property (retain) IBOutlet NSButton *cbLXXPentateuch;
@property (retain) IBOutlet NSButton *cbLXXFormerProphets;
@property (retain) IBOutlet NSButton *cbLXXMajorProphets;
@property (retain) IBOutlet NSButton *cbLXXMinorProphets;
@property (retain) IBOutlet NSButton *cbLXXKethubimPoetry;
@property (retain) IBOutlet NSButton *cbLXXKethubimHistory;
@property (retain) IBOutlet NSButton *cbLXXPsedepigrapha;

/*===============================================================================================*
 *                                                                                               *
 *      Outlets relating to the menu controling right-hand sub-areas                             *
 *      ------------------------------------------------------------                             *
 *                                                                                               *
 *===============================================================================================*/
@property (retain) IBOutlet NSMenuItem *maximiseTop;
@property (retain) IBOutlet NSMenuItem *maximiseBottom;
@property (retain) IBOutlet NSMenuItem *equaliseBoth;

/*===============================================================================================*
 *                                                                                               *
 *      Setting and resetting copy options                                                       *
 *      ----------------------------------                                                       *
 *                                                                                               *
 *===============================================================================================*/
@property (retain) IBOutlet NSMenuItem *mnuChangeRemember;

@end

