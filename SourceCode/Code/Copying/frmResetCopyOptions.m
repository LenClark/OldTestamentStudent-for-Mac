//
//  frmResetCopyOptions.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 18/06/2022.
//

#import "frmResetCopyOptions.h"

@interface frmResetCopyOptions ()

@end

@implementation frmResetCopyOptions

@synthesize cbBHSWord;
@synthesize cbBHSVerse;
@synthesize cbBHSChapter;
@synthesize cbBHSSelection;
@synthesize cbLXXWord;
@synthesize cbLXXVerse;
@synthesize cbLXXChapter;
@synthesize cbLXXSelection;

classGlobal *globalVarsResetCopy;
AppDelegate *appDelegate;

- (void)windowDidLoad {
    [super windowDidLoad];
    appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

    globalVarsResetCopy = [appDelegate globalVars];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:0 forTextType:0] == 0 )[cbBHSWord setState:NSControlStateValueOn]; else [cbBHSWord setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:1 forTextType:0] == 0 )[cbBHSVerse setState:NSControlStateValueOn]; else [cbBHSVerse setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:2 forTextType:0] == 0 )[cbBHSChapter setState:NSControlStateValueOn]; else [cbBHSChapter setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:3 forTextType:0] == 0 )[cbBHSSelection setState:NSControlStateValueOn]; else [cbBHSSelection setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:0 forTextType:1] == 0 )[cbLXXWord setState:NSControlStateValueOn]; else [cbLXXWord setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:1 forTextType:1] == 0 )[cbLXXVerse setState:NSControlStateValueOn]; else [cbLXXVerse setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:2 forTextType:1] == 0 )[cbLXXChapter setState:NSControlStateValueOn]; else [cbLXXChapter setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:3 forTextType:1] == 0 )[cbLXXSelection setState:NSControlStateValueOn]; else [cbLXXSelection setState:NSControlStateValueOff];
}

- (void) setup: (classGlobal *) inGlobal
{
/*    globalVarsResetCopy = inGlobal;
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:0 forTextType:0] == 0 )[cbBHSWord setState:NSControlStateValueOn]; else [cbBHSWord setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:1 forTextType:0] == 0 )[cbBHSVerse setState:NSControlStateValueOn]; else [cbBHSVerse setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:2 forTextType:0] == 0 )[cbBHSChapter setState:NSControlStateValueOn]; else [cbBHSChapter setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:3 forTextType:0] == 0 )[cbBHSSelection setState:NSControlStateValueOn]; else [cbBHSSelection setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:0 forTextType:1] == 0 )[cbLXXWord setState:NSControlStateValueOn]; else [cbLXXWord setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:1 forTextType:1] == 0 )[cbLXXVerse setState:NSControlStateValueOn]; else [cbLXXVerse setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:2 forTextType:1] == 0 )[cbLXXChapter setState:NSControlStateValueOn]; else [cbLXXChapter setState:NSControlStateValueOff];
    if( [globalVarsResetCopy getCopyOption:3 forCopyType:3 forTextType:1] == 0 )[cbLXXSelection setState:NSControlStateValueOn]; else [cbLXXSelection setState:NSControlStateValueOff]; */
}

- (IBAction)doCancel:(id)sender
{
    [NSApp stopModalWithCode:NSModalResponseCancel];
    [self close];
}

- (IBAction)doOK:(id)sender
{
    if( [cbBHSWord state] == NSControlStateValueOff) [globalVarsResetCopy setCopyOption:3 forCopyType:0 forTextType:0 withValue:1]; else [globalVarsResetCopy setCopyOption:3 forCopyType:0 forTextType:0 withValue:0];
    if( [cbBHSVerse state] == NSControlStateValueOff) [globalVarsResetCopy setCopyOption:3 forCopyType:1 forTextType:0 withValue:1]; else [globalVarsResetCopy setCopyOption:3 forCopyType:1 forTextType:0 withValue:0];
    if( [cbBHSChapter state] == NSControlStateValueOff) [globalVarsResetCopy setCopyOption:3 forCopyType:2 forTextType:0 withValue:1]; else [globalVarsResetCopy setCopyOption:3 forCopyType:2 forTextType:0 withValue:0];
    if( [cbBHSSelection state] == NSControlStateValueOff) [globalVarsResetCopy setCopyOption:3 forCopyType:3 forTextType:0 withValue:1]; else [globalVarsResetCopy setCopyOption:3 forCopyType:3 forTextType:0 withValue:0];
    if( [cbLXXWord state] == NSControlStateValueOff) [globalVarsResetCopy setCopyOption:3 forCopyType:0 forTextType:1 withValue:1]; else [globalVarsResetCopy setCopyOption:3 forCopyType:0 forTextType:1 withValue:0];
    if( [cbLXXVerse state] == NSControlStateValueOff) [globalVarsResetCopy setCopyOption:3 forCopyType:1 forTextType:1 withValue:1]; else [globalVarsResetCopy setCopyOption:3 forCopyType:1 forTextType:1 withValue:0];
    if( [cbLXXChapter state] == NSControlStateValueOff) [globalVarsResetCopy setCopyOption:3 forCopyType:2 forTextType:1 withValue:1]; else [globalVarsResetCopy setCopyOption:3 forCopyType:2 forTextType:1 withValue:0];
    if( [cbLXXSelection state] == NSControlStateValueOff) [globalVarsResetCopy setCopyOption:3 forCopyType:3 forTextType:1 withValue:1]; else [globalVarsResetCopy setCopyOption:3 forCopyType:3 forTextType:1 withValue:0];
    [NSApp stopModalWithCode:NSModalResponseOK];
    [self close];
}

@end
