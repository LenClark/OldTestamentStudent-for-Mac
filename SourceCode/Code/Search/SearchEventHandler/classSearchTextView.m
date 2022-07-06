//
//  classSearchTextView.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 08/06/2022.
//

#import "classSearchTextView.h"

@implementation classSearchTextView

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

    NSInteger cursorPosition, lineCsrPstn, mouseButton = 0, clickCount;
    NSString *pageContent, *targetLine, *verseString;
    NSPoint mDownPos, localPoint;
    NSRange cursorRange, lineRange;
    NSTextView *sourceView;
    AppDelegate *mainAppDelegate;
    classGlobal *globalVarsSearchHandler;
    
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
    globalVarsSearchHandler = [mainAppDelegate globalVars];
    mDownPos = [event locationInWindow];
    sourceView = [globalVarsSearchHandler txtSearchResults];
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
    [globalVarsSearchHandler setLatestSearchCursorPosition:cursorPosition];
    [globalVarsSearchHandler setLatestSearchLineRange:lineRange];
    [globalVarsSearchHandler setSearchVerseIsolate:targetLine];
    [globalVarsSearchHandler setSearchVerseReferenceNo:verseString];
    [globalVarsSearchHandler setLatestRevisedSearchCursorPstn:lineCsrPstn];
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
