//
//  classGkKeyboard.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import "classGkKeyboard.h"

@implementation classGkKeyboard

@synthesize greekOrthography;
@synthesize isGkMiniscule;
@synthesize isLXXCarriageReturnDown;
@synthesize isLXXShiftDown;
@synthesize lxxKeyboardPanel;
@synthesize lxxHistoryPanel;
@synthesize gkKeys;
@synthesize minisculeGkKeyFace;
@synthesize majisculeGkKeyFace;
@synthesize showLXXHideButton;
@synthesize rbtnGkKbNotes;
@synthesize rbtnGkKbPrimary;
@synthesize rbtnGkKbSecondary;

classGlobal *globalVarsGkKeyboard;
classKbCommon *kbMethods;

- (id) init: (classGlobal *) inGlobal withGkOthography: (classGreekOrthography *) inGkOrth
{
    if( self = [super init])
    {
        globalVarsGkKeyboard = inGlobal;
        greekOrthography = inGkOrth;
        lxxKeyboardPanel = [globalVarsGkKeyboard viewGreekKeyboard];
        kbMethods = [[classKbCommon alloc] init];
    }
    return self;
}

- (void) setupGkKeyboard
{
    /*=============================================================================================================*
     *                                                                                                             *
     *                                              setupGkKeyboard                                                *
     *                                              ===============                                                *
     *                                                                                                             *
     *  Specific to the virtual keyboard for Greek.  Because we have to manage the change of characters as accents *
     *    or other non-alphabetic elements are added, the processing is more complex than for Hebrew.              *
     *                                                                                                             *
     *=============================================================================================================*/
    const NSInteger noOfCols = 13;

    NSInteger idx, keyRow, keyCol, maxForRow, keyWidth, baseHeight, leftRBtn = 15, rbtnTop, currLeft, currHeight, noOfRows, keyGap, keyHeight;
    NSString *keyFaceMinName = @"gkKeyFaceMin", *keyFaceMajName = @"gkKeyFaceMaj", *keyHintMinName = @"gkKeyHintMin", *keyHintMajName = @"gkKeyHintMaj", *keyWidthName = @"keyWidths";
    NSString *currentKeyFace;
    NSArray *keyWidths, *radioButtonText, *gkKeyFace, *gkKeyHint;
    NSMutableDictionary *buttonStore, *minisculeFaceSetup, *majisculeFaceSetup;
    NSButton *rbtnTemp, *btnTemp;
    NSBox *gbTextDestination;
    NSFont *typicalFont;

    noOfRows = [globalVarsGkKeyboard noOfKeyboardRows];
    keyHeight = [globalVarsGkKeyboard keyHeight];
    keyGap = [globalVarsGkKeyboard keyGap];
    isGkMiniscule = true;
    radioButtonText = [[NSArray alloc] initWithObjects: @"Notes", @"Primary Search Word", @"Secondary Search Word", nil];
    /*============================================================================*
     *                                                                            *
     *  buttonStore                                                               *
     *  ===========                                                               *
     *                                                                            *
     *  This disctionary will store the details of keys (buttons) generated in    *
     *    sequence.  Since there are no more than 13 keys per row, we will store  *
     *    these as a 20 by x array.  However, since objective-c finds multi-d     *
     *    arrays difficult, we will key the dictionary on an integer calculated   *
     *    by:                                                                     *
     *             20 x row number + column number                                *
     *                                                                            *
     *  Key:   the identifying index, as described above                          *
     *  Value: the NSButton address                                               *
     *                                                                            *
     *============================================================================*/
    buttonStore = [[NSMutableDictionary alloc] init];
    minisculeFaceSetup = [[NSMutableDictionary alloc] init];
    majisculeFaceSetup = [[NSMutableDictionary alloc] init];
    typicalFont = [NSFont fontWithName:@"Times New Roman" size:16];
    lxxHistoryPanel = [globalVarsGkKeyboard viewLXXHistoryPnl];
    keyWidths = [kbMethods loadKeyWidths:keyWidthName withNoOfRows:noOfRows andNoOfColumns:noOfCols];
    /*===================================================================
     *
     * Now actually create the two sets of keys
     */
    gkKeyFace = [kbMethods loadFileData:keyFaceMinName withNoOfRows:noOfRows andNoOfColumns:noOfCols];
    gkKeyHint = [kbMethods loadFileData:keyHintMinName withNoOfRows:noOfRows andNoOfColumns:noOfCols];
    maxForRow = 0;
    baseHeight = 8;
    idx = 1;
//    rbtnTop = [lxxKeyboardPanel frame].size.height - keyHeight - 4;
    rbtnTop = [globalVarsGkKeyboard keyboardAreaTop];
    currHeight = rbtnTop;
    currLeft = 0;
    for (keyRow = 0; keyRow < noOfRows; keyRow++)
    {
        currLeft = leftRBtn;
        switch (keyRow)
        {
            case 0:
            case 1:
            case 2: maxForRow = noOfCols; break;
            case 3: maxForRow = 12; break;
//            case 4: maxForRow = 8; break;
        }
        for (keyCol = 0; keyCol < maxForRow; keyCol++)
        {
            keyWidth = [kbMethods getKeyWidth:keyWidths fromRow:keyRow andColumn:keyCol];
            btnTemp = [[NSButton alloc] initWithFrame:NSMakeRect(currLeft, currHeight, keyWidth, keyHeight)];
            currentKeyFace = [[NSString alloc] initWithString:[kbMethods getLoadedData:gkKeyFace fromRow:keyRow andColumn:keyCol]];
            [btnTemp setTitle:[[NSString alloc] initWithString:currentKeyFace]];
            [minisculeFaceSetup setObject:currentKeyFace forKey:[[NSString alloc] initWithFormat:@"%ld", keyRow * 20 + keyCol]];
            [btnTemp setAlignment:NSTextAlignmentCenter];
            [btnTemp setFont:typicalFont];
            [btnTemp setTag:idx];
            [btnTemp setTarget:self];
            [btnTemp setToolTip:[kbMethods getLoadedData:gkKeyHint fromRow:keyRow andColumn:keyCol]];
            [buttonStore setValue:btnTemp forKey: [[NSString alloc] initWithFormat:@"%ld", keyRow * 20 + keyCol]];
            [lxxKeyboardPanel addSubview:btnTemp];
            currLeft += keyWidth + keyGap;
            idx++;
        }
        currHeight -= (keyHeight + keyGap);
    }
    
    /*===================================================================
     *
     *  Now create the group box of destination options
     */
    currHeight = rbtnTop;
    gbTextDestination = [[NSBox alloc] initWithFrame:NSMakeRect(currLeft + 4, currHeight - 100, 210, 100)];
    [gbTextDestination setTitle: @"Direct Hebrew text to: "];
    [lxxKeyboardPanel addSubview:gbTextDestination];
    
    currLeft = 4;
    currHeight = 48;
    for( idx = 0; idx < 3; idx++)
    {
        rbtnTemp = [[NSButton alloc] initWithFrame:NSMakeRect(currLeft, currHeight, 200, 18)];
        [rbtnTemp setTitle:[radioButtonText objectAtIndex:idx]];
        [rbtnTemp setButtonType:NSButtonTypeRadio];
        if( idx == 0) [rbtnTemp setState:NSControlStateValueOn];
        switch (idx)
        {
            case 0: rbtnGkKbNotes = rbtnTemp; break;
            case 1: rbtnGkKbPrimary = rbtnTemp; break;
            case 2: rbtnGkKbSecondary = rbtnTemp; break;
            default: break;
        }
        [gbTextDestination addSubview:rbtnTemp];
        currHeight -= 22;
    }
    [globalVarsGkKeyboard setRbtnLXXNotes:rbtnGkKbNotes];
    [globalVarsGkKeyboard setRbtnLXXPrimary:rbtnGkKbPrimary];
    [globalVarsGkKeyboard setRbtnLXXSecondary:rbtnGkKbSecondary];
}

-(void) virtualKeyPress: (id) sender
{
    NSUInteger cursorPstn;
    NSInteger tagVal;
    NSString *searchTextSoFar;
    NSRange searchRange;
    NSButton *rbNotes, *rbMainSearch, *rbSecondarySearch;
    NSTextView *currentTextView;
    NSTextField *currentTextField;
    NSTabViewItem *targetTabItem;
    NSTabView *targetTab;
    classReturnedModifiedText *modifiedText;
    
    rbNotes = [globalVarsGkKeyboard rbtnLXXNotes];
    rbMainSearch = [globalVarsGkKeyboard rbtnLXXPrimary];
    rbSecondarySearch = [globalVarsGkKeyboard rbtnLXXSecondary];
    targetTab = [globalVarsGkKeyboard tabLXXUtilityDetail];  //Bottom right tab area for MT
    if( rbNotes.state == NSControlStateValueOn )
    {
        targetTabItem = [globalVarsGkKeyboard itemLXXNotes];
        currentTextView = [globalVarsGkKeyboard txtLXXNotes];
        [targetTab selectTabViewItemAtIndex:0];
    }
    else
    {
        if( [rbMainSearch state] == NSControlStateValueOn ) currentTextField = [globalVarsGkKeyboard txtLXXPrimaryWord];
        else currentTextField = [globalVarsGkKeyboard txtLXXSecondaryWord];
        [targetTab selectTabViewItemAtIndex:2];
    }
    // tagVal identifies the Virtual key that has been "pressed"
    tagVal = [sender tag];
    searchTextSoFar = [currentTextView string];
    searchRange = [currentTextView selectedRange];
    cursorPstn = searchRange.location;
    switch (tagVal)
    {
        case 29:
        case 30:
        case 31:   //Tab
            break;
        case 32:
//            modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:nil addChar:@" "];
            break;
        case 33:
            if( [searchTextSoFar length] == 0 ) break;
            currentTextView.string = [currentTextView.string substringToIndex:[searchTextSoFar length] - 1];
            break;
        default:
            modifiedText = [kbMethods reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:[[NSMutableDictionary alloc] init] addChar:[sender title]];
            break;
    }
    [currentTextView setString:[modifiedText returnedText]];
    [currentTextView setSelectedRange:NSMakeRange([modifiedText newCursorPosition], 0)];
}

@end
