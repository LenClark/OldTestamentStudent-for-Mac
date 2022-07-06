//
//  frmResetCopyOptions.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 18/06/2022.
//

#import <Cocoa/Cocoa.h>
#import "classGlobal.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface frmResetCopyOptions : NSWindowController

@property (retain) IBOutlet NSButton *cbBHSWord;
@property (retain) IBOutlet NSButton *cbBHSVerse;
@property (retain) IBOutlet NSButton *cbBHSChapter;
@property (retain) IBOutlet NSButton *cbBHSSelection;
@property (retain) IBOutlet NSButton *cbLXXWord;
@property (retain) IBOutlet NSButton *cbLXXVerse;
@property (retain) IBOutlet NSButton *cbLXXChapter;
@property (retain) IBOutlet NSButton *cbLXXSelection;

- (void) setup: (classGlobal *) inGlobal;

@end

NS_ASSUME_NONNULL_END
