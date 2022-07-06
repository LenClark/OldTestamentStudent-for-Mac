//
//  frmCopyOptions.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 24/05/2022.
//

#import <Cocoa/Cocoa.h>
#import "classGlobal.h"
#import "classHebLexicon.h"
#import "classGreekOrthography.h"
#import "classBHSNotes.h"
#import "classLXXNotes.h"
#import "classBHSBook.h"
#import "classLXXBook.h"
#import "classAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface frmCopyOptions : NSWindowController

@property (retain) IBOutlet NSWindow *thisWindow;
@property (retain) IBOutlet NSButton *rbtnCopyToMemory;
@property (retain) IBOutlet NSButton *rbtnCopyToNotes;
@property (retain) IBOutlet NSButton *rbtnIncludeReference;
@property (retain) IBOutlet NSButton *rbtnExcludeReference;
@property (retain) IBOutlet NSButton *rbtnIncludeAccents;
@property (retain) IBOutlet NSButton *rbtnExcludeAccents;
@property (retain) IBOutlet NSButton *cbRemember;

@property (nonatomic) NSInteger typeOfCopy;
@property (nonatomic) NSInteger whichVersion;
@property (nonatomic) NSInteger destCode;
@property (nonatomic) NSInteger refCode;
@property (nonatomic) NSInteger accentCode;
@property (nonatomic) NSInteger rememberCode;
@property (retain) NSString *referenceText;
@property (retain) NSString *selectedText;

- (void) initialise: (NSInteger) copyCode forVersion: (NSInteger) mtOrLxx withGlobalClass: (classGlobal *) inGlobal hebLexicon: (classHebLexicon *) inHebLex andGkOrthog: (classGreekOrthography *) inGkProcs withNote: (NSObject *) inNote;
// - (void) copyWord: (NSInteger) destCode withRefCode: (NSInteger) refCode andAccentCode: (NSInteger) accentCode;
- (void) performCopy;

@end

NS_ASSUME_NONNULL_END
