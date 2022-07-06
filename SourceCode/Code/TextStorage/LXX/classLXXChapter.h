/*============================================================================================================*
  *                                                                                                            *
  *                                             classLXXChapter                                                *
  *                                             ---------------                                                *
  *                                                                                                            *
  *  In essence, we want to identify each verse that belongs to a given chapter.  At root, information about   *
  *    the verse is provided by the class classLXXVerse.  However, we need to cater for the possibility that   *
  *    verse number is _not_ a simple integer but may contain alphanumerics (e.g. 12a).  So, we                *
  *    a) key the list of class instances on a sequential integer.  The sequence has no significance other     *
  *       than ensuring uniqueness.  (It will actually be generated in the sequence the verses are encountered *
  *       in the source data.)                                                                                 *
  *    b) we separately provide a lookup of this sequence number which gives the String-based version of the   *
  *       verse "number" (which we will call a verse reference"), which is recorded in the sequence listed in  *
  *       the source data.  This means that numbers may also be out of strict sequence.                        *
  *    c) we also provide an inverse lookup that allows us to find the sequence number, if we know the string- *
  *       based verse reference.  This is important because it allows us to find the verse details (the class  *
  *       instance) from the verse reference provided by the source data.                                      *
  *                                                                                                            *
  *  Note: 1. verse sequences will be zero-based (i.e. start at zero) while  verse references are (ostensibly) *
  *           meaningful and normally start at 1 (although they can be zero).                                  *
  *        2. noOfVersesInChapter will count the *sequence* of verses                                          *
  *                                                                                                            *
  *  Created by Len Clark                                                                                      *
  *  May 2022                                                                                                  *
  *                                                                                                            *
  *============================================================================================================*/

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classLXXVerse.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLXXChapter : NSObject

@property (nonatomic) NSInteger noOfVersesInChapter;
@property (nonatomic) NSInteger bookNo;
@property (nonatomic) NSInteger chapterNo;
@property (retain) NSString *chapterRef;
@property (retain) NSMutableDictionary *versesBySequence;
@property (retain) NSMutableDictionary *verseReferenceBySequence;
@property (retain) NSMutableDictionary *sequenceForVerseReference;
@property (retain) classLXXChapter *previousChapter;
@property (retain) classLXXChapter *nextChapter;

- (id) init: (classGlobal *) inGlobal;
- (classLXXVerse *) addVerseToChapter: (NSString *) verseId;
- (classLXXVerse *) getVerseBySequence: (NSInteger) seqNo;
- (classLXXVerse *) getVerseByVerseNo: (NSString *) verseRef;
- (NSInteger) getSequenceByVerseNo: (NSString *) verseRef;
- (NSString *) getVerseNoBySequence: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
