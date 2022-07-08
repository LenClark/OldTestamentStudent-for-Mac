//
//  classVocabTextView.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 18/01/2021.
//

#import "classVocabTextView.h"

@implementation classVocabTextView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void) mouseEntered:(NSEvent *)event
{
    AppDelegate *mainAppDelegate;
    
    mainAppDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [super mouseEntered:event];
    [mainAppDelegate locateCurrentTextView:6 forTextView:-1];
}

@end
