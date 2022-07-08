//
//  classGreekProcessing.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "classCleanReturn.h"

NS_ASSUME_NONNULL_BEGIN

@interface classGreekProcessing : NSObject

@property (retain) NSArray *allowedPunctuation;
@property (retain) NSMutableDictionary *allGkChars;
@property (retain) NSMutableDictionary *conversionWithBreathings;
@property (retain) NSMutableDictionary *addRoughBreathing;
@property (retain) NSMutableDictionary *addSmoothBreathing;
@property (retain) NSMutableDictionary *addAccute;
@property (retain) NSMutableDictionary *addGrave;
@property (retain) NSMutableDictionary *addCirc;
@property (retain) NSMutableDictionary *addDiaeresis;
@property (retain) NSMutableDictionary *addIotaSub;

- (id) init: (classConfig *) inConfig;
- (classCleanReturn *) removeNonGkChars: (NSString *) source;
- (NSString *) reduceToBareGreek: (NSString *) source isRemovedAlready: (bool) nonGkIsAlreadyRemoved;

@end

NS_ASSUME_NONNULL_END
