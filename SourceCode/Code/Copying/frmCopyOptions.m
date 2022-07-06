/*=======================================================================================================*
 *                                                                                                       *
 *                                           frmCopyOptions                                              *
 *                                           ==============                                              *
 *                                                                                                       *
 *  Controls and performs the various copying options, as provided in the context menu of the two main   *
 *    text areas.                                                                                        *
 *                                                                                                       *
 *  Parameters:                                                                                          *
 *  ==========                                                                                           *
 *                                                                                                       *
 *  typeOfCopy    Basically, which of the options was selected:                                          *
 *                                                                                                       *
 *       Code                          Significance                                                      *
 *         1         Copy the currently selected word (or the word the user has clicked on               *
 *         2         Copy the current verse                                                              *
 *         3         Copy the whole chapter                                                              *
 *         4         Copy the user-selected text (replaces ^C)                                           *
 *                                                                                                       *
 *  whichVersion  Identifies whether the copy is in the BHS or LXX                                       *
 *         1         BHS                                                                                 *
 *         2         LXX                                                                                 *
 *                                                                                                       *
 *  Created by Len Clark                                                                                 *
 *  May 2022                                                                                             *
 *                                                                                                       *
 *=======================================================================================================*/

#import "frmCopyOptions.h"

@interface frmCopyOptions ()

@end

@implementation frmCopyOptions

@synthesize thisWindow;
@synthesize rbtnCopyToMemory;
@synthesize rbtnCopyToNotes;
@synthesize rbtnIncludeReference;
@synthesize rbtnExcludeReference;
@synthesize rbtnIncludeAccents;
@synthesize rbtnExcludeAccents;
@synthesize cbRemember;

@synthesize typeOfCopy;
@synthesize whichVersion;

/*-----------------------------------------------------------------------------------*
 *                                                                                   *
 *                                Controlling codes                                  *
 *                                 ----------------                                  *
 *                                                        Values                     *
 *     Code            Meaning                      0                 1              *
 *                                                                                   *
 *   destCode     copyDestination               Notes              Pasteboard        *
 *   refCode      referenceIncluded             Exclude            Include           *
 *   accentCode   AccentsIncluded               Exclude            Include           *
 *   rememberCode Remember and use settings     Don't use          Use               *
 *                                                                                   *
 *   whichVersion Alternative to whichVersion   BHS = 0             LXX = 1          *
 *                                                                                   *
 *-----------------------------------------------------------------------------------*/
@synthesize destCode;
@synthesize refCode;
@synthesize accentCode;
@synthesize rememberCode;
@synthesize referenceText;
@synthesize selectedText;

classGlobal *globalVarsCopyOpts;
classHebLexicon *hebrewMethodsCopyOpts;
classGreekOrthography *greekMethodsCopyOpts;
classBHSNotes *bhsNoteProcs;
classLXXNotes *lxxNoteProcs;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void) initialise: (NSInteger) copyCode forVersion: (NSInteger) mtOrLxx withGlobalClass: (classGlobal *) inGlobal hebLexicon: (classHebLexicon *) inHebLex andGkOrthog: (classGreekOrthography *) inGkProcs withNote: (NSObject *) inNote
{
    /*==================================================================================================*
     *                                                                                                  *
     *                                        initialise                                                *
     *                                        ==========                                                *
     *                                                                                                  *
     *  Clearly, this needs to be executed before the class is used.                                    *
     *                                                                                                  *
     *==================================================================================================*/
    typeOfCopy = copyCode;
    whichVersion = mtOrLxx;
    globalVarsCopyOpts = inGlobal;
    hebrewMethodsCopyOpts = inHebLex;
    greekMethodsCopyOpts = inGkProcs;
    if( mtOrLxx == 0) bhsNoteProcs = (classBHSNotes *) inNote;
    else lxxNoteProcs = (classLXXNotes *) inNote;
    referenceText = [self formReference];
    [self getRelevantText];
    switch( copyCode)
    {
        case 0:
        case 1: [thisWindow setTitle:[[NSString alloc] initWithFormat:@"Copying %@ - %@", referenceText, selectedText]]; break;
        case 2: [thisWindow setTitle:[[NSString alloc] initWithFormat:@"Copying %@", referenceText]]; break;
        case 3: [thisWindow setTitle:[[NSString alloc] initWithFormat:@"Copying a selection from %@", referenceText]]; break;
    }
    if( destCode == 0)
    {
        [rbtnCopyToNotes setState:NSControlStateValueOn];
        [rbtnCopyToMemory setState:NSControlStateValueOff];
    }
    else
    {
        [rbtnCopyToNotes setState:NSControlStateValueOff];
        [rbtnCopyToMemory setState:NSControlStateValueOn];
    }
    if(refCode == 0)
    {
        [rbtnIncludeReference setState:NSControlStateValueOff];
        [rbtnExcludeReference setState:NSControlStateValueOn];
    }
    else
    {
        [rbtnIncludeReference setState:NSControlStateValueOn];
        [rbtnExcludeReference setState:NSControlStateValueOff];
    }
    if(accentCode == 0)
    {
        [rbtnIncludeAccents setState:NSControlStateValueOff];
        [rbtnExcludeAccents setState:NSControlStateValueOn];
    }
    else
    {
        [rbtnIncludeAccents setState:NSControlStateValueOn];
        [rbtnExcludeAccents setState:NSControlStateValueOff];
    }
    [cbRemember setState:NSControlStateValueOff];
}

- (NSString *) formReference
{
    NSComboBox *cbBook, *cbChapter, *cbVerse;
    NSString *refText, *bookName, *chapNo, *vNo;
    classBHSBook *currentBHSBook;
    classLXXBook *currentLXXBook;

    refText = @"";
    switch ( whichVersion)
    {
        case 1:
            cbBook = [globalVarsCopyOpts cbBHSBook];
            currentBHSBook = nil;
            currentBHSBook = [[globalVarsCopyOpts bhsBookList] objectForKey:[globalVarsCopyOpts convertIntegerToString:[cbBook indexOfSelectedItem]]];
            bookName = [currentBHSBook bookName];
            if( bookName == nil) return @"";
            cbChapter = [globalVarsCopyOpts cbBHSChapter];
            chapNo = [[NSString alloc] initWithString:[cbChapter itemObjectValueAtIndex:[cbChapter indexOfSelectedItem]]];
            cbVerse = [globalVarsCopyOpts cbBHSVerse];
            vNo = [[NSString alloc] initWithString:[cbVerse itemObjectValueAtIndex:[cbVerse indexOfSelectedItem]]];
            switch (typeOfCopy)
            {
                case 0:
                case 1: refText = [[NSString alloc] initWithFormat:@"%@ %@.%@", bookName, chapNo, vNo]; break;
                case 2:
                case 3: refText = [[NSString alloc] initWithFormat:@"%@ %@", bookName, chapNo]; break;
            }
            break;
        case 2:
            cbBook = [globalVarsCopyOpts cbLXXBook];
            currentLXXBook = nil;
            currentLXXBook = [[globalVarsCopyOpts lxxBookList] objectForKey:[globalVarsCopyOpts convertIntegerToString:[cbBook indexOfSelectedItem]]];
            bookName = [currentLXXBook commonName];
            if( bookName == nil) return @"";
            cbChapter = [globalVarsCopyOpts cbLXXChapter];
            chapNo = [[NSString alloc] initWithString:[cbChapter itemObjectValueAtIndex:[cbChapter indexOfSelectedItem]]];
            cbVerse = [globalVarsCopyOpts cbLXXVerse];
            vNo = [[NSString alloc] initWithString:[cbVerse itemObjectValueAtIndex:[cbVerse indexOfSelectedItem]]];
            switch (typeOfCopy)
            {
                case 0:
                case 1: refText = [[NSString alloc] initWithFormat:@"%@ %@.%@", bookName, chapNo, vNo]; break;
                case 2:
                case 3: refText = [[NSString alloc] initWithFormat:@"%@ %@", bookName, chapNo]; break;
            }
            break;
    }
    return refText;
}

- (void) getRelevantText
{
    NSInteger nStart, nLength;
    NSRange selectionRange;
    NSTextView *targetTextArea;

    switch ( whichVersion)
    {
        case 0:
            targetTextArea = [globalVarsCopyOpts txtBHSText];
            switch (typeOfCopy)
            {
                case 0: selectedText = [[NSString alloc] initWithString:[globalVarsCopyOpts latestSelectedBHSWord]]; break;
                case 1:
                    selectedText = [[NSString alloc]initWithString:[globalVarsCopyOpts bhsVerseIsolate]];
                    nStart = [selectedText rangeOfString:@":"].location;
                    while ( [selectedText characterAtIndex:++nStart] == ' ') ;
                    selectedText = [[NSString alloc] initWithString:[selectedText substringFromIndex:nStart]];
                    break;
                case 2: selectedText = [[NSString alloc] initWithString:[targetTextArea string]]; break;
                case 3:
                    selectionRange = [targetTextArea selectedRange];
                    nLength = selectionRange.length;
                    if (nLength == 0) selectedText = @"";
                    else selectedText = [[NSString alloc] initWithString:[[targetTextArea string] substringWithRange:selectionRange]]; break;
            }
            break;
        case 1:
            targetTextArea = [globalVarsCopyOpts txtLXXText];
            switch (typeOfCopy)
            {
                case 0: selectedText = [[NSString alloc] initWithString:[globalVarsCopyOpts latestSelectedLXXWord]]; break;
                case 1:
                    selectedText = [[NSString alloc]initWithString:[globalVarsCopyOpts lxxVerseIsolate]];
                    nStart = [selectedText rangeOfString:@":"].location;
                    while ( [selectedText characterAtIndex:++nStart] == ' ') ;
                    selectedText = [[NSString alloc] initWithString:[selectedText substringFromIndex:nStart]];
                    break;
                case 2: selectedText = [[NSString alloc] initWithString:[targetTextArea string]]; break;
                case 3:
                    selectionRange = [targetTextArea selectedRange];
                    nLength = selectionRange.length;
                    if (nLength == 0) selectedText = @"";
                    else selectedText = [[NSString alloc] initWithString:[[targetTextArea string] substringWithRange:selectionRange]]; break;
            }
            break;
    }
}
/*
- (void) copyWord: (NSInteger) destCode withRefCode: (NSInteger) refCode andAccentCode: (NSInteger) accentCode
{
    const unichar zeroWidthSpace = L'\u200b', zeroWidthNonJoiner = L'\u200d';

    NSString *copyWord, *modifiedWord, *informationMessage;
    NSPasteboard *standardPasteboard;
    classAlert *alert;
    
    copyWord = @"";
    informationMessage = @"";
    switch ( whichVersion)
    {
        case 1:
            {
                copyWord = [globalVarsCopyOpts latestSelectedBHSWord];
                modifiedWord = [[NSString alloc] initWithString:[copyWord stringByReplacingOccurrencesOfString:[[NSString alloc] initWithFormat:@"%C", zeroWidthSpace] withString:@""]];
                if (accentCode == 2) modifiedWord = [[NSString alloc] initWithString:[hebrewMethodsCopyOpts removeAccents:modifiedWord]];
                if( destCode == 1)
                {
                    standardPasteboard = [NSPasteboard generalPasteboard];
                    [standardPasteboard clearContents];
                    if (refCode == 1) [standardPasteboard setString:[[NSString alloc] initWithFormat:@"%@: %@", referenceText, modifiedWord] forType:NSPasteboardTypeString];
                    else [standardPasteboard setString:modifiedWord forType:NSPasteboardTypeString];
                    informationMessage = [[NSString alloc] initWithFormat:@"%@, %@ has been copied to the pasteboard", referenceText, modifiedWord];
                    alert = [[classAlert alloc] init];
                    [alert messageBox:informationMessage title:[[NSString alloc] initWithFormat:@"Copy of %@ successful", copyWord] boxStyle:NSAlertStyleInformational];
                }
            }
            break;
        case 2:
            {
                copyWord = [globalVarsCopyOpts latestSelectedLXXWord];
                modifiedWord = [[NSString alloc] initWithString:[copyWord stringByReplacingOccurrencesOfString:[[NSString alloc] initWithFormat:@"%C", zeroWidthSpace] withString:@""]];
                modifiedWord = [[NSString alloc] initWithString:[copyWord stringByReplacingOccurrencesOfString:[[NSString alloc] initWithFormat:@"%C", zeroWidthNonJoiner] withString:@""]];
                if (accentCode == 2) modifiedWord = [[NSString alloc] initWithString:[greekMethodsCopyOpts reduceToBareGreek:modifiedWord withNonGkRemoved:true]];
                if (destCode == 1)
                {
                    standardPasteboard = [NSPasteboard generalPasteboard];
                    [standardPasteboard clearContents];
                    if (refCode == 1) [standardPasteboard setString:[[NSString alloc] initWithFormat:@"%@: %@", referenceText, modifiedWord] forType:NSPasteboardTypeString];
                    else [standardPasteboard setString:modifiedWord forType:NSPasteboardTypeString];
                    informationMessage = [[NSString alloc] initWithFormat:@"%@, %@ has been copied to the pasteboard", referenceText, modifiedWord];
                    alert = [[classAlert alloc] init];
                    [alert messageBox:informationMessage title:[[NSString alloc] initWithFormat:@"Copy of %@ successful", copyWord] boxStyle:NSAlertStyleInformational];
                }
            }
            break;
    }
}  */

- (void) setupCodes
{
    /*=============================================================================================================*
     *                                                                                                             *
     *                                               setupCodes                                                    *
     *                                               ==========                                                    *
     *                                                                                                             *
     *  Called when a user has selected OK.                                                                        *
     *                                                                                                             *
     *   Local           Global                 value is 1                        value is 0                       *
     *                                          ----------                        ----------                       *
     *  destCode     destinationCopy      Copied text will go to Pasteboard  Copied text will go to active Note    *
     *  refCode      referenceOption      The reference will be included     The reference will not be included    *
     *  accentCode   accentsOption        Original accents will be included  Accents will not be included          *
     *  rememberCode useExistingOption    I.e. the options dialog will be    The options dialog will not be        *
     *                                      displayed                          displayed and inherited options     *
     *                                                                         will be used                        *
     *                                                                                                             *
     *============================================================================================================*/
    if ( [rbtnCopyToMemory state] == NSControlStateValueOn ) destCode = 1;
    else destCode = 0;
    if ( [rbtnIncludeReference state] == NSControlStateValueOn ) refCode = 1;
    else refCode = 0;
    if ( [rbtnIncludeAccents state] == NSControlStateValueOn) accentCode = 1;
    else accentCode = 0;
    if ( [cbRemember state] == NSControlStateValueOn) rememberCode = 0;
    else rememberCode = 1;
    switch (whichVersion)
    {
        case 0: whichVersion = 0; break; //BHS
        case 1: whichVersion = 1; break; //LXX
        default: whichVersion = -1; break;
    }
}

- (void) performCopy
{
    /*=================================================================================================*
     *                                                                                                 *
     *                                    performCopy                                                  *
     *                                    ===========                                                  *
     *                                                                                                 *
     *  This is the actual copy.  Everything else is basically setting up parameters to ensure that    *
     *    options selected are registered.                                                             *
     *                                                                                                 *
     *=================================================================================================*/
    const unichar zeroWidthSpace = L'\u200b', zeroWidthNonJoiner = L'\u200d';

    NSInteger idx, noOfWords;
    NSString *modifiedWord, *tempText, *messageText, *ultimateText;
    NSMutableString *finalText;
    NSMutableAttributedString *noteInsert;
    NSArray *brokenText;
    NSTextView *currentTextView;
    NSTabViewItem *targetTabItem;
    NSTabView *targetTab, *utilitiesTab;
    NSPasteboard *standardPasteboard;
    classAlert *alert;

    if (whichVersion < 0) return;
    tempText = @"";
    messageText = @"";
    /*-------------------------------------------------------------------------------------------------------------*
     *                                                                                                             *
     *  Note that these values are used as set in the dialog but this method does _not_ feed them back to the      *
     *    global class instance storing values.                                                                    *
     *                                                                                                             *
     *   Local           Global                 value is 1                        value is 0                       *
     *                                          ----------                        ----------                       *
     *  destCode     destinationCopy      Copied text will go to Pasteboard  Copied text will go to active Note    *
     *  refCode      referenceOption      The reference will be included     The reference will not be included    *
     *  accentCode   accentsOption        Original accents will be included  Accents will not be included          *
     *  rememberCode useExistingOption    I.e. the options dialog will be    The options dialog will not be        *
     *                                      displayed                          displayed and inherited options     *
     *                                                                         will be used                        *
     *                                                                                                             *
     *  If a previous entry has set rememberCode to 2, these values will have been posted directly by the calling  *
     *    method.                                                                                                  *
     *                                                                                                             *
     *-------------------------------------------------------------------------------------------------------------*/
    
    // selectedText was populated as part of the initialise processing
    modifiedWord = [[NSString alloc] initWithString:[selectedText stringByReplacingOccurrencesOfString:[[NSString alloc] initWithFormat:@"%C",zeroWidthSpace] withString:@""]];
    modifiedWord = [[NSString alloc] initWithString:[selectedText stringByReplacingOccurrencesOfString:[[NSString alloc] initWithFormat:@"%C",zeroWidthNonJoiner] withString:@""]];
    switch (accentCode)
    {
        case 1: finalText = [[NSMutableString alloc] initWithString: modifiedWord]; break;
        case 0:
            brokenText = [modifiedWord componentsSeparatedByString:@" "];
            noOfWords = [brokenText count];
            for( idx = 0; idx < noOfWords; idx++)
            {
                switch( whichVersion )
                {
                    case 0: tempText = [[NSString alloc] initWithString:[hebrewMethodsCopyOpts removeAccents:[brokenText objectAtIndex:idx]]]; break;
                    case 1: tempText = [[NSString alloc] initWithString:[greekMethodsCopyOpts reduceToBareGreek:[brokenText objectAtIndex:idx] withNonGkRemoved:true]]; break;
                }
                if (idx == 0) finalText = [[NSMutableString alloc] initWithString: tempText];
                else [finalText appendFormat: @" %@", tempText];
            }
            break;
    }
    if (refCode == 1) ultimateText = [[NSString alloc] initWithFormat:@"%@: %@", referenceText, finalText];
    else ultimateText = [[NSString alloc] initWithString:finalText];
    switch( typeOfCopy)
    {
        case 0: messageText = selectedText; break;
        case 1: messageText = @"the verse"; break;
        case 2: messageText = @"the chapter"; break;
        case 3: messageText = @"the selected text"; break;
    }
    switch( destCode)
    {
        case 1:
            standardPasteboard = [NSPasteboard generalPasteboard];
            [standardPasteboard clearContents];
            [standardPasteboard setString:ultimateText forType:NSPasteboardTypeString];
            alert = [[classAlert alloc] init];
            [alert messageBox:[[NSString alloc] initWithFormat:@"%@: %@ has been copied to the pasteboard", referenceText, messageText] title:@"Copy Successful" boxStyle:NSAlertStyleInformational];
            break;
        case 0:
            utilitiesTab = [globalVarsCopyOpts tabUtilities];
            if (whichVersion == 0) //BHS
            {
                [utilitiesTab selectTabViewItemAtIndex:0];
                targetTab = [globalVarsCopyOpts tabBHSUtilityDetail];  //Bottom right tab area for BHS
                targetTabItem = [globalVarsCopyOpts itemBHSNotes];
                currentTextView = [globalVarsCopyOpts txtBHSNotes];
                [targetTab selectTabViewItemAtIndex:0];
                noteInsert = [[NSMutableAttributedString alloc] initWithString:ultimateText];
                [noteInsert addAttribute:NSFontAttributeName value:[globalVarsCopyOpts bhsTextMainFont] range:NSMakeRange(0, [noteInsert length])];
                [[currentTextView textStorage] insertAttributedString:noteInsert atIndex:[currentTextView selectedRange].location];
            }
            else
            {
                [utilitiesTab selectTabViewItemAtIndex:1];
                targetTab = [globalVarsCopyOpts tabLXXUtilityDetail];  //Bottom right tab area for LXX
                targetTabItem = [globalVarsCopyOpts itemLXXNotes];
                currentTextView = [globalVarsCopyOpts txtLXXNotes];
                [targetTab selectTabViewItemAtIndex:0];
                noteInsert = [[NSMutableAttributedString alloc] initWithString:ultimateText];
                [noteInsert addAttribute:NSFontAttributeName value:[globalVarsCopyOpts lxxTextMainFont] range:NSMakeRange(0, [noteInsert length])];
                [[currentTextView textStorage] insertAttributedString:noteInsert atIndex:[currentTextView selectedRange].location];
            }
            break;
    }
}

- (IBAction)doCopyChoice:(id)sender
{
    
}

- (IBAction)doReferenceChoice:(id)sender
{
    
}

- (IBAction)doAccentChoice:(id)sender
{
    
}

- (IBAction)doCancel:(id)sender
{
    [NSApp stopModalWithCode:NSModalResponseCancel];
    [self close];
}

- (IBAction)doOk:(id)sender
{
    [self setupCodes];
    [self performCopy];
    [globalVarsCopyOpts setCopyOption:0 forCopyType:typeOfCopy forTextType:whichVersion withValue:destCode];
    [globalVarsCopyOpts setCopyOption:1 forCopyType:typeOfCopy forTextType:whichVersion withValue:refCode];
    [globalVarsCopyOpts setCopyOption:2 forCopyType:typeOfCopy forTextType:whichVersion withValue:accentCode];
    [globalVarsCopyOpts setCopyOption:3 forCopyType:typeOfCopy forTextType:whichVersion withValue:rememberCode];
    [NSApp stopModalWithCode:NSModalResponseOK];
    [self close];
}

@end
