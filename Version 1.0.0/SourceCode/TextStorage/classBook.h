//
//  classBook.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "classChapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBook : NSObject

@property (retain) NSString *bookName;
@property (retain) NSString *shortName;
@property (retain) NSString *fileName;
@property (nonatomic) NSInteger noOfChaptersInBook;
@property (retain) NSMutableDictionary *chaptersInBook;
@property (retain) NSMutableDictionary *chapterLookup;
@property (retain) NSMutableDictionary *chapterSequence;

-(void) initialise: (classConfig *) passedConfig forBook: (NSString *) currentBookName;
- (classChapter *) getChapterBySeqNo: (NSInteger) seqNo;
- (classChapter *) getChapterByChapterId: (NSString *) chapterId;
- (NSInteger) getSeqNoByChapterId: (NSString *) chapterId;
- (NSString *) getChapterIdBySeqNo: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
