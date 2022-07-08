//
//  AppDelegate.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 04/01/2021.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "classConfig.h"
#import "classRegistry.h"
#import "classGreekProcessing.h"
#import "classLexicon.h"
#import "classText.h"
#import "classKeyboard.h"
#import "classSearch.h"
#import "classSearchRecord.h"
#import "classNotes.h"
#import "classVocab.h"
#import "frmStart.h"
#import "frmManageNotes.h"
#import "frmPreferences.h"
#import "frmHelp.h"
#import "frmAbout.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextViewDelegate, NSTabViewDelegate, NSComboBoxDelegate>

@property (retain) classConfig *globalVars;
@property (retain) IBOutlet NSWindow *mainWindow;
@property (retain) IBOutlet NSView *initialView;

/*************************************************
 *
 *              Main Text Areas
 *              ===============
 */

@property (retain) IBOutlet NSTextView *ntTextView;
@property (retain) IBOutlet NSTextView *lxxTextView;
@property (retain) IBOutlet NSTextView *parseTextView;
@property (retain) IBOutlet NSTextView *lexiconTextView;
@property (retain) IBOutlet NSTextView *searchTextView;
@property (retain) IBOutlet NSTextView *vocabTextView;
@property (retain) IBOutlet NSTextView *notesTextView;

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

@property (retain) IBOutlet NSComboBox *cbNtBook;
@property (retain) IBOutlet NSComboBox *cbNtChapter;
@property (retain) IBOutlet NSComboBox *cbNtVerse;
@property (retain) IBOutlet NSComboBox *cbNtHistory;
@property (retain) IBOutlet NSButton *btnNtPrevChapter;
@property (retain) IBOutlet NSButton *btnNtNextChapter;

/**------------------------------------------------
 *
 *           Old Testament
 *           =============
 */

@property (retain) IBOutlet NSComboBox *cbLxxBook;
@property (retain) IBOutlet NSComboBox *cbLxxChapter;
@property (retain) IBOutlet NSComboBox *cbLxxVerse;
@property (retain) IBOutlet NSComboBox *cbLxxHistory;
@property (retain) IBOutlet NSButton *btnLxxPrevChapter;
@property (retain) IBOutlet NSButton *btnLxxNextChapter;

/*************************************************
 *
 *           Main Screen, overall Views
 *           ==========================
 */

@property (retain) IBOutlet NSTabView *topLeftTabView;
@property (retain) IBOutlet NSTabView *topRightTabView;
@property (retain) IBOutlet NSTabView *bottomRightTabView;
@property (retain) IBOutlet NSTabViewItem *tabNewTestament;
@property (retain) IBOutlet NSTabViewItem *tabSeptuagint;
@property (retain) IBOutlet NSTabViewItem *tabParse;
@property (retain) IBOutlet NSTabViewItem *tabLexicon;
@property (retain) IBOutlet NSTabViewItem *tabSearch;
@property (retain) IBOutlet NSTabViewItem *tabVocab;
@property (retain) IBOutlet NSTabViewItem *tabNotes;
@property (retain) IBOutlet NSSplitView *mainSplitView;
@property (retain) IBOutlet NSSplitView *rightSplitView;
@property (retain) IBOutlet NSView *leftUpperSubView;
@property (retain) IBOutlet NSSplitView *leftSplitView;
@property (retain) IBOutlet NSView *keyboardHeader;

/*************************************************
 *
 *           Web Views, for Lexicon Appendix
 *           ===============================
 */

@property (retain) IBOutlet NSTextView *webComments;
@property (retain) IBOutlet NSTextView *webAuthors;
@property (retain) IBOutlet NSTextView *webEpigraphical;
@property (retain) IBOutlet NSTextView *webPapyrologicl;
@property (retain) IBOutlet NSTextView *webPeriodicals;
@property (retain) IBOutlet NSTextView *webAbbreviations;

/*************************************************
 *
 *           Outlets and Variables for Search
 *           ================================
 */

/*------------------------------------------------
 *      Variables for the listbox
 *      -------------------------
 */

@property (retain) IBOutlet NSTableView *booksOfBible;
@property (retain) NSMutableArray *booksOfBibleColumn;
@property (retain) NSArray *booksMaster;

/*------------------------------------------------
 *      Variables for the various options
 *      ---------------------------------
 */

@property (retain) IBOutlet NSButton *chkMoses;
@property (retain) IBOutlet NSButton *chkHistory;
@property (retain) IBOutlet NSButton *chkWisdom;
@property (retain) IBOutlet NSButton *chkProphets;
@property (retain) IBOutlet NSButton *chkGospels;
@property (retain) IBOutlet NSButton *chkPaul;
@property (retain) IBOutlet NSButton *chkRest;
@property (retain) IBOutlet NSButton *rbtnExclude;
@property (retain) IBOutlet NSButton *rbtnInclude;

/*------------------------------------------------
 *      Other Controls
 *      --------------
 */

@property (retain) IBOutlet NSTextView *primarySearchWord;
@property (retain) IBOutlet NSTextView *secondarySearchWord;
@property (retain) IBOutlet NSScrollView *secondarySuperView;
@property (retain) IBOutlet NSButton *performSearch;
@property (retain) IBOutlet NSButton *advancedSearch;
@property (retain) IBOutlet NSButton *btnRemove;
@property (retain) IBOutlet NSButton *btnReinstate;
@property (retain) IBOutlet NSButton *btnRoot;
@property (retain) IBOutlet NSButton *btnExact;
@property (retain) IBOutlet NSTextField *labWithin;
@property (retain) IBOutlet NSTextField *labWordsOf;
@property (retain) IBOutlet NSTextField *txtWordSeperation;
@property (retain) IBOutlet NSStepper *stepperWordSeperation;
@property (retain) IBOutlet NSTextField *statusLabel;
@property (retain) IBOutlet NSTextField *statusLabel2;

/*************************************************
 *
 *           Outlets and Variables for Keyboard
 *           ================================
 */

@property (retain) IBOutlet NSView *keyboardView;
@property (retain) IBOutlet NSButton *btnKeyboard;
@property (retain) IBOutlet NSButton *rbtnNotes;
@property (retain) IBOutlet NSButton *rbtnPrimary;
@property (retain) IBOutlet NSButton *rbtnSecondary;

/*************************************************
 *
 *           Variables for TextView Delegates
 *           ================================
 *
 *  For explanations, see the main code file.
 */

@property (nonatomic) NSUInteger textViewIndicator;
@property (nonatomic) NSInteger latestCursorPosition;
@property (nonatomic) NSRange latestLineRange;
@property (nonatomic) NSInteger latestRevisedCursorPosition;
@property (nonatomic) NSInteger latestMouseButton;
@property (nonatomic) NSInteger latestClickCount;
@property (nonatomic) NSInteger currentlyVisibleText;

/*************************************************
 *
 *           Variables for Setting Vocab Lists
 *           =================================
 *
 */

@property (retain) IBOutlet NSButton *rbtnListVerse;
@property (retain) IBOutlet NSButton *rbtnListChapter;
@property (retain) IBOutlet NSButton *rbtnDisplayTypeAlpha;
@property (retain) IBOutlet NSButton *rbtnDisplayTypeOrder;
@property (retain) IBOutlet NSButton *rbtnDisplayMixedAlpha;
@property (retain) IBOutlet NSButton *rbtnDisplayMixedOrder;
@property (retain) IBOutlet NSButton *rbtnActualWords;
@property (retain) IBOutlet NSButton *rbtnRootWords;
@property (retain) IBOutlet NSButton *rbtnActualAndRoot;
@property (retain) IBOutlet NSButton *chkNouns;
@property (retain) IBOutlet NSButton *chkVerbs;
@property (retain) IBOutlet NSButton *chkAdjectives;
@property (retain) IBOutlet NSButton *chkAdverbs;
@property (retain) IBOutlet NSButton *chkPrepositions;
@property (retain) IBOutlet NSButton *chkOther;

/*************************************************
 *
 *           Menus
 *           =====
 *
 */

@property (retain) IBOutlet NSMenu *mainTextContextMenu;
@property (retain) IBOutlet NSMenu *parseLexiconContextMenu;
@property (retain) IBOutlet NSMenu *searchContextMenu;
@property (retain) IBOutlet NSMenu *notesContextMenu;
@property (retain) IBOutlet NSMenu *vocabListContextMenu;

/*************************************************
 *
 *           Progress Window - Initialisation
 *           ======== ======   ==============
 *
 */

@property (retain) NSProgressIndicator *initialisationProgress;
@property (retain) NSTextField *labProgress1;
@property (retain) NSTextField *labProgress2;
@property (retain) NSRunLoop *mainLoop;

- (void) locateCurrentTextView: (NSInteger) testamentCode forTextView: (NSInteger) textViewCode;
- (void) mouseDownCursorRecord: (NSInteger) cursorPosition targetCode: (NSInteger) targetCode inVerse: (NSString *) verseRef containingLineRange: (NSRange) lineRange
     withRevisedCursorPosition: (NSInteger) revCsrPstn whichMouseButton: (NSInteger) mouseButton howManyClicks: (NSInteger) clickCount;
-(void) remotePause: (NSString *) lab1Message withSecondMsg: (NSString *) lab2Message andOption: (BOOL) isChanged withOptionValue: (BOOL) isHidden;

@end

