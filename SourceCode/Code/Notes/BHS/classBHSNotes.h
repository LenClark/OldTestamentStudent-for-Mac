//
//  classBHSNotes.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 04/06/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSNotes : NSObject

- (id) init: (classGlobal *) inConfig;
-(void) storeANoteFor: (NSInteger) bookId chapterSequence: (NSInteger) chapIdx andVerseSequence: (NSInteger) verseIdx;
-(void) retrieveANoteFor: (NSInteger) bookId chapterSequence: (NSInteger) chapIdx andVerseSequence: (NSInteger) verseIdx;

@end

NS_ASSUME_NONNULL_END
