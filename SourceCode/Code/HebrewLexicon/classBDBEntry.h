/*================================================================================*
 *                                                                                *
 *                              classBDBEntry                                     *
 *                              =============                                     *
 *                                                                                *
 *  Because different instances of Hebrew and Aramaic words may have the same     *
 *    root form we must enable multiple BDB entries for a given word.  Since the  *
 *    Word will be the key of our dictionary, we need this class to resolve the   *
 *    one-to-many relationship.                                                   *
 *                                                                                *
 *  Created by Len Clark                                                          *
 *  May 2022                                                                      *
 *                                                                                *
 *================================================================================*/

#import <Cocoa/Cocoa.h>
#import "classBDBEntryDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBDBEntry : NSObject

@property (nonatomic) NSInteger sourceFileNo;
@property (nonatomic) NSInteger languageCode;
@property (nonatomic) NSInteger noOfDetailItems;
@property (nonatomic) NSInteger noOfStrongRefs;
@property (retain) NSString *entryWord;
@property (retain) NSMutableDictionary *bdbEntryList;
@property (retain) NSDictionary *strongRefList;

- (void) addANonRefDetail: (NSString *) entryText withTextStyleCode: (NSInteger) textStyleCode LineStyleCode: (NSInteger) lineStyleCode andKeyCode: (NSInteger) keyCode;
- (void) addARefDetail: (NSString *) entryText
     withTextStyleCode: (NSInteger) textStyleCode
         LineStyleCode: (NSInteger) lineStyleCode
            andKeyCode: (NSInteger) keyCode
     referenceBookName: (NSString *) specificBookName
          startChapter: (NSInteger) startChapter
            endChapter: (NSInteger) endChapter
            startVerse: (NSInteger) startVerse
              endVerse: (NSInteger) endVerse;
- (classBDBEntryDetail *) getEntryDetailBySequence: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
