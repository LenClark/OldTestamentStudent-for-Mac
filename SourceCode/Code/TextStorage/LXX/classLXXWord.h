//
//  classLXXWord.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLXXWord : NSObject

@property (retain) NSString *catString;
@property (retain) NSString *parseString;
@property (retain) NSString *uniqueValue;
@property (retain) NSString *textWord;
@property (retain) NSString *accentlessTextWord;
@property (retain) NSString *bareTextWord;
@property (retain) NSString *punctuation;
@property (retain) NSString *preWordChars;
@property (retain) NSString *postWordChars;
@property (retain) NSString *rootWord;

- (id) init: (classGlobal *) inGlobal;

@end

NS_ASSUME_NONNULL_END
