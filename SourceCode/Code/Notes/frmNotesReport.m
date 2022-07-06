//
//  frmNotesReport.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 07/06/2022.
//

#import "frmNotesReport.h"

@interface frmNotesReport ()

@end

@implementation frmNotesReport

@synthesize notesReportWindow;
@synthesize currentBHSNoteSet;
@synthesize currentLXXNoteSet;
@synthesize availableBHSNoteSets;
@synthesize availableLXXNoteSets;
@synthesize bhsNoteSets;
@synthesize lxxNoteSets;

classGlobal *globalVarsNotesReport;

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

- (void) dialogSetup: (classGlobal *) inGlobal
{
    BOOL isDir;
    NSString *partialPath, *fileContents, *currentBHSName, *currentLXXName;
    NSArray *allNotesFolders;
    NSFileManager *fmNotes;
    
    globalVarsNotesReport = inGlobal;
    currentBHSName = [[NSString alloc] initWithString:[globalVarsNotesReport bhsNotesName]];
    currentLXXName = [[NSString alloc] initWithString:[globalVarsNotesReport lxxNotesName]];
    [currentBHSNoteSet setStringValue:currentBHSName];
    [currentLXXNoteSet setStringValue:currentLXXName];
    bhsNoteSets = [[NSMutableArray alloc] init];
    lxxNoteSets = [[NSMutableArray alloc] init];
    partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsNotesReport iniPath], [globalVarsNotesReport notesPath], [globalVarsNotesReport bhsNotesFolder]];
    fmNotes = [NSFileManager defaultManager];
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
            if( [fileContents compare:currentBHSName] != NSOrderedSame )
            {
                [bhsNoteSets addObject:[[NSString alloc] initWithString:fileContents]];
            }
        }
    }
    partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsNotesReport iniPath], [globalVarsNotesReport notesPath], [globalVarsNotesReport lxxNotesFolder]];
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
            if( [fileContents compare:currentLXXName] != NSOrderedSame )
            {
                [lxxNoteSets addObject:[[NSString alloc] initWithString:fileContents]];
            }
        }
    }
    if( [bhsNoteSets count] > 0 ) [availableBHSNoteSets reloadData];
    if( [lxxNoteSets count] > 0 ) [availableLXXNoteSets reloadData];
}

#pragma mark - Table View Data Source

- (NSInteger) numberOfRowsInTableView: (NSTableView *)tableView
{
    NSInteger tagVal;
    
    tagVal = [tableView tag];
    switch (tagVal)
    {
        case 1: return [bhsNoteSets count];
        case 2: return [lxxNoteSets count];
        default: break;
    }
    return -1;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn: (NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSInteger tagVal;
    
    tagVal = [tableView tag];
    switch (tagVal)
    {
        case 1:
            if( [tableColumn.identifier isEqualToString:@"noteSet"])
            {
                return [bhsNoteSets objectAtIndex:row];
            }
            break;
        case 2:
            if( [tableColumn.identifier isEqualToString:@"noteSet"])
            {
                return [lxxNoteSets objectAtIndex:row];
            }
            break;
        default: break;
    }
    return nil;

}

/*=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=*
 *                                         End of Table Management Section                                         *
 *=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=*/
- (IBAction)doClose:(id)sender
{
    [NSApp stopModal];
    [self close];
}

@end
