/*============================================================================================================*
  *                                                                                                            *
  *                                             classBHSBook                                                   *
  *                                             ------------                                                   *
  *                                                                                                            *
  *  In essence, we want to identify each chapter that belongs to a given book.  At root, information about    *
  *    the chapter is provided by the class classBHSChapter.  However, we need to cater for the possibility    *
  *    that the chapter number is _not_ a simple integer but may contain alphanumerics (e.g. 12a).  So, we     *
  *    a) key the list of class instances on a sequential integer.  The sequence has no significance other     *
  *       than ensuring uniqueness.  (It will actually be generated in the sequence the chapters are           *
  *       encounteredin the source data.)                                                                      *
  *    b) we separately provide a lookup of this sequence number which gives the String-based version of the   *
  *       chapter "number" (which we will call a chapter reference"), which is recorded in the sequence listed *
  *       in the source data.  This means that numbers may also be out of strict sequence.                     *
  *    c) we also provide an inverse lookup that allows us to find the sequence number, if we know the string- *
  *       based chapter reference.  This is important because it allows us to find the chapter details (the    *
  *       class instance) from the chapter reference provided by the source data.                              *
  *                                                                                                            *
  *  Note: 1. chapter sequences will be zero-based (i.e. start at zero) while chapter references are           *
  *           (ostensibly) meaningful and normally start at 1 (although they can be zero).                     *
  *        2. noOfChaptersInBook will count the *sequence* of chapters                                         *
  *                                                                                                            *
  *  Created by Len Clark                                                                                      *
  *  May 2022                                                                                                  *
  *                                                                                                            *
  *============================================================================================================*/

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classBHSChapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSBook : NSObject

@property (nonatomic) NSInteger noOfChaptersInBook;
@property (nonatomic) NSInteger category;
@property (nonatomic) NSInteger bookId;
@property (retain) NSString *bookName;
@property (retain) NSString *shortName;
@property (retain) NSMutableDictionary *chaptersBySequence;
@property (retain) NSMutableDictionary *chapterReferencesBySequence;
@property (retain) NSMutableDictionary *sequenceForChapterReference;

- (id) init: (classGlobal *) inGlobal;
- (classBHSChapter *) addNewChapterToBook: (NSString *) chapterId;
- (classBHSChapter *) getChapterBySequence: (NSInteger) seqNo;
- (classBHSChapter *) getChapterByChapterNo: (NSString *) chapterId;
- (NSInteger) getSequenceByChapterNo: (NSString *) chapterId;
- (NSString *) getChapterNoBySequence: (NSInteger) seqNo;

@end

NS_ASSUME_NONNULL_END
