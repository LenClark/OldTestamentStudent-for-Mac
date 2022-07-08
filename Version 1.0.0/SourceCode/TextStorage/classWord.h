//
//  classWord.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface classWord : NSObject

@property (nonatomic) NSString *catString;
@property (nonatomic) NSString *parseString;
@property (nonatomic) NSString *uniqueValue;
@property (nonatomic) NSString *textWord;
@property (nonatomic) NSString *accentlessTextWord;
@property (nonatomic) NSString *bareTextWord;
@property (nonatomic) NSString *punctuation;
@property (nonatomic) NSString *preWordChars;
@property (nonatomic) NSString *postWordChars;
@property (nonatomic) NSString *rootWord;

@end

NS_ASSUME_NONNULL_END
