//
//  classLXXPrimaryResult.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 31/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classLXXVerse.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLXXPrimaryResult : NSObject

@property (nonatomic) BOOL isRepeatInVerse;
@property (nonatomic) NSInteger bookId;
@property (nonatomic) NSInteger chapSeq;
@property (nonatomic) NSInteger verseSeq;
@property (nonatomic) NSInteger noOfMatchingWords;
@property (retain) NSString *chapReference;
@property (retain) NSString *verseReference;
@property (retain) NSMutableDictionary *matchingWordPositions;
@property (retain) classLXXVerse *impactedVerse;

- (id) init: (classGlobal *) inGlobal;
- (void) addWordPosition: (NSInteger) position;
- (NSInteger) getWordPositionBySeq: (NSInteger) index;

@end

NS_ASSUME_NONNULL_END
