//
//  classVerse.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Foundation/Foundation.h>
#import "classWord.h"
#import "GBSAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface classVerse : NSObject
{
@private
    NSInteger bookId;
    NSString *noteText;
}

@property (nonatomic) NSUInteger wordCount;
@property (nonatomic) NSInteger bookId;
@property (retain) NSMutableDictionary *wordIndex;
@property (retain) NSString *noteText;
@property (retain) NSString *bibleReference;
@property (retain) classVerse *previousVerse;
@property (retain) classVerse *nextVerse;

-(void) initialise: (NSInteger) inputBookId;
- (NSUInteger) WordCount;
- (NSInteger) getBookId;
- (void) setBookId: (NSInteger) inBookId;
- (classWord *) getwordBySeqNo: (NSInteger) seqNo;
- (NSString *) getWholeText;

@end

NS_ASSUME_NONNULL_END
