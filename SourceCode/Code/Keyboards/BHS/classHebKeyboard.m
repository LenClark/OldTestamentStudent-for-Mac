//
//  classHebKeyboard.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import "classHebKeyboard.h"

@implementation classHebKeyboard

@synthesize isBHSCarriageReturnDown;
@synthesize isBHSShiftDown;
@synthesize bhsKeyboardPanel;
@synthesize bhsHistoryPanel;
@synthesize hebKeys;
@synthesize hebKeyFace;
@synthesize showBHSHideButon;
@synthesize showBHSHideButton;
@synthesize rbtnBHSKbNotes;
@synthesize rbtnBHSKbPrimary;
@synthesize rbtnBHSKbSecondary;
@synthesize inFlightText;
@synthesize inFlightCursorPstn;
@synthesize editView;
@synthesize btnUse;

classGlobal *globalVarsHebKeyboard;
classKbCommon *keyboardMethods;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init])
    {
        globalVarsHebKeyboard = inGlobal;
        bhsKeyboardPanel = [globalVarsHebKeyboard viewHebrewKeyboard];
        keyboardMethods = [[classKbCommon alloc] init];
        inFlightText = [[NSMutableString alloc] initWithString:@""];
        inFlightCursorPstn = 0;
    }
    return self;
}

- (void) setupHebKeyboard
{
    /*=============================================================================================================*
     *                                                                                                             *
     *                                              setupHebKeyboard                                               *
     *                                              ================                                               *
     *                                                                                                             *
     *  Specific to the virtual keyboard in the Masoretic Text section.                                            *
     *                                                                                                             *
     *=============================================================================================================*/
    const NSInteger noOfCols = 13;

    NSInteger idx, keyRow, keyCol, maxForRow, keyWidth, accummulativeWidth, baseHeight, leftRBtn = 15, rbtnTop, currLeft, currHeight, noOfRows, keyGap, keyHeight;
    NSString *keyFaceName = @"hebKeyFace", *keyHintName = @"hebKeyHint", *keyWidthName = @"keyWidths";
    NSArray *keyWidths, *radioButtonText, *hebKeyFace, *hebKeyHint;
    NSMutableDictionary *buttonStore;
//    NSArray *rbtnLeft = { 15, 90, 224, 300 };
//    String[,] hebKeyFace, hebKeyHint, hebKeyVal;
//    ToolTip[,] hebToolTips = new ToolTip[noOfRows, noOfCols];
    NSButton *rbtnTemp, *btnTemp;
    NSTextField *editLabel;
    NSBox *gbTextDestination;
    NSFont *typicalFont;

    noOfRows = [globalVarsHebKeyboard noOfKeyboardRows];
    keyHeight = [globalVarsHebKeyboard keyHeight];
    keyGap = [globalVarsHebKeyboard keyGap];
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
    typicalFont = [NSFont fontWithName:@"Times New Roman" size:16];
    bhsHistoryPanel = [globalVarsHebKeyboard viewBHSHistoryPnl];
    keyWidths = [keyboardMethods loadKeyWidths:keyWidthName withNoOfRows:noOfRows andNoOfColumns:noOfCols];
    /*===================================================================
     *
     * Now actually create the two sets of keys
     */
    hebKeyFace = [keyboardMethods loadFileData:keyFaceName withNoOfRows:noOfRows andNoOfColumns:noOfCols];
    hebKeyHint = [keyboardMethods loadFileData:keyHintName withNoOfRows:noOfRows andNoOfColumns:noOfCols];
    maxForRow = 0;
    baseHeight = 8;
    idx = 1;
//    rbtnTop = [bhsKeyboardPanel frame].size.height - keyHeight - 4;
    rbtnTop = [globalVarsHebKeyboard keyboardAreaTop];
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
            case 3: maxForRow = 13; break;
            case 4: maxForRow = 8; break;
        }
        accummulativeWidth = 16;
        for (keyCol = 0; keyCol < maxForRow; keyCol++)
        {
            keyWidth = [keyboardMethods getKeyWidth:keyWidths fromRow:keyRow andColumn:keyCol];
            btnTemp = [[NSButton alloc] initWithFrame:NSMakeRect(currLeft, currHeight, keyWidth, keyHeight)];
            if ((keyRow == 0) && (keyCol < maxForRow - 1)) [btnTemp setTitle:[[NSString alloc] initWithFormat:@"%C%@", 0x25cc, [keyboardMethods getLoadedData:hebKeyFace fromRow:keyRow andColumn:keyCol]]];
            else [btnTemp setTitle:[[NSString alloc] initWithString:[keyboardMethods getLoadedData:hebKeyFace fromRow:keyRow andColumn:keyCol]]];
            [btnTemp setAlignment:NSTextAlignmentCenter];
            [btnTemp setFont:typicalFont];
            [btnTemp setTag:idx];
            [btnTemp setTarget:self];
            [btnTemp setAction:@selector(virtualKeyPress:)];
            [btnTemp setToolTip:[keyboardMethods getLoadedData:hebKeyHint fromRow:keyRow andColumn:keyCol]];
            [buttonStore setValue:btnTemp forKey: [[NSString alloc] initWithFormat:@"%ld", keyRow * 20 + keyCol]];
            [bhsKeyboardPanel addSubview:btnTemp];
            currLeft += keyWidth + keyGap;
            idx++;
        }
        currHeight -= (keyHeight + keyGap);
    }
    keyRow = currHeight + (keyHeight + keyGap);
    keyCol = currLeft + 4;

    /*===================================================================
     *
     *  Now create the group box of destination options
     */
    currHeight = [globalVarsHebKeyboard keyboardAreaTop];
    gbTextDestination = [[NSBox alloc] initWithFrame:NSMakeRect(keyCol, currHeight - 50, 210, 100)];
    [gbTextDestination setTitle: @"Direct Hebrew text to: "];
    [bhsKeyboardPanel addSubview:gbTextDestination];
    
    currLeft = 4;
    currHeight = 48;
    for( idx = 0; idx < 3; idx++)
    {
        rbtnTemp = [[NSButton alloc] initWithFrame:NSMakeRect(currLeft, currHeight, 200, 18)];
        [rbtnTemp setTitle:[radioButtonText objectAtIndex:idx]];
        [rbtnTemp setButtonType:NSButtonTypeRadio];
        if( idx == 0) [rbtnTemp setState:NSControlStateValueOn];
        [rbtnTemp setTarget:self];
        [rbtnTemp setAction:@selector(dummyRbtnMethod:)];
        [gbTextDestination addSubview:rbtnTemp];
        currHeight -= 22;
        switch (idx)
        {
            case 0:rbtnBHSKbNotes = rbtnTemp; break;
            case 1:rbtnBHSKbPrimary = rbtnTemp; break;
            case 2:rbtnBHSKbSecondary = rbtnTemp; break;
            default: break;
        }
    }
    [globalVarsHebKeyboard setRbtnBHSNotes:rbtnBHSKbNotes];
    [globalVarsHebKeyboard setRbtnBHSPrimary:rbtnBHSKbPrimary];
    [globalVarsHebKeyboard setRbtnBHSSecondary:rbtnBHSKbSecondary];
    
    /*===================================================================
     *
     *  Now create a temporary editing area
     */
    
    currHeight = [bhsKeyboardPanel frame].size.height - 32;
    editLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(keyCol + 6, keyRow + 36, 150, 18)];
    [editLabel setStringValue:@"Current entry:"];
    [editLabel setSelectable:NO];
    [editLabel setEditable:NO];
    [editLabel setBordered:NO];
    [editLabel setDrawsBackground:NO];
    [bhsKeyboardPanel addSubview:editLabel];
    editView = [[NSTextView alloc] initWithFrame:NSMakeRect(keyCol, keyRow, 140, 32)];
    [editView setFont:[globalVarsHebKeyboard bhsTextMainFont]];
    [editView setEditable:YES];
    [editView setSelectionGranularity:NSSelectByCharacter];
    [editView setAutomaticQuoteSubstitutionEnabled:NO];
    [bhsKeyboardPanel addSubview:editView];
    btnUse = [[NSButton alloc] initWithFrame:NSMakeRect(keyCol + 142, keyRow, 42, 32)];
    [btnUse setButtonType:NSButtonTypeMomentaryPushIn];
    [btnUse setTitle:@"Use"];
    [btnUse setTarget:self];
    [btnUse setAction:@selector(doUse:)];
    [bhsKeyboardPanel addSubview:btnUse];
}

-(void) virtualKeyPress: (id) sender
{
    NSUInteger cursorPstn;
    NSInteger tagVal;
    NSString *searchTextSoFar;
    NSRange searchRange;
    NSTextView *currentTextView;
    NSTabViewItem *targetTabItem;
    NSTabView *targetTab;
    
    targetTab = [globalVarsHebKeyboard tabBHSUtilityDetail];  //Bottom right tab area for BHS
    targetTabItem = [globalVarsHebKeyboard itemBHSNotes];
    currentTextView = [globalVarsHebKeyboard txtBHSNotes];
    [targetTab selectTabViewItemAtIndex:0];
    // tagVal identifies the Virtual key that has been "pressed"
    tagVal = [sender tag];
    searchTextSoFar = [currentTextView string];
    searchRange = [currentTextView selectedRange];
    cursorPstn = searchRange.location;
    switch (tagVal)
    {
        case 13: [self backspaceString]; break;
        case 26: [self forwardDelete]; break;
        case 39: [editView setString:@""]; break;
        case 41: [self reviseSearchString:@" "]; break;
        default: [self reviseSearchString:[sender title]]; break;
    }
}

- (IBAction)dummyRbtnMethod:(id)sender
{
    [editView setString:@""];
}

-(void) reviseSearchString: (NSString *) addChar
{
    /*==================================================================================================================================*
     *                                                                                                                                  *
     *  The method handles the management of normally added characters                                                                  *
     *                                                                                                                                  *
     *  sourceString   The total string being referenced (which may be nil or have zero length);                                        *
     *  Pstn           The zero-based reference to the position of the caret in the string                                              *
     *  actionArray    The dictionary that provides from-to data for the non-alphabet characters                                        *
     *                                                                                                                                  *
     *==================================================================================================================================*/
    NSString *newChar;
    classDisplayUtilities *displayUtilities;
    
    displayUtilities = [[classDisplayUtilities alloc] init:globalVarsHebKeyboard];
    if( [addChar length] > 1 )
    {
        newChar = [[NSString alloc] initWithString:[addChar substringFromIndex:[addChar length] - 1]];
    }
    else newChar = [[NSString alloc] initWithString:addChar];
    if( [[editView textStorage] length] == 0 )
    {
        [[editView textStorage] appendAttributedString: [displayUtilities addAttributedText:newChar offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView]];
    }
    else
    {
        if( [inFlightText length] == inFlightCursorPstn)
        {
            [[editView textStorage] appendAttributedString: [displayUtilities addAttributedText:newChar offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView]];
        }
        else
        {
            [[editView textStorage] insertAttributedString: [displayUtilities addAttributedText:newChar offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView] atIndex:[editView selectedRange].location];
//            [inFlightText insertString:addChar atIndex:inFlightCursorPstn++];
        }
    }
}

- (void) backspaceString
{
    NSInteger nPstn, eviewLength;
    NSString *firstPart, *secondPart;
    classDisplayUtilities *displayUtilities;

    displayUtilities = [[classDisplayUtilities alloc] init:globalVarsHebKeyboard];
    eviewLength = [[editView textStorage] length];
    if( eviewLength == 0) return;
    nPstn = [editView selectedRange].location;
    if( nPstn == 0 ) return;
    if( eviewLength == 1)
    {
        [editView setString:@""];
        return;
    }
    if( nPstn == eviewLength)
    {
        firstPart = [[NSString alloc] initWithString:[[editView string] substringToIndex:[[editView string] length] - 1]];
        [editView setString:@""];
        [[editView textStorage] appendAttributedString:[displayUtilities addAttributedText:firstPart offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView]];
    }
    else
    {
        if( nPstn == 1 )
        {
            firstPart = [[NSString alloc] initWithString:[[editView string] substringFromIndex:1]];
            [editView setString:@""];
            [[editView textStorage] appendAttributedString:[displayUtilities addAttributedText:firstPart offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView]];
            [editView setSelectedRange:NSMakeRange(0, 0)];
        }
        else
        {
            firstPart = [[NSString alloc] initWithString:[[editView string] substringToIndex:nPstn - 1]];
            secondPart = [[NSString alloc] initWithString:[[editView string] substringFromIndex:nPstn]];
            [editView setString:@""];
            [[editView textStorage] appendAttributedString:[displayUtilities addAttributedText:[[NSString alloc] initWithFormat:@"%@%@", firstPart, secondPart] offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView]];
            [editView setSelectedRange:NSMakeRange(nPstn - 1, 0)];
        }
    }
}

- (void) forwardDelete
{
    NSInteger nPstn, eviewLength;
    NSString *firstPart, *secondPart;
    classDisplayUtilities *displayUtilities;

    displayUtilities = [[classDisplayUtilities alloc] init:globalVarsHebKeyboard];
    eviewLength = [[editView textStorage] length];
    if( eviewLength == 0) return;
    nPstn = [editView selectedRange].location;
    if( nPstn == eviewLength ) return;
    if( ( eviewLength == 1 ) && ( nPstn == 0 ))
    {
        [editView setString:@""];
        return;
    }
    if( nPstn == 0)
    {
        firstPart = [[NSString alloc] initWithString:[[editView string] substringFromIndex:1]];
        [editView setString:@""];
        [[editView textStorage] appendAttributedString:[displayUtilities addAttributedText:firstPart offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView]];
    }
    else
    {
        if( nPstn == eviewLength - 1 )
        {
            firstPart = [[NSString alloc] initWithString:[[editView string] substringToIndex:[[editView textStorage] length] - 2]];
            [editView setString:@""];
            [[editView textStorage] appendAttributedString:[displayUtilities addAttributedText:firstPart offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView]];
            [editView setSelectedRange:NSMakeRange(0, 0)];
        }
        else
        {
            firstPart = [[NSString alloc] initWithString:[[editView string] substringToIndex:nPstn]];
            secondPart = [[NSString alloc] initWithString:[[editView string] substringFromIndex:nPstn + 1]];
            [editView setString:@""];
            [[editView textStorage] appendAttributedString:[displayUtilities addAttributedText:[[NSString alloc] initWithFormat:@"%@%@", firstPart, secondPart] offsetCode:0 fontId:1 alignment:0 withAdjustmentFor:editView]];
            [editView setSelectedRange:NSMakeRange(nPstn, 0)];
        }
    }
}

-(void) doUse: (id) sender
{
    NSTextView *currentTextView;
    NSTextField *currentTextField;
    NSTabViewItem *targetTabItem;
    NSTabView *targetMainTab, *targetTab;
    
    targetTab = [globalVarsHebKeyboard tabBHSUtilityDetail];  //Bottom right tab area for BHS
    targetTabItem = [globalVarsHebKeyboard itemBHSNotes];
    currentTextView = [globalVarsHebKeyboard txtBHSNotes];
    [targetTab selectTabViewItemAtIndex:0];

    targetMainTab = [globalVarsHebKeyboard tabUtilities];
    [targetMainTab selectTabViewItemAtIndex:0];
    if( [rbtnBHSKbNotes state] == NSControlStateValueOn)
    {
        currentTextView = [globalVarsHebKeyboard txtBHSNotes];
        targetTab = [globalVarsHebKeyboard tabBHSUtilityDetail];
        [targetTab selectTabViewItemAtIndex:0];
        [[currentTextView textStorage] insertAttributedString:[editView textStorage] atIndex:[currentTextView selectedRange].location];
    }
    else
    {
        targetTab = [globalVarsHebKeyboard tabBHSUtilityDetail];
        [targetTab selectTabViewItemAtIndex:1];
        if( [rbtnBHSKbPrimary state] == NSControlStateValueOn)
        {
            currentTextField = [globalVarsHebKeyboard txtBHSPrimaryWord];
            [currentTextField setStringValue:[editView string]];
        }
        else
        {
            currentTextField = [globalVarsHebKeyboard txtBHSSecondaryWord];
            [currentTextField setStringValue:[editView string]];
            [[globalVarsHebKeyboard labBHSWordsOfLbl] setHidden:false];
            [[globalVarsHebKeyboard bhsSteps] setHidden:false];
            [[globalVarsHebKeyboard stepperBHSScan] setHidden:false];
            [[globalVarsHebKeyboard labBHSWithinLbl] setHidden:false];
            [[globalVarsHebKeyboard txtBHSSecondaryWord] setHidden:false];
            [[globalVarsHebKeyboard btnBHSAdvanced] setTitle:@"Basic Search"];
       }
    }
}

- (NSString *) removeAccents: (NSString *) sourceWord
{
    /*========================================================================================*
     *                                                                                        *
     *                                     removeAccents                                      *
     *                                     =============                                      *
     *                                                                                        *
     *  Purpose: to remove all except                                                         *
     *           a) core Hebrew characters                                                    *
     *           b) vowel pointing                                                            *
     *           c) sin/shin points                                                           *
     *           d) dagesh (forte and line)                                                   *
     *                                                                                        *
     *  Parameter:                                                                            *
     *  =========                                                                             *
     *                                                                                        *
     *  sourceWord   may be a word, sentence or entire verse, so can includes spaces.         *
     *                                                                                        *
     *========================================================================================*/

    NSInteger idx, wordLength;
    NSMutableString *resultingWord;

    resultingWord = [[NSMutableString alloc] initWithString:@""];
    wordLength = [sourceWord length];
    for (idx = 0; idx < wordLength; idx++)
    {
        // Is the character a standard Hebrew consonant?
        if (((NSInteger)[sourceWord characterAtIndex:idx] >= 0x5d0) && ((NSInteger)[sourceWord characterAtIndex:idx] <= 0x5ea))
        {
            [resultingWord appendString: [sourceWord substringWithRange:NSMakeRange(idx, 1)]];
            continue;
        }
        // Is the character a vowel or acceptable pointing character?
        if (((NSInteger)[sourceWord characterAtIndex:idx] >= 0x5b0) && ((NSInteger)[sourceWord characterAtIndex:idx] <= 0x5bc))
        {
            [resultingWord appendString: [sourceWord substringWithRange:NSMakeRange(idx, 1)]];
            continue;
        }
        // Is the character a sin/shin dot, end of verse Sof Pasuq or mark dot ?
        if (((NSInteger)[sourceWord characterAtIndex: idx] >= 0x5c1) && ((NSInteger)[sourceWord characterAtIndex: idx] <= 0x5c5))
        {
            [resultingWord appendString: [sourceWord substringWithRange:NSMakeRange(idx, 1)]];
            continue;
        }
        // Is the character a mappeq?
        if ((NSInteger)[sourceWord characterAtIndex:idx] == 0x05be)
        {
            [resultingWord appendFormat:@"%C", 0x05be];
            continue;
        }
        // Is the character a low order ASCII character, including space and non-break space
        if (((NSInteger)[sourceWord characterAtIndex:idx] >= 0x0020) & ((NSInteger)[sourceWord characterAtIndex:idx] <= 0x00a0))
        {
            [resultingWord appendString: [sourceWord substringWithRange:NSMakeRange(idx, 1)]];
            continue;
        }
        // Is the character a carriage return?
        if ([sourceWord characterAtIndex:idx] == '\n')
        {
            [resultingWord appendString: @"\n"];
            continue;
        }
    }
    return resultingWord;
}

@end
