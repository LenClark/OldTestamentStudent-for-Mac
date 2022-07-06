/*===============================================================================================================*
 *                                                                                                                *
 *                                            classHebLexicon                                                     *
 *                                            ===============                                                     *
 *                                                                                                                *
 *  This class will also handle some methods for processing words (in order to avoid creating yet another         *
 *    orthography class.                                                                                          *
 *                                                                                                                *
 *  Because the text can contain line feeds, we have resorted to using non-ASCII unicode values as field          *
 *    separators.                                                                                                 *
 *    1) There are 10022 separate lexical elements.  These were initially in individual text files but the load   *
 *       time for these files was far too long.  So, we have consolodated them into a single file, with each      *
 *       "virtual file" delineated by a "full width bar" (or "full width vertical line").                         *
 *    2) Each logical record of each virtual files is delineated by a "full width full stop", so we shall refer   *
 *       to them as "sentences".                                                                                  *
 *    3) Each item within a "sentence" is separated by a "full width comma" (but we haven't got a fancy name for  *
 *       these items.                                                                                             *
 *                                                                                                                *
 *  The logic and action of this method needs some explanation:                                                   *
 *                                                                                                                *
 *  Once we have broken a virtual file into "sentences" (stored in textByLine), we then split out the individual  *
 *    items, which will be in the array, bdbContent.  bdbContent[2] contains the controlling value, the keyCode.  *
 *                                                                                                                *
 *  The first sentence in each virtual file contains a list of related Strongs Numbers. These are handled in the  *
 *    loop that begins:                                                                                           *
 *          if( nCount == 0 )                                                                                     *
 *    The immediate effect of this part of the code is to store this list of Strongs Refs in the temporary        *
 *    dictionary, temporaryStrongNoStore.                                                                         *
 *                                                                                                                *
 *  Subsequent processing will loop through the rest of the "sentences", processing the details in the light of   *
 *    the keyCode.                                                                                                *
 *                                                                                                                *
 *  The first sentence (after the Strongs refs) should have a keyCode of either 1 (the Hebrew entry) or 2 (the    *
 *    Aramaic entry),  Anything else will be ignored until a keyCode of 1 or 2 has been encountered. The process  *
 *    for keyCode 1 or 2 will create an instance of classBDBEntry, which will be used by subsequent sentences. It *
 *    will also store the lexican word in a suitable instance of classWordToBDB (creating it, if need be), which  *
 *    allow all BDB entries for a given word form to be accessed.                                                 *
 *                                                                                                                *
 *  Once we have fully processed the entry, we return to the Strong References, stored temporarily in             *
 *    temporaryStrongNoStore.  We now access each related Strong reference in turn and store the address of the   *
 *    BDB entry in the relevant instance of classBDBForStrong (which we also create, if we need to).  The reason  *
 *    that this step was deferred to this point was because we needed to know the address of the BDB entry.       *
 *                                                                                                                *
 *  Created by Len Clark                                                                                          *
 *  May 2022                                                                                                      *
 *                                                                                                                *
 *===============================================================================================================*/


#import <Foundation/Foundation.h>
#import "classGlobal.h"
//#import "classRenderLexiconText.h"
#import "classBDBEntry.h"
#import "classWordEntry.h"
#import "classAlert.h"
//#import "classBDBForStrong.h"
#import "frmProgress.h"
#import "classStrongToBDBLookup.h"

NS_ASSUME_NONNULL_BEGIN

@interface classHebLexicon : NSObject

@property (nonatomic) NSInteger noOfMatchesReturned;
@property (retain) NSMutableDictionary *bdbLexEntryList;
@property (retain) NSMutableDictionary *listOfSearchResults;
@property (retain) NSMutableDictionary *hebEntryList;
@property (retain) NSMutableDictionary *strongToBDBList;
@property (retain) NSRunLoop *lexLoop;
@property (retain) frmProgress *lexProgress;

- (id) init: (classGlobal *) inGlobal withLoop: (NSRunLoop *) inLoop forProgressForm: (frmProgress *) inProg;
- (classBDBEntry *) getBDBEntryForStrongNo: (NSInteger) strongNo;
- (NSString *) removeAccents: (NSString *) sourceWord;

@end

NS_ASSUME_NONNULL_END
