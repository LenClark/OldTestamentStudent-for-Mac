//
//  classRegistry.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import "classRegistry.h"

@implementation classRegistry

BOOL isIniFile, isFound;
NSString *basePath, *initPath, *initFileName, *iniBackupFile, *initContents, *initKey, *fontName;
NSArray *font01, *font02, *additionalFont01, *additionalFont02, *notesDescriptors;
NSFileManager *fmInit;

classGlobal *globalVarsReg;

- (void) initialiseRegistry: (classGlobal *) passedConfig
{
    NSInteger defaultStyleCode;
    CGFloat defaultSmallFontSize, defaultLargeFontSize, sizeValue;
    NSString *defaultFileName, *iniFileContents, *initKey, *tempBase, *tempName, *tempStyle, *tempSize, *tempColour, *tempBgColour,
             *tempNotesPath, *tempBhsNotesFolder, *tempLxxNotesFolder, *tempBhsNotesName, *tempLxxNotesName;
    NSArray *iniFileLines, *lineContents;
    globalVarsReg = passedConfig;
    NSFileManager *fileManager;
    
    /*----------------------------------------------------------------------*
     *                                                                      *
     *             Initialise key variables with default values             *
     *                                                                      *
     *----------------------------------------------------------------------*/

    // Initialise the init.dat file
    defaultFileName = @"Times New Roman";
    defaultStyleCode = 0;
    defaultSmallFontSize = 16.0;
    defaultLargeFontSize = 24.0;
    font01 = [[NSArray alloc] initWithObjects:@"BHS English Text", @"LXX English Text", @"Parse Text", @"Lexicon Text", @"Search English Text", @"", @"BHS Notes Text", @"LXX Notes Text", @"Kethib Qere English", nil];
    font02 = [[NSArray alloc] initWithObjects:@"BHS Hebrew Text", @"LXX Greek Text", @"Parse Title", @"Lexicon Title", @"Search BHS Main Text", @"Search Greek Main Text", @"", @"", @"Kethib Qere Main", nil];
    additionalFont01 = [[NSArray alloc] initWithObjects:@"BHS Variant Text", @"", @"", @"Lexicon Heb and Aram", @"Search BHS Primary Match", @"Search Greek Primary Match", @"", @"", @"", nil];
    additionalFont02 = [[NSArray alloc] initWithObjects:@"", @"", @"", @"", @"Search BHS Secondary Match", @"Search Greek Secondary Match", @"", @"", @"", nil];
    notesDescriptors = [[NSArray alloc] initWithObjects:@"Notes Path", @"BHS Notes Name", @"LXX Notes Name", @"BHS Notes Folder", @"LXX Notes Folder", @"Specific BHS Folder", @"Specific LXX Folder", nil];
    fmInit = [NSFileManager defaultManager];
    basePath = @"Library/LFCConsulting/OTS";
    initPath = [[NSString alloc] initWithFormat:@"%@/%@", [fmInit homeDirectoryForCurrentUser], basePath];
    if( [initPath containsString:@"file:///"] ) initPath = [[NSString alloc] initWithString:[initPath substringFromIndex:7]];
    initFileName = [[NSString alloc] initWithFormat:@"%@/ini.dat", initPath];
    iniBackupFile = [[NSString alloc] initWithFormat:@"%@/ini.bak", initPath];
    tempNotesPath = @"";
    tempBhsNotesFolder = @"";
    tempLxxNotesFolder = @"";
    tempBhsNotesName = @"";
    tempLxxNotesName = @"";
    if( [fmInit fileExistsAtPath:initFileName]) isIniFile = true;
    else isIniFile = false;

    // Set default values of everything first
    [globalVarsReg setBhsTextEngName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setBhsTextMainName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setBhsTextVariantName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setLxxTextEngName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setLxxTextMainName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setParseTitleName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setParseTextName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setLexTitleName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setLexTextName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setLexPrimaryName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setSearchEngName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setSearchBHSMainName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setSearchBHSPrimaryName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setSearchBHSSecondaryName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setSearchGreekMainName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setSearchGreekPrimaryName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setSearchGreekSecondaryName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setBhsNotesFontName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setLxxNotesFontName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setKqEngName: [[NSString alloc] initWithString:defaultFileName]];
    [globalVarsReg setKqMainName: [[NSString alloc] initWithString:defaultFileName]];

    [globalVarsReg setBhsTextEngStyle: defaultStyleCode];
    [globalVarsReg setBhsTextMainStyle: defaultStyleCode];
    [globalVarsReg setBhsTextVariantStyle: defaultStyleCode];
    [globalVarsReg setLxxTextEngStyle: defaultStyleCode];
    [globalVarsReg setLxxTextMainStyle: defaultStyleCode];
    [globalVarsReg setParseTitleStyle: defaultStyleCode];
    [globalVarsReg setParseTextStyle: defaultStyleCode];
    [globalVarsReg setLexTitleStyle: defaultStyleCode];
    [globalVarsReg setLexTextStyle: defaultStyleCode];
    [globalVarsReg setLexPrimaryStyle: defaultStyleCode];
    [globalVarsReg setSearchEngStyle: defaultStyleCode];
    [globalVarsReg setSearchBHSMainStyle: defaultStyleCode];
    [globalVarsReg setSearchBHSPrimaryStyle: defaultStyleCode];
    [globalVarsReg setSearchBHSSecondaryStyle: defaultStyleCode];
    [globalVarsReg setSearchGreekMainStyle: defaultStyleCode];
    [globalVarsReg setSearchGreekPrimaryStyle: defaultStyleCode];
    [globalVarsReg setSearchGreekSecondaryStyle: defaultStyleCode];
    [globalVarsReg setBhsNotesStyle: defaultStyleCode];
    [globalVarsReg setLxxNotesStyle: defaultStyleCode];
    [globalVarsReg setKqEngStyle: defaultStyleCode];
    [globalVarsReg setKqMainStyle: defaultStyleCode];

    [globalVarsReg setBhsTextEngSize: defaultSmallFontSize];
    [globalVarsReg setBhsTextMainSize: defaultLargeFontSize];
    [globalVarsReg setBhsTextVariantSize: defaultLargeFontSize];
    [globalVarsReg setLxxTextEngSize: defaultSmallFontSize];
    [globalVarsReg setLxxTextMainSize: defaultSmallFontSize];
    [globalVarsReg setParseTitleSize: defaultLargeFontSize];
    [globalVarsReg setParseTextSize: defaultSmallFontSize];
    [globalVarsReg setLexTitleSize: defaultLargeFontSize];
    [globalVarsReg setLexTextSize: defaultSmallFontSize];
    [globalVarsReg setLexPrimarySize: defaultLargeFontSize];
    [globalVarsReg setSearchEngSize: defaultSmallFontSize];
    [globalVarsReg setSearchBHSMainSize: defaultLargeFontSize];
    [globalVarsReg setSearchBHSPrimarySize: defaultLargeFontSize];
    [globalVarsReg setSearchBHSSecondarySize: defaultLargeFontSize];
    [globalVarsReg setSearchGreekMainSize: defaultSmallFontSize];
    [globalVarsReg setSearchGreekPrimarySize: defaultSmallFontSize];
    [globalVarsReg setSearchGreekSecondarySize: defaultSmallFontSize];
    [globalVarsReg setBhsNotesSize: defaultSmallFontSize];
    [globalVarsReg setLxxNotesSize: defaultSmallFontSize];
    [globalVarsReg setKqEngSize: defaultSmallFontSize];
    [globalVarsReg setKqMainSize: defaultLargeFontSize];

    /*-----------------------------------------------------------------------------------------------------*
     *                                                                                                     *
     *  Colours  (group 14)                                                                                *
     *                                                                                                     *
     *    These follow the same pattern as fonts except we have one additional colour for each area, which *
     *      is the area background colour.                                                                 *
     *                                                                                                     *
     *-----------------------------------------------------------------------------------------------------*/

    [globalVarsReg setBhsTextEngColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setBhsTextMainColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setBhsTextVariantColour:[NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setBhsTextBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setLxxTextEngColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setLxxTextMainColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setLxxTextBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setParseTitleColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setParseTextColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setParseTextBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setLexTitleColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setLexTextColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setLexPrimaryColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setLexTextBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setSearchEngColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setSearchBHSMainColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setSearchBHSPrimaryColour:[NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setSearchBHSSecondaryColour:[NSColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setSearchBHSBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setSearchGreekMainColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setSearchGreekPrimaryColour:[NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setSearchGreekSecondaryColour:[NSColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setSearchGreekBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setBhsNotesColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setBhsNotesBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setLxxNotesColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setLxxNotesBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [globalVarsReg setKqEngColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setKqMainColour:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [globalVarsReg setKqBackgroundColour:[NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
    // Now check whether we have stored values
    if( isIniFile)
    {
        iniFileContents = [[NSString alloc] initWithContentsOfFile:initFileName encoding:NSUTF8StringEncoding error:nil];
        iniFileLines = [iniFileContents componentsSeparatedByString:@"\n"];
        /*-------------------------------------------------------------------------------------------------*
        *  Apologies for the following: it is inelegant and, with a bit of forethought, would have been   *
        *    easy to program but, having gone down a specific root, I didn't want a major re-write.       *
        *-------------------------------------------------------------------------------------------------*/
        for (NSString *individualLine in iniFileLines)
        {
            isFound = false;
            if(( individualLine == nil ) || ( [individualLine length] == 0 ) ) continue;
            lineContents = [individualLine componentsSeparatedByString:@"="];
            initKey = [[NSString alloc] initWithString:[lineContents objectAtIndex:0]];
            tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:0]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setBhsTextEngName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setBhsTextEngStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setBhsTextEngSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setBhsTextEngColour:[self setColourValue:lineContents]];
                if( [initKey compare:tempBgColour] == NSOrderedSame ) [globalVarsReg setBhsTextBackgroundColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:0]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setBhsTextMainName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setBhsTextMainStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setBhsTextMainSize:[self setFloatValue:lineContents]];

                if( [initKey compare:tempColour] == NSOrderedSame )
                {
                    NSColor *tempBGColour = [self setColourValue:lineContents];
                    [globalVarsReg setBhsTextMainColour:tempBGColour];
                }
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[additionalFont01 objectAtIndex:0]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setBhsTextVariantName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setBhsTextVariantStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setBhsTextVariantSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setBhsTextVariantColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:1]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setLxxTextEngName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setLxxTextEngStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setLxxTextEngSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setLxxTextEngColour:[self setColourValue:lineContents]];
                if( [initKey compare:tempBgColour] == NSOrderedSame ) [globalVarsReg setLxxTextBackgroundColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:1]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setLxxTextMainName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setLxxTextMainStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setLxxTextMainSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setLxxTextMainColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:2]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setParseTextName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setParseTextStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setParseTextSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setParseTextColour:[self setColourValue:lineContents]];
                if( [initKey compare:tempBgColour] == NSOrderedSame ) [globalVarsReg setParseTextBackgroundColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:2]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setParseTitleName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setParseTitleStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setParseTitleSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setParseTitleColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:3]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setLexTextName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setLexTextStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setLexTextSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setLexTextColour:[self setColourValue:lineContents]];
                if( [initKey compare:tempBgColour] == NSOrderedSame ) [globalVarsReg setLexTextBackgroundColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:3]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setLexTitleName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setLexTitleStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setLexTitleSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setLexTitleColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[additionalFont01 objectAtIndex:3]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setLexPrimaryName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setLexPrimaryStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setLexPrimarySize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setLexPrimaryColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:4]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setSearchEngName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setSearchEngStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setSearchEngSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setSearchEngColour:[self setColourValue:lineContents]];
                if( [initKey compare:tempBgColour] == NSOrderedSame ) [globalVarsReg setSearchBHSBackgroundColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:4]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setSearchBHSMainName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setSearchBHSMainStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setSearchBHSMainSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setSearchBHSMainColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[additionalFont01 objectAtIndex:4]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setSearchBHSPrimaryName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setSearchBHSPrimaryStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setSearchBHSPrimarySize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setSearchBHSPrimaryColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[additionalFont02 objectAtIndex:4]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setSearchBHSSecondaryName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setSearchBHSSecondaryStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setSearchBHSSecondarySize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setSearchBHSSecondaryColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:5]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setSearchGreekMainName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setSearchGreekMainStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setSearchGreekMainSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setSearchGreekMainColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[additionalFont01 objectAtIndex:5]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setSearchGreekPrimaryName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setSearchGreekPrimaryStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setSearchGreekPrimarySize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setSearchGreekPrimaryColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[additionalFont02 objectAtIndex:5]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setSearchGreekSecondaryName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setSearchGreekSecondaryStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setSearchGreekSecondarySize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setSearchGreekSecondaryColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:6]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setBhsNotesName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setBhsNotesStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setBhsNotesSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setBhsNotesColour:[self setColourValue:lineContents]];
                if( [initKey compare:tempBgColour] == NSOrderedSame ) [globalVarsReg setBhsNotesBackgroundColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:7]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setLxxNotesName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setLxxNotesStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setLxxNotesSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setLxxNotesColour:[self setColourValue:lineContents]];
                if( [initKey compare:tempBgColour] == NSOrderedSame ) [globalVarsReg setLxxNotesBackgroundColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:8]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setKqEngName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setKqEngStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setKqEngSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setKqEngColour:[self setColourValue:lineContents]];
                if( [initKey compare:tempBgColour] == NSOrderedSame ) [globalVarsReg setKqBackgroundColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:8]];
            if( [tempBase length] > 0)
            {
                tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
                tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
                tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
                tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
                if( [initKey compare:tempName] == NSOrderedSame ) [globalVarsReg setKqMainName:[self setStringValue:lineContents]];
                if( [initKey compare:tempStyle] == NSOrderedSame ) [globalVarsReg setKqMainStyle:[self setIntegerValue:lineContents]];
                if( [initKey compare:tempSize] == NSOrderedSame ) [globalVarsReg setKqMainSize:[self setFloatValue:lineContents]];
                if( [initKey compare:tempColour] == NSOrderedSame ) [globalVarsReg setKqMainColour:[self setColourValue:lineContents]];
            }
            if( isFound) continue;
            if( [initKey compare:[notesDescriptors objectAtIndex:0]] == NSOrderedSame) [globalVarsReg setNotesPath:[self setStringValue:lineContents]];
            if( isFound) continue;
            if( [initKey compare:[notesDescriptors objectAtIndex:1]] == NSOrderedSame) [globalVarsReg setBhsNotesName:[self setStringValue:lineContents]];
            if( isFound) continue;
            if( [initKey compare:[notesDescriptors objectAtIndex:2]] == NSOrderedSame) [globalVarsReg setLxxNotesName:[self setStringValue:lineContents]];
            if( isFound) continue;
            if( [initKey compare:[notesDescriptors objectAtIndex:3]] == NSOrderedSame) [globalVarsReg setBhsNotesFolder:[self setStringValue:lineContents]];
            if( isFound) continue;
            if( [initKey compare:[notesDescriptors objectAtIndex:4]] == NSOrderedSame) [globalVarsReg setLxxNotesFolder:[self setStringValue:lineContents]];
            if( isFound) continue;
            if( [initKey compare:[notesDescriptors objectAtIndex:5]] == NSOrderedSame) [globalVarsReg setSpecificBHSNoteFolder:[self setStringValue:lineContents]];
            if( isFound) continue;
            if( [initKey compare:[notesDescriptors objectAtIndex:6]] == NSOrderedSame) [globalVarsReg setSpecificLXXNoteFolder:[self setStringValue:lineContents]];
            if( isFound) continue;
            if( [initKey compare:@"Window Left"] == NSOrderedSame )
            {
                sizeValue = [[lineContents objectAtIndex:1] floatValue];
                [[globalVarsReg mainWindow] setFrameOrigin:NSMakePoint(sizeValue, [[globalVarsReg mainWindow] frame].origin.y)];
            }
            if( [initKey compare:@"Window Top"] == NSOrderedSame )
            {
                sizeValue = [[lineContents objectAtIndex:1] floatValue];
                [[globalVarsReg mainWindow] setFrameOrigin:NSMakePoint([[globalVarsReg mainWindow] frame].origin.x, sizeValue)];
            }
            if( [initKey compare:@"Window Height"] == NSOrderedSame )
            {
                sizeValue = [[lineContents objectAtIndex:1] floatValue];
                [[globalVarsReg mainWindow] setFrame:NSMakeRect([[globalVarsReg mainWindow] frame].origin.x, [[globalVarsReg mainWindow] frame].origin.y, [[globalVarsReg mainWindow] frame].size.width, sizeValue) display:YES];
            }
            if( [initKey compare:@"Window Width"] == NSOrderedSame )
            {
                sizeValue = [[lineContents objectAtIndex:1] floatValue];
                [[globalVarsReg mainWindow] setFrame:NSMakeRect([[globalVarsReg mainWindow] frame].origin.x, [[globalVarsReg mainWindow] frame].origin.y, sizeValue, [[globalVarsReg mainWindow] frame].size.height) display:YES];
            }
            if( [initKey compare:@"Divider"] == NSOrderedSame )
            {
                sizeValue = [[lineContents objectAtIndex:1] floatValue];
                [[globalVarsReg splitMain] setPosition:sizeValue ofDividerAtIndex:0];
            }
        }
    }
    [globalVarsReg reformAllFonts];
    if( [[globalVarsReg notesPath] length] == 0 ) [globalVarsReg setNotesPath:[[NSString alloc] initWithFormat:@"%@/Notes", initPath]];
    if( [[globalVarsReg bhsNotesName] length] == 0 ) [globalVarsReg setBhsNotesName:@"default"];
    if( [[globalVarsReg lxxNotesName] length] == 0 ) [globalVarsReg setLxxNotesName:@"default"];
    if( [[globalVarsReg bhsNotesFolder] length] == 0 ) [globalVarsReg setBhsNotesFolder:@"default"];
    if( [[globalVarsReg lxxNotesFolder] length] == 0 ) [globalVarsReg setLxxNotesFolder:@"default"];
    fileManager = [NSFileManager defaultManager];
    tempBhsNotesFolder = [[NSString alloc] initWithFormat:@"%@/Notes/BHS", [globalVarsReg iniPath]];
    tempLxxNotesFolder = [[NSString alloc] initWithFormat:@"%@/Notes/LXX", [globalVarsReg iniPath]];
    if( ! [fileManager fileExistsAtPath:tempBhsNotesFolder] ) [fileManager createDirectoryAtPath:tempBhsNotesFolder withIntermediateDirectories:YES attributes:nil error:nil];
    if( ! [fileManager fileExistsAtPath:tempLxxNotesFolder] ) [fileManager createDirectoryAtPath:tempLxxNotesFolder withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void) saveIniValues
{
    NSString *tempBase, *tempName, *tempStyle, *tempSize, *tempColour, *tempBgColour;
    NSMutableString *initFileContents;
    NSError *error;
    NSWindow *masterWindow;
    classAlert *alert;
    
    initFileContents = [[NSMutableString alloc] initWithString:@""];
    tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:0]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
        [initFileContents appendFormat:@"%@=%@", tempName, [globalVarsReg bhsTextEngName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg bhsTextEngStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg bhsTextEngSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg bhsTextEngColour]]];
        [initFileContents appendFormat:@"\n%@=%@", tempBgColour, [self encodeColourValue:[globalVarsReg bhsTextBackgroundColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:0]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg bhsTextMainName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg bhsTextMainStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg bhsTextMainSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg bhsTextMainColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[additionalFont01 objectAtIndex:0]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg bhsTextVariantName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg bhsTextVariantStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg bhsTextVariantSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg bhsTextVariantColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:1]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg lxxTextEngName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg lxxTextEngStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg lxxTextEngSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg lxxTextEngColour]]];
        [initFileContents appendFormat:@"\n%@=%@", tempBgColour, [self encodeColourValue:[globalVarsReg lxxTextBackgroundColour]]];

    }
    tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:1]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg lxxTextMainName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg lxxTextMainStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg lxxTextMainSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg lxxTextMainColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:2]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg parseTextName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg parseTextStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg parseTextSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg parseTextColour]]];
        [initFileContents appendFormat:@"\n%@=%@", tempBgColour, [self encodeColourValue:[globalVarsReg parseTextBackgroundColour]]];

    }
    tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:2]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg parseTitleName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg parseTitleStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg parseTitleSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg parseTitleColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:3]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg lexTextName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg lexTextStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg lexTextSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg lexTextColour]]];
        [initFileContents appendFormat:@"\n%@=%@", tempBgColour, [self encodeColourValue:[globalVarsReg lexTextBackgroundColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:3]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg lexTitleName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg lexTitleStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg lexTitleSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg lexTitleColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[additionalFont01 objectAtIndex:3]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg lexPrimaryName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg lexPrimaryStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg lexPrimarySize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg lexPrimaryColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:4]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg searchEngName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg searchEngStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg searchEngSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg searchEngColour]]];
        [initFileContents appendFormat:@"\n%@=%@", tempBgColour, [self encodeColourValue:[globalVarsReg searchBHSBackgroundColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:4]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg searchBHSMainName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg searchBHSMainStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg searchBHSMainSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg searchBHSMainColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[additionalFont01 objectAtIndex:4]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg searchBHSPrimaryName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg searchBHSPrimaryStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg searchBHSPrimarySize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg searchBHSPrimaryColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[additionalFont02 objectAtIndex:4]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg searchBHSSecondaryName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg searchBHSSecondaryStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg searchBHSSecondarySize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg searchBHSSecondaryColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:5]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg searchGreekMainName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg searchGreekMainStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg searchGreekMainSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg searchGreekMainColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[additionalFont01 objectAtIndex:5]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg searchGreekPrimaryName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg searchGreekPrimaryStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg searchGreekPrimarySize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg searchGreekPrimaryColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[additionalFont02 objectAtIndex:5]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg searchGreekSecondaryName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg searchGreekSecondaryStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg searchGreekSecondarySize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg searchGreekSecondaryColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:6]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg bhsNotesName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg bhsNotesStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg bhsNotesSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg bhsNotesColour]]];
        [initFileContents appendFormat:@"\n%@=%@", tempBgColour, [self encodeColourValue:[globalVarsReg bhsNotesBackgroundColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:7]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg lxxNotesName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg lxxNotesStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg lxxNotesSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg lxxNotesColour]]];
        [initFileContents appendFormat:@"\n%@=%@", tempBgColour, [self encodeColourValue:[globalVarsReg lxxNotesBackgroundColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font01 objectAtIndex:8]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        tempBgColour = [[NSString alloc] initWithFormat:@"%@ Background", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg kqEngName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg kqEngStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg kqEngSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg kqEngColour]]];
        [initFileContents appendFormat:@"\n%@=%@", tempBgColour, [self encodeColourValue:[globalVarsReg kqBackgroundColour]]];
    }
    tempBase = [[NSString alloc] initWithString:[font02 objectAtIndex:8]];
    if( [tempBase length] > 0)
    {
        tempName = [[NSString alloc] initWithFormat:@"%@ Name", tempBase];
        tempStyle = [[NSString alloc] initWithFormat:@"%@ Style", tempBase];
        tempSize = [[NSString alloc] initWithFormat:@"%@ Size", tempBase];
        tempColour = [[NSString alloc] initWithFormat:@"%@ Colour", tempBase];
        [initFileContents appendFormat:@"\n%@=%@", tempName, [globalVarsReg kqMainName]];
        [initFileContents appendFormat:@"\n%@=%@", tempStyle, [globalVarsReg convertIntegerToString:[globalVarsReg kqMainStyle]]];
        [initFileContents appendFormat:@"\n%@=%@", tempSize, [globalVarsReg convertIntegerToString:(NSInteger)[globalVarsReg kqMainSize]]];
        [initFileContents appendFormat:@"\n%@=%@", tempColour, [self encodeColourValue:[globalVarsReg kqMainColour]]];
    }
    // Now save Notes information
    masterWindow = [globalVarsReg mainWindow];
    [initFileContents appendFormat:@"\nWindow Left=%f", [masterWindow frame].origin.x];
    [initFileContents appendFormat:@"\nWindow Top=%f", [masterWindow frame].origin.y];
    [initFileContents appendFormat:@"\nWindow Height=%f", [masterWindow frame].size.height];
    [initFileContents appendFormat:@"\nWindow Width=%f", [masterWindow frame].size.width];
    [initFileContents appendFormat:@"\nDivider=%f", [[[[globalVarsReg splitMain] arrangedSubviews] objectAtIndex:0] frame].size.width];
    
    [initFileContents appendFormat:@"\n%@=%@", [notesDescriptors objectAtIndex:0], [globalVarsReg notesPath]];
    [initFileContents appendFormat:@"\n%@=%@", [notesDescriptors objectAtIndex:1], [globalVarsReg bhsNotesName]];
    [initFileContents appendFormat:@"\n%@=%@", [notesDescriptors objectAtIndex:2], [globalVarsReg lxxNotesName]];
    [initFileContents appendFormat:@"\n%@=%@", [notesDescriptors objectAtIndex:3], [globalVarsReg bhsNotesFolder]];
    [initFileContents appendFormat:@"\n%@=%@", [notesDescriptors objectAtIndex:4], [globalVarsReg lxxNotesFolder]];
    [initFileContents appendFormat:@"\n%@=%@", [notesDescriptors objectAtIndex:5], [globalVarsReg specificBHSNoteFolder]];
    [initFileContents appendFormat:@"\n%@=%@", [notesDescriptors objectAtIndex:6], [globalVarsReg specificLXXNoteFolder]];

    // Now save sizing data
    alert = [[classAlert alloc] init];
    if( [fmInit fileExistsAtPath:iniBackupFile])
    {
        [fmInit removeItemAtPath:iniBackupFile error:&error];
        if( [[error localizedDescription] length] > 0) [alert messageBox:[error localizedDescription] title:@"File Deletion Error" boxStyle:NSAlertStyleWarning];

    }
    if( [fmInit fileExistsAtPath:initFileName])
    {
        [fmInit moveItemAtPath:initFileName toPath:iniBackupFile error:&error];
        if( [[error localizedDescription] length] > 0) [alert messageBox:[error localizedDescription] title:@"File Move Error" boxStyle:NSAlertStyleWarning];
    }
//    [fmInit createFileAtPath:initFileName contents:nil attributes:nil];
    if( ! [initFileContents writeToFile:initFileName atomically:YES encoding:NSUTF8StringEncoding error:&error] ) [alert messageBox:[error localizedDescription] title:@"File Creation Error" boxStyle:NSAlertStyleWarning];
}

- (NSString *) setStringValue: (NSArray *) lineEntry
{
    isFound = true;
    return [[NSString alloc] initWithString:[lineEntry objectAtIndex:1]];
}

- (NSInteger) setIntegerValue: (NSArray *) lineEntry
{
    isFound = true;
    return [[[NSString alloc] initWithString:[lineEntry objectAtIndex:1]] integerValue];
}

- (CGFloat) setFloatValue: (NSArray *) lineEntry
{
    isFound = true;
    return [[[NSString alloc] initWithString:[lineEntry objectAtIndex:1]] integerValue];
}

- (NSColor *) setColourValue: (NSArray *) lineEntry
{
    NSArray *colourComponants;
    
    isFound = true;
    colourComponants = [[lineEntry objectAtIndex:1] componentsSeparatedByString:@"|"];
    return [NSColor colorWithRed:[[colourComponants objectAtIndex:0] floatValue] green:[[colourComponants objectAtIndex:1] floatValue] blue:[[colourComponants objectAtIndex:2] floatValue] alpha:1.0];
}

- (NSString *) encodeColourValue: (NSColor *) sourceColour
{
    CGFloat red, green, blue, alpha;

    [sourceColour getRed:&red green:&green blue:&blue alpha:&alpha];
    return [[NSString alloc] initWithFormat:@"%f|%f|%f|%f", red, green, blue, alpha];
}

@end
