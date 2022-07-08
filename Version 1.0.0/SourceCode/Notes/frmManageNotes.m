//
//  frmManageNotes.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 26/01/2021.
//

#import "frmManageNotes.h"

@interface frmManageNotes ()

@end

@implementation frmManageNotes

@synthesize thisWindow;
@synthesize selfReference;
@synthesize mainLabel;
@synthesize secondaryLabel;
@synthesize notesSetEntry;
@synthesize cbNotesSet;
@synthesize currentNoteName;
@synthesize actionCode;

classConfig *globalVarsManageNotes;
classNotes *notesInstance;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

/*********************************************************************************
 *                                                                               *
 *                                  setContent                                   *
 *                                  ==========                                   *
 *                                                                               *
 *  This sets up the dialog before use.  It allows a single Window Controller to *
 *    be used for the first three menu options for notes.                        *
 *                                                                               *
 *  Anatomy of the Dialog:                                                       *
 *                                                                               *
 *   Veriable/Control   Data Type    Control Type   Option(s)      Function      *
 *   ----------------   ---------    ------------   ---------      --------      *
 *    notesSetEntry    NSTextField   Edit Box         1         Name of new note *
 *    cbNotesSet       NSComboBox    Combo Box        2, 3      Select a note    *
 *    secondaryLabel   NSTextField   Label            all       Information      *
 *    currentNoteName  NSTextField   Label            all       Information      *
 *                                                                               *
 *********************************************************************************/
 
- (void) setContent: (NSString *) windowsTitle formInstance: (frmManageNotes *) inFrmInstance configuration: (classConfig *) inConfig notesMethods: (classNotes *) inNotes
          mainLabel: (NSString *) inMainLabel secondaryLabel: (NSString *) inSecondaryLabel action: (NSInteger) inCode
{
    NSString *notesFolder, *currentNote;
    NSArray *folderContents;
    NSFileManager *fmNotes;
    GBSAlert *alert;

    // Set global variables - nothing directly to do with building the dialog
    globalVarsManageNotes = inConfig;
    notesInstance = inNotes;
    selfReference = inFrmInstance;
    
    // Act on the passed parameters
    actionCode = inCode;
    [thisWindow setTitle:windowsTitle];
    [mainLabel setStringValue:inMainLabel];
    [secondaryLabel setStringValue:inSecondaryLabel];
    [currentNoteName setStringValue:[globalVarsManageNotes notesName]];
    
    notesFolder = [globalVarsManageNotes notesFolder];
    fmNotes = [NSFileManager defaultManager];
    folderContents = [[NSArray alloc] initWithArray:[fmNotes contentsOfDirectoryAtPath:notesFolder error:nil]];
    currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes notesName]];
    // Set up the variable parts of the dialog
    if( actionCode == 1 )
    {
        [notesSetEntry setHidden:NO];
        [cbNotesSet setHidden:YES];
    }
    else
    {
        [notesSetEntry setHidden:YES];
        [cbNotesSet setHidden:NO];
        for( NSString *candidatePath in folderContents)
        {
            if( [candidatePath compare:currentNote] != NSOrderedSame )
            {
                if( [candidatePath characterAtIndex:0] == '.' ) continue;
                [cbNotesSet addItemWithObjectValue:candidatePath];
            }
        }
        if( [cbNotesSet numberOfItems] == 0 )
        {
            alert = [GBSAlert new];
            [alert messageBox:@"There are no Note Sets other than the current one" title:@"Unable to perform this action" boxStyle:NSAlertStyleCritical];
            [self doCancel:self];
        }
        else
        {
            [cbNotesSet selectItemAtIndex:0];
        }
    }
}

- (IBAction)doCancel:(id)sender
{
    [selfReference close];
}

- (IBAction)doClose:(id)sender
{
    NSInteger testamentId, bookId, chapterId, verseId;
    NSString *newNoteName, *notesFolder, *fullPath, *currentNote;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSFileManager *fmNotes;
    GBSAlert *alert;
    
    switch (actionCode)
    {
        case 1:
            // Get the new note name
            newNoteName = [[NSString alloc] initWithString:[notesSetEntry stringValue]];
            // Check whether that folder = Note Set exists
            notesFolder = [globalVarsManageNotes notesFolder];
            fullPath = [[NSString alloc] initWithFormat:@"%@/%@", notesFolder, newNoteName];
            fmNotes = [NSFileManager defaultManager];
            if( [fmNotes fileExistsAtPath:fullPath])
            {
                alert = [GBSAlert new];
                [alert messageBox:@"That Notes Set appears to exist already" title:@"Note Creation Error" boxStyle:NSAlertStyleCritical];
                return;
            }
            // Make sure the current note has been saved
            [notesInstance storeANote];
            // Then get rid of all - since it's a new note, there can be no existing notes
            [notesInstance clearAllNotes];
            [[globalVarsManageNotes notesTextView] setString:@""];
            // Make sure it is now the current note name
            globalVarsManageNotes.notesName = newNoteName;
            // And that new notes have a dedicated folder for saves
            [fmNotes createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
            break;
        case 2:
            newNoteName = [[NSString alloc] initWithString:[cbNotesSet objectValueOfSelectedItem]];
            currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes notesName]];
            if( [newNoteName compare:currentNote] == NSOrderedSame )
            {
                alert = [GBSAlert new];
                [alert messageBox:[[NSString alloc] initWithFormat:@"%@ is already the currently active Notes Set", currentNote] title:@"Change of Note Set Error" boxStyle:NSAlertStyleWarning];
                return;
            }
            // Make sure the current note has been saved
            [notesInstance storeANote];
            // Then get rid of all
            [notesInstance clearAllNotes];
            // Make sure it is now the current note name
            globalVarsManageNotes.notesName = newNoteName;
            // Now repopulate the data with the new note set
            [notesInstance retrieveAllNotes];
            // Add any current note to the notes text area
            testamentId = [[globalVarsManageNotes topLeftTabView] indexOfTabViewItem:[[globalVarsManageNotes topLeftTabView] selectedTabViewItem]] + 1;
            if( testamentId == 1)
            {
                cbBook = [globalVarsManageNotes cbNtBook];
                cbChapter = [globalVarsManageNotes cbNtChapter];
                cbVerse = [globalVarsManageNotes cbNtVerse];
            }
            else
            {
                cbBook = [globalVarsManageNotes cbLxxBook];
                cbChapter = [globalVarsManageNotes cbLxxChapter];
                cbVerse = [globalVarsManageNotes cbLxxVerse];
            }
            bookId = [cbBook indexOfSelectedItem];
            chapterId = [cbChapter indexOfSelectedItem];
            verseId = [cbVerse indexOfSelectedItem];
            [notesInstance displayANote:testamentId forBookId:bookId chapterSequence:chapterId verseSequence:verseId];
            break;
        case 3:
            newNoteName = [[NSString alloc] initWithString:[cbNotesSet objectValueOfSelectedItem]];
            currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes notesName]];
            if( [newNoteName compare:currentNote] == NSOrderedSame )
            {
                alert = [GBSAlert new];
                [alert messageBox:@"Unable to delete the currently active Notes Set" title:@"Note Set Deletion Error" boxStyle:NSAlertStyleCritical];
                return;
            }
            notesFolder = [globalVarsManageNotes notesFolder];
            fullPath = [[NSString alloc] initWithFormat:@"%@/%@", notesFolder, newNoteName];
            fmNotes = [NSFileManager defaultManager];
            [fmNotes removeItemAtPath:fullPath error:nil];
            break;
        default:
            break;
    }
    [selfReference close];
}

@end
