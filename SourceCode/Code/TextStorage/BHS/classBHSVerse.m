/*=====================================================================================================*
 *                                                                                                     *
 *                                       classBHSVerse                                                 *
 *                                       =============                                                 *
 *                                                                                                     *
 *  The key elements of this class is the Dictionary, wordIndex.  This will have the form:             *
 *    key:   a simple sequence number (indicating the order of the word in the verse)                  *
 *    value: the address of the relevant classBHSWord instance                                         *
 *                                                                                                     *
 *  wordCount keeps a track of the key sequence while being populated and then provides the total      *
 *    number of words in the verse.  (Note that prefixes, such as prepositions, and affixes are        *
 *    treated as words in their own right.)                                                            *
 *                                                                                                     *
 *  References to the parent chapter and the verse itself are mainly for debug benefit.  Note that, in *
 *    both cases, the xxxSeq are the literal sequence value while the xxxRef are the values provided   *
 *    by the source data.  Thus, the xxxRef values may be out of sequence, repeat and contain non-     *
 *    numbers (e.g. verse 8b).                                                                         *
 *                                                                                                     *
 *  Created by Len Clark                                                                               *
 *  May 2022                                                                                           *
 *                                                                                                     *
 *=====================================================================================================*/

#import "classBHSVerse.h"

@implementation classBHSVerse

@synthesize wordCount;
@synthesize chapSeq;
@synthesize verseSeq;
@synthesize noteText;
@synthesize chapRef;
@synthesize verseRef;
@synthesize nextVerse;

@synthesize wordIndex;
classGlobal *globalVarsBHSVerse;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init] )
    {
        globalVarsBHSVerse = inGlobal;
        wordIndex = [[NSMutableDictionary alloc] init];
        wordCount = 0;
    }
    return self;
}

- (classBHSWord *) addWordToVers
{
    classBHSWord *newWord;

    newWord = [[classBHSWord alloc] init:globalVarsBHSVerse];
    [wordIndex setObject:newWord forKey:[globalVarsBHSVerse convertIntegerToString:wordCount++]];
    return newWord;
}

- (classBHSWord *) getWord: (NSInteger) seqNo
{
    classBHSWord *newWord;

    newWord = nil;
    newWord = [wordIndex objectForKey:[globalVarsBHSVerse convertIntegerToString:seqNo]];
    return newWord;
}

@end
