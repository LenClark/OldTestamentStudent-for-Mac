//
//  classCleanReturn.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface classCleanReturn : NSObject

@property (retain) NSString *charactersBeforeWord;
@property (retain) NSString *charactersAfterWord;
@property (retain) NSString *cleanedWord;
@property (retain) NSString *punctuation;

- (id) init: (NSString *) inWord preChar: (NSString *) inPreWord postWord: (NSString *) inPostWord punctuation: (NSString *) inPunctuation;

@end

NS_ASSUME_NONNULL_END
