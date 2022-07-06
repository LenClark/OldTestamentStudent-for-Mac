//
//  classLXXVerse.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classLXXWord.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLXXVerse : NSObject

@property (nonatomic) NSInteger wordCount;
@property (nonatomic) NSInteger chapSeq;
@property (nonatomic) NSInteger verseSeq;
@property (retain) NSString *noteText;
@property (retain) NSString *chapRef;
@property (retain) NSString *verseRef;
@property (retain) NSMutableDictionary *wordIndex;
@property (retain) classLXXVerse *previousVerse;
@property (retain) classLXXVerse *nextVerse;

- (id) init: (classGlobal *) inGlobal;
- (classLXXWord *) addWordToVerse;
- (classLXXWord *) getWord: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
