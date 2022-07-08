//
//  classConfig.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import "classConfig.h"

@implementation classConfig

@synthesize mainWindow;
@synthesize basePath;
@synthesize lfcFolder;
@synthesize appFolder;
@synthesize iniPath;
@synthesize iniFile;
@synthesize notesFolder;
@synthesize notesName;
@synthesize ntTextView;
@synthesize lxxTextView;
@synthesize parseTextView;
@synthesize lexiconTextView;
@synthesize searchTextView;
@synthesize vocabTextView;
@synthesize notesTextView;
@synthesize ntListOfBooks;
@synthesize lxxListOfBooks;
@synthesize collectionOfWebViews;
@synthesize cbNtBook;
@synthesize cbNtChapter;
@synthesize cbNtVerse;
@synthesize cbLxxBook;
@synthesize cbLxxChapter;
@synthesize cbLxxVerse;
@synthesize cbNtHistory;
@synthesize cbLxxHistory;
@synthesize historyMax;
@synthesize topLeftTabView;
@synthesize topRightTabView;
@synthesize rightSplitView;
@synthesize dividerPstn;
@synthesize bottomRightTabView;
@synthesize mainDividerPosition;
@synthesize tabNewTestament;
@synthesize tabSeptuagint;
@synthesize booksMaster;
@synthesize gospels;
@synthesize paul;
@synthesize restOfNT;
@synthesize Pent;
@synthesize history;
@synthesize wisdom;
@synthesize prophets;
@synthesize statusLabel;
@synthesize statusLabel2;
@synthesize keyboardView;
@synthesize rbtnNotes;
@synthesize rbtnPrimary;
@synthesize rbtnSecondary;

/*==============================================
 *
 *  Dimensions and variables relating to the main form
 *
 */

@synthesize mainX;
@synthesize mainY;
@synthesize mainWidth;
@synthesize mainHeight;

@synthesize fontSize;
@synthesize fgColour;
@synthesize bgColour;
@synthesize searchPrimaryColour;
@synthesize searchSecondaryColour;

@synthesize prefsTextViews;
@synthesize prefsFgColours;
@synthesize prefsBgColours;
@synthesize prefsPrimaryColour;
@synthesize prefsSecondaryColour;
@synthesize appDelegate;
@synthesize prefsOK;

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

@end
