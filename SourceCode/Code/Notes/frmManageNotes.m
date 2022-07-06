/*==================================================================================================================*
 *                                                                                                                  *
 *                                               frmManageNotes                                                     *
 *                                               ==============                                                     *
 *                                                                                                                  *
 *  The methods in the form class relate to setting up different Note Sets.  A Note Set is a collection of all      *
 *    notes for either the Biblia Hebraica Stuttgartensia or the Septuagint with a given name.  The user can create *
 *    a new Note Set without harming the old one.  In fact, the functions are:                                      *
 *    a) create a new Note Set;                                                                                     *
 *    b) Changing from one Note Set to another (existing) one;                                                      *
 *    c) delete an existing Note Set (other than the one currently being used);                                     *
 *    d) simply displaying the names of the currently active Note Sets.                                             *
 *                                                                                                                  *
 *  When a note is created, it will be stored under:                                                                *
 *                                                                                                                  *
 *              <user directory>/Library/LFCConsulting/OTS/Notes                                                    *
 *                                                                                                                  *
 *    Within Notes, the file structure will be as follows:                                                          *
 *                                                                                                                  *
 *              Notes                                                                                               *
 *                |                                                                                                 *
 *                 -- BHS                                                                                           *
 *                |    |                                                                                            *
 *                |     -- B000001                                                                                  *
 *                |    |      |                                                                                     *
 *                |    |       -- bb-yy (book and chapter directory)                                                *
 *                |    |      |                                                                                     *
 *                |    |       -- bb-yy (ditto)                                                                     *
 *                |    |      .                                                                                     *
 *                |    |      .                                                                                     *
 *                |    |      .                                                                                     *
 *                |    |                                                                                            *
 *                |     -- B000002                                                                                  *
 *                |    .                                                                                            *
 *                |    .                                                                                            *
 *                |    .                                                                                            *
 *                |                                                                                                 *
 *                 -- LXX                                                                                           *
 *                     |                                                                                            *
 *                      -- L000001                                                                                  *
 *                            |                                                                                     *
 *                             -- bb-yy                                                                             *
 *                            |                                                                                     *
 *                             -- bb-yy                                                                             *
 *                            .                                                                                     *
 *                            .                                                                                     *
 *                            .                                                                                     *
 *                                                                                                                  *
 *  Note that each directory containing the Notes data is simply a sequential number, yet the Notes are given a     *
 *    meaningful name.  This means that OTS must manage both the user-friendly name and the machine name and keep   *
 *    the two synchronised.                                                                                         *
 *                                                                                                                  *
 *  In order to do this, the following variables are defined:                                                       *
 *                                                                                                                  *
 *    Variable name               Function                                                                          *
 *    -------------               --------                                                                          *
 *                                                                                                                  *
 *    NotesPath       A little misleading: it is simply the directory at the head of the Notes Set store and will   *
 *                      be "Notes".                                                                                 *
 *    bhsNotesFolder  The head of the BHS specific notes = "BHS"                                                    *
 *    lxxNotesFolder  The same for the Sptuagint = "LXX"                                                            *
 *    bhsNotesName    By default, this is "Default" but can be anything the user chooses                            *
 *    lxxNotesName    By default, this is also Default but can be anything.  (Note that the names cannot be         *
 *                      duplicated within BHS or LXX but can be duplicated across the two.                          *
 *    specificBHSNoteFolder  This is "B" + a sequential integer value (left padded to 6 significant places)         *
 *    specificLXXNoteFolder  As specificBHSNoteFolder but prefixed with "L"                                         *
 *                                                                                                                  *
 *  Note that Additional files will be placed in the Notes store to enable us to relate the user-friendly Note name *
 *    and the meaningless (character unconstrained) name.  These will be:                                           *
 *                                                                                                                  *
 *       in "BHS" and "LXX":                                                                                        *
 *          Index.count   The last (highest) sequential number used for Note Sets                                   *
 *                                                                                                                  *
 *       in each BHS/Bnnnnnn directory:                                                                             *
 *          NoteSetName.desc   This file will contain the user-friendly name for the given directory.               *
 *                                                                                                                  *
 *  When the application needs to present a list of Note Set names, it will need to:                                *
 *    a) scan through each of the Bnnnnnn or Lnnnnnn directories                                                    *
 *    b) in each case, open the file, NoteSetName.desc                                                              *
 *    c) read and use the name given in the file.                                                                   *
 *                                                                                                                  *
 *  Created: Len Clark                                                                                              *
 *  June 2022                                                                                                       *
 *                                                                                                                  *
 *==================================================================================================================*/

#import "frmManageNotes.h"

@interface frmManageNotes ()

@end

@implementation frmManageNotes

@synthesize thisWindow;
@synthesize mainLabel;
@synthesize secondaryLabel;
@synthesize notesSetEntry;
@synthesize cbNotesSet;
@synthesize currentNoteName;
@synthesize rbtnBHS;
@synthesize rbtnLXX;
@synthesize actionCode;

classGlobal *globalVarsManageNotes;
classBHSNotes *bhsNotesInstance;
classLXXNotes *lxxNotesInstance;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

/*===============================================================================================*
 *                                                                                               *
 *                                            setContent                                         *
 *                                            ==========                                         *
 *                                                                                               *
 *  This sets up the dialog before use.  It allows a single Window Controller to be used for the *
 *    first three menu options for notes.                                                        *
 *                                                                                               *
 *  Anatomy of the Dialog:                                                                       *
 *                                                   actionCode                                  *
 *   Veriable/Control   Data Type    Control Type    BHS      LXX   Function                     *
 *   ----------------   ---------    ------------   -----    -----  --------                     *
 *    notesSetEntry    NSTextField   Edit Box       1        4      Name of new note             *
 *    cbNotesSet       NSComboBox    Combo Box      2, 3     5, 6   Select a note                *
 *    secondaryLabel   NSTextField   Label                all       Information                  *
 *    currentNoteName  NSTextField   Label                all       Information                  *
 *                                                                                               *
 *===============================================================================================*/
 
- (void) setContent: (NSString *) windowsTitle
      configuration: (classGlobal *) inConfig
 notesMethodsforBHS: (classBHSNotes *) inBHSNotes
 notesMethodsforLXX: (classLXXNotes *) inLXXNotes
          mainLabel: (NSString *) inMainLabel
     secondaryLabel: (NSString *) inSecondaryLabel
             action: (NSInteger) inCode
{

    // Set global variables - nothing directly to do with building the dialog
    globalVarsManageNotes = inConfig;
    bhsNotesInstance = inBHSNotes;
    lxxNotesInstance = inLXXNotes;
    
    // Act on the passed parameters
    actionCode = inCode;
    [thisWindow setTitle:windowsTitle];
    [mainLabel setStringValue:inMainLabel];
    [secondaryLabel setStringValue:inSecondaryLabel];
    // The idea of repeatableContent is that it is called whenever the radiobuttons for BHS or LXX are changed
    [self repeatableContent];
}

- (void) repeatableContent
{
    BOOL isDir;
    NSInteger BHSorLXX;
    NSString *currentNote, *partialPath, *fileContents;
    NSArray *allNotesFolders;
    NSMutableArray *folderContents;
    NSFileManager *fmNotes;
    classAlert *alert;

    /*-------------------------------------------------------------------------------------------------------------*
     *                                      Manage Notes [Title]                                                   *
     *-------------------------------------------------------------------------------------------------------------*
     *                                                                                                             *
     *                                                                                                             *
     *                                                        --- Language/Text to manage: ---------------         *
     *                                                        |                                           |        *
     *                                                        |   o  Biblia Hebraica Stutt... [rbtnBHS]   |        *
     *                                                        |   o  Septuagint (Rhalfs) [rbtnLXX]        |        *
     *                                                         -------------------------------------------         *
     *   Main Label  <------------------------------------------------------------------------------------------------- [mainLabel]
     *       --------------------------------                                                                      *
     *      |                                |   <--------------------------------------------------------------------- {either [notesSetEntry] or [cbNotesSet]}
     *       --------------------------------                                                                      *
     *                                                                                                             *
     *   Secondary Label  <-------------------------------------------------------------------------------------------- [secondaryLabel]
     *                                                                                                             *
     *   The current Note Set name is: Notes Set Name  <--------------------------------------------------------------- [currentNoteName]
     *                                                                                                 --------    *
     *    --------                                                                                    |   OK   |   *
     *   | Cancel |                                                                                    --------    *
     *    --------                                                                                                 *
     *                                                                                                             *
     *-------------------------------------------------------------------------------------------------------------*/
    if( [rbtnBHS state] == NSControlStateValueOn ) BHSorLXX = 1;
    else BHSorLXX = 2;
    // Used to get the text for currentNoteName
    if( BHSorLXX == 1)
    {
        currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes bhsNotesName]];
        partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes bhsNotesFolder]];
    }
    else
    {
        currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes lxxNotesName]];
        partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes lxxNotesFolder]];
    }
    [currentNoteName setStringValue:currentNote];
    folderContents = [[NSMutableArray alloc] init];
    fmNotes = [NSFileManager defaultManager];
    allNotesFolders = [[NSArray alloc] initWithArray:[fmNotes contentsOfDirectoryAtPath:partialPath error:nil]];
    for( NSString *itemName in allNotesFolders )
    {
        [fmNotes fileExistsAtPath:[[NSString alloc] initWithFormat:@"%@/%@", partialPath, itemName] isDirectory:&isDir];
        // Only worry about directories
        if( isDir)
        {
            // In each case, open and read NotesSetName.desc
            fileContents = [[NSString alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@/%@/NoteSetName.desc", partialPath, itemName] encoding:NSUTF8StringEncoding error:nil];
            // Compare the name in each file with the new name
            // If they are the same, and the scan and perform the third processing steps
            if( [fileContents compare:currentNote] != NSOrderedSame )
            {
                [folderContents addObject:fileContents];
            }
        }
    }
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
        [cbNotesSet removeAllItems];
        if( [folderContents count] > 0)
        {
            [cbNotesSet addItemsWithObjectValues:folderContents];
            [cbNotesSet selectItemAtIndex:0];
        }
        else
        {
            alert = [classAlert new];
            [alert messageBox:@"There are no Note Sets other than the current one" title:@"Unable to perform this action" boxStyle:NSAlertStyleCritical];
        }
    }
}

- (IBAction)doSelectLanguage:(id)sender
{
    [self repeatableContent];
}

- (IBAction)doCancel:(id)sender
{
    [self close];
}

- (IBAction)doClose:(id)sender
{
    BOOL isDir;
    NSInteger BHSorLXX, noteCount;
    NSString *newNoteName, *notesFolder, *currentNote, *partialPath, *fileContents, *fullNotesPath, *tempCount;
    NSMutableString *initialNewName;
    NSArray *allNotesFolders;
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSTextView *currentNotesTextView;
    NSFileManager *fmNotes;
    classAlert *alert;
    
    if( [rbtnBHS state] == NSControlStateValueOn ) BHSorLXX = 1;
    else BHSorLXX = 2;
    switch (actionCode)
    {
        case 1:
            /*--------------------------------------------------------------------------------------------*
            *                                                                                            *
            *    actionCode = 1: Create a new Note Set                                                   *
            *    -------------------------------------                                                   *
            *                                                                                            *
            *  The user has entered the name of a new Note Set (in newNoteName).                         *
            *                                                                                            *
            *  The processing requires:                                                                  *
            *  1. Check whether this Note Set already exists.  Do do this:                               *
            *     a) Scan all the _directories_ one level down from .../Notes/XXX                        *
            *     b) In each case, open and read NotesSetName.desc                                       *
            *     c) Compare the name in each file with the new name                                     *
            *     d) If they are the same, send an elert and then quit                                   *
            *  2. If new, then                                                                           *
            *     a) Register the new name with the global variable, xxxNotesName                        *
            *     b) Get the current index max from .../Notes/XXX/Index.count and increment it           *
            *     c) Save the new value to .../Notes/XXX/Index.count                                     *
            *     d) register the current index value (prefixed by B or L) with the global variable,     *
            *          specificXXXNoteFolder                                                             *
            *  3. Remove any content from the current Notes textview                                     *
            *                                                                                            *
            *  There is no need to actually do anything else: it will be handled by processing in the    *
            *    classXXXNotes instance.                                                                 *
            *                                                                                            *
            *--------------------------------------------------------------------------------------------*/
            // Get the new note name
            initialNewName = [[NSMutableString alloc] initWithString:[notesSetEntry stringValue]];
            // Replace a simple "=" with one with a higher unicode value, so that it isn't confused with the "=" sign in the .dat file
            [initialNewName replaceOccurrencesOfString:@"=" withString:[[NSString alloc] initWithFormat:@"%C", 0xff1d] options:NSLiteralSearch range:NSMakeRange(0,[initialNewName length])];
            newNoteName = [[NSString alloc] initWithString:initialNewName];
            // Check whether that folder = Note Set exists
            if( BHSorLXX == 1 ) notesFolder = [[NSString alloc] initWithString:[globalVarsManageNotes bhsNotesFolder]];
            else notesFolder = [[NSString alloc] initWithString:[globalVarsManageNotes lxxNotesFolder]];
            partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes bhsNotesFolder]];
            fmNotes = [NSFileManager defaultManager];
            // Scan all the _directories_ one level down from .../Notes/XXX (partialPath)
            allNotesFolders = [[NSArray alloc] initWithArray:[fmNotes contentsOfDirectoryAtPath:partialPath error:nil]];
            for( NSString *lowerFolder in allNotesFolders)
            {
                [fmNotes fileExistsAtPath:[[NSString alloc] initWithFormat:@"%@/%@", partialPath, lowerFolder] isDirectory:&isDir];
                // Only worry about directories
                if( isDir)
                {
                    // In each case, open and read NotesSetName.desc
                    fileContents = [[NSString alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@/%@/NoteSetName.desc", partialPath, lowerFolder] encoding:NSUTF8StringEncoding error:nil];
                    // Compare the name in each file with the new name
                    // If they are the same, send an elert and then quit
                    if( [fileContents compare:newNoteName] == NSOrderedSame )
                    {
                        alert = [classAlert new];
                        [alert messageBox:@"That Notes Set appears to exist already" title:@"Note Creation Error" boxStyle:NSAlertStyleCritical];
                        return;
                    }
                }
            }
            // Get the current index max from .../Notes/XXX/Index.count and increment it
            if( BHSorLXX == 1 )
            {
                fullNotesPath = [[NSString alloc] initWithFormat:@"%@/%@/%@/", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes bhsNotesFolder]];
                fileContents = [[NSString alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@Index.count", fullNotesPath] encoding:NSUTF8StringEncoding error:nil];
            }
            else
            {
                fullNotesPath = [[NSString alloc] initWithFormat:@"%@/%@/%@/", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes lxxNotesFolder]];
                fileContents = [[NSString alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@Index.count", fullNotesPath] encoding:NSUTF8StringEncoding error:nil];
            }
            noteCount = [fileContents integerValue];
            tempCount = [[NSString alloc] initWithFormat:@"00000%ld", ++noteCount];
            tempCount = [[NSString alloc] initWithString:[tempCount substringFromIndex:[tempCount length] - 6]];
            // Save the new value to .../Notes/XXX/Index.count
            [tempCount writeToFile:[[NSString alloc] initWithFormat:@"%@/Index.count", partialPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            if(BHSorLXX == 1)
            {
                // Make sure the current note has been saved
                cbBook = [globalVarsManageNotes cbBHSBook];
                cbChapter = [globalVarsManageNotes cbBHSChapter];
                cbVerse = [globalVarsManageNotes cbBHSVerse];
                [bhsNotesInstance storeANoteFor:[cbBook indexOfSelectedItem] chapterSequence:[cbChapter indexOfSelectedItem] andVerseSequence:[cbVerse indexOfSelectedItem]];
                // Register the new name with the global variable, xxxNotesName
                [globalVarsManageNotes setBhsNotesName:newNoteName];
                // register the current index value (prefixed by B or L) with the global variable, specificXXXNoteFolder
                [globalVarsManageNotes setSpecificBHSNoteFolder:[[NSString alloc] initWithFormat:@"B%@", tempCount]];
                fullNotesPath = [[NSString alloc] initWithFormat:@"%@/%@", fullNotesPath, [globalVarsManageNotes specificBHSNoteFolder]];
                [fmNotes createDirectoryAtPath:[[NSString alloc] initWithString: fullNotesPath] withIntermediateDirectories:YES attributes:nil error:nil];
                [newNoteName writeToFile:[[NSString alloc] initWithFormat:@"%@/NoteSetName.desc", fullNotesPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                // Remove any content from the current Notes textview
                currentNotesTextView = [globalVarsManageNotes txtBHSNotes];
                if( [[currentNotesTextView string] length] > 0)
                {
                    [currentNotesTextView selectAll:self];
                    [currentNotesTextView delete:self];
                }
            }
            else
            {
                // Make sure the current note has been saved
                cbBook = [globalVarsManageNotes cbLXXBook];
                cbChapter = [globalVarsManageNotes cbLXXChapter];
                cbVerse = [globalVarsManageNotes cbLXXVerse];
                [lxxNotesInstance storeANoteFor:[cbBook indexOfSelectedItem] chapterSequence:[cbChapter indexOfSelectedItem] andVerseSequence:[cbVerse indexOfSelectedItem]];
                // Register the new name with the global variable, xxxNotesName
                [globalVarsManageNotes setLxxNotesName:[[NSString alloc] initWithString:newNoteName]];
                // register the current index value (prefixed by B or L) with the global variable, specificXXXNoteFolder
                [globalVarsManageNotes setSpecificLXXNoteFolder:[[NSString alloc] initWithFormat:@"L%@", tempCount]];
                fullNotesPath = [[NSString alloc] initWithFormat:@"%@/%@", fullNotesPath, [globalVarsManageNotes specificLXXNoteFolder]];
                [fmNotes createDirectoryAtPath:[[NSString alloc] initWithString: fullNotesPath] withIntermediateDirectories:YES attributes:nil error:nil];
                [newNoteName writeToFile:[[NSString alloc] initWithFormat:@"%@/NoteSetName.desc", fullNotesPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                currentNotesTextView = [globalVarsManageNotes txtLXXNotes];
                if( [[currentNotesTextView string] length] > 0)
                {
                    [currentNotesTextView selectAll:self];
                    [currentNotesTextView delete:self];
                }
            }
            break;
        case 2:
            /*--------------------------------------------------------------------------------------------*
            *                                                                                            *
            *    actionCode = 2: Change to another (existing) Note Set                                   *
            *    -----------------------------------------------------                                   *
            *                                                                                            *
            *  In the method, setContent, a combobox has been populated with all available Note Sets     *
            *    other than the current one.  (If there _is_ no other Note Set available, the user will  *
            *    have received a warning and the combobox will be empty.  The user will have selected    *
            *    one of those Note Sets before clicking on the OK button.                                *
            *                                                                                            *
            *  The processing requires:                                                                  *
            *  1. Handle any existing Note (at the current book-chapter-verse) by                        *
            *     a) If it exists, saving it to disk                                                     *
            *     b) Subsequently, removing any content from the current Notes textview                  *
            *  2. To get the internal directory name for the new selection:                              *
            *     a) Scan all the _directories_ one level down from .../Notes/XXX                        *
            *     b) In each case, open and read NotesSetName.desc                                       *
            *     c) Compare the name in each file with the new name                                     *
            *     d) If they are the same, end the scan and perform the third processing steps           *
            *  3. Now that you know the Note Set name and internal directory location                    *
            *     a) Register the new name with the global variable, xxxNotesName                        *
            *     b) register the new Note Set's internal directory with the global variable,            *
            *          specificXXXNoteFolder                                                             *
            *                                                                                            *
            *  There is no need to actually do anything else: it will be handled by processing in the    *
            *    classXXXNotes instance.                                                                 *
            *                                                                                            *
            *--------------------------------------------------------------------------------------------*/
            newNoteName = [[NSString alloc] initWithString:[cbNotesSet objectValueOfSelectedItem]];
            if( BHSorLXX == 1)
            {
                currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes bhsNotesName]];
            }
            else
            {
                currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes lxxNotesName]];
            }
            if( [newNoteName compare:currentNote] == NSOrderedSame )  // It should never get here
            {
                alert = [classAlert new];
                [alert messageBox:[[NSString alloc] initWithFormat:@"%@ is already the currently active Notes Set", currentNote] title:@"Change of Note Set Error" boxStyle:NSAlertStyleWarning];
                return;
            }
            if( BHSorLXX == 1)
            {
            // Make sure the current note has been saved
                // If it exists
                currentNotesTextView = [globalVarsManageNotes txtBHSNotes];
                // We will need these later, even if they're not used here
                cbBook = [globalVarsManageNotes cbBHSBook];
                cbChapter = [globalVarsManageNotes cbBHSChapter];
                cbVerse = [globalVarsManageNotes cbBHSVerse];
                if( [[currentNotesTextView string] length] > 0)
                {
                    // saving it to disk
                    [bhsNotesInstance storeANoteFor:[cbBook indexOfSelectedItem] chapterSequence:[cbChapter indexOfSelectedItem] andVerseSequence:[cbVerse indexOfSelectedItem]];
                    // Subsequently, removing any content from the current Notes textview
                    [currentNotesTextView selectAll:self];
                    [currentNotesTextView delete:self];
                }
                // Make sure it is now the current note name
                [globalVarsManageNotes setBhsNotesName:newNoteName];
                // Add any current note to the notes text area
                currentNotesTextView = [globalVarsManageNotes txtBHSNotes];
                partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes bhsNotesFolder]];
            }
            else
            {
                // If it exists
                currentNotesTextView = [globalVarsManageNotes txtLXXNotes];
                // We will need these later, even if they're not used here
                cbBook = [globalVarsManageNotes cbLXXBook];
                cbChapter = [globalVarsManageNotes cbLXXChapter];
                cbVerse = [globalVarsManageNotes cbLXXVerse];
                if( [[currentNotesTextView string] length] > 0)
                {
                    // saving it to disk
                    [lxxNotesInstance storeANoteFor:[cbBook indexOfSelectedItem] chapterSequence:[cbChapter indexOfSelectedItem] andVerseSequence:[cbVerse indexOfSelectedItem]];
                    // Subsequently, removing any content from the current Notes textview
                    [currentNotesTextView selectAll:self];
                    [currentNotesTextView delete:self];
                }
                // Make sure it is now the current note name
                [globalVarsManageNotes setLxxNotesName:newNoteName];
                // Add any current note to the notes text area
                currentNotesTextView = [globalVarsManageNotes txtLXXNotes];
                partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes lxxNotesFolder]];
            }
            fmNotes = [NSFileManager defaultManager];
            // Scan all the _directories_ one level down from .../Notes/XXX (partialPath)
            allNotesFolders = [[NSArray alloc] initWithArray:[fmNotes contentsOfDirectoryAtPath:partialPath error:nil]];
            for( NSString *lowerFolder in allNotesFolders)
            {
                [fmNotes fileExistsAtPath:[[NSString alloc] initWithFormat:@"%@/%@", partialPath, lowerFolder] isDirectory:&isDir];
                // Only worry about directories
                if( isDir)
                {
                    // In each case, open and read NotesSetName.desc
                    fileContents = [[NSString alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@/%@/NoteSetName.desc", partialPath, lowerFolder] encoding:NSUTF8StringEncoding error:nil];
                    // Compare the name in each file with the new name
                    // If they are the same, and the scan and perform the third processing steps
                    if( [fileContents compare:newNoteName] == NSOrderedSame )
                    {
                        // Now that you know the Note Set name and internal directory location
                        if( BHSorLXX == 1 )
                        {
                            // Register the new name with the global variable, bhsNotesName
                            [globalVarsManageNotes setBhsNotesName:[[NSString alloc] initWithString:newNoteName]];
                            // register the new Note Set's internal directory with the global variable, specificBHSNoteFolder
                            [globalVarsManageNotes setSpecificBHSNoteFolder:[[NSString alloc] initWithString:lowerFolder]];
                            // If the newly chosen Note Set has an entry for the current verse, display it
                            [bhsNotesInstance retrieveANoteFor:[cbBook indexOfSelectedItem] chapterSequence:[cbChapter indexOfSelectedItem] andVerseSequence:[cbVerse indexOfSelectedItem]];
                        }
                        else
                        {
                            // Register the new name with the global variable, lxxNotesName
                            [globalVarsManageNotes setLxxNotesName:[[NSString alloc] initWithString:newNoteName]];
                            // register the new Note Set's internal directory with the global variable, specificLXXNoteFolder
                            [globalVarsManageNotes setSpecificLXXNoteFolder:[[NSString alloc] initWithString:lowerFolder]];
                            // If the newly chosen Note Set has an entry for the current verse, display it
                            [lxxNotesInstance retrieveANoteFor:[cbBook indexOfSelectedItem] chapterSequence:[cbChapter indexOfSelectedItem] andVerseSequence:[cbVerse indexOfSelectedItem]];
                        }
                        break;
                    }
                }
            }
            break;
        case 3:
            /*--------------------------------------------------------------------------------------------*
            *                                                                                            *
            *    actionCode = 3: Delete a selected (existing) Note Set                                   *
            *    -----------------------------------------------------                                   *
            *                                                                                            *
            *  In the method, setContent, a combobox has been populated with all available Note Sets     *
            *    other than the current one.  (If there _is_ no other Note Set available, the user will  *
            *    have received a warning and the combobox will be empty.  The user will have selected    *
            *    one of those Note Sets before clicking on the OK button.                                *
            *                                                                                            *
            *  The processing requires:                                                                  *
            *  1. To get the internal directory name for the new selection:                              *
            *     a) Scan all the _directories_ one level down from .../Notes/XXX                        *
            *     b) In each case, open and read NotesSetName.desc                                       *
            *     c) Compare the name in each file with the new name                                     *
            *     d) If they are the same, end the scan and perform the second processing steps          *
            *  2. Now that you know the Note Set name and internal directory location, delete the        *
            *       directory, .../Notes/XXX/<internal directory name> and all items below it.           *
            *                                                                                            *
            *  There is no need to actually do anything else: it will be handled by processing in the    *
            *    classXXXNotes instance.                                                                 *
            *                                                                                            *
            *--------------------------------------------------------------------------------------------*/
            newNoteName = [[NSString alloc] initWithString:[cbNotesSet objectValueOfSelectedItem]];
            if (BHSorLXX == 1)
            {
                currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes bhsNotesName]];
            }
            else
            {
                currentNote = [[NSString alloc] initWithString:[globalVarsManageNotes lxxNotesName]];
            }
            if( [newNoteName compare:currentNote] == NSOrderedSame )  // It should never get here
            {
                alert = [classAlert new];
                [alert messageBox:@"Unable to delete the currently active Notes Set" title:@"Note Set Deletion Error" boxStyle:NSAlertStyleCritical];
                return;
            }
            if (BHSorLXX == 1)
            {
                partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes bhsNotesFolder]];
            }
            else
            {
                partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsManageNotes iniPath], [globalVarsManageNotes notesPath], [globalVarsManageNotes lxxNotesFolder]];
            }
            fmNotes = [NSFileManager defaultManager];
            // Scan all the _directories_ one level down from .../Notes/XXX
            allNotesFolders = [[NSArray alloc] initWithArray:[fmNotes contentsOfDirectoryAtPath:partialPath error:nil]];
            for( NSString *lowerFolder in allNotesFolders)
            {
                currentNote = [[NSString alloc] initWithFormat:@"%@/%@", partialPath, lowerFolder];
                [fmNotes fileExistsAtPath:currentNote isDirectory:&isDir];
                if( isDir)
                {
                    // In each case, open and read NotesSetName.desc
                    fileContents = [[NSString alloc] initWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@/NoteSetName.desc", currentNote] encoding:NSUTF8StringEncoding error:nil];
                    // Compare the name in each file with the new name
                    if( [fileContents compare:newNoteName] == NSOrderedSame )
                    {
                        // Now that you know the Note Set name and internal directory location, delete the directory, .../Notes/XXX/<internal directory name> and all items below it
                        [fmNotes removeItemAtPath:currentNote error:nil];
                        // end the scan
                        break;
                    }
                }
            }
            break;
        default:
            break;
    }
    [self close];
}

@end
