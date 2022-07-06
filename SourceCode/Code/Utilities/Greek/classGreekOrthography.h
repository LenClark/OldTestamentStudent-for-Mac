/*=====================================================================================================================*
 *                                                                                                                     *
 *                                             classGreekOrthography                                                   *
 *                                             =====================                                                   *
 *                                                                                                                     *
 *  This class provides methods for converting greek words into simpler forms (e.g. removing accents).  It also stores *
 *    the resulting, modified characters so that they can easily be retrieved.                                         *
 *                                                                                                                     *
 *  Len Clark                                                                                                          *
 *  May 2022                                                                                                           *
 *                                                                                                                     *
 *=====================================================================================================================*/

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classGkCleanResults.h"

NS_ASSUME_NONNULL_BEGIN

@interface classGreekOrthography : NSObject

@property (retain) classGlobal *globalVarsGkOrth;

- (void) initialiseGreekOrthography: (classGlobal *) inGlobal;
- (NSString *) reduceToBareGreek: (NSString *) source withNonGkRemoved: (bool) nonGkIsAlreadyRemoved;
- (classGkCleanResults *) removeNonGkChars: (NSString *) source;
- (NSString *) getCharacterWithRoughBreathing: (NSString *) previousChar;
- (NSString *) getCharacterWithSmoothBreathing: (NSString *) previousChar;
- (NSString *) getCharacterWithAccuteAccent: (NSString *) previousChar;
- (NSString *) getCharacterWithGraveAccent: (NSString *) previousChar;
- (NSString *) getCharacterWithCircumflexAccent: (NSString *) previousChar;
- (NSString *) getCharacterWithDieresis: (NSString *) previousChar;
- (NSString *) getCharacterWithIotaSubscript: (NSString *) previousChar;

@end

NS_ASSUME_NONNULL_END
