//
//  classLXXWord.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import "classLXXWord.h"

@implementation classLXXWord

@synthesize catString;
@synthesize parseString;
@synthesize uniqueValue;
@synthesize textWord;
@synthesize accentlessTextWord;
@synthesize bareTextWord;
@synthesize punctuation;
@synthesize preWordChars;
@synthesize postWordChars;
@synthesize rootWord;

classGlobal *globalVarsLXXWord;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init] )
    {
        globalVarsLXXWord = inGlobal;
    }
    return self;
}

@end
