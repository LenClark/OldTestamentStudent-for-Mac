//
//  classLexicon.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import "classLexicon.h"

@implementation classLexicon

/***********************************************************************
 *                                                                     *
 *                            Lexicon                                  *
 *                            =======                                  *
 *                                                                     *
 *  The Liddell & Scott Intermediate Lexicon forms the heart of this   *
 *    class.  However, we will also use it for:                        *
 *    a) parse related activity, and                                   *
 *    b) processing related to the lexicon - notably, the appendices   *
 *                                                                     *
 ***********************************************************************/

classConfig *globalVarsLexicon;

/*--------------------------------------------------------------------------------------------*
 *                                                                                            *
 *  lexiconEntry stores word and meaning:                                                     *
 *                                                                                            *
 *  Key:   the root Greek word                                                                *
 *  Value: the full meaning                                                                   *
 *                                                                                            *
 *--------------------------------------------------------------------------------------------*/

NSMutableDictionary *lexiconEntry;
NSMutableDictionary *alternativeCharacters;

- (id) init: (classConfig *) inGlobal
{
bool doesExist = false;
NSInteger idx, wordLength, letterValue;
NSString *keyWord, *altWord, *retrievedText, *filePathAndName, *fullText, *textLine, *originalLine, *returnedString;
NSMutableString *lexMeaning;
NSArray *problemChars = [[NSArray alloc] initWithObjects: @"ά", @"έ", @"ή", @"ί", @"ό", @"ύ", @"ώ", @"Ά", @"Έ", @"Ή", @"Ί", @"Ό", @"Ύ", @"Ώ", @"ΐ", @"ΰ", nil];
NSArray *replacementChars = [[NSArray alloc] initWithObjects: @"ά", @"έ", @"ή", @"ί", @"ό", @"ύ", @"ώ", @"Ά", @"Έ", @"Ή", @"Ί", @"Ό", @"Ύ", @"Ώ", @"ΐ", @"ΰ", nil];
NSArray *textByLine;
unichar firstCharInString, secondInString, finalChar;

if( self = [super init])
{
globalVarsLexicon = inGlobal;

/**********************************************************************************************
 *                                                                                            *
 *                           Lexicon: population of lexiconEntry                              *
 *                           ===================================                              *
 *                                                                                            *
 *  The Liddell & Scott Intermediate Lexicon forms the heart of this class.  The original     *
 *    XML file has been preprocessed to make loading the data easier.  This processed data    *
 *    can be found in the file: LandSSummary.txt.                                             *
 *                                                                                            *
 *  The purpose of the rest of this initialisation method id to load the data from this file  *
 *                                                                                            *
 *  File format:                                                                              *
 *  ===========                                                                               *
 *                                                                                            *
 *  The file is a simple text format file but the contents have a specific structure.  Each   *
 *    record (i.e. lexicon entry) is made of multiple lines.  Every line begins with one of   *
 *    the following characters:                                                               *
 *      '+'   Defines a header entry but is actually ignored                                  *
 *      '='   Defines the word and is used as the key for the dictionary entry                *
 *       ?    I.e. any character other than those specified (including '>' alone).  Text in   *
 *              an un-prefixed line is the actual meaning of the word and may be provided in  *
 *              multiple, unprefixed lines.                                                   *
 *      '>1'  The meaning is actually given by a different, related word but no meaning is    *
 *              actually given                                                                *
 *      '>2'  Similar to '>1' but there *is* an available meaning                             *
 *      '-'   Marks the end of a word definition.                                             *
 *                                                                                            *
 *  The lines described above will occur in the sequence described as well.                   *
 *                                                                                            *
 *  This data is stored in the dictionary, lexiconEntry as follows:                           *
 *                                                                                            *
 *  Key:   the root Greek word                                                                *
 *  Value: the full meaning                                                                   *
 *                                                                                            *
 *********************************************************************************************/

lexiconEntry = [[NSMutableDictionary alloc] init];
lexMeaning = [[NSMutableString alloc] initWithString:@""];
keyWord = @"";
altWord = @"";
wordLength = [problemChars count];
/*----------------------------------------------------------------------*
 *                                                                      *
 *  alternativeCharacters                                               *
 *  ---------------------                                               *
 *                                                                      *
 *  This caters for the exceptional situation that the Unicode table    *
 *    actually provides two different codes for Greek characters with a *
 *    specific accent.  Theoretically, these are used in completely     *
 *    different contexts but, in practice, some sources use one and     *
 *    some the other for the same grammatical element.  So, we will     *
 *    ensure a consistent use of only one code for each occurrence.     *
 *                                                                      *
 *----------------------------------------------------------------------*/
alternativeCharacters = [[NSMutableDictionary alloc] init];
for (idx = 0; idx < wordLength; idx++) [alternativeCharacters setObject:[replacementChars objectAtIndex:idx] forKey:[problemChars objectAtIndex:idx]];
filePathAndName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:@"LandSSummary" ofType:@"txt"]];
fullText = [[NSString alloc] initWithContentsOfFile:filePathAndName encoding:NSUTF8StringEncoding error:nil];
textByLine = [[NSArray alloc] initWithArray:[fullText componentsSeparatedByString:@"\n"]];
for( NSString *lexBuffer in textByLine)
{
    originalLine = [[NSString alloc] initWithString:lexBuffer];
    textLine = [[NSString alloc] initWithString:[lexBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if( [textLine length] == 0) continue;
    firstCharInString = [textLine characterAtIndex:0];
    switch (firstCharInString)
    {
        case '+':
            altWord = [[NSString alloc] initWithString:[textLine substringFromIndex:1]]; break;   // Discard because includes wierd additions
        case '=':
            if( [textLine length] == 1)
            {
                // If the '=' character exists without any accompanying text, then use the more questionable header
                keyWord = [[NSString alloc] initWithString:altWord];
                continue;
            }
            keyWord = [[NSString alloc] initWithString:[textLine substringFromIndex:1]];
            // There's clearly a problem with some entries ending with a non-final sigma
            // It only seems to be a problem with πόσ = πός
            finalChar = [keyWord characterAtIndex:([keyWord length] - 1)];
            letterValue = (NSInteger) finalChar;
            if( ( letterValue >= 0x30 ) && ( letterValue <= 0x39 ) ) keyWord = [[NSString alloc] initWithString:[keyWord substringToIndex:([keyWord length] - 1)]];
            // Do we already have an entry
            returnedString = nil;
            returnedString = [lexiconEntry objectForKey:keyWord];
            if( returnedString == nil) doesExist = false;
            else doesExist = true;
            break;
        case '>':
            // I haven't really checked this section - trust it's okay
            secondInString = [textLine characterAtIndex:1];
            textLine = [[NSString alloc] initWithString:[textLine substringFromIndex:2]];
            switch (secondInString)
        {
            case '1':
                // There is a related word (and no specified meaning for this version
                [lexMeaning appendString:[[NSString alloc] initWithFormat:@"Related word:%@\n", textLine]];
                wordLength = [textLine length] + 14;
                for( idx = 0; idx < wordLength; idx++ ) [lexMeaning appendString:@"="];
                [lexMeaning appendString:@"\n"];
                returnedString = nil;
                returnedString = [lexiconEntry objectForKey:keyWord];
                if( returnedString == nil ) [lexMeaning appendString:@"No related meaning found"];
                else
                {
                    if( [returnedString length] == 0) [lexMeaning appendString: @"Unable to retrieve a related meaning"];
                    else [lexMeaning appendString:retrievedText];
                }
                break;
            case '2':
                // There is a different word that is used with exactly the same meaning
                [lexMeaning appendString:[[NSString alloc] initWithFormat:@"Equivalent word to:%@\n", textLine]];
                wordLength = [textLine length] + 20;
                for( idx = 0; idx < wordLength; idx++ ) [lexMeaning appendString:@"="];
                [lexMeaning appendString:@"\n"];
                returnedString = nil;
                returnedString = [lexiconEntry objectForKey:keyWord];
                if( returnedString == nil ) [lexMeaning appendString:@"No related meaning found"];
                else
                {
                    if( [returnedString length] == 0) [lexMeaning appendString: @"Unable to retrieve a related meaning"];
                    else
                    {
                        if( retrievedText == nil) [lexMeaning appendString: @"Unable to retrieve a related meaning"];
                        else [lexMeaning appendString:retrievedText];
                    }
                }
                break;
            default: break;
        }
            break;
        case '-':
            if( doesExist )
            {
                returnedString = nil;
                returnedString = [lexiconEntry objectForKey:keyWord];
                if( returnedString != nil )
                {
                    [lexiconEntry removeObjectForKey:keyWord];
                    [lexiconEntry setObject:[[NSString alloc] initWithFormat:@"%@\n\nAdditional Meaning:\n==================\n\n%@", returnedString, lexMeaning] forKey:keyWord];
                    lexMeaning = [[NSMutableString alloc] initWithString:@""];
                    break;
                }
            }
            if( ( [keyWord compare:@"-i"] == NSOrderedSame) || ( [lexMeaning length] == 0 ) )
            {
                lexMeaning = [[NSMutableString alloc] initWithString:@""];
                break;
            }
            [lexiconEntry setObject:lexMeaning forKey:keyWord];
            lexMeaning = [[NSMutableString alloc] initWithString:@""];
            break;
        default:
            // Lines starting with any other characters are considered part of the meaning
            [lexMeaning appendFormat:@"%@\n", originalLine];
            break;
    }
}
}
return self;
}

/***********************************************************************
*                                                                     *
* Liddell & Scott Appendices                                          *
*                                                                     *
***********************************************************************/

- (void) populateAppendice
{
    NSInteger idx, noOfAppendices;
    NSString *fileName, *fullFileName, *webContent;
    NSArray *webAppendices, *fileNames;
    NSTextView *activeWeb;

fileNames = [[NSArray alloc] initWithObjects:@"Comments", @"L1_authors_and_works", @"L2_epigraphical_publications", @"L3_papyrological_publications",
        @"L4_periodicals", @"L5_general_abbreviations", nil];
webAppendices = [globalVarsLexicon  collectionOfWebViews];
noOfAppendices = [webAppendices count];
    for (idx = 0; idx < noOfAppendices; idx++)
    {
        activeWeb = [webAppendices objectAtIndex:idx];
        fileName = [fileNames objectAtIndex:idx];
        fullFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
        webContent = [[NSString alloc] initWithContentsOfFile:fullFileName encoding:NSUTF8StringEncoding error:nil];
        [activeWeb setString:webContent];
    }
}
                                 
- (NSString *) getLexiconEntry: (NSString *) wordToExplain
{
bool isModified = false;
NSInteger idx, wordLength;
NSString *sourceLetter, *workingWord, *temporaryString;
NSMutableString *fullMeaning;

fullMeaning = [[NSMutableString alloc] initWithString:@""];
workingWord = [[NSString alloc] initWithString:[wordToExplain stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
[fullMeaning appendFormat:@"Word analysed: %@\n", workingWord];
wordLength = [workingWord length] + 15;
for (idx = 0; idx < wordLength; idx++)
{
[fullMeaning appendString:@"="];
}
[fullMeaning appendString:@"\n\n"];
temporaryString = nil;
temporaryString = [lexiconEntry objectForKey:workingWord];
if( temporaryString == nil)
{
wordLength = [workingWord length];
for (idx = 0; idx < wordLength; idx++)
{
    sourceLetter = [workingWord substringWithRange:NSMakeRange(idx, 1)];
    temporaryString = [alternativeCharacters objectForKey:sourceLetter];
    if (temporaryString != nil)
    {
        workingWord = [[NSString alloc] initWithString:[workingWord stringByReplacingOccurrencesOfString:sourceLetter withString:temporaryString]];
        isModified = true;
    }
}
if (isModified)
{
    temporaryString = nil;
    temporaryString = [lexiconEntry objectForKey:workingWord];
    if (temporaryString != nil)
    {
        [fullMeaning appendString:temporaryString];
    }
}
else [fullMeaning appendString:@"Meaning not found"];
}
else
{
[fullMeaning appendString:temporaryString];
}
return fullMeaning;
}
                                 
- (NSString *) parseGrammar: (NSString *) codes1 withFullerCode: (NSString *) codes2 isNT: (bool) isNT
{
if (isNT) return [self parseNTGrammar:codes1 withFullerCode:codes2];
else return [self parseLXXGrammar:codes1 withFullerCode:codes2];
}
                                 
- (NSString *) parseNTGrammar: (NSString *) codes1 withFullerCode: (NSString *) codes2
{
bool isPtcpl = false;
unichar currentCode, decodeChar;
NSMutableString *outputText;
                                     
if ((codes1 == nil) || (codes2 == nil)) return @"";
currentCode = [codes1 characterAtIndex:0];
outputText = [[NSMutableString alloc] initWithString:@""];
switch (currentCode)
{
case 'V': // The word is a verb
{
    [outputText appendString:@"Verb: "];
    decodeChar = [codes2 characterAtIndex:3];
    if (decodeChar == 'P') isPtcpl = true;
    if (isPtcpl)
    {
        decodeChar = [codes2 characterAtIndex:4];
        switch (decodeChar)
        {
            case 'N': [outputText appendString:@"Nominative "]; break;
            case 'V': [outputText appendString:@"Vocative "]; break;
            case 'A': [outputText appendString:@"Accusative "]; break;
            case 'G': [outputText appendString:@"Genitive "]; break;
            case 'D': [outputText appendString:@"Dative "]; break;
            default: break;
        }
    }
    decodeChar = [codes2 characterAtIndex:0];
    switch (decodeChar)
    {
        case '1': [outputText appendString:@"1st person "]; break;
        case '2': [outputText appendString:@"2nd person "]; break;
        case '3': [outputText appendString:@"3rd person "]; break;
        default: // do nothing
            break;
    }
    decodeChar = [codes2 characterAtIndex:5];
    switch (decodeChar)
    {
        case 'S': [outputText appendString:@"Singular "]; break;
        case 'P': [outputText appendString:@"Plural "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:6];
    switch (decodeChar)
    {
        case 'M': [outputText appendString:@"Masculine "]; break;
        case 'F': [outputText appendString:@"Feminine "]; break;
        case 'N': [outputText appendString:@"Neuter "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:1];
    switch (decodeChar)
    {
        case 'P': [outputText appendString:@"Present "]; break;
        case 'I': [outputText appendString:@"Imperfect "]; break;
        case 'F': [outputText appendString:@"Future "]; break;
        case 'A': [outputText appendString:@"Aorist "]; break;
        case 'X': [outputText appendString:@"Perfect "]; break;
        case 'Y': [outputText appendString:@"Pluperfect "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:2];
    switch (decodeChar)
    {
        case 'A': [outputText appendString:@"Active "]; break;
        case 'M': [outputText appendString:@"Middle "]; break;
        case 'P': [outputText appendString:@"Passive "]; break;
        case 'E': [outputText appendString:@"Middle or Passive "]; break;
        case 'D': [outputText appendString:@"Middle deponent "]; break;
        case 'O': [outputText appendString:@"Passive deponent "]; break;
        case 'N': [outputText appendString:@"Middle or Passive deponent "]; break;
        case 'Q': [outputText appendString:@"Impersonal active "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:3];
    switch (decodeChar)
    {
        case 'I': [outputText appendString:@"Indicative "]; break;
        case 'S': [outputText appendString:@"Subjunctive "]; break;
        case 'O': [outputText appendString:@"Optative "]; break;
        case 'M': [outputText appendString:@"Imperative "]; break;
        case 'D': [outputText appendString:@"Imperative "]; break;
        case 'N': [outputText appendString:@"Infinitive "]; break;
        case 'P': [outputText appendString:@"Participle "]; break;
        case 'R': [outputText appendString:@"Imperative participle "]; break;
        default: break;
    }
}
    break;
case 'N':
case 'A':
{
    if (currentCode == 'A')
    {
        [outputText appendString:@"Adjective: "];
    }
    else
    {
        [outputText appendString:@"Noun: "];
    }
    if ([codes2 length] > 4)
    {
        decodeChar = [codes2 characterAtIndex:4];
        switch (decodeChar)
        {
            case 'N': [outputText appendString:@"Nominative "]; break;
            case 'V': [outputText appendString:@"Vocative "]; break;
            case 'A': [outputText appendString:@"Accusative "]; break;
            case 'G': [outputText appendString:@"Genitive "]; break;
            case 'D': [outputText appendString:@"Dative "]; break;
            default: break;
        }
    }
    if ([codes2 length] > 5)
    {
        decodeChar = [codes2 characterAtIndex:5];
        switch (decodeChar)
        {
            case 'S': [outputText appendString:@"Singular "]; break;
            case 'P': [outputText appendString:@"Plural "]; break;
            default: break;
        }
    }
    if ([codes2 length] > 6)
    {
        decodeChar = [codes2 characterAtIndex:6];
        switch (decodeChar)
        {
            case 'M': [outputText appendString:@"Masculine "]; break;
            case 'F': [outputText appendString:@"Feminine "]; break;
            case 'N': [outputText appendString:@"Neuter "]; break;
            default: break;
        }
    }
    if ([codes2 length] > 7)
    {
        decodeChar = [codes2 characterAtIndex:7];
        switch (decodeChar)
        {
            case 'C': [outputText appendString:@"Comparative "]; break;
            case 'S': [outputText appendString:@"Superlative "]; break;
            default: break;
        }
    }
}
    break;
case 'P': [outputText appendString:@"Preposition"]; break;
case 'C': [outputText appendString:@"Conjunction"]; break;
case 'D': [outputText appendString:@"Enclitic"]; break;
case 'X': [outputText appendString:@"Exclamation or indefinite pronoun"]; break;
case 'I': [outputText appendString:@"Interjection"]; break;
case 'R':
{
    if ([codes2 length] > 4)
    {
        decodeChar = [codes2 characterAtIndex:4];
        switch (decodeChar)
        {
            case 'N': [outputText appendString:@"Nominative "]; break;
            case 'V': [outputText appendString:@"Vocative "]; break;
            case 'A': [outputText appendString:@"Accusative "]; break;
            case 'G': [outputText appendString:@"Genitive "]; break;
            case 'D': [outputText appendString:@"Dative "]; break;
            default: break;
        }
    }
    if ([codes2 length] > 5)
    {
        decodeChar = [codes2 characterAtIndex:5];
        switch (decodeChar)
        {
            case 'S': [outputText appendString:@"Singular "]; break;
            case 'P': [outputText appendString:@"Plural "]; break;
            default: break;
        }
    }
    if ([codes2 length] > 6)
    {
        decodeChar = [codes2 characterAtIndex:6];
        switch (decodeChar)
        {
            case 'M': [outputText appendString:@"Masculine "]; break;
            case 'F': [outputText appendString:@"Feminine "]; break;
            case 'N': [outputText appendString:@"Neuter "]; break;
            default: break;
        }
    }
    if ([codes1 length] > 1)
    {
        switch ([codes1 characterAtIndex:1])
        {
            case 'A': [outputText appendString:@" Article "]; break;
            case 'P': [outputText appendString:@" Personal Pronoun "]; break;
            case 'I': [outputText appendString:@" Interrogative Pronoun "]; break;
            case 'R': [outputText appendString:@" Relative Pronoun "]; break;
            case 'D': [outputText appendString:@" Demonstrative Pronoun "]; break;
            default: [outputText appendFormat:@" Unknown: %@", codes1]; break;
        }
    }
}
    break;
}
return outputText;
}
                                 
- (NSString *) parseLXXGrammar: (NSString *) codes1 withFullerCode: (NSString *) codes2
{
bool isPtcpl = false;
unichar currentCode, decodeChar;
NSMutableString *outputText;
                                     
if ((codes1 == nil) || (codes2 == nil)) return @"";
currentCode = [codes1 characterAtIndex:0];
outputText = [[NSMutableString alloc] initWithString:@""];
switch (currentCode)
{
case 'V': // The word is a verb
{
    [outputText appendString:@"Verb: "];
    decodeChar = [codes2 characterAtIndex:2];
    if (decodeChar == 'P') isPtcpl = true;
    if (isPtcpl)
    {
        decodeChar = [codes2 characterAtIndex:3];
        switch (decodeChar)
        {
            case 'N': [outputText appendString:@"Nominative "]; break;
            case 'V': [outputText appendString:@"Vocative "]; break;
            case 'A': [outputText appendString:@"Accusative "]; break;
            case 'G': [outputText appendString:@"Genitive "]; break;
            case 'D': [outputText appendString:@"Dative "]; break;
            default: break;
        }
    }
    if([codes2 length] > 3)
    {
        decodeChar = [codes2 characterAtIndex:3];
        switch (decodeChar)
        {
            case '1': [outputText appendString:@"1st person "]; break;
            case '2': [outputText appendString:@"2nd person "]; break;
            case '3': [outputText appendString:@"3rd person "]; break;
            default: // do nothing
                break;
        }
    }
    if ([codes2 length] > 4)
    {
        decodeChar = [codes2 characterAtIndex:4];
        switch (decodeChar)
        {
            case 'S': [outputText appendString:@"Singular "]; break;
            case 'D': [outputText appendString:@"Dual"]; break;
            case 'P': [outputText appendString:@"Plural "]; break;
            default: break;
        }
    }
    if ([codes2 length] > 5)
    {
        decodeChar = [codes2 characterAtIndex:5];
        switch (decodeChar)
        {
            case 'M': [outputText appendString:@"Masculine "]; break;
            case 'F': [outputText appendString:@"Feminine "]; break;
            case 'N': [outputText appendString:@"Neuter "]; break;
            default: break;
        }
    }
    decodeChar = [codes2 characterAtIndex:0];
    switch (decodeChar)
    {
        case 'P': [outputText appendString:@"Present "]; break;
        case 'I': [outputText appendString:@"Imperfect "]; break;
        case 'F': [outputText appendString:@"Future "]; break;
        case 'A': [outputText appendString:@"Aorist "]; break;
        case 'X': [outputText appendString:@"Perfect "]; break;
        case 'Y': [outputText appendString:@"Pluperfect "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:1];
    switch (decodeChar)
    {
        case 'A': [outputText appendString:@"Active "]; break;
        case 'M': [outputText appendString:@"Middle "]; break;
        case 'P': [outputText appendString:@"Passive "]; break;
        case 'E': [outputText appendString:@"Middle or Passive "]; break;
        case 'D': [outputText appendString:@"Middle deponent "]; break;
        case 'O': [outputText appendString:@"Passive deponent "]; break;
        case 'N': [outputText appendString:@"Middle or Passive deponent "]; break;
        case 'Q': [outputText appendString:@"Impersonal active "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:2];
    switch (decodeChar)
    {
        case 'I': [outputText appendString:@"Indicative "]; break;
        case 'S': [outputText appendString:@"Subjunctive "]; break;
        case 'O': [outputText appendString:@"Optative "]; break;
        case 'M': [outputText appendString:@"Imperative "]; break;
        case 'D': [outputText appendString:@"Imperative "]; break;
        case 'N': [outputText appendString:@"Infinitive "]; break;
        case 'P': [outputText appendString:@"Participle "]; break;
        case 'R': [outputText appendString:@"Imperative participle "]; break;
        default: break;
    }
}
    break;
case 'N':
case 'A':
{
    if (currentCode == 'A')
    {
        [outputText appendString:@"Adjective: "];
    }
    else
    {
        [outputText appendString:@"Noun: "];
    }
    decodeChar = [codes2 characterAtIndex:0];
    switch (decodeChar)
    {
        case 'N': [outputText appendString:@"Nominative "]; break;
        case 'V': [outputText appendString:@"Vocative "]; break;
        case 'A': [outputText appendString:@"Accusative "]; break;
        case 'G': [outputText appendString:@"Genitive "]; break;
        case 'D': [outputText appendString:@"Dative "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:1];
    switch (decodeChar)
    {
        case 'S': [outputText appendString:@"Singular "]; break;
        case 'D': [outputText appendString:@"Dual "]; break;
        case 'P': [outputText appendString:@"Plural "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:2];
    switch (decodeChar)
    {
        case 'M': [outputText appendString:@"Masculine "]; break;
        case 'F': [outputText appendString:@"Feminine "]; break;
        case 'N': [outputText appendString:@"Neuter "]; break;
        default: break;
    }
    if ([codes2 length] > 3)
    {
        decodeChar = [codes2 characterAtIndex:3];
        switch (decodeChar)
        {
            case 'C': [outputText appendString:@"Comparative "]; break;
            case 'S': [outputText appendString:@"Superlative "]; break;
            default: break;
        }
    }
}
    break;
case 'P': [outputText appendString:@"Preposition"]; break;
case 'C': [outputText appendString:@"Conjunction"]; break;
case 'D': [outputText appendString:@"Adverb"]; break;
case 'X': [outputText appendString:@"Particle"]; break;
case 'I': [outputText appendString:@"Interjection"]; break;
case 'M': [outputText appendString:@"Indeclinable number"]; break;
case 'R':
{
    decodeChar = [codes2 characterAtIndex:0];
    switch (decodeChar)
    {
        case 'N': [outputText appendString:@"Nominative "]; break;
        case 'V': [outputText appendString:@"Vocative "]; break;
        case 'A': [outputText appendString:@"Accusative "]; break;
        case 'G': [outputText appendString:@"Genitive "]; break;
        case 'D': [outputText appendString:@"Dative "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:1];
    switch (decodeChar)
    {
        case 'S': [outputText appendString:@"Singular "]; break;
        case 'D': [outputText appendString:@"Dual "]; break;
        case 'P': [outputText appendString:@"Plural "]; break;
        default: break;
    }
    decodeChar = [codes2 characterAtIndex:2];
    switch (decodeChar)
    {
        case 'M': [outputText appendString:@"Masculine "]; break;
        case 'F': [outputText appendString:@"Feminine "]; break;
        case 'N': [outputText appendString:@"Neuter "]; break;
        default: break;
    }
    decodeChar = [codes1 characterAtIndex:1];
    switch (decodeChar)
    {
        case 'A': [outputText appendString:@" Article "]; break;
        case 'P': [outputText appendString:@" Personal Pronoun "]; break;
        case 'I': [outputText appendString:@" Interrogative Pronoun "]; break;
        case 'R': [outputText appendString:@" Relative Pronoun "]; break;
        case 'D': [outputText appendString:@" Demonstrative Pronoun "]; break;
        case 'X': [outputText appendString:@"ὅστις"]; break;
        default: [outputText appendFormat:@" Unknown: %@", codes1]; break;
    }
}
    break;
}
return outputText;
}

@end
