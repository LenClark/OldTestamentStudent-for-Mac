//
//  classKeyboard.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 10/01/2021.
//

#import "classKeyboard.h"

@implementation classKeyboard

NSArray *keyToolTip, *buttonObjects, *keyboardConversion, *keyboardChars;
NSView *keyboardView;
NSBox *targetBox;
NSButton *rbtnNotes;
NSButton *rbtnPrimary;
NSButton *rbtnSecondary;
classConfig *globalVarsKeyboard;
classGreekProcessing *gkProcessingKeyboard;

- (id) init: (classConfig *) inConfig greekInfo: (classGreekProcessing *) inGreek
{
    const NSInteger xmax = 37, keyWidth = 25, keyHeight = 28;
    const NSNumber *nsKeyWidth = @25;

    NSInteger idx, lineNo = 0, xPstn, yPstn, thisLineLen, currXStart, gkRepresentation, boxLeft, boxTop, boxHeight;
    NSString *buttonText;
    NSArray *keySizes, *lineLengths;
    NSMutableArray *interimButtonArray;

    if( self = [super init])
    {
        globalVarsKeyboard = inConfig;
        gkProcessingKeyboard = inGreek;
        keyboardView = [globalVarsKeyboard keyboardView];
        
        interimButtonArray = [[NSMutableArray alloc] init];
        keyboardChars = [[NSArray alloc]initWithObjects:@0x03c2, @0x03b5, @0x03c1, @0x03c4, @0x03c5, @0x03b8, @0x03b9, @0x03bf, @0x03c0, @0x0314, @0x0313,
                                   @0x03b1, @0x03c3, @0x03b4, @0x03c6, @0x03b3, @0x03b7, @0x03be, @0x03ba, @0x03bb, @0x0308, @0x0345,
                                   @0x03b6, @0x03c7, @0x03c8, @0x03c9, @0x03b2, @0x03bd, @0x03bc, @0, @1,
                                   @2, @3, @4, @0x0300, @0x0301, @0x0342, @0x03a3, @0x0395, @0x03a1, @0x03a4, @0x03a5, @0x0398, @0x0399, @0x039f, @0x03a0, @0x0314, @0x0313,
                                   @0x0391, @0x03a3, @0x0394, @0x03a6, @0x0393, @0x0397, @0x039e, @0x039a, @0x0399, @0x0308, @0x0345,
                                   @0x0396, @0x03a7, @0x03a8, @0x03a9, @0x0392, @0x039d, @0x039a, @0, @1,
                                   @2, @3, @4, @0x0300, @0x0301, @0x0342,nil];
        keyboardConversion = [[NSArray alloc]initWithObjects:@"Shift", @"Cap", @"Tab", @"Space", @"Bsp", nil];
        keySizes = [[NSArray alloc]initWithObjects:nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth,
                               nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth,
                               nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, nsKeyWidth, [NSNumber numberWithInteger:keyWidth * 2], [NSNumber numberWithInteger:keyWidth * 2],
                               [NSNumber numberWithInteger:keyWidth * 2], [NSNumber numberWithInteger:keyWidth * 5], [NSNumber numberWithInteger:keyWidth * 2], nsKeyWidth, nsKeyWidth, nsKeyWidth, nil];
        lineLengths = [[NSArray alloc]initWithObjects:[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:11], [NSNumber numberWithInteger:22], [NSNumber numberWithInteger:31], [NSNumber numberWithInteger:37], nil];
        keyToolTip = [[NSArray alloc]initWithObjects:@"Final sigma", @"Epsilon", @"Rho", @"Tau", @"Upsilon", @"Theta", @"Iota", @"Omicron", @"Pi", @"Rough Breathing", @"Smooth Breathing",
                       @"Alpha", @"Sigma", @"Delta", @"Phi", @"Gamma", @"Eta", @"Xi", @"Kappa", @"Lambda", @"Diaeresis", @"Iota subscript",
                       @"Zeta", @"Chi", @"Psi", @"Omega", @"Beta", @"Nu", @"Mu", @"Shift", @"Caps Lock",
                       @"Tab", @"Space", @"Backspace", @"Varia (Grave accent)", @"Oxia (Accute accent)", @"Perispomeni (Circumflex)", nil];

        thisLineLen = 0;
        idx = 0;
        xPstn = yPstn = currXStart = 0;
        while (idx < xmax )
        {
            if( idx == thisLineLen )
            {
                lineNo++;
                xPstn = 0;
                yPstn = 165 - ( keyHeight +2 ) * lineNo;
                currXStart = 45;
                thisLineLen = (int)[lineLengths[lineNo] integerValue];
            }
            NSButton *currButton = [[NSButton alloc] initWithFrame:NSMakeRect( currXStart, yPstn, (int)[keySizes[idx] integerValue], keyHeight )];
            [interimButtonArray setObject:currButton atIndexedSubscript:idx];
            [keyboardView addSubview:currButton];
            gkRepresentation = [keyboardChars[idx] integerValue];
            if( gkRepresentation < 10) buttonText = [[NSString alloc] initWithString:[keyboardConversion objectAtIndex:gkRepresentation]];
            else buttonText = [[NSString alloc] initWithFormat:@"%C", (unichar)gkRepresentation];
            [currButton setTitle: buttonText];
            [currButton setTag:idx];
            [currButton setToolTip:keyToolTip[idx]];
            [currButton setTarget:self];
            [currButton setAction:@selector(virtualKeyPress:)];
            currXStart += (int)[keySizes[idx] integerValue] + 2;
            
            xPstn++;
            idx++;
        }
        buttonObjects = [[NSArray alloc] initWithArray:interimButtonArray];
        
        boxLeft = 11 * keyWidth + 120;
        boxTop = 85;
        boxHeight = 92;
        targetBox = [[NSBox alloc] initWithFrame:NSMakeRect( boxLeft, boxTop, 250, boxHeight )];
        [targetBox setTitle:@"Where your keystrokes will go: "];
        [targetBox setFillColor:[NSColor redColor]];
        [keyboardView addSubview:targetBox];
        rbtnNotes = [globalVarsKeyboard rbtnNotes];
        rbtnPrimary = [globalVarsKeyboard rbtnPrimary];
        rbtnSecondary = [globalVarsKeyboard rbtnSecondary];
        [rbtnNotes setFrame:NSMakeRect(4, 48, 200, 18)];
        [rbtnPrimary setFrame:NSMakeRect(4, 26, 200, 18)];
        [rbtnSecondary setFrame:NSMakeRect(4, 4, 200, 18)];
        [rbtnNotes setButtonType:NSButtonTypeRadio];
        [rbtnPrimary setButtonType:NSButtonTypeRadio];
        [rbtnSecondary setButtonType:NSButtonTypeRadio];
        [rbtnNotes setTitle:@"Notes Area"];
        [rbtnPrimary setTitle:@"Primary Search Text Field"];
        [rbtnSecondary setTitle:@"Secondary Search Text Field"];
        [rbtnNotes setState:NSControlStateValueOn];
        [rbtnNotes setTarget:self];
        [rbtnNotes setAction:@selector(radioButtonHandler:)];
        [rbtnPrimary setTarget:self];
        [rbtnPrimary setAction:@selector(radioButtonHandler:)];
        [rbtnSecondary setTarget:self];
        [rbtnSecondary setAction:@selector(radioButtonHandler:)];
        [targetBox addSubview:rbtnNotes];
        [targetBox addSubview:rbtnPrimary];
        [targetBox addSubview:rbtnSecondary];
    }
    return self;
}


-(void) virtualKeyPress: (id) sender
{
    static bool isShiftPressed = false, isCapPressed = false;
    NSUInteger cursorPstn;
    NSInteger tagVal;
    NSString *searchTextSoFar;
    NSRange searchRange;
    NSButton *rbNotes, *rbMainSearch, *rbSecondarySearch;
    NSTextView *currentTextView;
    NSTabView *notesAndSearch;
    classReturnedModifiedText *modifiedText;
    
    rbNotes = [globalVarsKeyboard rbtnNotes];
    rbMainSearch = [globalVarsKeyboard rbtnPrimary];
    rbSecondarySearch = [globalVarsKeyboard rbtnSecondary];
    notesAndSearch = [globalVarsKeyboard bottomRightTabView];
    if( rbNotes.state == NSControlStateValueOn )
    {
        currentTextView = [globalVarsKeyboard notesTextView];
        [notesAndSearch selectTabViewItemAtIndex:0];
    }
    else
    {
        if( [rbMainSearch state] == NSControlStateValueOn ) currentTextView = [globalVarsKeyboard primarySearchWord];
        else currentTextView = [globalVarsKeyboard secondarySearchWord];
        [notesAndSearch selectTabViewItemAtIndex:2];
    }
    // tagVal identifies the Virtual key that has been "pressed"
    tagVal = [sender tag];
    searchTextSoFar = [currentTextView string];
    searchRange = [currentTextView selectedRange];
    cursorPstn = searchRange.location;
    switch (tagVal)
    {
        case 0:
            if( isShiftPressed || isCapPressed ) break;
            modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:nil addChar:[sender title]];
            //[NSString stringWithFormat:@"%@%@", searchTextSoFar, [sender title]];
            if( isShiftPressed )
            {
                [self reDisplayKeyboard:isShiftPressed | isCapPressed];
                isShiftPressed = false;
            }
            break;
        case 9: modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:[gkProcessingKeyboard addRoughBreathing] addChar:nil]; // Rough Breathing
            break;
        case 10: modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:[gkProcessingKeyboard addSmoothBreathing] addChar:nil]; // Smooth Breathing
            break;
        case 20: modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:[gkProcessingKeyboard addDiaeresis] addChar:nil]; // Diaeresis
            break;
        case 21: modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:[gkProcessingKeyboard addIotaSub] addChar:nil]; //Iota Subscript
            break;
        case 34: modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:[gkProcessingKeyboard addGrave] addChar:nil]; //Grave accent
            break;
        case 35: modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:[gkProcessingKeyboard addAccute] addChar:nil]; //Acute accent
            break;
        case 36: modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:[gkProcessingKeyboard addCirc] addChar:nil]; // Circumflex
            break;
        case 29:
            if( isCapPressed ) break;
            isShiftPressed = [self reDisplayKeyboard:isShiftPressed];
            break;
        case 30:
            isCapPressed = [self reDisplayKeyboard:isCapPressed];
            break;
        case 31:   //Tab
            break;
        case 32:
            modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:nil addChar:@" "];
            break;
        case 33:
            if( [searchTextSoFar length] == 0 ) break;
            currentTextView.string = [currentTextView.string substringToIndex:[searchTextSoFar length] - 1];
            break;
        default:
            modifiedText = [self reviseSearchString: searchTextSoFar atCursorPosition:cursorPstn forAction:nil addChar:[sender title]];
//            [currentTextView setString:[modifiedText returnedText]];
//            [currentTextView setSelectedRange:NSMakeRange([modifiedText newCursorPosition], 0)];
            if( isShiftPressed )
            {
                [self reDisplayKeyboard:isShiftPressed | isCapPressed];
                isShiftPressed = false;
            }
            break;
    }
    [currentTextView setString:[modifiedText returnedText]];
    [currentTextView setSelectedRange:NSMakeRange([modifiedText newCursorPosition], 0)];
}

-(classReturnedModifiedText *) reviseSearchString: (NSString *) sourceString atCursorPosition: (NSUInteger) Pstn forAction: (NSMutableDictionary *) actionArray addChar: (NSString *) addChar
{
    /************************************************************************************************************************************
     *                                                                                                                                  *
     *  The method effectively handles two, distinct scenarios:                                                                         *
     *                                                                                                                                  *
     *  1. Where special characters have been selected (such as breathings and accents) that change the preceeding character, and       *
     *  2. The management of normally added characters                                                                                  *
     *                                                                                                                                  *
     *  If addChar is nil, we are in scenario 1; otherwise, scenario 2.                                                                 *
     *                                                                                                                                  *
     *  The greatest challenge is that the process must account for the fact that the caret might be other than at the end of the       *
     *    string being entered.                                                                                                         *
     *                                                                                                                                  *
     *  sourceString   The total string being referenced (which may be nil or have zero length);                                        *
     *  Pstn           The zero-based reference to the position of the caret in the string                                              *
     *  actionArray    The dictionary that provides from-to data for the non-alphabet characters                                        *
     *                                                                                                                                  *
     ************************************************************************************************************************************/
    
    unichar singleChar;
    NSInteger derivedVal;
    NSNumber *lastCharVal, *outNumber;
    NSString *lastChar, *nextChar;
    NSRange tmpRange;
    classReturnedModifiedText *modifiedTextRecord;
    
    modifiedTextRecord = [classReturnedModifiedText new];
    if( Pstn > 0 )
    {
        if( addChar == nil )
        {
            // It's a special character
            // We are provided the current caret position, so we can find the previously "printed" character
            singleChar = [sourceString characterAtIndex:Pstn - 1];
            lastChar = [NSString stringWithFormat:@"%C", singleChar];
            lastCharVal = [NSNumber numberWithInt:singleChar];
            // Now retrieve the character transformed by the new key press
            outNumber = [actionArray objectForKey:lastCharVal];
            derivedVal = [outNumber intValue];
            nextChar = [[NSString alloc] initWithFormat:@"%C",(unichar)derivedVal ];
            if( ( nextChar != nil ) && ( [nextChar length] > 0 ) )
            {
                if ( Pstn == 1 )
                {
                    modifiedTextRecord.returnedText = [[NSString alloc] initWithFormat:@"%@%@", nextChar, [sourceString substringFromIndex:1] ];
                }
                else
                {
                    if( Pstn == [sourceString length] )
                    {
                        modifiedTextRecord.returnedText = [[NSString alloc] initWithFormat:@"%@%@", [sourceString substringToIndex:Pstn - 1], nextChar];
                    }
                    else
                    {
                        modifiedTextRecord.returnedText = [[NSString alloc] initWithFormat:@"%@%@%@", [sourceString substringToIndex:Pstn - 1], nextChar,
                                           [sourceString substringFromIndex:Pstn]];
                    }
                }
                tmpRange = NSMakeRange(Pstn, 0);
                modifiedTextRecord.newCursorPosition = tmpRange.location;
            }
        }
        else
        {
            if( Pstn == [sourceString length] )
            {
                modifiedTextRecord.returnedText = [NSString stringWithFormat:@"%@%@", sourceString, addChar];
            }
            else
            {
                modifiedTextRecord.returnedText = [NSString stringWithFormat:@"%@%@%@", [sourceString substringToIndex:Pstn], addChar,
                                   [sourceString substringFromIndex:Pstn]];
            }
            tmpRange = NSMakeRange(Pstn + 1, 0);
            modifiedTextRecord.newCursorPosition = tmpRange.location;
        }
    }
    else
    {
        modifiedTextRecord.returnedText = addChar;
        modifiedTextRecord.newCursorPosition = 1;
    }
    return modifiedTextRecord;
}

- (bool) reDisplayKeyboard: (bool) isShifted
{
    const NSInteger lcmax = 36, ucmax = 72;
    
    bool returnBool;
    NSInteger gkRepresentation;
    NSUInteger idx, idxMax, buttonIdx;
    NSString *buttonText;
    NSButton *currButton;
    
    if( isShifted )
    {
        returnBool = false;
        idx = 0;
        idxMax = lcmax;
    }
    else
    {
        returnBool = true;
        idx = lcmax + 1;
        idxMax = ucmax;
    }
    buttonIdx = 0;
    while (idx <= idxMax )
    {
        currButton = [buttonObjects objectAtIndex:buttonIdx];
        gkRepresentation = [keyboardChars[idx] integerValue];
        if( gkRepresentation < 10) buttonText = [[NSString alloc] initWithString:[keyboardConversion objectAtIndex:gkRepresentation]];
        else buttonText = [[NSString alloc] initWithFormat:@"%C", (unichar)gkRepresentation];
        [currButton setTitle: buttonText];
        buttonIdx++;
        idx++;
    }
    return returnBool;
}

-(void) radioButtonHandler: (id) sender
{
    
}

@end
