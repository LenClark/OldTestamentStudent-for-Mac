/*=======================================================================================================*
 *                                                                                                       *
 *                                          classGkLexicon                                               *
 *                                          ==============                                               *
 *                                                                                                       *
 *  The Liddell & Scott Intermediate Lexicon forms the heart of this class.  However, we will also use   *
 *    it for:                                                                                            *
 *    a) parse related activity, and                                                                     *
 *    b) processing related to the lexicon - notably, the appendices                                     *
 *                                                                                                       *
 *  Len Clark                                                                                            *
 *  May 2022                                                                                             *
 *                                                                                                       *
 *=======================================================================================================*/

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classGreekOrthography.h"
#import "classGkLexiconExtras.h"
#import "classDisplayUtilities.h"
#import "frmProgress.h"

NS_ASSUME_NONNULL_BEGIN

@interface classGkLexicon : NSObject

@property (retain) NSMutableDictionary *lexiconEntry;
@property (retain) NSMutableDictionary *unaccentedLookup;
@property (retain) NSMutableDictionary *alternativeCharacters;
@property (retain) NSRunLoop *gkLexLoop;
@property (retain) frmProgress *gkLexProgress;

- (id) init: (classGlobal *) inConfig withOrthography: (classGreekOrthography *) inGkProcs usingUtils: (classDisplayUtilities *) inUtilities;
- (void) loadLexiconData;
- (void) populateAppendice;
- (void) getLexiconEntry: (NSString *) wordToExplain;
- (NSString *) parseGrammar: (NSString *) codes1 withSecondCode: (NSString *) codes2;

@end

NS_ASSUME_NONNULL_END
