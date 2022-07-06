//
//  classDisplayUtilities.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@interface classDisplayUtilities : NSObject

@property (retain) classGlobal *globalDispUtilsVar;

- (id) init: (classGlobal *) inGlobal;
- (NSMutableAttributedString *) addAttributedText: (NSString *) mainText
                                       offsetCode: (NSInteger) offsetCode
                                           fontId: (NSInteger) fontId
                                        alignment: (NSInteger) alignment
                                withAdjustmentFor: (NSTextView *) baseView;

@end

NS_ASSUME_NONNULL_END
