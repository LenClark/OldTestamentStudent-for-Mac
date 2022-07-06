/*=======================================================================================================*
 *                                                                                                       *
 *                                          classGkLexicon                                               *
 *                                          ==============                                               *
 *                                                                                                       *
 *  The Liddell & Scott Intermediate Lexicon forms the heart of this class.  However, we will also use   *
 *    it for:                                                                                            *
 *    a) parse related activity, and                                                                     *
 *    b) processing related to the lexicon - notably, the appendices                                     *
 *                                                                                                       *
 *  Len Clark                                                                                            *
 *  May 2022                                                                                             *
 *                                                                                                       *
 *=======================================================================================================*/

#import "classGkLexicon.h"

@implementation classGkLexicon

classGlobal *globalGkLexVars;
classGreekOrthography *greekProcessing;
classDisplayUtilities *gkLexUtilities;

/*--------------------------------------------------------------------------------------------*
 *                                                                                            *
 *  lexiconEntry stores word and meaning:                                                     *
 *                                                                                            *
 *  Key:   the root Greek word                                                                *
 *  Value: the full meaning                                                                   *
 *                                                                                            *
 *--------------------------------------------------------------------------------------------*/

@synthesize lexiconEntry;
@synthesize unaccentedLookup;
@synthesize alternativeCharacters;
@synthesize gkLexLoop;
@synthesize gkLexProgress;

- (id) init: (classGlobal *) inConfig withOrthography: (classGreekOrthography *) inGkProcs usingUtils: (classDisplayUtilities *) inUtilities
{
    if( self = [super init])
    {
        globalGkLexVars = inConfig;
        greekProcessing = inGkProcs;
        gkLexUtilities = inUtilities;
    }
    return self;
}

- (void) loadLexiconData
{
    bool doesExist = false;
    NSInteger idx, wordLength, letterValue;
    // Single character strings
    unichar firstInString, secondInString, finalChar;
    NSString *lexFileName, *lexBuffer, *keyWord, *entryForm, *altWord, *retrievedText, *flatWord = @"", *cleanWord, *newWord, *firstLetter, *prevFirstLetter;
    NSMutableString *lexMeaning, *altLexMeaning;
    NSArray *problemChars, *textByLine;
    NSArray *replacementChars;
    classGkLexiconExtras *lexiconExtras;

    problemChars = [[NSArray alloc] initWithObjects: @"ά", @"έ", @"ή", @"ί", @"ό", @"ύ", @"ώ", @"Ά", @"Έ", @"Ή", @"Ί", @"Ό", @"Ύ", @"Ώ", @"ΐ", @"ΰ", nil];
    replacementChars = [[NSArray alloc] initWithObjects: @"ά", @"έ", @"ή", @"ί", @"ό", @"ύ", @"ώ", @"Ά", @"Έ", @"Ή", @"Ί", @"Ό", @"Ύ", @"Ώ", @"ΐ", @"ΰ", nil];
    lexiconEntry = [[NSMutableDictionary alloc] init];
    unaccentedLookup = [[NSMutableDictionary alloc] init];
    alternativeCharacters = [[NSMutableDictionary alloc] init];
    lexMeaning = [[NSMutableString alloc] initWithString:@""];
    keyWord = @"";
    altWord = @"";
    prevFirstLetter = @"?";
    // Replace characters that have two forms un the Unicode specification
    wordLength = [problemChars count];
    for (idx = 0; idx < wordLength; idx++) [alternativeCharacters setObject:[replacementChars objectAtIndex:idx] forKey:[problemChars objectAtIndex:idx]];
    // Get the lexicon data
    lexFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:[globalGkLexVars fullGkLexiconFile] ofType:@"txt"]];
    lexBuffer = [[NSString alloc] initWithContentsOfFile:lexFileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[lexBuffer componentsSeparatedByString:@"\n"]];
    for (NSString *lineOfText in textByLine)
    {
        cleanWord = [[NSString alloc] initWithString:[lineOfText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        if ([cleanWord length] == 0) continue;
        firstInString = [cleanWord characterAtIndex:0];
        switch (firstInString)
        {
            case '+':
                // This _was_ used as a key for the entry but is now ignored
                // Note that there are some entries that are identical but with two seperate entries (e.g. ἀγός and ἄγος1)
                // Note also there are values for this field that vary only in accent (e.g. ἄγη1 and ἀγή1)
                keyWord = [[NSString alloc] initWithString:[cleanWord substringFromIndex:1]];
                break; // Discard because includes wierd additions
            case '=':
                // This contains the word which is actually the lexicon entry
                if ([cleanWord length] == 1)
                {
                    // If the '=' character exists without any accompanying text, then use the more questionable header
                    entryForm = [[NSString alloc] initWithString: keyWord];
                    continue;
                }
                else entryForm = [cleanWord substringFromIndex:1];
                firstLetter = [self getLetterCode:[[NSString alloc] initWithString:[entryForm substringToIndex:1]]];
                if( [firstLetter compare:prevFirstLetter] != NSOrderedSame )
                {
                    [gkLexProgress updateProgressMain:@"Loading Greek lexicon data - letter:" withSecondMsg:firstLetter];
                    [gkLexLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
                    prevFirstLetter = [[NSString alloc] initWithString:firstLetter];
                }
                finalChar = [entryForm characterAtIndex:[entryForm length] - 1];
                letterValue = (NSInteger)finalChar;
                // The keyWord may contain a digit; in which case, remove it
                if ((letterValue >= 0x30) && (letterValue <= 0x39))
                {
                    entryForm = [entryForm substringToIndex:[entryForm length]];
                }
                // Do we already have an entry
                altLexMeaning = nil;
                altLexMeaning = [lexiconEntry objectForKey:entryForm];
                if (altLexMeaning == nil)
                {
                    doesExist = false;
                }
                else
                {
                    doesExist = true;
                }
                break;
            case ';':
                // This adds the version of the word with no accents, etc.
                // It follows the keyWord entry and uses the same logic
                flatWord = [[NSString alloc] initWithString:[cleanWord substringFromIndex:1]];
                break;
            case '>':
                // This is used for equivalence references
                secondInString = [[[NSString alloc] initWithString:[cleanWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] characterAtIndex:1];
                newWord = [[[NSString alloc] initWithString:[cleanWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] substringFromIndex:2];
                switch (secondInString)
                {
                    case '1':
                        // There is a related word (and no specified meaning for this version
                        [lexMeaning appendFormat:@"Related word: %@\n", newWord];
                        wordLength = [newWord length] + 14;
                        for (idx = 0; idx < wordLength; idx++)
                        {
                            [lexMeaning appendString:@"="];
                        }
                        [lexMeaning appendString:@"\n"];
                        altLexMeaning = nil;
                        altLexMeaning = [lexiconEntry objectForKey:entryForm];
                        if (altLexMeaning != nil)
                        {
                            [lexMeaning appendString:retrievedText];
                        }
                        else
                        {
                            [lexMeaning appendString: @"No related meaning found."];
                        }
                        break;
                    case '2':
                        // There is a different word that is used with exactly the same meaning
                        [lexMeaning appendFormat: @"Equivalent word to: %@\n", entryForm];
                        wordLength = [lexMeaning length] + 20;
                        for (idx = 0; idx < wordLength; idx++)
                        {
                            [lexMeaning appendString: @"="];
                        }
                        [lexMeaning appendString: @"\n"];
                        altLexMeaning = nil;
                        altLexMeaning = [lexiconEntry objectForKey:entryForm];
                        if (altLexMeaning != nil)
                        {
                            [lexMeaning appendString: altLexMeaning];
                        }
                        else
                        {
                            [lexMeaning appendString:@"No related meaning found."];
                        }
                        break;
                }
                break;
            case '-':
                if (doesExist)
                {
                    altLexMeaning = nil;
                    altLexMeaning = [lexiconEntry objectForKey:entryForm];
//                        [altLexMeaning appendFormat: @"\n\nAdditional Meaning:\n==================\n\n%@", lexMeaning];
                    [lexiconEntry removeObjectForKey:entryForm];
                    [lexiconEntry setObject:[[NSString alloc] initWithFormat:@"\n\nAdditional Meaning:\n==================\n\n%@%@", altLexMeaning, lexMeaning] forKey:entryForm];
                    if( [unaccentedLookup doesContain:flatWord])
                    {
                        lexiconExtras = [[classGkLexiconExtras alloc] init];
                        [unaccentedLookup setObject:lexiconEntry forKey:flatWord];
                    }
                    else lexiconExtras = [unaccentedLookup objectForKey:flatWord];
                    [lexiconExtras addAKey:entryForm];
                    lexMeaning = [[NSMutableString alloc] initWithString: @""];
                    break;
                }
                else
                {
                    retrievedText = nil;
                    retrievedText = [lexiconEntry objectForKey:entryForm];
                    {
                        if( retrievedText != nil)
                        {
                            [lexiconEntry removeObjectForKey:entryForm];
                            [unaccentedLookup removeObjectForKey:flatWord];
                        }
                    }
                }
                if (([entryForm compare:@"-i"] == NSOrderedSame) || ([lexMeaning length] == 0))
                {
                    lexMeaning = [[NSMutableString alloc] initWithString: @""];
                    break;
                }
                [lexiconEntry setObject:lexMeaning forKey:entryForm];
                if (! [unaccentedLookup doesContain:flatWord])
                {
                    lexiconExtras = [[classGkLexiconExtras alloc] init];
                    [unaccentedLookup setObject:lexiconExtras forKey:flatWord];
                }
                else lexiconExtras = [unaccentedLookup objectForKey:flatWord];
                [lexiconExtras addAKey:entryForm];
                lexMeaning = [[NSMutableString alloc] initWithString: @""];
                break;
            default:
                [lexMeaning appendFormat:@"%@\n", cleanWord];
                break;
        }
    }
}

- (NSString *) getLetterCode: (NSString *) sourceLetter
{
    NSInteger letterValue;
    NSString *workingSource;
    
    if( [sourceLetter length] == 0) return @"";
    if( [sourceLetter length] > 1) workingSource = [[NSString alloc] initWithString:[sourceLetter substringToIndex:1]];
    else workingSource = [[NSString alloc] initWithString:sourceLetter];
    letterValue = [workingSource characterAtIndex:0];
    if( (letterValue >= 0x1f00) && ( letterValue <= 0x1f0f)) return @"α";
    if( (letterValue == 0x1f70) || ( letterValue == 0x1f71)) return @"α";
    if( (letterValue >= 0x1f80) && ( letterValue <= 0x1f8f)) return @"α";
    if( (letterValue >= 0x1fb0) && ( letterValue <= 0x1fbf)) return @"α";
    if( (letterValue == 0x0386) || ( letterValue == 0x0391)) return @"α";
    if( (letterValue == 0x03ac) || ( letterValue == 0x03b1)) return @"α";
    if( (letterValue == 0x0392) || ( letterValue == 0x03b2)) return @"β";
    if( (letterValue == 0x0393) || ( letterValue == 0x03b3)) return @"γ";
    if( (letterValue == 0x0394) || ( letterValue == 0x03b4)) return @"δ";
    if( (letterValue >= 0x1f10) && ( letterValue <= 0x1f1f)) return @"ε";
    if( (letterValue == 0x1f72) || ( letterValue == 0x1f73)) return @"ε";
    if( (letterValue == 0x1fc8) || ( letterValue == 0x1fc9)) return @"ε";
    if( (letterValue == 0x0388) || ( letterValue == 0x0395)) return @"ε";
    if( (letterValue == 0x03ad) || ( letterValue == 0x03b5)) return @"ε";
    if( (letterValue == 0x0396) || ( letterValue == 0x03b6)) return @"ζ";
    if( (letterValue >= 0x1f20) && ( letterValue <= 0x1f2f)) return @"η";
    if( (letterValue == 0x1f74) || ( letterValue == 0x1f75)) return @"η";
    if( (letterValue >= 0x1f90) && ( letterValue <= 0x1f9f)) return @"η";
    if( (letterValue >= 0x1fc2) && ( letterValue <= 0x1fc7)) return @"η";
    if( (letterValue == 0x0389) || ( letterValue == 0x0397)) return @"η";
    if( (letterValue == 0x03ae) || ( letterValue == 0x03b7)) return @"η";
    if( (letterValue == 0x0398) || ( letterValue == 0x03b8)) return @"θ";
    if( (letterValue >= 0x1f30) && ( letterValue <= 0x1f3f)) return @"ι";
    if( (letterValue == 0x1f76) || ( letterValue == 0x1f77)) return @"ι";
    if( (letterValue >= 0x1fd0) && ( letterValue <= 0x1fdf)) return @"ι";
    if( (letterValue == 0x038a) || ( letterValue == 0x0399)) return @"ι";
    if( (letterValue == 0x03af) || ( letterValue == 0x03b9)) return @"ι";
    if( (letterValue == 0x039a) || ( letterValue == 0x03ba)) return @"κ";
    if( (letterValue == 0x039b) || ( letterValue == 0x03bb)) return @"λ";
    if( (letterValue == 0x039c) || ( letterValue == 0x03bc)) return @"μ";
    if( (letterValue == 0x039d) || ( letterValue == 0x03bd)) return @"ν";
    if( (letterValue == 0x039e) || ( letterValue == 0x03be)) return @"ξ";
    if( (letterValue >= 0x1f40) && ( letterValue <= 0x1f4f)) return @"ο";
    if( (letterValue == 0x1f78) || ( letterValue == 0x1f79)) return @"ο";
    if( (letterValue == 0x1ff8) || ( letterValue == 0x1ff9)) return @"ο";
    if( (letterValue == 0x038c) || ( letterValue == 0x039f)) return @"ο";
    if( (letterValue == 0x03bf) || ( letterValue == 0x03cc)) return @"ο";
    if( (letterValue == 0x03a0) || ( letterValue == 0x03c0)) return @"π";
    if( (letterValue == 0x03a1) || ( letterValue == 0x03c1)) return @"ρ";
    if( (letterValue == 0x1fe4) || ( letterValue == 0x1fe5) || ( letterValue == 0x1fec)) return @"ρ";
    if( (letterValue == 0x03a3) || ( letterValue == 0x03c2) || ( letterValue == 0x03c3)) return @"σ";
    if( (letterValue == 0x03a4) || ( letterValue == 0x03c4)) return @"τ";
    if( (letterValue >= 0x1f50) && ( letterValue <= 0x1f5f)) return @"υ";
    if( (letterValue == 0x1f7a) || ( letterValue == 0x1f7b)) return @"υ";
    if( (letterValue >= 0x1fe0) && ( letterValue <= 0x1fe3)) return @"υ";
    if( (letterValue >= 0x1fe6) && ( letterValue <= 0x1feb)) return @"υ";
    if( (letterValue == 0x038e) || ( letterValue == 0x03a5)) return @"υ";
    if( (letterValue == 0x03c5) || ( letterValue == 0x03cd)) return @"υ";
    if( (letterValue == 0x03a6) || ( letterValue == 0x03c6)) return @"φ";
    if( (letterValue == 0x03a7) || ( letterValue == 0x03c7)) return @"χ";
    if( (letterValue == 0x03a8) || ( letterValue == 0x03c8)) return @"ψ";
    if( (letterValue >= 0x1f60) && ( letterValue <= 0x1f6f)) return @"ω";
    if( (letterValue == 0x1f7c) || ( letterValue == 0x1f7d)) return @"ω";
    if( (letterValue >= 0x1fa0) && ( letterValue <= 0x1faf)) return @"ω";
    if( (letterValue == 0x1ff2) || ( letterValue == 0x1ff7)) return @"ω";
    if( (letterValue == 0x1ffa) || ( letterValue == 0x1ffc)) return @"ω";
    if( (letterValue == 0x038f) || ( letterValue == 0x03a9)) return @"ω";
    if( (letterValue == 0x03c9) || ( letterValue == 0x03ce)) return @"ω";
    return 0;
}

/*=====================================================================*
 *                                                                     *
 * Liddell & Scott Appendices                                          *
 *                                                                     *
 *=====================================================================*/

- (void) populateAppendice
{
/*    NSInteger idx, noOfAppendices;
    NSString *fileName, *fullFileName;
    NSURL *fullFileUrl;
    WKWebView *activeWeb;
    NSURLRequest *currentRequest;

    noOfAppendices = [globalGkLexVars maxWebBrowsers];
    for( idx = 0; idx < noOfAppendices; idx++)
    {
        fileName = (NSString *)[globalGkLexVars getGroupedControl:[globalGkLexVars landsCode] atPosition:idx];
        activeWeb = (WKWebView *)[globalGkLexVars getGroupedControl:[globalGkLexVars webBrowsersCode] atPosition:idx];
        fullFileName = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
        fullFileUrl = [NSURL fileURLWithPath:fullFileName];
        currentRequest = [[NSURLRequest alloc] initWithURL:fullFileUrl];
        [activeWeb loadRequest:currentRequest];
    } */
}

- (void) getLexiconEntry: (NSString *) wordToExplain
{
    bool isModified = false, isNoUse = false;
    NSInteger idx, wordLength;
    NSString *sourceLetter, *targetLetter;
    NSString *retrievedMeaning, *workingWord, *finalLetter;
    NSMutableString *alternativeWorkingWord;
    classGkLexiconExtras *lexiconExtras;
    NSArray *setOfKeys;
//    Color  backgroundColour;
    NSTextView *txtLexicon;

//    backgroundColour = globalVars.getColourSetting(3, 0);
    workingWord = [[NSString alloc] initWithString:[wordToExplain stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    txtLexicon = [globalGkLexVars txtAllLexicon];
    [txtLexicon selectAll:self];
    [txtLexicon delete:self];
//    rtxtLexicon.BackColor = backgroundColour;  // Background colour for the lexical area
    [[txtLexicon textStorage] appendAttributedString:[gkLexUtilities addAttributedText:workingWord offsetCode:0 fontId:7 alignment:1 withAdjustmentFor:txtLexicon]];
    [[txtLexicon textStorage] appendAttributedString:[gkLexUtilities addAttributedText:@"\n" offsetCode:0 fontId:7 alignment:1 withAdjustmentFor:txtLexicon]];
    [[txtLexicon textStorage] appendAttributedString:[gkLexUtilities addAttributedText:@"\n" offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:txtLexicon]];
    retrievedMeaning = nil;
    retrievedMeaning = [lexiconEntry objectForKey:workingWord];
    if (retrievedMeaning != nil)
    {
        // The simple solution: we've found an entry
        [[txtLexicon textStorage] appendAttributedString:[gkLexUtilities addAttributedText:retrievedMeaning offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:txtLexicon]];
    }
    else
    {
        // So, no immediate entry - try changing accented characters to second Unicode form
        isNoUse = true;
        alternativeWorkingWord = [[NSMutableString alloc] initWithString: workingWord];
        wordLength = [alternativeWorkingWord length];
        for (idx = 0; idx < wordLength; idx++)
        {
            sourceLetter = [alternativeWorkingWord substringToIndex:1];
            targetLetter = nil;
            targetLetter = [alternativeCharacters objectForKey:sourceLetter];
            if (targetLetter != nil)
            {
                [alternativeWorkingWord replaceOccurrencesOfString:sourceLetter withString:targetLetter options:NSLiteralSearch range:NSMakeRange(0, [alternativeWorkingWord length])];
                isModified = true;
            }
        }
        if (isModified)
        {
            retrievedMeaning = nil;
            retrievedMeaning = [lexiconEntry objectForKey:alternativeWorkingWord];
            if (retrievedMeaning != nil)
            {
                // Ah!  That worked
                [[txtLexicon textStorage] appendAttributedString:[gkLexUtilities addAttributedText:retrievedMeaning offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:txtLexicon]];
                isNoUse = false;
            }
        }
        if (isNoUse)
        {
            // We're now faced with fiddling around - first, see if we can find a flat text solution
            alternativeWorkingWord = [[NSMutableString alloc] initWithString:[greekProcessing reduceToBareGreek:workingWord withNonGkRemoved:true]];
            lexiconExtras = nil;
            lexiconExtras = [unaccentedLookup objectForKey:alternativeWorkingWord];
            if (lexiconExtras != nil)
            {
                // Good news!  We seem to have found the word
                setOfKeys = [[NSArray alloc] initWithArray:[lexiconExtras setOfKeys]];
                for (NSString *foundKeyWord in setOfKeys)
                {
                    retrievedMeaning = nil;
                    retrievedMeaning = [lexiconEntry objectForKey:foundKeyWord];
                    if (retrievedMeaning != nil)
                    {
                        [[txtLexicon textStorage] appendAttributedString:[gkLexUtilities addAttributedText:retrievedMeaning offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:txtLexicon]];
                    }
                }
            }
            else
            {
                if ([alternativeWorkingWord length] < 5)
                {
                    finalLetter = @"xxxx";
                }
                else
                {
                    finalLetter = [alternativeWorkingWord substringFromIndex:[alternativeWorkingWord length] - 4];
                }
                if ([finalLetter compare:@"ομαι"] == NSOrderedSame)
                {
                    alternativeWorkingWord = [[NSMutableString alloc] initWithFormat:@"%@ω", [alternativeWorkingWord substringToIndex:[alternativeWorkingWord length] - 4]];
                    lexiconExtras = nil;
                    lexiconExtras = [unaccentedLookup objectForKey:alternativeWorkingWord];
                    if (lexiconExtras != nil)
                    {
                        // Good news!  We seem to have found the word
                        setOfKeys = [lexiconExtras setOfKeys];
                        for (NSString *foundKeyWord in setOfKeys)
                        {
                            retrievedMeaning = nil;
                            retrievedMeaning = [lexiconEntry objectForKey:foundKeyWord];
                            if (retrievedMeaning != nil)
                            {
                                [[txtLexicon textStorage] appendAttributedString:[gkLexUtilities addAttributedText:retrievedMeaning offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:txtLexicon]];
                            }
                        }
                    }
                }
                else
                {
                    [[txtLexicon textStorage] appendAttributedString:[gkLexUtilities addAttributedText:@"Meaning not found" offsetCode:0 fontId:8 alignment:0 withAdjustmentFor:txtLexicon]];
                }
            }
        }
    }
}

- (NSString *) parseGrammar: (NSString *) codes1 withSecondCode: (NSString *) codes2
{
    bool isPtcpl = false;
    unichar currentCode, decodeChar;
    NSMutableString *outputText;

    if ((codes1 == nil) || (codes2 == nil)) return @"";
    currentCode = [codes1 characterAtIndex:0];
    outputText = [[NSMutableString alloc] initWithString: @""];
    switch (currentCode)
    {
        case 'V': // The word is a verb
            {
                outputText = [[NSMutableString alloc] initWithString: @"Verb: "];
                decodeChar = [codes2 characterAtIndex:2];
                if (decodeChar == 'P') isPtcpl = true;
                if (isPtcpl)
                {
                    decodeChar = [codes2 characterAtIndex:3];
                    switch (decodeChar)
                    {
                        case 'N': [outputText appendString: @"Nominative "]; break;
                        case 'V': [outputText appendString: @"Vocative "]; break;
                        case 'A': [outputText appendString: @"Accusative "]; break;
                        case 'G': [outputText appendString: @"Genitive "]; break;
                        case 'D': [outputText appendString: @"Dative "]; break;
                        default: break;
                    }
                }
                decodeChar = [codes2 characterAtIndex:3];
                switch (decodeChar)
                {
                    case '1': [outputText appendString: @"1st person "]; break;
                    case '2': [outputText appendString: @"2nd person "]; break;
                    case '3': [outputText appendString: @"3rd person "]; break;
                    default: // do nothing
                        break;
                }
                if ([codes2 length] > 4)
                {
                    decodeChar = [codes2 characterAtIndex:4];
                    switch (decodeChar)
                    {
                        case 'S': [outputText appendString: @"Singular "]; break;
                        case 'D': [outputText appendString: @"Dual"]; break;
                        case 'P': [outputText appendString: @"Plural "]; break;
                        default: break;
                    }
                }
                if ([codes2 length] > 5)
                {
                    decodeChar = [codes2 characterAtIndex:5];
                    switch (decodeChar)
                    {
                        case 'M': [outputText appendString: @"Masculine "]; break;
                        case 'F': [outputText appendString: @"Feminine "]; break;
                        case 'N': [outputText appendString: @"Neuter "]; break;
                        default: break;
                    }
                }
                decodeChar = [codes2 characterAtIndex:0];
                switch (decodeChar)
                {
                    case 'P': [outputText appendString: @"Present "]; break;
                    case 'I': [outputText appendString: @"Imperfect "]; break;
                    case 'F': [outputText appendString: @"Future "]; break;
                    case 'A': [outputText appendString: @"Aorist "]; break;
                    case 'X': [outputText appendString: @"Perfect "]; break;
                    case 'Y': [outputText appendString: @"Pluperfect "]; break;
                    default: break;
                }
                decodeChar = [codes2 characterAtIndex:1];
                switch (decodeChar)
                {
                    case 'A': [outputText appendString: @"Active "]; break;
                    case 'M': [outputText appendString: @"Middle "]; break;
                    case 'P': [outputText appendString: @"Passive "]; break;
                    case 'E': [outputText appendString: @"Middle or Passive "]; break;
                    case 'D': [outputText appendString: @"Middle deponent "]; break;
                    case 'O': [outputText appendString: @"Passive deponent "]; break;
                    case 'N': [outputText appendString: @"Middle or Passive deponent "]; break;
                    case 'Q': [outputText appendString: @"Impersonal active "]; break;
                    default: break;
                }
                decodeChar = [codes2 characterAtIndex:2];
                switch (decodeChar)
                {
                    case 'I': [outputText appendString: @"Indicative "]; break;
                    case 'S': [outputText appendString: @"Subjunctive "]; break;
                    case 'O': [outputText appendString: @"Optative "]; break;
                    case 'M': [outputText appendString: @"Imperative "]; break;
                    case 'D': [outputText appendString: @"Imperative "]; break;
                    case 'N': [outputText appendString: @"Infinitive "]; break;
                    case 'P': [outputText appendString: @"Participle "]; break;
                    case 'R': [outputText appendString: @"Imperative participle "]; break;
                    default: break;
                }
            }
            break;
        case 'N':
        case 'A':
            {
                if (currentCode == 'A')
                {
                    outputText = [[NSMutableString alloc] initWithString: @"Adjective: "];
                }
                else
                {
                    outputText = [[NSMutableString alloc] initWithString: @"Noun: "];
                }
                decodeChar = [codes2 characterAtIndex:0];
                switch (decodeChar)
                {
                    case 'N': [outputText appendString: @"Nominative "]; break;
                    case 'V': [outputText appendString: @"Vocative "]; break;
                    case 'A': [outputText appendString: @"Accusative "]; break;
                    case 'G': [outputText appendString: @"Genitive "]; break;
                    case 'D': [outputText appendString: @"Dative "]; break;
                    default: break;
                }
                decodeChar = [codes2 characterAtIndex:1];
                switch (decodeChar)
                {
                    case 'S': [outputText appendString: @"Singular "]; break;
                    case 'D': [outputText appendString: @"Dual "]; break;
                    case 'P': [outputText appendString: @"Plural "]; break;
                    default: break;
                }
                decodeChar = [codes2 characterAtIndex:2];
                switch (decodeChar)
                {
                    case 'M': [outputText appendString: @"Masculine "]; break;
                    case 'F': [outputText appendString: @"Feminine "]; break;
                    case 'N': [outputText appendString: @"Neuter "]; break;
                    default: break;
                }
                if ([codes2 length] > 3)
                {
                    decodeChar = [codes2 characterAtIndex:3];
                    switch (decodeChar)
                    {
                        case 'C': [outputText appendString: @"Comparative "]; break;
                        case 'S': [outputText appendString: @"Superlative "]; break;
                        default: break;
                    }
                }
            }
            break;
        case 'P': [outputText appendString: @"Preposition"]; break;
        case 'C': [outputText appendString: @"Conjunction"]; break;
        case 'D': [outputText appendString: @"Adverb"]; break;
        case 'X': [outputText appendString: @"Particle"]; break;
        case 'I': [outputText appendString: @"Interjection"]; break;
        case 'M': [outputText appendString: @"Indeclinable number"]; break;
        case 'R':
            {
                decodeChar = [codes2 characterAtIndex:0];
                switch (decodeChar)
                {
                    case 'N': [outputText appendString: @"Nominative "]; break;
                    case 'V': [outputText appendString: @"Vocative "]; break;
                    case 'A': [outputText appendString: @"Accusative "]; break;
                    case 'G': [outputText appendString: @"Genitive "]; break;
                    case 'D': [outputText appendString: @"Dative "]; break;
                    default: break;
                }
                decodeChar = [codes2 characterAtIndex:1];
                switch (decodeChar)
                {
                    case 'S': [outputText appendString: @"Singular "]; break;
                    case 'D': [outputText appendString: @"Dual "]; break;
                    case 'P': [outputText appendString: @"Plural "]; break;
                    default: break;
                }
                decodeChar = [codes2 characterAtIndex:2];
                switch (decodeChar)
                {
                    case 'M': [outputText appendString: @"Masculine "]; break;
                    case 'F': [outputText appendString: @"Feminine "]; break;
                    case 'N': [outputText appendString: @"Neuter "]; break;
                    default: break;
                }
                switch ([codes1 characterAtIndex:1])
                {
                    case 'A': [outputText appendString: @" Article "]; break;
                    case 'P': [outputText appendString: @" Personal Pronoun "]; break;
                    case 'I': [outputText appendString: @" Interrogative Pronoun "]; break;
                    case 'R': [outputText appendString: @" Relative Pronoun "]; break;
                    case 'D': [outputText appendString: @" Demonstrative Pronoun "]; break;
                    case 'X': [outputText appendString: @"ὅστις"]; break;
                    default: [outputText appendString: @" Unknown: "];
                              [outputText appendString: codes1];
                               break;
                }
            }
            break;
    }
    return outputText;
}

@end
