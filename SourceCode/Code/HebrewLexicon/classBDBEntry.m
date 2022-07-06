/*================================================================================*
 *                                                                                *
 *                              classBDBEntry                                     *
 *                              =============                                     *
 *                                                                                *
 *  Because different instances of Hebrew and Aramaic words may have the same     *
 *    root form we must enable multiple BDB entries for a given word.  Since the  *
 *    Word will be the key of our dictionary, we need this class to resolve the   *
 *    one-to-many relationship.                                                   *
 *                                                                                *
 *  Created by Len Clark                                                          *
 *  May 2022                                                                      *
 *                                                                                *
 *================================================================================*/

#import "classBDBEntry.h"

@implementation classBDBEntry

@synthesize sourceFileNo;
@synthesize languageCode;
@synthesize noOfDetailItems;
@synthesize noOfStrongRefs;
@synthesize entryWord;
@synthesize bdbEntryList;
@synthesize strongRefList;

- (id) init
{
    if( self = [super init])
    {
        bdbEntryList = [[NSMutableDictionary alloc] init];
        sourceFileNo = -1;
        noOfDetailItems = 0;
        noOfStrongRefs = 0;
    }
    return self;
}

- (void) addANonRefDetail: (NSString *) entryText withTextStyleCode: (NSInteger) textStyleCode LineStyleCode: (NSInteger) lineStyleCode andKeyCode: (NSInteger) keyCode
{
    classBDBEntryDetail *bdbRecord;
    
    bdbRecord = [[classBDBEntryDetail alloc] init];
    [bdbRecord setTextStyleCode:textStyleCode];
    [bdbRecord setLineStyleCode:lineStyleCode];
    [bdbRecord setKeyCode:keyCode];
    [bdbRecord setText:entryText];
    [bdbEntryList setObject:bdbRecord forKey:[[NSString alloc] initWithFormat:@"%ld", noOfDetailItems++]];
}

- (void) addARefDetail: (NSString *) entryText
     withTextStyleCode: (NSInteger) textStyleCode
         LineStyleCode: (NSInteger) lineStyleCode
            andKeyCode: (NSInteger) keyCode
     referenceBookName: (NSString *) specificBookName
          startChapter: (NSInteger) startChapter
            endChapter: (NSInteger) endChapter
            startVerse: (NSInteger) startVerse
              endVerse: (NSInteger) endVerse
{
    classBDBEntryDetail *bdbRecord;
    
    bdbRecord = [[classBDBEntryDetail alloc] init];
    [bdbRecord setTextStyleCode:textStyleCode];
    [bdbRecord setLineStyleCode:lineStyleCode];
    [bdbRecord setKeyCode:keyCode];
    [bdbRecord setText:entryText];
    [bdbRecord setBookName:specificBookName];
    [bdbRecord setStartChapter:startChapter];
    [bdbRecord setEndChapter:endChapter];
    [bdbRecord setStartVerse:startVerse];
    [bdbRecord setEndVerse:endVerse];
   [bdbEntryList setObject:bdbRecord forKey:[[NSString alloc] initWithFormat:@"%ld", noOfDetailItems++]];

}

- (classBDBEntryDetail *) getEntryDetailBySequence: (NSInteger) seqNo
{
    classBDBEntryDetail *candidateDetail;
    
    candidateDetail = nil;
    if( seqNo < noOfDetailItems) candidateDetail = [bdbEntryList objectForKey:[[NSString alloc] initWithFormat: @"%ld", seqNo]];
    return candidateDetail;
}

@end
