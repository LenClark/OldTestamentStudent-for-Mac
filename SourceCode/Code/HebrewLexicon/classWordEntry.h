/*================================================================================*
 *                                                                                *
 *                              classWordEntry                                    *
 *                              ==============                                    *
 *                                                                                *
 *  Because different instances of Hebrew and Aramaic words may have the same     *
 *    root form we must enable multiple BDB entries for a given word.  Since the  *
 *    Word will be the key of our dictionary, we need this class to resolve the   *
 *    one-to-many relationship.                                                   *
 *                                                                                *
 *  In brief, each distinct word form (as identified using the Strong Reference)  *
 *    will be stored in a single instance of this class.  However, that "word"    *
 *    may relate to more than one actual BDB entry.  So, this class will maintain *
 *    a one-to-many relationship between classWordEntry and classBDBEntry.        *
 *                                                                                *
 *  Created by Len Clark                                                          *
 *  May 2022                                                                      *
 *                                                                                *
 *================================================================================*/

#import <Cocoa/Cocoa.h>
#import "classBDBEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface classWordEntry : NSObject

@property (nonatomic) NSInteger noOfEntries;
@property (retain) NSMutableDictionary *relatedBDBEntries;

- (void) addEntry: (classBDBEntry *) bdbEntry;

- (classBDBEntry *) getCodeForSequence: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
