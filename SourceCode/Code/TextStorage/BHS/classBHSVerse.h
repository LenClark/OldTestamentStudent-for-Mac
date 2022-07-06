/*=====================================================================================================*
 *                                                                                                     *
 *                                       classBHSVerse                                                 *
 *                                       =============                                                 *
 *                                                                                                     *
 *  The key elements of this class is the Dictionary, wordIndex.  This will have the form:             *
 *    key:   a simple sequence number (indicating the order of the word in the verse)                  *
 *    value: the address of the relevant classBHSWord instance                                         *
 *                                                                                                     *
 *  wordCount keeps a track of the key sequence while being populated and then provides the total      *
 *    number of words in the verse.  (Note that prefixes, such as prepositions, and affixes are        *
 *    treated as words in their own right.)                                                            *
 *                                                                                                     *
 *  References to the parent chapter and the verse itself are mainly for debug benefit.  Note that, in *
 *    both cases, the xxxSeq are the literal sequence value while the xxxRef are the values provided   *
 *    by the source data.  Thus, the xxxRef values may be out of sequence, repeat and contain non-     *
 *    numbers (e.g. verse 8b).                                                                         *
 *                                                                                                     *
 *  Created by Len Clark                                                                               *
 *  May 2022                                                                                           *
 *                                                                                                     *
 *=====================================================================================================*/

#import <Foundation/Foundation.h>
#import "classBHSWord.h"
#import "classGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSVerse : NSObject

@property (nonatomic) NSInteger wordCount;
@property (nonatomic) NSInteger chapSeq;
@property (nonatomic) NSInteger verseSeq;
@property (retain) NSString *noteText;
@property (retain) NSString *chapRef;
@property (retain) NSString *verseRef;
@property (retain) classBHSVerse *nextVerse;
@property (retain) NSMutableDictionary *wordIndex;

- (id) init: (classGlobal *) inGlobal;
- (classBHSWord *) addWordToVers;
- (classBHSWord *) getWord: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
