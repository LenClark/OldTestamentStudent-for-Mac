//
//  classLXXText.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classLXXBook.h"
#import "classLXXChapter.h"
#import "classLXXVerse.h"
#import "classLXXWord.h"
#import "classAlert.h"
#import "classGkLexicon.h"
#import "classDisplayUtilities.h"
#import "frmProgress.h"
#import "classLXXNotes.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLXXText : NSObject

@property (retain) classLXXNotes *lxxNotes;
@property (retain) classDisplayUtilities *lxxTextUtilities;
@property (retain) NSRunLoop *lxxLoop;
@property (retain) frmProgress *lxxProgress;
@property (retain) NSMutableDictionary *bookList;

- (id) init: (classGlobal *) inGlobal withLexicon: (classGkLexicon *) inLexicon andUtilities: (classDisplayUtilities *) inUtilities;
- (void) loadText;
- (void) displayChapter: (NSString *) chapIdx forBook: (NSInteger) bookIdx;
- (void) handleComboBoxChange: (NSUInteger) targetCbCode;
- (void) analysis;
- (void) prevOrNextChapter: (NSInteger) forwardBack;
- (void) changeOfHistoryReference;
- (void) processSearchAction: (NSInteger) actionCode;

@end

NS_ASSUME_NONNULL_END
