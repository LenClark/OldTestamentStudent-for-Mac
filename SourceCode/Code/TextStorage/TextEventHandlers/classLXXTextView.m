//
//  classLXXTextView.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 25/05/2022.
//

#import "classLXXTextView.h"

@implementation classLXXTextView

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
     *  This method is called by classNtTextView and classLxxTextView and communicates back        *
     *    information about a mouse click.                                                         *
     *                                                                                             *
     *  Parameters:                                                                                *
     *  ----------                                                                                 *
     *                                                                                             *
     *  initial parameter     The absolute cursor position within the whole text page              *
     *  verseRef              The string verse "number", picked up from the text (zero-length      *
     *                          if not NT or LXX)                                                  *
     *  lineRange             The NSRange defining the line for the verse only                     *
     *  revisedCursorPosition (revCsrPstn) The cursor position in the line (as opposed to the      *
     *                                     entire text                                             *
     *  mouseButton           Which mouse button has been pressed:                                 *
     *                          0 = no information available                                       *
     *                          1 = left                                                           *
     *                          2 = right                                                          *
     *                          3 = any other button                                               *
     *  clickCount            How many times the button was clicked (0, if of no interest).        *
     *                                                                                             *
     ***********************************************************************************************/

    NSInteger cursorPosition, lineCsrPstn, mouseButton = 0, clickCount, nPstn, wordLength, idx, noOfGroups, bookId;
    NSString *pageContent, *targetLine, *verseString, *chapterRef;
    NSArray *wordGroups;
    NSPoint mDownPos, localPoint;
    NSRange cursorRange, lineRange;
    NSTextView *sourceView;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter;
    classLXXVerse *currentVerse;
    classLXXWord *currentWord;
    AppDelegate *mainAppDelegate;
    classGlobal *globalVarsLXXHandler;
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
    globalVarsLXXHandler = [mainAppDelegate globalVars];
    mDownPos = [event locationInWindow];
    sourceView = [globalVarsLXXHandler txtLXXText];
    localPoint = [sourceView convertPoint:mDownPos fromView:nil];
    cursorPosition = [sourceView characterIndexForInsertionAtPoint:localPoint];
    // Get the text for the chapter
    pageContent = [[NSString alloc] initWithString:[sourceView string]];
    cursorRange = NSMakeRange(cursorPosition, 0);
    // Get the range of the line in which the cursor resides
    lineRange = [pageContent lineRangeForRange:cursorRange];
    // Get the line itself
    targetLine = [pageContent substringWithRange:lineRange];
    lineCsrPstn = cursorPosition - lineRange.location;
    [globalVarsLXXHandler setLatestLXXCursorPosition:cursorPosition];
    [globalVarsLXXHandler setLatestLXXLineRange:lineRange];
    [globalVarsLXXHandler setLxxVerseIsolate:targetLine];
    [globalVarsLXXHandler setLxxVerseReferenceNo:verseString];
    [globalVarsLXXHandler setLatestRevisedLXXCursorPosition:lineCsrPstn];
    // And finally, the verse itself
    cbVerse = [globalVarsLXXHandler cbLXXVerse];
    verseString = [[NSString alloc] initWithString:[self getVerseNumberOfLine:targetLine]];
    [cbVerse selectItemWithObjectValue:verseString];

    wordGroups = [targetLine componentsSeparatedByString:[[NSString alloc] initWithFormat:@"%c", ' ']];
    // The first object will be the verse number; all objects after that are sequential words;
    noOfGroups = [wordGroups count];
    nPstn = 0;
    for( idx = 0; idx < noOfGroups; idx++)
    {
        wordLength = [[wordGroups objectAtIndex:idx] length];
        if( wordLength == 0) continue;
        nPstn += wordLength;
        if( lineCsrPstn <= nPstn)
        {
            if( idx == 0 )
            {
                alert = [[classAlert alloc] init];
                [alert messageBox:@"You have clicked on a verse number, which can't be used." title:@"Selection error" boxStyle:NSAlertStyleCritical];
                return;
            }
            else
            {
                // We have found the word
                cbBook = [globalVarsLXXHandler cbLXXBook];
                cbChapter = [globalVarsLXXHandler cbLXXChapter];
                bookId = [cbBook indexOfSelectedItem];
                currentBook = [[globalVarsLXXHandler lxxBookList] objectForKey:[globalVarsLXXHandler convertIntegerToString: bookId]];
                chapterRef = [cbChapter itemObjectValueAtIndex: [cbChapter indexOfSelectedItem]];
                currentChapter = [currentBook getChapterByChapterNo:chapterRef];
                currentVerse = [currentChapter getVerseByVerseNo:verseString];
                currentWord = [currentVerse getWord:idx - 2];
                [globalVarsLXXHandler setLatestSelectedLXXWord:[currentWord textWord]];
                [globalVarsLXXHandler setSequenceOfLatestLXXWord:idx - 2];
                break;
            }
        }
        nPstn++;
    }
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
