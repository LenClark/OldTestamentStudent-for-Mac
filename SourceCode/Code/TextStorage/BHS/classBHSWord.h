//
//  classBHSWord.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import <Foundation/Foundation.h>
#import "classKethib_Qere.h"
#import "classGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSWord : NSObject

@property (nonatomic) BOOL isPrefix;
@property (nonatomic) BOOL hasVariant;
@property (nonatomic) NSInteger eRef;
@property (nonatomic) NSInteger noOfStrongRefs;
@property (retain) NSString *actualWord;
@property (retain) NSString *morphology;
@property (retain) NSString *affix;
@property (retain) NSString *unaccentedWord;
@property (retain) NSString *bareWord;
@property (retain) NSString *gloss;
@property (retain) classKethib_Qere *wordVariant;
@property (retain) NSMutableDictionary *listOfStrongRefs;

- (id) init: (classGlobal *) inGlobal;
- (void) addStrongRef: (NSInteger) strongRef;
- (NSInteger) getStrongRefBySeq: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
