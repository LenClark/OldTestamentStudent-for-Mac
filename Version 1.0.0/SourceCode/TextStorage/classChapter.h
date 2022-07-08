//
//  classChapter.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classVerse.h"

NS_ASSUME_NONNULL_BEGIN

@interface classChapter : NSObject
{
@private
    NSInteger bookId;
    NSString *chapterId;
    classChapter *previousChapter, *nextChapter;
}
@property (nonatomic) NSUInteger noOfVersesInChapter;
@property (retain) NSMutableDictionary *versesInChapter;
@property (retain) NSMutableDictionary *verseLookup;
@property (retain) NSMutableDictionary *verseSequence;

-(void) initialise: (NSInteger) inBookId forChapter: (NSString *) inChapId;
- (NSInteger) getBookId;
- (NSString *) getChapterId;
- (classChapter *) getPreviousChapter;
- (classChapter *) getNextChapter;
- (void) setBookId: (NSInteger) inBookId;
- (void) setChapterId: (NSString *) inChapterId;
- (void) setPreviousChapter:(classChapter *)InPreviousChapter;
- (void) setNextChapter:(nullable classChapter *)InNextChapter;
- (NSUInteger) NoOfVersesInChapter;
- (classVerse *) getVerseBySeqNo: (NSInteger) seqNo;
- (classVerse *) getVerseByVerseNo: (NSString *) verseId;
- (NSString *) getVerseIdBySeqNo: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
