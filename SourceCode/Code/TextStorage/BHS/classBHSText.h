//
//  classBHSText.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import <Cocoa/Cocoa.h>
#import "classGlobal.h"
#import "classBHSBook.h"
#import "classBHSChapter.h"
#import "classBHSVerse.h"
#import "classBHSWord.h"
#import "classKethib_Qere.h"
#import "classWordToStrong.h"
#import "frmProgress.h"
#import "classAlert.h"
#import "classHebLexicon.h"
#import "classStrongToBDBLookup.h"
//#import "classBDBEntry.h"
//#import "classBDBEntryDetail.h"
#import "classDisplayUtilities.h"
#import "classBHSNotes.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSText : NSObject

@property (retain) classBHSNotes *bhsNotes;
@property (retain) NSMutableDictionary *variantList;
@property (retain) NSRunLoop *bhsLoop;
@property (retain) frmProgress *bhsProgress;
@property (retain) NSMutableDictionary *bhsBookList;
@property (retain) NSMutableDictionary *listOfStrongConversions;
@property (retain) NSMutableArray *strongConversionRef;
@property (retain) NSMutableDictionary *codeDecode;
@property (retain) NSMutableArray *codeRef;
@property (retain) NSMutableArray *variantRef;

- (id) init: (classGlobal *) inGlobal;
 - (void) loadText: (classHebLexicon *) inLex;
- (void) displayChapter: (NSString *) chapIdx forBook: (NSInteger) bookIdx;
- (void) handleComboBoxChange: (NSUInteger) targetCbCode;
- (void) analysis;
- (void) prevOrNextChapter: (NSInteger) forwardBack;
- (void) changeOfHistoryReference;
- (void) processSearchAction: (NSInteger) actionCode;

@end

NS_ASSUME_NONNULL_END
