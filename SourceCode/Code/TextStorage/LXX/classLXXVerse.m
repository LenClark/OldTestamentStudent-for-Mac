//
//  classLXXVerse.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import "classLXXVerse.h"

@implementation classLXXVerse

@synthesize wordCount;
@synthesize chapSeq;
@synthesize verseSeq;
@synthesize noteText;
@synthesize chapRef;
@synthesize verseRef;
@synthesize wordIndex;
@synthesize previousVerse;
@synthesize nextVerse;

classGlobal *globalVarsLXXVerse;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init])
    {
        globalVarsLXXVerse = inGlobal;
        wordIndex = [[NSMutableDictionary alloc] init];
        wordCount = 0;
    }
    return self;
}

- (classLXXWord *) addWordToVerse
{
    classLXXWord *newWord;

    newWord = [[classLXXWord alloc] init:globalVarsLXXVerse];
    [wordIndex setValue:newWord forKey:[globalVarsLXXVerse convertIntegerToString: wordCount++]];
    return newWord;
}

- (classLXXWord *) getWord: (NSInteger) seqNo
{
    classLXXWord *newWord;

    newWord = nil;
    newWord = [wordIndex objectForKey:[globalVarsLXXVerse convertIntegerToString: seqNo]];
    return newWord;
}

@end
