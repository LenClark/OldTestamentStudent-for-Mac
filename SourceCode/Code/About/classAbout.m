//
//  classAbout.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 17/06/2022.
//

#import "classAbout.h"

@interface classAbout ()

@end

@implementation classAbout

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)doClose:(id)sender
{
    [NSApp stopModalWithCode:NSModalResponseOK];
    [self close];
}
@end
