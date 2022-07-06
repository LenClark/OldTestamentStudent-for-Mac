/*===========================================================================*
 *                                                                           *
 *                            classWordToStrong                              *
 *                            =================                              *
 *                                                                           *
 *  The file, WordToBdb.txt, is "keyed" on a word with consonants and vowels *
 *    but no accents (or additional characters).  The second field in the    *
 *    file contains a list of possible occurrences for that word.  I assume  *
 *    that the key word is the word that _might_ have a BDB entry while the  *
 *    words composing the second field are potential occurrences in BHS.     *
 *                                                                           *
 *  Variables:                                                               *
 *  =========                                                                *
 *                                                                           *
 *  unaccentedWord     This is effectively the key to the class and is not   *
 *                       strictly necessary in the instance itself           *
 *  listOfActualWords  This contains the fully pointed word and, at the time *
 *                       of creation, it's not clear whether it will be      *
 *                       needed.  Ideally, this will always be a list of one *
 *                       but it caters for the possibility that there will   *
 *                       be two forms that are morphologically different but *
 *                       which result in the same unaccented form.           *
 *  noOfDistinctWords  A count of listOfActualWords                          *
 *  actualWordsProcessed                                                     *
 *                     This is a list that reproduces the values of          *
 *                       listOfActualWords and is used purely to check       *
 *                       whether we have already entered a given word        *
 *  strongRef          The list of Strongs references for the word (or words)*
 *                       in the instance                                     *
 *  noOfStrongRefs     A count of items in strongRef                         *
 *                                                                           *
 *  Created by Len Clark                                                     *
 *  May 2022                                                                 *
 *                                                                           *
 *===========================================================================*/

#import <Foundation/Foundation.h>
#import "classGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@interface classWordToStrong : NSObject

@property (nonatomic) NSInteger noOfDistinctWords;
@property (nonatomic) NSInteger noOfStrongRefs;
@property (retain) NSString *unaccentedWord;
@property (retain) NSMutableDictionary *listOfActualWords;
@property (retain) NSMutableArray *actualWordsProcessed;
@property (retain) NSMutableDictionary *strongRef;
@property (retain) NSMutableArray *strongRefProcessed;

- (id) init: (classGlobal *) inGlobal;
- (void) addAnActualWord: (NSString *) inWord;
- (void) addAStrongRef: (NSInteger) inRef;
- (NSString *) getActualWordByIndex: (NSInteger) index;
- (NSInteger) getStrongRefByIndex: (NSInteger) index;

@end

NS_ASSUME_NONNULL_END
