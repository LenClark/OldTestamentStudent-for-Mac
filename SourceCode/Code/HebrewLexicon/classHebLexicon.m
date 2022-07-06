/*================================================================================================================*
 *                                                                                                                *
 *                                            classHebLexicon                                                     *
 *                                            ===============                                                     *
 *                                                                                                                *
 *  This class will also handle some methods for processing words (in order to avoid creating yet another         *
 *    orthography class.                                                                                          *
 *                                                                                                                *
 *  Because the text can contain line feeds, we have resorted to using non-ASCII unicode values as field          *
 *    separators.                                                                                                 *
 *    1) There are 10022 separate lexical elements.  These were initially in individual text files but the load   *
 *       time for these files was far too long.  So, we have consolodated them into a single file, with each      *
 *       "virtual file" delineated by a "full width bar" (or "full width vertical line").                         *
 *    2) Each logical record of each virtual files is delineated by a "full width full stop", so we shall refer   *
 *       to them as "sentences".                                                                                  *
 *    3) Each item within a "sentence" is separated by a "full width comma" (but we haven't got a fancy name for  *
 *       these items.                                                                                             *
 *                                                                                                                *
 *  The logic and action of this method needs some explanation:                                                   *
 *                                                                                                                *
 *  Once we have broken a virtual file into "sentences" (stored in textByLine), we then split out the individual  *
 *    items, which will be in the array, bdbContent.  bdbContent[2] contains the controlling value, the keyCode.  *
 *                                                                                                                *
 *  The first sentence in each virtual file contains a list of related Strongs Numbers. These are handled in the  *
 *    loop that begins:                                                                                           *
 *          if( nCount == 0 )                                                                                     *
 *    The immediate effect of this part of the code is to store this list of Strongs Refs in the temporary        *
 *    dictionary, temporaryStrongNoStore.                                                                         *
 *                                                                                                                *
 *  Subsequent processing will loop through the rest of the "sentences", processing the details in the light of   *
 *    the keyCode.                                                                                                *
 *                                                                                                                *
 *  The first sentence (after the Strongs refs) should have a keyCode of either 1 (the Hebrew entry) or 2 (the    *
 *    Aramaic entry),  Anything else will be ignored until a keyCode of 1 or 2 has been encountered. The process  *
 *    for keyCode 1 or 2 will create an instance of classBDBEntry, which will be used by subsequent sentences. It *
 *    will also store the lexican word in a suitable instance of classWordToBDB (creating it, if need be), which  *
 *    allow all BDB entries for a given word form to be accessed.                                                 *
 *                                                                                                                *
 *  Once we have fully processed the entry, we return to the Strong References, stored temporarily in             *
 *    temporaryStrongNoStore.  We now access each related Strong reference in turn and store the address of the   *
 *    BDB entry in the relevant instance of classBDBForStrong (which we also create, if we need to).  The reason  *
 *    that this step was deferred to this point was because we needed to know the address of the BDB entry.       *
 *                                                                                                                *
 *  Created by Len Clark                                                                                          *
 *  May 2022                                                                                                      *
 *                                                                                                                *
 *================================================================================================================*/

#import "classHebLexicon.h"

@implementation classHebLexicon

@synthesize noOfMatchesReturned;
@synthesize bdbLexEntryList;
@synthesize listOfSearchResults;
@synthesize hebEntryList;
@synthesize strongToBDBList;
@synthesize lexLoop;
@synthesize lexProgress;

classGlobal *globalVarsHebLexicon;

- (id) init: (classGlobal *) inGlobal withLoop: (NSRunLoop *) inLoop forProgressForm: (frmProgress *) inProg
{
    if( self = [super init])
    {
        globalVarsHebLexicon = inGlobal;
        lexLoop = inLoop;
        lexProgress = inProg;
        bdbLexEntryList = [[NSMutableDictionary alloc] init];
        listOfSearchResults = [[NSMutableDictionary alloc] init];
        hebEntryList = [[NSMutableDictionary alloc] init];
        strongToBDBList = [[NSMutableDictionary alloc] init];
        noOfMatchesReturned = 0;
        [self loadLexiconData];
    }
    return self;
}

- (void) loadLexiconData
{
    /*====================================================================================================================*
     *                                                                                                                    *
     *                                                loadLexiconData                                                     *
     *                                                ===============                                                     *
     *                                                                                                                    *
     *  The source data is comprised of "lines" of data.  However, the lines are not formfeed terminated (or ended by any *
     *    recognised line ending) because the source data may contain any line-ending character(s).  As a result, each    *
     *    line has been terminated by a "full width bar" See the explanation at the head of this file and read it for a   *
     *    full explanation of the source data structure (and why).                                                        *
     *                                                                                                                    *
     *  You can inspect the source data by using a decent editor but                                                      *
     *    a) it will take some time to load 10022 files-worth of data                                                     *
     *    b) because Hebrew text is included in the data, it distorts the visual presentation of data                     *
     *                                                                                                                    *
     *  In the main "records" (all but the first [zeroth] one):                                                           *
     *                                                                                                                    *
     *     variable for  field No                      Meaning                                                            *
     *     ------------  --------                      -------                                                            *
     *    textStyleCode     0       Identifies whether the related text is regular, bold, italic or both                  *
     *    lineStyleCode     1       Identifies any offset of the text (i.e. whether superscript or subscript)             *
     *    workArea          2       Identifies the "keycode", which tells us what function the text has (if any)          *
     *    probableText      3       The relevant text (probable because some codes don't have associated text).           *
     *                                                                                                                    *
     *====================================================================================================================*/
    
    const unichar fullWidthComma = L'\uff0c', fullWidthFullStop = L'\uff0e', fullWidthBar = L'\uff5c';

    NSInteger fileIndex, fileCount, idx, nCount, noOfStrongNos, strongRef, strongTempCount = 0, keyCode, noOfEntries, textStyleCode, lineStyleCode, startChapter, endChapter, startVerse, endVerse, progressCount;
    NSString *fullBuffer, *workArea, *fileName, *virtualFile, *probableText, *strongRefString;
    NSArray *bdbContent, *textByLine, *files;
    NSMutableDictionary *temporaryStrongNoStore;
    classBDBEntry *currentEntry;
    classWordEntry *wordEntry;
    classStrongToBDBLookup *currentStrongToBDB;

    temporaryStrongNoStore = [[NSMutableDictionary alloc] init];
    progressCount = 0;
    fileName = [[NSBundle mainBundle] pathForResource:[globalVarsHebLexicon lexiconData] ofType:@"txt"];
    fullBuffer = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    // files: I've used this name because each main "record" was originally a separate file.  There are 10022 of them and this was too slow; hence this approach.
    files = [[NSArray alloc] initWithArray:[fullBuffer componentsSeparatedByString:[[NSString alloc] initWithFormat:@"%C", fullWidthBar]]];
    fileCount = [files count];
    for( fileIndex = 0; fileIndex < fileCount; fileIndex++)
    {
        virtualFile = [files objectAtIndex:fileIndex];
        // So, virtualFile is effectively each one of those originally independant files
        if( ++progressCount % 1000 == 0)
        {
            [lexProgress updateProgressMain:@"Loading lexicon data:" withSecondMsg: [[NSString alloc] initWithFormat: @"Processed %ld entries", progressCount]];
            [lexLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
        } 
        // textByLine: is an array of each "line" within the "file"
        textByLine = [virtualFile componentsSeparatedByString:[[NSString alloc] initWithFormat:@"%C", fullWidthFullStop]];
        nCount = 0;
        for (NSString *lineOfText in textByLine)
        {
            // lineOfText is the text of each line, inspected line by line
            if( [lineOfText length] == 0) continue;
            bdbContent = [[NSArray alloc] initWithArray:[lineOfText componentsSeparatedByString:[[NSString alloc] initWithFormat:@"%C", fullWidthComma]]];
            // We are nearing the data: bdbContent provides an array of "fields" for each line
            if( nCount == 0 )
            {
                // Strongs Numbers relating to the entry are stored in the first "Sentence" of the file
                noOfStrongNos = [bdbContent count];
                strongTempCount = 0;
                for( idx = 0; idx < noOfStrongNos; idx++)
                {
                    strongRef = [[bdbContent objectAtIndex:idx] integerValue];
                    // We'll use a temporary store so that the final form can be stored in a non-mutable dictionary
                    [temporaryStrongNoStore setObject:[globalVarsHebLexicon convertIntegerToString: strongRef] forKey:[globalVarsHebLexicon convertIntegerToString: strongTempCount++]];
                }
                nCount++;
            }
            else
            {
                // All "records" other than the first one
                if( [bdbContent count] > 3 )
                {
                    // This should be all records (but defensive programming ...
                    probableText = [[NSString alloc] initWithString:[bdbContent objectAtIndex:3]];
                    workArea = [[NSString alloc] initWithString:[bdbContent objectAtIndex:2]];
                    textStyleCode = [[[NSString alloc] initWithString:[bdbContent objectAtIndex:0]] integerValue];
                    lineStyleCode = [[[NSString alloc] initWithString:[bdbContent objectAtIndex:1]] integerValue];
                    keyCode = [workArea integerValue];
                    switch (keyCode)
                    {
                        case 1:
                            // The text is the entry, which is a Hebrew word
                            wordEntry = nil;
                            wordEntry = [hebEntryList objectForKey:probableText];
                            // Have we already encountered the word?
                            if( wordEntry == nil)
                            {
                                // No, we haven't
                                wordEntry = [[classWordEntry alloc] init];
                                [hebEntryList setObject:wordEntry forKey:probableText];
                            }
                            noOfEntries = [wordEntry noOfEntries];
                            // I don't understand this!  (Yes, I know: I wrote it!)
                            // Surely each entry of the word *will* have an entry, so why the check and what about multiple entries?
                            currentEntry = nil;
                            for( idx = 0; idx < noOfEntries; idx++)
                            {
                                currentEntry = [[wordEntry relatedBDBEntries] objectForKey:[[NSString alloc] initWithFormat:@"%ld", idx]];
                                if( currentEntry != nil) break;
                            }
                            if( currentEntry == nil)
                            {
                                currentEntry = [[classBDBEntry alloc] init];
                                [bdbLexEntryList setObject:currentEntry forKey:[[NSString alloc] initWithFormat:@"%ld", noOfEntries++]];
                            }
                            [currentEntry setSourceFileNo:progressCount];
                            [currentEntry setLanguageCode:1];
                            [currentEntry addANonRefDetail:probableText withTextStyleCode:textStyleCode LineStyleCode:lineStyleCode andKeyCode:1];
                            [currentEntry setStrongRefList:[[NSDictionary alloc] initWithDictionary:temporaryStrongNoStore]];
                            [currentEntry setNoOfStrongRefs:strongTempCount];
                            for( idx = 0; idx < strongTempCount; idx++)
                            {
                                strongRefString = [[NSString alloc] initWithString:[temporaryStrongNoStore objectForKey:[globalVarsHebLexicon convertIntegerToString:idx]]];
                                if( strongRefString == nil) continue;
                                currentStrongToBDB = nil;
                                currentStrongToBDB = [[globalVarsHebLexicon strongRefLookup] objectForKey:strongRefString];
                                if( currentStrongToBDB == nil)
                                {
                                    currentStrongToBDB = [[classStrongToBDBLookup alloc] init:globalVarsHebLexicon];
                                    [[globalVarsHebLexicon strongRefLookup] setObject:currentStrongToBDB forKey:strongRefString];
                                }
                                [currentStrongToBDB addBDBEntry:currentEntry];
                            }
                            [currentEntry setEntryWord:probableText];
                            break;
                        case 2:
                            // The text is the entry, which is an Aramaic word
                            wordEntry = nil;
                            wordEntry = [hebEntryList objectForKey:probableText];
                            if( wordEntry == nil)
                            {
                                wordEntry = [[classWordEntry alloc] init];
                                [hebEntryList setObject:wordEntry forKey:probableText];
                            }
                            noOfEntries = [wordEntry noOfEntries];
                            currentEntry = nil;
                            for( idx = 0; idx < noOfEntries; idx++)
                            {
                                currentEntry = [[wordEntry relatedBDBEntries] objectForKey:[[NSString alloc] initWithFormat:@"%ld", idx]];
                                if( currentEntry != nil) break;
                            }
                            if( currentEntry == nil)
                            {
                                currentEntry = [[classBDBEntry alloc] init];
                                [bdbLexEntryList setObject:currentEntry forKey:[[NSString alloc] initWithFormat:@"%ld", noOfEntries++]];
                            }
                            [currentEntry setSourceFileNo:progressCount];
                            [currentEntry setLanguageCode:2];
                            [currentEntry addANonRefDetail:probableText withTextStyleCode:textStyleCode LineStyleCode:lineStyleCode andKeyCode:2];
                            [currentEntry setStrongRefList:[[NSDictionary alloc] initWithDictionary:temporaryStrongNoStore]];
                            [currentEntry setNoOfStrongRefs:strongTempCount];
                            for( idx = 0; idx < strongTempCount; idx++)
                            {
                                strongRefString = [[NSString alloc] initWithString:[temporaryStrongNoStore objectForKey:[globalVarsHebLexicon convertIntegerToString:idx]]];
                                if( strongRefString == nil) continue;
                                currentStrongToBDB = nil;
                                currentStrongToBDB = [[globalVarsHebLexicon strongRefLookup] objectForKey:strongRefString];
                                if( currentStrongToBDB == nil)
                                {
                                    currentStrongToBDB = [[classStrongToBDBLookup alloc] init:globalVarsHebLexicon];
                                    [[globalVarsHebLexicon strongRefLookup] setObject:currentStrongToBDB forKey:strongRefString];
                                }
                                [currentStrongToBDB addBDBEntry:currentEntry];
                            }
                            [currentEntry setEntryWord:probableText];
                            break;
                        case 3:
                            // assumes a currentEntry has been created
                            if( currentEntry == nil) break;
                            startChapter = [[[NSString alloc] initWithString:[bdbContent objectAtIndex:4]] integerValue];
                            endChapter = [[[NSString alloc] initWithString:[bdbContent objectAtIndex:5]] integerValue];
                            startVerse = [[[NSString alloc] initWithString:[bdbContent objectAtIndex:6]] integerValue];
                            endVerse = [[[NSString alloc] initWithString:[bdbContent objectAtIndex:7]] integerValue];
                            [currentEntry addARefDetail:probableText withTextStyleCode:textStyleCode LineStyleCode:lineStyleCode andKeyCode:3 referenceBookName:probableText startChapter:startChapter endChapter:endChapter startVerse:startVerse endVerse:endVerse];
                            break;
                        case 0:
                        case 4:
                        case 5:
                        case 6:
                        case 7:
                        case 8:
                            // assumes a currentEntry has been created
                            [currentEntry addANonRefDetail:probableText withTextStyleCode:textStyleCode LineStyleCode:lineStyleCode andKeyCode:keyCode];
                            break;
                        default: break;
                    }
                }
            }
        }
        // Remember the temporary dictionary where we stored the Strong refs?  Now we have all the data, let's sort them out
        for( idx = 0; idx < strongTempCount; idx++)
        {
            workArea = nil;
            workArea = [temporaryStrongNoStore objectForKey:[[NSString alloc] initWithFormat:@"%ld", idx]];
 /*           if( workArea != nil)
            {
                strongRef = [workArea integerValue];
                currentBDBToStrong = nil;
                currentBDBToStrong = [strongToBDBList objectForKey:workArea];
                if( currentBDBToStrong == nil)
                {
                    currentBDBToStrong = [[classBDBForStrong alloc] init];
                    [strongToBDBList setObject:currentBDBToStrong forKey:[[NSString alloc] initWithFormat:@"%ld", strongRef]];
                }
                [currentBDBToStrong addEntry:currentEntry forWord:[currentEntry entryWord]];
            }  */
        }
    }
}

- (classBDBEntry *) getBDBEntryForStrongNo: (NSInteger) strongNo
{
    classBDBEntry *acquiredEntry;

    acquiredEntry = nil;
    acquiredEntry = [bdbLexEntryList objectForKey:[[NSString alloc] initWithFormat:@"%ld", strongNo]];
    return acquiredEntry;
}

- (NSString *) removeAccents: (NSString *) sourceWord
{
    /*========================================================================================*
     *                                                                                        *
     *                                     removeAccents                                      *
     *                                     =============                                      *
     *                                                                                        *
     *  Purpose: to remove all except                                                         *
     *           a) core Hebrew characters                                                    *
     *           b) vowel pointing                                                            *
     *           c) sin/shin points                                                           *
     *           d) dagesh (forte and line)                                                   *
     *                                                                                        *
     *  Parameter:                                                                            *
     *  =========                                                                             *
     *                                                                                        *
     *  sourceWord   may be a word, sentence or entire verse, so can includes spaces.         *
     *                                                                                        *
     *========================================================================================*/

    NSInteger idx, wordLength;
    NSMutableString *resultingWord;

    resultingWord = [[NSMutableString alloc] initWithString:@""];
    wordLength = [sourceWord length];
    for (idx = 0; idx < wordLength; idx++)
    {
        // Is the character a standard Hebrew consonant?
        if (((NSInteger)[sourceWord characterAtIndex:idx] >= 0x5d0) && ((NSInteger)[sourceWord characterAtIndex:idx] <= 0x5ea))
        {
            [resultingWord appendString: [sourceWord substringWithRange:NSMakeRange(idx, 1)]];
            continue;
        }
        // Is the character a vowel or acceptable pointing character?
        if (((NSInteger)[sourceWord characterAtIndex:idx] >= 0x5b0) && ((NSInteger)[sourceWord characterAtIndex:idx] <= 0x5bc))
        {
            [resultingWord appendString: [sourceWord substringWithRange:NSMakeRange(idx, 1)]];
            continue;
        }
        // Is the character a sin/shin dot, end of verse Sof Pasuq or mark dot ?
        if (((NSInteger)[sourceWord characterAtIndex: idx] >= 0x5c1) && ((NSInteger)[sourceWord characterAtIndex: idx] <= 0x5c5))
        {
            [resultingWord appendString: [sourceWord substringWithRange:NSMakeRange(idx, 1)]];
            continue;
        }
        // Is the character a mappeq?
        if ((NSInteger)[sourceWord characterAtIndex:idx] == 0x05be)
        {
            [resultingWord appendFormat:@"%C", 0x05be];
            continue;
        }
        // Is the character a low order ASCII character, including space and non-break space
        if (((NSInteger)[sourceWord characterAtIndex:idx] >= 0x0020) & ((NSInteger)[sourceWord characterAtIndex:idx] <= 0x00a0))
        {
            [resultingWord appendString: [sourceWord substringWithRange:NSMakeRange(idx, 1)]];
            continue;
        }
        // Is the character a carriage return?
        if ([sourceWord characterAtIndex:idx] == '\n')
        {
            [resultingWord appendString: @"\n"];
            continue;
        }
    }
    return resultingWord;
}

@end
