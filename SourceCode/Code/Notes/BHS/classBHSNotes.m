/*==================================================================================================================*
 *                                                                                                                  *
 *                                                classBHSNotes                                                     *
 *                                                =============                                                     *
 *                                                                                                                  *
 *                                                                                                                  *
 *  Created by Len Clark                                                                                            *
 *  June 2022                                                                                                       *
 *                                                                                                                  *
 *==================================================================================================================*/

#import "classBHSNotes.h"

@implementation classBHSNotes

classGlobal *globalVarsBHSNotes;

- (id) init: (classGlobal *) inConfig
{
    if( self = [super init])
    {
        globalVarsBHSNotes = inConfig;
    }
    return self;
}

-(void) storeANoteFor: (NSInteger) bookId chapterSequence: (NSInteger) chapIdx andVerseSequence: (NSInteger) verseIdx
{
    /*==================================================================================================================*
     *                                                                                                                  *
     *                                                  storeANote                                                      *
     *                                                  ==========                                                      *
     *                                                                                                                  *
     *  This stores the note you are "leaving".  It will both:                                                          *
     *    - store the current note text in the class instance of the verse, and                                         *
     *    - save the text to file                                                                                       *
     *                                                                                                                  *
     *  Because Objective-C (XCode) does not have an exit textview event, we have to use any change in the cbVerse      *
     *  comboboxes as a trigger to save (and, if necessary, load) a note.                                               *
     *                                                                                                                  *
     *==================================================================================================================*/

    BOOL isDir = true;
    NSString *noteText, *partialPath, *notesPath, *fullFileName, *countFile, *fileContents;
    NSURL *fileURL;
    NSAttributedStringDocumentAttributeKey attributeKey;
    NSAttributedStringDocumentType documentType;
    NSMutableDictionary *attributeList;
    NSTextView *noteTextView;
    NSTextStorage *noteStore;
    NSFileWrapper *fileWrapper;
    NSFileManager *fmNotes;
    NSError *error;
    classAlert *alert;
    
    noteTextView = [globalVarsBHSNotes txtBHSNotes];
    if( [noteTextView string] != nil)
    {
        partialPath = [[NSString alloc] initWithFormat:@"%@/%@/%@", [globalVarsBHSNotes iniPath], [globalVarsBHSNotes notesPath], [globalVarsBHSNotes bhsNotesFolder]];
        notesPath = [[NSString alloc] initWithFormat:@"%@/%@/%ld-%ld", partialPath, [globalVarsBHSNotes specificBHSNoteFolder], bookId, chapIdx];
        fmNotes = [NSFileManager defaultManager];
        if( [[noteTextView string] length] > 0 )
        {
            if( ! [fmNotes fileExistsAtPath:notesPath isDirectory:&isDir]) [fmNotes createDirectoryAtPath:notesPath withIntermediateDirectories:YES attributes:nil error:nil];
            // Since we are using a mangled Note name, we need to place a decode file at root.
            countFile = [[NSString alloc] initWithFormat:@"%@/Index.count", partialPath];
            if( ! [fmNotes fileExistsAtPath:countFile]) [@"000001" writeToFile:countFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
            fileContents = [[NSString alloc] initWithFormat:@"%@", [globalVarsBHSNotes bhsNotesName]];
            [fileContents writeToFile:[[NSString alloc] initWithFormat:@"%@/%@/NoteSetName.desc", partialPath, [globalVarsBHSNotes specificBHSNoteFolder]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            fullFileName = [[NSString alloc] initWithFormat:@"%@/%ld.nte", notesPath, verseIdx];
            fileURL = [[NSURL alloc] initFileURLWithPath:fullFileName];
            noteStore = [noteTextView textStorage];
            noteText = [[NSString alloc] initWithString:[noteStore string]];
            attributeKey = NSDocumentTypeDocumentAttribute;
            documentType = NSRTFTextDocumentType;
            attributeList = [[NSMutableDictionary alloc] init];
            [attributeList setObject:documentType forKey:attributeKey];
            fileWrapper = [noteStore fileWrapperFromRange:NSMakeRange(0, [noteStore length]) documentAttributes:attributeList error:nil];
            [fileWrapper writeToURL:fileURL options:NSFileWrapperWritingAtomic originalContentsURL:nil error:&error];
            alert = [[classAlert alloc] init];
            if( [error localizedDescription] != nil) [alert messageBox:[error localizedDescription] title:@"File Error" boxStyle:NSAlertStyleCritical];
        }
        else
        {
            if( [fmNotes fileExistsAtPath:notesPath isDirectory:&isDir])
            {
                fullFileName = [[NSString alloc] initWithFormat:@"%@/%ld.nte", notesPath, verseIdx];
                if( [fmNotes fileExistsAtPath:fullFileName]) [fmNotes removeItemAtPath:fullFileName error:nil];
            }
        }
    }
}

-(void) retrieveANoteFor: (NSInteger) bookId chapterSequence: (NSInteger) chapIdx andVerseSequence: (NSInteger) verseIdx
{
    /*==================================================================================================================*
     *                                                                                                                  *
     *                                               retrieveANoteFor                                                   *
     *                                               ================                                                   *
     *                                                                                                                  *
     *  Inspect the archive of notes.  If a matching noe exists, display it.                                            *
     *                                                                                                                  *
     *==================================================================================================================*/

    BOOL isDir = true;
    NSString *notesPath, *fullFileName;
    NSTextView *noteTextView;
    NSTextStorage *noteStore;
    NSFileManager *fmNotes;
    
    noteTextView = [globalVarsBHSNotes txtBHSNotes];
    noteStore = [noteTextView textStorage];
    notesPath = [[NSString alloc] initWithFormat:@"%@/%@/%@/%@/%ld-%ld", [globalVarsBHSNotes iniPath], [globalVarsBHSNotes notesPath], [globalVarsBHSNotes bhsNotesFolder], [globalVarsBHSNotes specificBHSNoteFolder], bookId, chapIdx];
    fmNotes = [NSFileManager defaultManager];
    if( ! [fmNotes fileExistsAtPath:notesPath isDirectory:&isDir]) return;
    fullFileName = [[NSString alloc] initWithFormat:@"%@/%ld.nte", notesPath, verseIdx];
    [noteTextView readRTFDFromFile:fullFileName];
}

@end
