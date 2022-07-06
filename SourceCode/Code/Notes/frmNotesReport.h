//
//  frmNotesReport.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 07/06/2022.
//

#import <Cocoa/Cocoa.h>
#import "classGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@interface frmNotesReport : NSWindowController

@property (retain) IBOutlet NSWindow *notesReportWindow;
@property (retain) IBOutlet NSTextField *currentBHSNoteSet;
@property (retain) IBOutlet NSTextField *currentLXXNoteSet;
@property (retain) IBOutlet NSTableView *availableBHSNoteSets;
@property (retain) IBOutlet NSTableView *availableLXXNoteSets;
@property (retain) NSMutableArray *bhsNoteSets;
@property (retain) NSMutableArray *lxxNoteSets;

- (void) dialogSetup: (classGlobal *) inGlobal;

@end

NS_ASSUME_NONNULL_END
