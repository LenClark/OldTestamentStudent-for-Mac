//
//  classSearchTextView.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 18/01/2021.
//

#import "classSearchTextView.h"

@implementation classSearchTextView

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

- (void) mouseDown:(NSEvent *)event
{
    NSInteger cursorPosition, lineCsrPstn;
    NSString *pageContent, *targetLine;
    NSPoint mDownPos, localPoint;
    NSRange cursorRange, lineRange;
    NSTextView *sourceView;
    AppDelegate *mainAppDelegate;
  
    // Before we start get the verse before change
    mainAppDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    sourceView = [mainAppDelegate searchTextView];
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
    lineCsrPstn = cursorPosition - lineRange.location;
    [mainAppDelegate mouseDownCursorRecord:cursorPosition targetCode:5 inVerse:@"" containingLineRange:lineRange withRevisedCursorPosition:lineCsrPstn
                          whichMouseButton:0 howManyClicks:0];
    [super mouseDown:event];
    [mainAppDelegate locateCurrentTextView:5 forTextView:-1];
}

@end
