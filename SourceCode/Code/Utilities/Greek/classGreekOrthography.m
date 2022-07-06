/*=====================================================================================================================*
 *                                                                                                                     *
 *                                             classGreekOrthography                                                   *
 *                                             =====================                                                   *
 *                                                                                                                     *
 *  This class provides methods for converting greek words into simpler forms (e.g. removing accents).  It also stores *
 *    the resulting, modified characters so that they can easily be retrieved.                                         *
 *                                                                                                                     *
 *  Len Clark                                                                                                          *
 *  May 2022                                                                                                           *
 *                                                                                                                     *
 *=====================================================================================================================*/

#import "classGreekOrthography.h"

@implementation classGreekOrthography

@synthesize globalVarsGkOrth;

/*---------------------------------------------------------------------------------------------------------*
 *                                                                                                         *
 *                                             allGkChars                                                  *
 *                                             ----------                                                  *
 *                                                                                                         *
 *   Load the two Unicode tables into memory.  This will identify the integer value of a character         *
 *     (provided in hexadecimal) with its String form.                                                     *
 *                                                                                                         *
 *       Key = the integer value of the character                                                          *
 *       Value = the hex code converted to a string character (i.e. the actual character)                  *
 *                                                                                                         *
 *   Note that the table will contain some characters of no interest to us, including some unprintable     *
 *     characters.  These will simply be ignored.                                                          *
 *                                                                                                         *
 *---------------------------------------------------------------------------------------------------------*/
int noOfGkChars = 0;
NSDictionary *allGkChars;

/*---------------------------------------------------------------------------------------------------------*
 *                                                                                                         *
 *                                          addRoughBreathing                                              *
 *                                          -----------------                                              *
 *                                                                                                         *
 *   This allows us to convert any Greek character that is cabable of carrying a rough breathing from its  *
 *     non-rough breathing state to one with a rough breathing.                                            *
 *                                                                                                         *
 *       Key = the character without a rough breathing                                                     *
 *       Value = the "same" character _with_ a rough breathing                                             *
 *                                                                                                         *
 *---------------------------------------------------------------------------------------------------------*/
NSDictionary *addRoughBreathing;

/*---------------------------------------------------------------------------------------------------------*
 *                                                                                                         *
 *            addSmoothBreathing, addAccute, addGrave, addCirc, addDiaeresis, addIotaSub                   *
 *            --------------------------------------------------------------------------                   *
 *                                                                                                         *
 *   These function much as addRoughBreathing: it converts a character from a state without the accent,    *
 *     breathing or other element to one that _does_ contain it.                                           *
 *                                                                                                         *
 *       Key = the character without the accent, breathing, etc.                                           *
 *       Value = the "same" character _with_ the relevant element.                                         *
 *                                                                                                         *
 *---------------------------------------------------------------------------------------------------------*/
NSDictionary *addSmoothBreathing;
NSDictionary *addAccute;
NSDictionary *addGrave;
NSDictionary *addCirc;
NSDictionary *addDiaeresis;
NSDictionary *addIotaSub;

/*---------------------------------------------------------------------------------------------------------*
 *                                                                                                         *
 *                                         conversionWithBreathings                                        *
 *                                         ------------------------                                        *
 *                                                                                                         *
 *---------------------------------------------------------------------------------------------------------*/
NSMutableDictionary *conversionWithBreathings;

// String[] allowedPunctuation = { ".", ";", ",", "\u00b7", "\u0387", "\u037e" };

- (void) initialiseGreekOrthography: (classGlobal *) inGlobal
{
    globalVarsGkOrth = inGlobal;
    conversionWithBreathings = [[NSMutableDictionary alloc] init];
    [self setupAllChar];
    addRoughBreathing = [[NSDictionary alloc] initWithDictionary: [self getRelevantGreek:[globalVarsGkOrth gkRough]]];
    addSmoothBreathing = [[NSDictionary alloc] initWithDictionary: [self getRelevantGreek:[globalVarsGkOrth gkSmooth]]];
    addAccute = [[NSDictionary alloc] initWithDictionary: [self getRelevantGreek:[globalVarsGkOrth gkAccute]]];
    addGrave = [[NSDictionary alloc] initWithDictionary: [self getRelevantGreek:[globalVarsGkOrth gkGrave]]];
    addCirc = [[NSDictionary alloc] initWithDictionary: [self getRelevantGreek:[globalVarsGkOrth gkCircumflex]]];
    addDiaeresis = [[NSDictionary alloc] initWithDictionary: [self getRelevantGreek:[globalVarsGkOrth gkDiaereses]]];
    addIotaSub = [[NSDictionary alloc] initWithDictionary: [self getRelevantGreek:[globalVarsGkOrth gkIota]]];
}

- (void) setupAllChar
{
    const NSInteger mainCharsStart = 0x0386, mainCharsEnd = 0x03ce, furtherCharsStart = 0x1f00, furtherCharsEnd = 0x1ffc;

    NSInteger idx = 0, mainCharIndex, furtherCharIndex, storedValue;
    NSString *charRepresentation, *convertedRepresentation, *altConvRep, *fileName, *buffer;
    NSArray *textByLine;

    /*---------------------------------------------------------------------------------------------------------*
     *                                                                                                         *
     *                                        convTable1 and convTable2                                        *
     *                                        -------------------------                                        *
     *                                                                                                         *
     *   These are used as temporary stores for creating breathing conversions.                                *
     *                                                                                                         *
     *---------------------------------------------------------------------------------------------------------*/
    NSMutableDictionary *convTable1, *convTable2, *tempDictionary;

    // First, populate convTables 1 and 2
    convTable1 = [[NSMutableDictionary alloc] init];
    fileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:[globalVarsGkOrth gkConv1] ofType:@"txt"]];
    buffer = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[buffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        if ([lineOfText length] > 0)
        {
            if ([lineOfText characterAtIndex:0] == '-') storedValue = -1;
            else storedValue = [self hexStringToInt:lineOfText];
            if (storedValue == -1) convertedRepresentation = @"";
            else convertedRepresentation = [[NSString alloc] initWithFormat:@"%C", (unichar) storedValue];
            [convTable1 setValue:convertedRepresentation forKey:[[NSString alloc] initWithFormat:@"%ld",idx++]];
        }
    }

    convTable2 = [[NSMutableDictionary alloc] init];
    idx = 0;
    fileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:[globalVarsGkOrth gkConv2] ofType:@"txt"]];
    buffer = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[buffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        if ([lineOfText length] > 0)
        {
            if ([lineOfText characterAtIndex:0] == '-') storedValue = -1;
            else storedValue = [self hexStringToInt:lineOfText];
            if (storedValue == -1) convertedRepresentation = @"";
            else convertedRepresentation = [[NSString alloc] initWithFormat:@"%C", (unichar) storedValue];
            [convTable2 setValue:convertedRepresentation forKey:[[NSString alloc] initWithFormat:@"%ld",idx++]];
        }
    }

    tempDictionary = [[NSMutableDictionary alloc] init];
    idx = 0;
    for (mainCharIndex = mainCharsStart; mainCharIndex <= mainCharsEnd; mainCharIndex++)
    {
        charRepresentation = [[NSString alloc] initWithFormat:@"%C", (unichar)mainCharIndex];
        [tempDictionary setObject:charRepresentation forKey:[[NSString alloc] initWithFormat:@"%ld",mainCharIndex]];
        convertedRepresentation = nil;
        convertedRepresentation = [convTable1 objectForKey:[[NSString alloc] initWithFormat:@"%ld",idx++]];
        altConvRep = nil;
        altConvRep = [conversionWithBreathings objectForKey:charRepresentation];
        if( altConvRep == nil) [conversionWithBreathings setValue:convertedRepresentation forKey:charRepresentation];
        noOfGkChars++;
    }
    idx = 0;
    for (furtherCharIndex = furtherCharsStart; furtherCharIndex <= furtherCharsEnd; furtherCharIndex++)
    {
        charRepresentation = [[NSString alloc] initWithFormat:@"%C", (unichar)furtherCharIndex];
        [tempDictionary setObject:charRepresentation forKey:[[NSString alloc] initWithFormat:@"%ld",furtherCharIndex]];
        convertedRepresentation = nil;
        convertedRepresentation = [convTable2 objectForKey:[[NSString alloc] initWithFormat:@"%ld",idx++]];
        altConvRep = nil;
        altConvRep = [conversionWithBreathings objectForKey:charRepresentation];
        if (altConvRep == nil) [conversionWithBreathings setValue:convertedRepresentation forKey:charRepresentation];
        noOfGkChars++;
    }
    charRepresentation = @"0x03dc";  // Majuscule and miuscule digamma
    [tempDictionary setObject:charRepresentation forKey:[[NSString alloc] initWithFormat:@"%d",0x03dc]];
    [conversionWithBreathings setObject:@"0x03dc" forKey:charRepresentation];
    charRepresentation = @"0x03dd";  // Miniscule and miuscule digamma
    [tempDictionary setObject:charRepresentation forKey:[[NSString alloc] initWithFormat:@"%d",0x03dd]];
    [conversionWithBreathings setObject:@"0x03dd" forKey:charRepresentation];
    noOfGkChars += 2;
    allGkChars = [[NSDictionary alloc] initWithDictionary:tempDictionary];
}

- (NSMutableDictionary *) getRelevantGreek: (NSString *) fileName
{
    /*==================================================================================================*
     *                                                                                                  *
     *                                      getRelevantGreek                                            *
     *                                      ================                                            *
     *                                                                                                  *
     *  Services initialiseGreekOrthography by simply loading data from files.                          *
     *                                                                                                  *
     *==================================================================================================*/

    NSString *buffer, *startingChar, *finalChar, *currentFile, *dummy;
    NSArray *textByLine, *components;
    NSMutableDictionary *tempDictionary;

    tempDictionary = [[NSMutableDictionary alloc] init];
    currentFile = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
    buffer = [[NSString alloc] initWithContentsOfFile:currentFile encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[buffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        if ([lineOfText length] > 0)
        {
            components = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:@","]];
            if( [[components objectAtIndex:0] characterAtIndex:0] == '0' ) startingChar = [[NSString alloc] initWithFormat:@"0x%04lx", (long)[self hexStringToInt:[components objectAtIndex:0]]];
            else startingChar = [[NSString alloc] initWithString: [components objectAtIndex:0]];
            if( [[components objectAtIndex:1] characterAtIndex:0] == '0' ) finalChar = [[NSString alloc] initWithFormat:@"0x%04lx", (long)[self hexStringToInt:[components objectAtIndex:1]]];
            else finalChar = [[NSString alloc] initWithString: [components objectAtIndex:1]];
            dummy = nil;
            dummy = [tempDictionary objectForKey:startingChar];
            if( dummy == nil) [tempDictionary setObject:finalChar forKey:startingChar];
        }
    }
    return tempDictionary;
}

- (NSInteger) hexStringToInt: (NSString *) hexString
{
    NSInteger idx, hexLength, multiplier, runningTotal = 0;
    NSString *activeString;

    // This assumes a string of the form 0xnnnn
    activeString = [[NSString alloc] initWithString: [hexString substringFromIndex:2]];
    hexLength = [activeString length];
    multiplier = 1;
    for( idx = hexLength - 1; idx >= 0; idx--)
    {
        if (([activeString characterAtIndex:idx] >= '0') && ([activeString characterAtIndex:idx] <= '9'))
            runningTotal += [[activeString substringWithRange:NSMakeRange(idx, 1)] intValue] * multiplier;
        else
        {
            switch( [activeString characterAtIndex:idx])
            {
                case 'a':
                case 'A': runningTotal += 10 * multiplier; break;
                case 'b':
                case 'B': runningTotal += 11 * multiplier; break;
                case 'c':
                case 'C': runningTotal += 12 * multiplier; break;
                case 'd':
                case 'D': runningTotal += 13 * multiplier; break;
                case 'e':
                case 'E': runningTotal += 14 * multiplier; break;
                case 'f':
                case 'F': runningTotal += 15 * multiplier; break;
            }
        }
        multiplier *= 16;
    }
    return runningTotal;
}

- (NSString *) reduceToBareGreek: (NSString *) source withNonGkRemoved: (bool) nonGkIsAlreadyRemoved
{
    /*===========================================================================================================*
     *                                                                                                           *
     *                                           reduceToBareGreek                                               *
     *                                           =================                                               *
     *                                                                                                           *
     *  There are times when we want the basic word (specifically for accent-independent comparisons).  We have  *
     *    already included accentless versions of words in classLXXWord but we may need to strip the extra       *
     *    elements from words from other sources.                                                                *
     *                                                                                                           *
     *  This will remove all accents, iota subscripts and length marks (it will retain breathings and diereses). *
     *    It will also:                                                                                          *
     *    - reduce any capital letters to minuscules (see below, however),                                       *
     *    - present final sigma as a normal sigma.                                                               *
     *                                                                                                           *
     *  Note that _any_ majuscule will also be reduced to a minuscule.                                           *
     *  Care will be taken to ensure that any final sigma *is* a final sigma.                                    *
     *                                                                                                           *
     *  Parameters:                                                                                              *
     *    source                 The starting text                                                               *
     *    nonGkIsAlreadyRemoved  This should be set to true if it has already been processed by removeNonGkChars *
     *                                                                                                           *
     *  Returned value:                                                                                          *
     *      String containing the suitably cleaned/stripped word                                                 *
     *                                                                                                           *
     *===========================================================================================================*/

    NSInteger idx, lengthOfString, characterValue;
    NSString *tempWorkArea, *strippedChar, *charString;
    NSMutableString *strippedString;
    classGkCleanResults *cleanReturn;

    tempWorkArea = [[NSString alloc] initWithString:source];
    lengthOfString = [tempWorkArea length];
    if (lengthOfString == 0) return source;
    strippedString = [[NSMutableString alloc] initWithString: @""];
    if (!nonGkIsAlreadyRemoved)
    {
        cleanReturn = [self removeNonGkChars:tempWorkArea];
        tempWorkArea = [cleanReturn greekWord];
    }
    lengthOfString = [tempWorkArea length];
    for (idx = 0; idx < lengthOfString; idx++)
    {
        // Get Hex value of character
        characterValue = [tempWorkArea characterAtIndex:idx];
        if (characterValue == 0x2d)
        {
            [strippedString appendString:@"-"];
            continue;
        }
        // What character are we dealing with?
        charString = [[NSString alloc] initWithString:[tempWorkArea substringWithRange:NSMakeRange(idx, 1)]];
        strippedChar = nil;
        strippedChar = [conversionWithBreathings objectForKey:charString];
        if( strippedChar != nil ) [strippedString appendFormat:@"%@", strippedChar];
    }
    // Check for final sigma
    lengthOfString = [strippedString length];
    if( lengthOfString > 0)
    {
        if ( (int)[strippedString characterAtIndex:lengthOfString - 1]  == 0x03c3)
        {
            strippedChar = nil;
            strippedChar = [allGkChars objectForKey:@"0x03c2"];
            if( strippedChar != nil) strippedString = [[NSMutableString alloc] initWithFormat:@"%@%@", [strippedString substringToIndex:lengthOfString - 1], strippedChar];
        }
    }
    return strippedString;
}

- (classGkCleanResults *) removeNonGkChars: (NSString *) source
{
    /*===========================================================================================================*
     *                                                                                                           *
     *                                              removeNonGkChars                                             *
     *                                              ================                                             *
     *                                                                                                           *
     *  The text comes with various characters derived from the Bible Society text that identifies variant       *
     *    readings.  Since we have no ability (or copyright agreement) to present these variant readings, they   *
     *    are redundant and even intrusive.  This method will remove them, where they occur.                     *
     *                                                                                                           *
     *  It will allso:                                                                                           *
     *    a) preserve any ascii text before the Greek word;                                                      *
     *    b) preserve any ascii non-punctuation after the Greek word;hars and punct.                             *
     *    c) preserve any punctuation attached to the word.                                                      *
     *                                                                                                           *
     *  Returned value is a Tuple with:                                                                          *
     *      item1 = any ascii text found as in a) above                                                          *
     *      item2 = any non-punctuation, as in b) above                                                          *
     *      item3 = any punctuation                                                                              *
     *      item4 = the Greek word without these spurious characters                                             *
     *                                                                                                           *
     *===========================================================================================================*/

    NSString *postChars = @"", *punctuation = @"", *clearGreek = @"", *tempString;
    NSMutableString *preChars, *copyOfSource;
    classGkCleanResults *resultRecord;
    
    copyOfSource = [[NSMutableString alloc] initWithString: source];
    preChars = [[NSMutableString alloc] initWithString:@""];
    while ([copyOfSource length] > 0)
    {
        if (([copyOfSource characterAtIndex:0] >= 0x0386) && ([copyOfSource characterAtIndex:0] <= 0x03ce)) break;
        if (([copyOfSource characterAtIndex:0] == 0x03dc) || ([copyOfSource characterAtIndex:0] == 0x03dd)) break;
        if (([copyOfSource characterAtIndex:0] >= 0x1f00) && ([copyOfSource characterAtIndex:0] <= 0x1fff)) break;
        if ([copyOfSource characterAtIndex:0] <= 0x007f)
        {
            [preChars appendString:[copyOfSource substringToIndex:1]];
        }
        copyOfSource = [[NSMutableString alloc] initWithString:[copyOfSource substringFromIndex:1]];
    }
    while ([copyOfSource length] > 0)
    {
        if ([copyOfSource characterAtIndex:[copyOfSource length] - 1] == 0x0386) break;
        if (([copyOfSource characterAtIndex:[copyOfSource length] - 1] >= 0x0388) && ([copyOfSource characterAtIndex:[copyOfSource length] - 1] <= 0x03ce)) break;
        if (([copyOfSource characterAtIndex:[copyOfSource length] - 1] == 0x03dc) || ([copyOfSource characterAtIndex:[copyOfSource length] - 1] == 0x03dd)) break;
        if (([copyOfSource characterAtIndex:[copyOfSource length] - 1] >= 0x1f00) && ([copyOfSource characterAtIndex:[copyOfSource length] - 1] <= 0x1fff)) break;
        tempString = nil;
        tempString = [[NSString alloc] initWithString:[copyOfSource substringFromIndex:[copyOfSource length] -1]];
        if (tempString != nil)
        {
            punctuation = [[NSString alloc] initWithFormat:@"%@%@", tempString, punctuation];
        }
        else
        {
            if ([copyOfSource characterAtIndex:[copyOfSource length] - 1] <= 0x007f)
            {
                postChars = [[NSString alloc] initWithFormat: @"%@%@", [copyOfSource substringFromIndex:[copyOfSource length] - 1], postChars];
            }
        }
        copyOfSource = [[NSMutableString alloc] initWithString:[copyOfSource substringFromIndex:[copyOfSource length] - 1]];
    }
    clearGreek = [[NSString alloc] initWithString: copyOfSource];
    resultRecord = [[classGkCleanResults alloc] init];
    [resultRecord setFoundAscii:preChars];
    [resultRecord setNonPunctuation:postChars];
    [resultRecord setPunctuation:punctuation];
    [resultRecord setGreekWord:clearGreek];
    return resultRecord;
}

- (NSString *) getCharacterWithRoughBreathing: (NSString *) previousChar
{
    NSString *replacementChar;

    replacementChar = nil;
    replacementChar = [addRoughBreathing objectForKey:previousChar];
    if (replacementChar == nil) return previousChar;
    return replacementChar;
}

- (NSString *) getCharacterWithSmoothBreathing: (NSString *) previousChar
{
    NSString *replacementChar;

    replacementChar = nil;
    replacementChar = [addSmoothBreathing objectForKey:previousChar];
    if (replacementChar == nil) return previousChar;
    return replacementChar;
}

- (NSString *) getCharacterWithAccuteAccent: (NSString *) previousChar
{
    NSString *replacementChar;

    replacementChar = nil;
    replacementChar = [addAccute objectForKey:previousChar];
    if (replacementChar == nil) return previousChar;
    return replacementChar;
}

- (NSString *) getCharacterWithGraveAccent: (NSString *) previousChar
{
    NSString *replacementChar;

    replacementChar = nil;
    replacementChar = [addGrave objectForKey:previousChar];
    if (replacementChar == nil) return previousChar;
    return replacementChar;
}

- (NSString *) getCharacterWithCircumflexAccent: (NSString *) previousChar
{
    NSString *replacementChar;

    replacementChar = nil;
    replacementChar = [addCirc objectForKey:previousChar];
    if (replacementChar == nil) return previousChar;
    return replacementChar;
}

- (NSString *) getCharacterWithDieresis: (NSString *) previousChar
{
    NSString *replacementChar;

    replacementChar = nil;
    replacementChar = [addDiaeresis objectForKey:previousChar];
    if (replacementChar == nil) return previousChar;
    return replacementChar;
}

- (NSString *) getCharacterWithIotaSubscript: (NSString *) previousChar
{
    NSString *replacementChar;

    replacementChar = nil;
    replacementChar = [addIotaSub objectForKey:previousChar];
    if (replacementChar == nil) return previousChar;
    return replacementChar;
}

@end
