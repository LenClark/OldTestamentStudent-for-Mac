//
//  classLXXSearchMatches.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 31/05/2022.
//

#import <Foundation/Foundation.h>
#import "classLXXWord.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLXXSearchMatches : NSObject

@property (nonatomic) BOOL isValid;
@property (nonatomic) NSInteger bookId;
@property (nonatomic) NSInteger primaryChapterSeq;
@property (nonatomic) NSInteger primaryVerseSeq;
@property (nonatomic) NSInteger primaryWordSeq;
@property (nonatomic) NSInteger secondaryChapterSeq;
@property (nonatomic) NSInteger secondaryVerseSeq;
@property (nonatomic) NSInteger secondaryWordSeq;
@property (retain) NSString *primaryChapterRef;
@property (retain) NSString *primaryVerseRef;
@property (retain) NSString *secondaryChapterRef;
@property (retain) NSString *secondaryVerseRef;
@property (retain) classLXXWord *primaryScanWord;
@property (retain) classLXXWord *secondaryScanWord;

@end

NS_ASSUME_NONNULL_END
