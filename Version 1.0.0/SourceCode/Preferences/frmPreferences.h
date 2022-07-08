//
//  frmPreferences.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 27/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface frmPreferences : NSWindowController

@property (retain) IBOutlet NSWindow *preferencesWindow;
@property (retain) IBOutlet NSTabView *preferencesTabView;
@property (retain) IBOutlet NSView *viewTab1;
@property (retain) IBOutlet NSView *viewTab2;
@property (retain) IBOutlet NSView *viewTab3;
@property (retain) IBOutlet NSView *viewTab4;
@property (retain) IBOutlet NSView *viewTab5;
@property (retain) IBOutlet NSView *viewTab6;
@property (retain) IBOutlet NSView *viewTab7;

@property (retain) NSMutableArray *fontComboBoxes;
@property (retain) NSMutableArray *fgColourWells;
@property (retain) NSMutableArray *bgColourWells;
@property (retain) NSColorWell *primaryColourWell;
@property (retain) NSColorWell *secondaryColourWell;
@property (retain) NSMutableArray *exampleTextViews;
@property (retain) NSMutableArray *currentFontSize;
@property (retain) NSMutableArray *currentFgColours;
@property (retain) NSMutableArray *currentBgColours;
@property (retain) NSColor *currentPrimaryColour;
@property (retain) NSColor *currentSecondaryColour;

@property (retain) NSString *sampleTextAid;
@property (retain) NSString *sampleParseAid;
@property (retain) NSString *sampleLexAid;
@property (retain) NSString *sampleSearchAid;
@property (retain) NSString *sampleLxxText;
@property (retain) NSString *sampleVocabAid;
@property (retain) NSString *sampleNotesAid;

- (void) initialiseWindow: (classConfig *) inConfig forWindow: (frmPreferences *) inForm;
- (IBAction)doOK:(NSButton *)sender;
- (IBAction)doCancel:(NSButton *)sender;

@end

NS_ASSUME_NONNULL_END
