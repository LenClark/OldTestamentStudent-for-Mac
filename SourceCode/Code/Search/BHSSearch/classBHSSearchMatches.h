//
//  classBHSSearchMatches.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 29/05/2022.
//

#import <Foundation/Foundation.h>
#import "classBHSWord.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSSearchMatches : NSObject

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
@property (retain) classBHSWord *primaryScanWord;
@property (retain) classBHSWord *secondaryScanWord;

@end

NS_ASSUME_NONNULL_END
