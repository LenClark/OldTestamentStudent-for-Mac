//
//  classText.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "classBook.h"
#import "classChapter.h"
#import "classVerse.h"
#import "classWord.h"
#import "GBSAlert.h"
#import "classGreekProcessing.h"
#import "classCleanReturn.h"
#import "classLexicon.h"
#import "classScanReturn.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface classText : NSObject

@property (nonatomic) BOOL isChapUpdateActive;
@property (nonatomic) NSInteger noOfNtBooks;
@property (nonatomic) NSInteger noOfLxxBooks;

- (id) init: (classConfig *) inConfig greekProcessing: (classGreekProcessing *) inGkProc withLexicon: (classLexicon *) inLexicon;
- (NSInteger) NoOfNtBooks;
- (NSInteger) NoOfLxxBooks;
- (NSArray *) storeAllText;
- (void) displayNTChapter: (NSInteger) bookIdx forChapter: (NSString *) chapIdx withNewBookFlag: (BOOL) isNewBook;
- (void) displayLxxChapter: (NSInteger) bookIdx forChapter: (NSString *) chapIdx withNewBookFlag: (BOOL) isNewBook;
- (void) handleComboBoxChange: (NSInteger) targetCbCode withListIndex: (NSInteger) listIndex andSelectedItem: (NSString *) selectedItem andBookCode: (NSInteger) bookCode;
- (void) performAnalysis: (NSString *) verseLine withCursorPosition: (NSInteger) currPstn oldOrNew: (NSUInteger) textViewIndicator
               forBookId: (NSInteger) bookId andChapterId: (NSString *) chapId andVerseId: (NSString *) verseId;
- (void) displayNewNote: (NSInteger) testamentId withSelectedItem: (NSString *) selectedValue;
- (void) loadHistory;
- (void) saveHistory;
- (void) prevOrNextChapter: (NSInteger) forwardBack forTestament: (NSInteger) ntLxxCode;
- (void) processSelectedHistory: (NSInteger) historyCode;
@end

NS_ASSUME_NONNULL_END
