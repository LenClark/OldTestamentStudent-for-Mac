//
//  frmManageNotes.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 26/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "classNotes.h"
#import "GBSAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface frmManageNotes : NSWindowController

@property (retain) IBOutlet NSWindow *thisWindow;
@property (retain) frmManageNotes *selfReference;
@property (retain) IBOutlet NSTextField *mainLabel;
@property (retain) IBOutlet NSTextField *secondaryLabel;
@property (retain) IBOutlet NSTextField *notesSetEntry;
@property (retain) IBOutlet NSComboBox *cbNotesSet;
@property (retain) IBOutlet NSTextField *currentNoteName;
@property (nonatomic) NSInteger actionCode;

- (void) setContent: (NSString *) windowsTitle formInstance: (frmManageNotes *) inFrmInstance configuration: (classConfig *) inConfig notesMethods: (classNotes *) inNotes
          mainLabel: (NSString *) inMainLabel secondaryLabel: (NSString *) inSecondaryLabel action: (NSInteger) inCode;
- (IBAction)doClose:(id)sender;
- (IBAction)doCancel:(id)sender;

@end

NS_ASSUME_NONNULL_END
