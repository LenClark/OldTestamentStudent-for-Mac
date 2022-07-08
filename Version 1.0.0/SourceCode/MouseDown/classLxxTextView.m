//
//  classLxxTextView.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 10/01/2021.
//

#import "classLxxTextView.h"

@implementation classLxxTextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void) mouseEntered:(NSEvent *)event
{
    AppDelegate *mainAppDelegate;
    
    mainAppDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [super mouseEntered:event];
}

- (void) rightMouseDown:(NSEvent *)event
{
    [self mouseDown:event];
    [super rightMouseDown:event];
}

-(void) otherMouseDown:(NSEvent *)event
{
    [self mouseDown:event];
    [super otherMouseDown:event];
}

- (void) mouseDown:(NSEvent *)event
{
    NSInteger cursorPosition, lineCsrPstn, mouseButton = 0, clickCount;
    NSString *pageContent, *targetLine, *verseString;
    NSPoint mDownPos, localPoint;
    NSRange cursorRange, lineRange;
    NSTextView *sourceView;
    AppDelegate *mainAppDelegate;

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
    sourceView = [mainAppDelegate lxxTextView];
    mDownPos = [event locationInWindow];
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
    [mainAppDelegate locateCurrentTextView:2 forTextView:2];
    [mainAppDelegate mouseDownCursorRecord:cursorPosition targetCode:2 inVerse:verseString containingLineRange:lineRange withRevisedCursorPosition:lineCsrPstn
                          whichMouseButton:mouseButton howManyClicks:clickCount];
    if( mouseButton > 1 ) return;
    [super mouseDown:event];
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
