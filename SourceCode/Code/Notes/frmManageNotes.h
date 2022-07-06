//
//  frmManageNotes.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 05/06/2022.
//

#import <Cocoa/Cocoa.h>
#import "classGlobal.h"
#import "classBHSNotes.h"
#import "classLXXNotes.h"
#import "classAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface frmManageNotes : NSWindowController

@property (retain) IBOutlet NSWindow *thisWindow;
@property (retain) IBOutlet NSTextField *mainLabel;
@property (retain) IBOutlet NSTextField *secondaryLabel;
@property (retain) IBOutlet NSTextField *notesSetEntry;
@property (retain) IBOutlet NSComboBox *cbNotesSet;
@property (retain) IBOutlet NSTextField *currentNoteName;
@property (retain) IBOutlet NSButton *rbtnBHS;
@property (retain) IBOutlet NSButton *rbtnLXX;
@property (nonatomic) NSInteger actionCode;

- (void) setContent: (NSString *) windowsTitle
      configuration: (classGlobal *) inConfig
 notesMethodsforBHS: (classBHSNotes *) inBHSNotes
 notesMethodsforLXX: (classLXXNotes *) inLXXNotes
          mainLabel: (NSString *) inMainLabel
     secondaryLabel: (NSString *) inSecondaryLabel
             action: (NSInteger) inCode;

@end

NS_ASSUME_NONNULL_END
