//
//  classVocab.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 18/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "classBook.h"
#import "classChapter.h"
#import "classVerse.h"
#import "classWord.h"

NS_ASSUME_NONNULL_BEGIN

@interface classVocab : NSObject

- (id) init: (classConfig *) inConfig;
- (void) makeVocabList: (NSInteger) testamentId checkedPos: (NSArray *) checkedList listCode: (NSInteger) listCode displayCode: (NSInteger) displayCode typeCode: (NSInteger) typeCode;
@end

NS_ASSUME_NONNULL_END
