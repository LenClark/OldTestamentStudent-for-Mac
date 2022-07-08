//
//  classNotes.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 18/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "classBook.h"
#import "classChapter.h"
#import "classVerse.h"

NS_ASSUME_NONNULL_BEGIN

@interface classNotes : NSObject

- (id) init: (classConfig *) inConfig;
- (void) retrieveAllNotes;
-(void) saveAllNotes;
-(void) clearAllNotes;
-(void) storeANote;
- (void) displayANote: (NSInteger) testamentId forBookId: (NSInteger) bookId chapterSequence: (NSInteger) chapSeq verseSequence: (NSInteger) verseSeq;

@end

NS_ASSUME_NONNULL_END
