//
//  classBHSSearchVerse.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 29/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classBHSVerse.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSSearchVerse : NSObject

@property (nonatomic) BOOL isFollowed;
@property (nonatomic) NSInteger bookId;
@property (nonatomic) NSInteger chapterNumber;
@property (nonatomic) NSInteger verseNumber;
@property (nonatomic) NSInteger noOfMatchingWords;
@property (retain) NSString *chapterReference;
@property (retain) NSString *verseReference;
@property (retain) classBHSVerse *impactedVerse;
@property (retain) NSMutableDictionary *matchingWordPositions;
@property (retain) NSMutableDictionary *matchingWordType;

- (id) init: (classGlobal *) inGlobal;
- (void) addWordPosition: (NSInteger) position forWordType: (NSInteger) wordType;
- (NSInteger) getWordPositionBySeq: (NSInteger) index;
- (NSInteger) getWordTypeBySeq: (NSInteger) index;

@end

NS_ASSUME_NONNULL_END
