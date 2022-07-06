//
//  classBHSPrimaryResult.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 29/05/2022.
//

#import <Foundation/Foundation.h>
#import "classBHSVerse.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSPrimaryResult : NSObject

@property (nonatomic) BOOL isRepeatInVerse;
@property (nonatomic) NSInteger bookId;
@property (nonatomic) NSInteger chapSeq;
@property (nonatomic) NSInteger verseSeq;
@property (nonatomic) NSInteger noOfMatchingWords;
@property (retain) NSString *chapReference;
@property (retain) NSString *verseReference;
@property (retain) NSMutableDictionary *matchingWordPositions;
@property (retain) classBHSVerse *impactedVerse;

- (void) addWordPosition: (NSInteger) position;
- (NSInteger) getWordPositionBySeq: (NSInteger) index;

@end

NS_ASSUME_NONNULL_END
