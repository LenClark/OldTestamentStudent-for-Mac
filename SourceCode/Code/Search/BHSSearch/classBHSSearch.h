//
//  classBHSSearch.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 29/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classHebLexicon.h"
#import "classBHSText.h"
#import "classBHSBook.h"
#import "classBHSChapter.h"
#import "classBHSVerse.h"
#import "classBHSWord.h"
#import "classAlert.h"
#import "classSearchVerify.h"
#import "classWordToStrong.h"
#import "classBHSPrimaryResult.h"
#import "classBHSScanUnit.h"
#import "classBHSSearchMatches.h"
#import "classDisplayUtilities.h"
#import "classBHSSearchVerse.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSSearch : NSObject

@property (retain) NSRunLoop *bhsSearchLoop;
@property (retain) NSTextField *labBHSSearchProgressLbl;

@property (retain) NSTextField *primaryBHSWord;
@property (retain) NSTextField *secondaryBHSWord;
@property (retain) NSTextField *bhsWithin;
@property (retain) NSTextField *bhsSteps;
@property (retain) NSStepper *bhsStepper;
@property (retain) NSTextField *bhsWordsOf;

@property (nonatomic) BOOL isSearchSuccessful;
@property (nonatomic) BOOL isWordGiven;
@property (nonatomic) BOOL isSWordGiven;
@property (nonatomic) NSInteger noOfMatchingBHSVerses;
@property (nonatomic) NSInteger currentVersion;
@property (nonatomic) NSInteger currentSearchType;
@property (nonatomic) NSInteger matchType;
@property (nonatomic) NSInteger noOfRTXLines;
@property (nonatomic) NSInteger noOfAllMatches;
@property (retain) NSMutableDictionary *listOfBHSPrimaryResults;
@property (retain) NSMutableDictionary *allBHSMatches;
@property (retain) NSMutableArray *booksToInclude;
@property (retain) NSArray *strongRefs;
@property (retain) NSArray *SecondStrongRefs;
@property (retain) NSMutableArray *storeReference;
@property (retain) NSMutableArray *storeText;

- (id) init: (classGlobal *) inGlobal forHebLexicon: (classHebLexicon *) inHebLex forHebText: (classBHSText *) inBHSText andLoop: (NSRunLoop *) inLoop; //withNotes: (classNote *) inNote
- (void) searchSetup: (NSInteger) tagVal;
- (void) controlSearch;

@end

NS_ASSUME_NONNULL_END
