//
//  classParseTextView.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 18/01/2021.
//

#import "classParseTextView.h"

@implementation classParseTextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void) mouseEntered:(NSEvent *)event
{
    AppDelegate *mainAppDelegate;
    
    mainAppDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [super mouseEntered:event];
    [mainAppDelegate locateCurrentTextView:3 forTextView:-1];
}
@end
