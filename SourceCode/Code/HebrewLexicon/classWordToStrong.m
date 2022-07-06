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

#import "classWordToStrong.h"

@implementation classWordToStrong

@synthesize noOfDistinctWords;
@synthesize noOfStrongRefs;
@synthesize unaccentedWord;
@synthesize listOfActualWords;
@synthesize actualWordsProcessed;
@synthesize strongRef;
@synthesize strongRefProcessed;

classGlobal *globalVarsWordToStrong;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init])
    {
        noOfDistinctWords = 0;
        noOfStrongRefs = 0;
        listOfActualWords = [[NSMutableDictionary alloc] init];
        actualWordsProcessed = [[NSMutableArray alloc] init];
        strongRef = [[NSMutableDictionary alloc] init];
        strongRefProcessed = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addAnActualWord: (NSString *) inWord
{
    if ( [actualWordsProcessed containsObject:inWord] ) return;  //We've already processed that word
    [actualWordsProcessed addObject:inWord];
    [listOfActualWords setObject:inWord forKey:[globalVarsWordToStrong convertIntegerToString:noOfDistinctWords++]];
}

- (void) addAStrongRef: (NSInteger) inRef
{
    NSString *referenceString;
    
    referenceString = [globalVarsWordToStrong convertIntegerToString:inRef];
    if ( [strongRefProcessed containsObject:referenceString] ) return;
    [strongRef setObject:referenceString forKey:[globalVarsWordToStrong convertIntegerToString:noOfStrongRefs++]];
    [strongRefProcessed addObject:referenceString];
}

- (NSString *) getActualWordByIndex: (NSInteger) index
{
    NSString *newWord;

    newWord = nil;
    newWord = [listOfActualWords objectForKey:[globalVarsWordToStrong convertIntegerToString:index]];
    return newWord;
}

- (NSInteger) getStrongRefByIndex: (NSInteger) index
{
    NSString *strongCandidate;

    strongCandidate = nil;
    strongCandidate = [strongRef objectForKey:[globalVarsWordToStrong convertIntegerToString:index]];
    if( strongCandidate == nil) return 0;
    return [strongCandidate integerValue];
}

@end
