//
//  classCleanReturn.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import "classCleanReturn.h"

@implementation classCleanReturn

@synthesize charactersBeforeWord;
@synthesize charactersAfterWord;
@synthesize cleanedWord;
@synthesize punctuation;

- (id) init: (NSString *) inWord preChar: (NSString *) inPreWord postWord: (NSString *) inPostWord punctuation: (NSString *) inPunctuation
{
    if( self = [super init] )
    {
        charactersBeforeWord = inPreWord;
        charactersAfterWord = inPostWord;
        cleanedWord = inWord;
        punctuation = inPunctuation;
    }
    return self;
}

@end
