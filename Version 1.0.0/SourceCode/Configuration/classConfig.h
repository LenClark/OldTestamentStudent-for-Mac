//
//  classConfig.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface classConfig : NSObject

@property (retain) NSWindow *mainWindow;

/*==============================================
 *
 *  File system variables (paths and directories)
 *
 */

@property (retain) NSString *basePath;
@property (retain) NSString *lfcFolder;
@property (retain) NSString *appFolder;
@property (retain) NSString *iniPath;
@property (retain) NSString *iniFile;

/*==============================================
 *
 *  Notes
 *
 */

@property (retain) NSString *notesFolder;
@property (retain) NSString *notesName;

/*==============================================
 *
 *  Textviews
 *
 */

@property (retain) NSTextView *ntTextView;
@property (retain) NSTextView *lxxTextView;
@property (retain) NSTextView *parseTextView;
@property (retain) NSTextView *lexiconTextView;
@property (retain) NSTextView *searchTextView;
@property (retain) NSTextView *vocabTextView;
@property (retain) NSTextView *notesTextView;

/*==============================================
 *
 *  Storage structures
 *
 */

@property (retain) NSDictionary *ntListOfBooks;
@property (retain) NSDictionary *lxxListOfBooks;

/*==============================================
 *
 *  Windows objects for other classes
 *
 */

@property (retain) NSArray *collectionOfWebViews;
@property (nonatomic) NSComboBox *cbNtBook;
@property (nonatomic) NSComboBox *cbNtChapter;
@property (nonatomic) NSComboBox *cbNtVerse;
@property (nonatomic) NSComboBox *cbLxxBook;
@property (nonatomic) NSComboBox *cbLxxChapter;
@property (nonatomic) NSComboBox *cbLxxVerse;
@property (retain) NSTabView *topLeftTabView;
@property (retain) NSTabView *topRightTabView;
@property (retain) NSTabView *bottomRightTabView;
@property (retain) IBOutlet NSTabViewItem *tabNewTestament;
@property (retain) IBOutlet NSTabViewItem *tabSeptuagint;
@property (retain) IBOutlet NSSplitView *rightSplitView;
@property (nonatomic) CGFloat dividerPstn;
@property (nonatomic) CGFloat mainDividerPosition;

/*==============================================
 *
 *  Specific collections
 *
 */

@property (retain) NSArray *booksMaster;
@property (retain) NSArray *gospels;
@property (retain) NSArray *paul;
@property (retain) NSArray *restOfNT;
@property (retain) NSArray *Pent;
@property (retain) NSArray *history;
@property (retain) NSArray *wisdom;
@property (retain) NSArray *prophets;
@property (retain) NSTextField *statusLabel;
@property (retain) NSTextField *statusLabel2;

/*==============================================
 *
 *  Handling history
 *
 */

@property (retain) NSComboBox *cbNtHistory;
@property (retain) NSComboBox *cbLxxHistory;
@property (nonatomic) NSInteger historyMax;

/*==============================================
 *
 *  Variables for keyboard management
 *
 */

@property (retain) NSView *keyboardView;
@property (retain) NSButton *rbtnNotes;
@property (retain) NSButton *rbtnPrimary;
@property (retain) NSButton *rbtnSecondary;

/*==============================================
 *
 *  Variables for search form
 *
 */

@property (retain) NSTextView *primarySearchWord;
@property (retain) NSTextView *secondarySearchWord;

/*==============================================
 *
 *  Dimensions and variables relating to the main form
 *
 */

@property (nonatomic) NSInteger mainX;
@property (nonatomic) NSInteger mainY;
@property (nonatomic) NSInteger mainWidth;
@property (nonatomic) NSInteger mainHeight;

/*==============================================
 *
 *  Variables for the preferences form
 *
 *  fgColour and bgColour are arrays of NSColor
 *  prefsFgColours and prefsBgColours are arrays of
 *    NSColor as well; they are mutable so that
 *    individual elements can be changed
 */

@property (retain) NSArray *fontSize;
@property (retain) NSArray *fgColour;
@property (retain) NSArray *bgColour;
@property (retain) NSColor *searchPrimaryColour;
@property (retain) NSColor *searchSecondaryColour;

@property (retain) NSMutableArray *prefsTextViews;
@property (retain) NSMutableArray *prefsFontSize;
@property (retain) NSMutableArray *prefsFgColours;
@property (retain) NSMutableArray *prefsBgColours;
@property (retain) NSColor *prefsPrimaryColour;
@property (retain) NSColor *prefsSecondaryColour;
@property (retain) NSObject *appDelegate;
@property (nonatomic) BOOL prefsOK;

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


@end

NS_ASSUME_NONNULL_END
