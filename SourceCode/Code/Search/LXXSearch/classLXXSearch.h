//
//  classLXXSearch.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 29/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classGkLexicon.h"
#import "classGreekOrthography.h"
#import "classGkCleanResults.h"
#import "classLXXText.h"
#import "classLXXBook.h"
#import "classLXXChapter.h"
#import "classLXXVerse.h"
#import "classLXXWord.h"
#import "classLXXSearchVerify.h"
#import "classLXXMatchResults.h"
#import "classLXXPrimaryResult.h"
#import "classLXXScanUnit.h"
#import "classLXXSearchMatches.h"
#import "classLXXSearchVerse.h"
#import "classDisplayUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLXXSearch : NSObject

@property (retain) NSRunLoop *lxxSearchLoop;
@property (retain) NSTextField *labLXXSearchProgressLbl;

@property (retain) NSTextField *primaryLXXWord;
@property (retain) NSTextField *secondaryLXXWord;
@property (retain) NSTextField *lxxWithin;
@property (retain) NSTextField *lxxSteps;
@property (retain) NSStepper *lxxStepper;
@property (retain) NSTextField *lxxWordsOf;

@property (nonatomic) BOOL isSearchSuccessful;
@property (nonatomic) BOOL isWordGiven;
@property (nonatomic) BOOL isSWordGiven;
@property (nonatomic) NSInteger noOfMatchingLXXVerses;
@property (nonatomic) NSInteger currentVersion;
@property (nonatomic) NSInteger currentSearchType;
@property (nonatomic) NSInteger matchType;
@property (nonatomic) NSInteger noOfRTXLines;
@property (nonatomic) NSInteger noOfAllMatches;
@property (retain) NSMutableDictionary *listOfLXXPrimaryResults;
@property (retain) NSDictionary *allLXXMatches;
@property (retain) NSMutableArray *booksToInclude;
@property (retain) NSMutableArray *storeReference;
@property (retain) NSMutableArray *storeText;

- (id) init: (classGlobal *) inGlobal forGreekLexicon: (classGkLexicon *) inGkLex withOrthography: (classGreekOrthography *) inOrth forGkText: (classLXXText *) inLXXText andLoop: (NSRunLoop *) inLoop; //withNotes: (classNote *) 
- (void) searchSetup: (NSInteger) tagVal;
- (void) controlSearch;
@end

NS_ASSUME_NONNULL_END
