//
//  classSearch.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 13/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "GBSAlert.h"
#import "classGreekProcessing.h"
#import "classCleanReturn.h"
#import "classSearchReturn.h"
#import "classBook.h"
#import "classChapter.h"
#import "classVerse.h"
#import "classWord.h"
#import "classReference.h"

NS_ASSUME_NONNULL_BEGIN

@interface classSearch : NSObject

@property (retain) NSMutableDictionary *listOfRefs;
@property (retain) NSMutableDictionary *refControl;
@property (nonatomic) NSInteger noOfRefs;
@property (nonatomic) NSInteger noOfMatches;
@property (retain) NSTextField *statusLabel;

- (id) init: (classConfig *) inConfig greekProcessing: (classGreekProcessing *) inGreek;
- (NSArray *) performSearch: (NSString *) sourceString primarySource: (NSInteger) primarySource bookCode: (NSInteger) bookCode
                     chapter: (NSString *) chapterCode verse: (NSString *) verseRef
              withSecondWord: (NSString *) secondaryWord secondarySource: (NSInteger) secondarySource last2ryBook: (NSInteger) bookCode2ary
              last2ryChapter: (NSString *) chapRef2ary last2ryVerse: (NSString *) verseRef2ary
            searchComplexity: (bool) isComplex searchType: (NSInteger) rbOption wordDistance: (NSInteger) contextCount
             ntBooksToSearch: (NSArray *) activeNtList lxxBooksToSearch: (NSArray *) activeLxxList;

@end

NS_ASSUME_NONNULL_END
