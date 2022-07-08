//
//  classLexicon.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "GBSAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLexicon : NSObject

- (id) init: (classConfig *) inGlobal;
- (void) populateAppendice;
- (NSString *) getLexiconEntry: (NSString *) wordToExplain;
- (NSString *) parseGrammar: (NSString *) codes1 withFullerCode: (NSString *) codes2 isNT: (bool) isNT;

@end

NS_ASSUME_NONNULL_END
