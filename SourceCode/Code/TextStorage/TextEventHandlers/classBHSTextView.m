//
//  classBHSTextView.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 25/05/2022.
//

#import "classBHSTextView.h"

@implementation classBHSTextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void) mouseDown:(NSEvent *)event
{
    [self allMouseDown:event];
    [super mouseDown:event];
}
\
- (void) rightMouseDown:(NSEvent *)event
{
    [self allMouseDown:event];
    [super rightMouseDown:event];
}

- (void) otherMouseDown:(NSEvent *)event
{
    [self allMouseDown:event];
    [super otherMouseDown:event];
}

- (void) allMouseDown: (NSEvent *)event
{
    /*=============================================================================================*
     *                                                                                             *
     *                                 mouseDownCursorRecord                                       *
     *                                 =====================                                       *
     *                                                                                             *
     *  This method will generate and store the following values in the global class instance:     *
     *                                                                                             *
     *  Method Variable    Global Name                            Function                         *
     *  ===============    ===========                            ========                         *
     *                                                                                             *
     *  cursorPosition     latestBHSCursorPosition   The actual cursor position in the full text.  *
     *  lineRange          latestBHSLineRange        The NSRange of the line of text in which the  *
     *                                                cursor occurs.                               *
     *  targetLine         bhsVerseIsolate           A copy of the line identified by lineRange    *
     *  verseString        bhsVerseReferenceNo       The verse number in string form.  This is the *
     *                                                equivalent of the Verse Ref (not a sequence) *
     *  lineCsrPstn        latestRevisedBHSCursorPosition                                          *
     *                                              The cursor position converted (by calculation) *
     *                                                to its position in the targetLine.           *
     *                                                                                             *
     *                                                                                             *
     *                                                                                             *
     *                                                                                             *
     *  Note the structure of the line:                                                            *
     *                                                                                             *
     *  <Verse no>:  <zeroWidthSpace><Word>[<zeroNonJoiner><affix>[ ]                              *
     *                      ^                                      |                               *
     *                      |           [repeat]                   v                               *
     *                       - - - - - - - - - - - - - - - - - - - -                               *
     *                                                                                             *
     *                                                                                             *
     *  targetLine (revCsrPstn) The cursor position in the line (as opposed to the                 *
     *                                     entire text                                             *
     *  mouseButton           Which mouse button has been pressed:                                 *
     *                          0 = no information available                                       *
     *                          1 = left                                                           *
     *                          2 = right                                                          *
     *                          3 = any other button                                               *
     *  clickCount            How many times the button was clicked (0, if of no interest).        *
     *                                                                                             *
     ***********************************************************************************************/

    const unichar zWSpace = 0x200b, zWNonJoiner = 0x200d;

    NSInteger cursorPosition, lineCsrPstn, mouseButton = 0, clickCount, seqCount, nPstn, altCsr, idx, noOfGroups, bookId, chapterSeq, verseSeq;
    NSString *pageContent, *targetLine, *verseString, *baseVerse, *candidateWord, *tempChar;
    NSArray *wordGroups;
    NSPoint mDownPos, localPoint;
    NSRange cursorRange, lineRange;
    NSTextView *sourceView;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    AppDelegate *mainAppDelegate;
    classGlobal *globalVarsBHSHandler;
    classBHSBook *currentBook;
    classBHSChapter *currentChapter;
    classBHSVerse *currentVerse;
    classBHSWord *currentWord;
    classAlert *alert;
    
    // First, get basic event information
    switch ([event type])
    {
        case NSEventTypeLeftMouseDown: mouseButton = 1; break;
        case NSEventTypeRightMouseDown: mouseButton = 2; break;
        case NSEventTypeOtherMouseDown: mouseButton = 3; break;
        default: break;
    }
    clickCount = [event clickCount];
    // Before we start get the verse before change
    mainAppDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    globalVarsBHSHandler = [mainAppDelegate globalVars];
    mDownPos = [event locationInWindow];
    sourceView = [globalVarsBHSHandler txtBHSText];
    localPoint = [sourceView convertPoint:mDownPos fromView:nil];
    cursorPosition = [sourceView characterIndexForInsertionAtPoint:localPoint];
    // Get the text for the chapter
    pageContent = [[NSString alloc] initWithString:[sourceView string]];
    cursorRange = NSMakeRange(cursorPosition, 0);
    // Get the range of the line in which the cursor resides
    lineRange = [pageContent lineRangeForRange:cursorRange];
    // Get the line itself
    targetLine = [pageContent substringWithRange:lineRange];
    // And finally, the verse itself
    verseString = [[NSString alloc] initWithString:[self getVerseNumberOfLine:targetLine]];
    lineCsrPstn = cursorPosition - lineRange.location;
    [globalVarsBHSHandler setLatestBHSCursorPosition:cursorPosition];
    [globalVarsBHSHandler setLatestBHSLineRange:lineRange];
    [globalVarsBHSHandler setBhsVerseIsolate:targetLine];
    [globalVarsBHSHandler setBhsVerseReferenceNo:verseString];
    [globalVarsBHSHandler setLatestRevisedBHSCursorPosition:lineCsrPstn];
    cbBook = [globalVarsBHSHandler cbBHSBook];
    bookId = [cbBook indexOfSelectedItem];
    currentBook = [[globalVarsBHSHandler bhsBookList] objectForKey:[globalVarsBHSHandler convertIntegerToString:bookId]];
    cbChapter = [globalVarsBHSHandler cbBHSChapter];
    chapterSeq = [cbChapter indexOfSelectedItem];
    currentChapter = [currentBook getChapterBySequence:chapterSeq];
    cbVerse = [globalVarsBHSHandler cbBHSVerse];
    [cbVerse selectItemWithObjectValue:verseString];
    verseSeq = [cbVerse indexOfSelectedItem];
    currentVerse = [currentChapter getVerseBySequence:verseSeq];

    //Now find the specific word on which the user has clicked
    // We will work from the recovered verse (targetLine) and the slightly more dangerous, calculated
    //   cursor position in the line (lineCsrPstn) becasue we want the sequence of the word as well as
    //   the word itself.
    seqCount = 0;
    nPstn = [targetLine rangeOfString:@":"].location;
    if( lineCsrPstn <= nPstn)
    {
        alert = [[classAlert alloc] init];
        [alert messageBox:@"You have clicked on a verse number, which can't be used." title:@"Selection error" boxStyle:NSAlertStyleCritical];
        return;
    }
    baseVerse = [[NSString alloc] initWithString:[[targetLine substringFromIndex:nPstn + 1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    altCsr = lineCsrPstn - nPstn;
    nPstn = 0;
    while ([baseVerse characterAtIndex:nPstn] == ' ') nPstn++;
    if( nPstn > 0)
    {
        baseVerse = [[NSString alloc] initWithString:[[targetLine substringFromIndex:nPstn + 1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        altCsr -= nPstn;
        nPstn = 0;
    }
    if( [baseVerse characterAtIndex:0] == zWSpace)
    {
        baseVerse = [[NSString alloc] initWithString:[baseVerse substringFromIndex:1]];
        altCsr--;
    }
    if( nPstn < 0) nPstn = 0;
    wordGroups = [baseVerse componentsSeparatedByString:[[NSString alloc] initWithFormat:@"%C", zWSpace]];
    noOfGroups = [wordGroups count];
    for( idx = 0; idx < noOfGroups; idx++)
    {
        candidateWord = [[NSString alloc] initWithString:[wordGroups objectAtIndex:idx]];
        if( altCsr <= [candidateWord length] + 1)
        {
            tempChar = [[NSString alloc] initWithFormat:@"%C", zWNonJoiner];
            if( [candidateWord containsString:tempChar])
            {
                nPstn = [candidateWord rangeOfString:tempChar].location;
                if( nPstn != NSNotFound) candidateWord = [[NSString alloc] initWithString:[candidateWord substringToIndex:nPstn]];
            }
            [globalVarsBHSHandler setLatestSelectedBHSWord:candidateWord];
            [globalVarsBHSHandler setSequenceOfLatestBHSWord:idx];
            break;
        }
        altCsr -= [candidateWord length] + 1;
    }
    currentWord = [currentVerse getWord:[globalVarsBHSHandler sequenceOfLatestBHSWord]];
    if( currentWord != nil)
    {
        if( [currentWord hasVariant] ) [[mainAppDelegate mnuKethibQere] setHidden:false];
        else [[mainAppDelegate mnuKethibQere] setHidden:true];
    }
    else [[mainAppDelegate mnuKethibQere] setHidden:true];
}

- (NSString *) getVerseNumberOfLine: (NSString *) sourceLine
{
    NSString *verseString;
    NSRange colonLocation, verseRange;
    
    colonLocation = [sourceLine rangeOfString:@":"];
    if( colonLocation.location == NSNotFound) return @"";
    verseRange = NSMakeRange(0, colonLocation.location);
    verseString = [[NSString alloc] initWithString:[[sourceLine substringWithRange:verseRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return verseString;
}

@end
