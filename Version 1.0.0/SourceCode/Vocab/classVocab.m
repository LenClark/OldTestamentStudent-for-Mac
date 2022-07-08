//
//  classVocab.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 18/01/2021.
//

#import "classVocab.h"

@implementation classVocab

classConfig *globalVarsVocab;

- (id) init: (classConfig *) inConfig
{
    if( self = [super init] )
    {
        globalVarsVocab = inConfig;
    }
    return self;
}


/*******************************************************************************
 *                                                                             *
 *                            doCreateVocabList                                *
 *                            =================                                *
 *                                                                             *
 *  Creates a new vocab list (in the final pane of the upper right area), as   *
 *    defined by the options selected in the final pane of the bottom right    *
 *    area.                                                                    *
 *                                                                             *
 *  checkedList (in AppDelegate = selectedVocabTypes):                         *
 *    Each vocab type represents a different part of speech.  So:              *
 *      Index       Part of Speech                                             *
 *        0           Noun                                                     *
 *        1           Verb                                                     *
 *        2           Adjective                                                *
 *        3           Adverb                                                   *
 *        4           Preposition                                              *
 *        5           All other pos (true idx = 5 to 12)                       *
 *    In each case, if selectedVocabTypes[x] = 1, that Pos has been selected;  *
 *    if 0, then it has been omitted.                                          *
 *                                                                             *
 *  listCode                                                                   *
 *    This indicates whether the whole chapter has been selected or merely the *
 *      current verse:                                                         *
 *        Index                Significance                                    *
 *          1         The verse only                                           *
 *          2         The whole chapter                                        *
 *                                                                             *
 *  displayCode                                                                *
 *    This is coded as follows:                                                *
 *        Code                 Significance                                    *
 *          1         Each grammatical type (Noun, verb, etc.) is listed       *
 *                       seperately but in alphabetical order in each type     *
 *          2         Each type is listed seperately but in order of use       *
 *          3         All words are provided in a single list but in           *
 *                       alphabetical order                                    *
 *          4         All words are in a single list and occur in order of use *
 *                                                                             *
 *******************************************************************************/

- (void) makeVocabList: (NSInteger) testamentId checkedPos: (NSArray *) checkedList listCode: (NSInteger) listCode displayCode: (NSInteger) displayCode typeCode: (NSInteger) typeCode
{
    BOOL isFirstCategory = true;
    NSInteger idx, bookId, chapId, VerseId, wordIdx, noOfWords, noOfVerses, checkIndex, checkValue, wordCount = 0, totalIdx = 0, newCount;
    unichar firstCharacter;
    NSNumber *idxEquivalent;
    NSString *catString, *textForDisplay, *accentlessText, *referenceText;
    NSMutableString *outputString;
    NSArray *categoryDesc = @[ @"Nouns", @"Verbs", @"Adjectives", @"Adverbs", @"Prepositions", @"Other types of words"];
    NSArray *sortedWord;
    NSMutableArray *wordsInCategory;
    NSDictionary *bookList;
    NSMutableDictionary *wordsInSequence, *noAccentWords, *categoryOfWords;
    classBook *currentBook;
    classChapter *currentChapter;
    classVerse *currentVerse;
    classWord *currentWord;

    wordsInSequence = [[NSMutableDictionary alloc] init];
    noAccentWords = [[NSMutableDictionary alloc] init];
    categoryOfWords = [[NSMutableDictionary alloc] init];
    if( testamentId == 1)
    {
        bookList = [globalVarsVocab ntListOfBooks];
        bookId = [[globalVarsVocab cbNtBook] indexOfSelectedItem];
        chapId = [[globalVarsVocab cbNtChapter] indexOfSelectedItem];
        VerseId = [[globalVarsVocab cbNtVerse] indexOfSelectedItem];
    }
    else
    {
        bookList = [globalVarsVocab lxxListOfBooks];
        bookId = [[globalVarsVocab cbLxxBook] indexOfSelectedItem];
        chapId = [[globalVarsVocab cbLxxChapter] indexOfSelectedItem];
        VerseId = [[globalVarsVocab cbLxxVerse] indexOfSelectedItem];
    }
    currentBook = [bookList objectForKey:[[NSString alloc] initWithFormat:@"%li", bookId]];
    currentChapter = [currentBook getChapterBySeqNo:chapId];
    currentVerse = [currentChapter getVerseBySeqNo:VerseId];
    referenceText = @"";
    if( listCode == 1)   // Only the verse
    {
        referenceText = [[NSString alloc] initWithFormat:@"%@ %@:%@", [currentBook bookName], [currentBook getChapterIdBySeqNo:chapId], [currentChapter getVerseIdBySeqNo:VerseId]];
        noOfWords = [currentVerse wordCount];
        for( wordIdx = 0; wordIdx < noOfWords; wordIdx++ )
        {
            currentWord = [currentVerse getwordBySeqNo:wordIdx];
            catString = [[NSString alloc] initWithString:[currentWord catString]];
            if( ( catString == nil ) || ( [catString length] == 0 ) ) continue;
            firstCharacter = [catString characterAtIndex:0];
            switch (firstCharacter)
            {
                case 'N': checkIndex = 1; break;
                case 'V': checkIndex = 2; break;
                case 'A': checkIndex = 3; break;
                case 'D': checkIndex = 4; break;
                case 'P': checkIndex = 5; break;
                default: checkIndex = 6; break;
            }
            checkValue = [[checkedList objectAtIndex:checkIndex - 1] integerValue];
            if( checkValue == 1)
            {
                textForDisplay = [self populateStore:typeCode forWordInstance:currentWord accentCode:1];
                accentlessText = [self populateStore:typeCode forWordInstance:currentWord accentCode:2];
                if( ! [self doesDictionary:noAccentWords ContainString:accentlessText])
                {
                    idxEquivalent = [NSNumber numberWithInteger:totalIdx];
                    [noAccentWords setObject:accentlessText forKey:idxEquivalent];
                    [wordsInSequence setObject:textForDisplay forKey:idxEquivalent];
                    [categoryOfWords setObject:[NSNumber numberWithInteger:checkIndex] forKey:idxEquivalent];
                    totalIdx++;
                }
            }
        }
    }
    else  // The whole chapter
    {
        referenceText = [[NSString alloc] initWithFormat:@"%@ %@", [currentBook bookName], [currentBook getChapterIdBySeqNo:chapId]];
        noOfVerses = [currentChapter noOfVersesInChapter];
        for( VerseId = 0; VerseId < noOfVerses; VerseId++)
        {
            currentVerse = [currentChapter getVerseBySeqNo:VerseId];
            noOfWords = [currentVerse wordCount];
            for( wordIdx = 0; wordIdx < noOfWords; wordIdx++)
            {
                currentWord = [currentVerse getwordBySeqNo:wordIdx];
                catString = [[NSString alloc] initWithString:[currentWord catString]];
                if( ( catString == nil ) || ( [catString length] == 0 ) ) continue;
                firstCharacter = [catString characterAtIndex:0];
                switch (firstCharacter)
                {
                    case 'N': checkIndex = 1; break;
                    case 'V': checkIndex = 2; break;
                    case 'A': checkIndex = 3; break;
                    case 'D': checkIndex = 4; break;
                    case 'P': checkIndex = 5; break;
                    default: checkIndex = 6; break;
                }
                checkValue = [[checkedList objectAtIndex:checkIndex - 1] integerValue];
                if( checkValue == 1)
                {
                    textForDisplay = [self populateStore:typeCode forWordInstance:currentWord accentCode:1];
                    accentlessText = [self populateStore:typeCode forWordInstance:currentWord accentCode:2];
                    if( ! [self doesDictionary:noAccentWords ContainString:accentlessText])
                    {
                        idxEquivalent = [NSNumber numberWithInteger:totalIdx];
                        [noAccentWords setObject:accentlessText forKey:idxEquivalent];
                        [wordsInSequence setObject:textForDisplay forKey:idxEquivalent];
                        [categoryOfWords setObject:[NSNumber numberWithInteger:checkIndex] forKey:idxEquivalent];
                        totalIdx++;
                    }
                }
            }
        }
    }
    wordCount = totalIdx;
    // So, by the time we get here, wordsInSequence contains all the words to be displayed.
    outputString = [[NSMutableString alloc] initWithFormat:@"%@\n\n",referenceText];
    if( ( displayCode == 1 ) || ( displayCode == 3 ) )
    {
        // We have to sort the words.
        if( displayCode == 1)
        {
            // ... and do it by category
            for( idx = 1; idx <= 6; idx++)
            {
                newCount = 0;
                wordsInCategory = [[NSMutableArray alloc] init];
                for( totalIdx = 0; totalIdx < wordCount; totalIdx++)
                {
                    if( [[categoryOfWords objectForKey:[NSNumber numberWithInteger:totalIdx]] integerValue] == idx )
                    {
                        [wordsInCategory addObject:[wordsInSequence objectForKey:[NSNumber numberWithInteger: totalIdx]]];
                    }
                }
                // We now have the array of words in the specific category
                sortedWord = [[NSArray alloc] initWithArray:[wordsInCategory sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
                if( [[checkedList objectAtIndex: idx - 1] integerValue] == 1 )
                {
                    if( isFirstCategory)
                    {
                        [outputString appendString:[categoryDesc objectAtIndex:idx - 1]];
                        isFirstCategory = false;
                    }
                    else [outputString appendFormat:@"\n%@",[categoryDesc objectAtIndex:idx - 1]];
                    for (NSString *oneWord in sortedWord)
                    {
                        [outputString appendString:[[NSString alloc] initWithFormat:@"\n\t%@", oneWord]];
                    }
                }
            }
        }
        else
        {
            sortedWord = [[NSArray alloc] initWithArray:[[wordsInSequence allValues] sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
            for (NSString *oneWord in sortedWord)
            {
                [outputString appendString:[[NSString alloc] initWithFormat:@"\n\t%@", oneWord]];
            }
        }
    }
    else
    {
        if( displayCode == 2)
        {
            for( idx = 1; idx <= 6; idx++)
            {
                newCount = 0;
                wordsInCategory = [[NSMutableArray alloc] init];
                for( totalIdx = 0; totalIdx < wordCount; totalIdx++)
                {
                    if( [[categoryOfWords objectForKey:[NSNumber numberWithInteger:totalIdx]] integerValue] == idx )
                    {
                        [wordsInCategory addObject:[wordsInSequence objectForKey:[NSNumber numberWithInteger: totalIdx]]];
                    }
                }
                // We now have the array of words in the specific category
                if( [[checkedList objectAtIndex: idx - 1] integerValue] == 1 )
                {
                    if( isFirstCategory)
                    {
                        [outputString appendString:[categoryDesc objectAtIndex:idx - 1]];
                        isFirstCategory = false;
                    }
                    else [outputString appendFormat:@"\n%@",[categoryDesc objectAtIndex:idx - 1]];
                    for (NSString *oneWord in wordsInCategory)
                    {
                        [outputString appendString:[[NSString alloc] initWithFormat:@"\n\t%@", oneWord]];
                    }
                }
            }
        }
        else
        {
            
            for (NSString *oneWord in [wordsInSequence allValues])
            {
                [outputString appendString:[[NSString alloc] initWithFormat:@"\n\t%@", oneWord]];
            }
        }
    }
    [[globalVarsVocab vocabTextView] setString:outputString];
}

/***********************************************************************************
 *                                                                                 *
 *                              populateStore                                      *
 *                              =============                                      *
 *                                                                                 *
 *  Works out either:                                                              *
 *    a) what word will be returned for display, or                                *
 *    b) what word will be returned for comparison (i.e. accentless form)          *
 *                                                                                 *
 *  Parameters:                                                                    *
 *    typeCode     Determines what will be returned:                               *
 *                     Code                  Meaning                               *
 *                       1      Word as displayed in text                          *
 *                       2      Root word                                          *
 *                       3      Root plus word as displayed                        *
 *    currentWord  Simply the class instance, from which to acquire the word       *
 *    accentCode   To determine whether to return 1 with or without accents        *
 *                     Code                  Meaning                               *
 *                       1      Word with accent                                   *
 *                       2      Word without accent                                *
 *                                                                                 *
 *  The final parameter is because words vary in accents within a verse (and       *
 *    chapter).  If we want to avoid repititions, we have to compare *without*     *
 *    accents.  (It only really applies to typeCode = 1 or 3.)                     *
 *    So, if accentCode = 2, always perform typeCode = 1                           *
 *                                                                                 *
 ***********************************************************************************/

- (NSString *) populateStore: (NSInteger) typeCode forWordInstance: (classWord *) currentWord accentCode: (NSInteger) accentCode
{
    NSInteger idx, lengthOfRoot, newTypeCode;
    NSMutableString *wordToDisplay;
    
    newTypeCode = typeCode;
    if( accentCode == 2) newTypeCode = 1;
    switch (newTypeCode)
    {
        case 1:
            if( accentCode == 1) wordToDisplay = [[NSMutableString alloc] initWithString:[currentWord textWord]];
            else wordToDisplay = [[NSMutableString alloc] initWithString:[currentWord accentlessTextWord]];
            break;
        case 2: wordToDisplay = [[NSMutableString alloc] initWithString:[currentWord rootWord]]; break;
        case 3:
            wordToDisplay = [[NSMutableString alloc] initWithString:[currentWord rootWord]];
            lengthOfRoot = 20 - [wordToDisplay length];
            if( lengthOfRoot > 0 )
            {
                for( idx = 0; idx < lengthOfRoot; idx++) [wordToDisplay appendString:@" "];
            }
            else [wordToDisplay appendString:@" "];
            [wordToDisplay appendString:[currentWord textWord]];
            break;
        default:
            break;
    }
    return [wordToDisplay copy];
}

- (BOOL) doesDictionary: (NSMutableDictionary *) sourceDictionary ContainString: (NSString *) targetWord
{
    NSString *comparedWord;
    
    for (NSNumber *key in sourceDictionary)
    {
        comparedWord = [[NSString alloc] initWithString:[sourceDictionary objectForKey:key]];
        if( [comparedWord compare:targetWord] == NSOrderedSame ) return true;
    }
    return false;
}

@end
