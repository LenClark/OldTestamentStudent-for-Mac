//
//  classRegistry.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 06/01/2021.
//

#import "classRegistry.h"

@implementation classRegistry

classConfig *globalVarsReg;

- (id) init: (classConfig *) passedConfig
{
    BOOL isDir;
    NSInteger idx, noOfTextAreas, mainX, mainY, mainWidth, mainHeight;
    CGFloat mainDivider;
    NSString *initFileName, *initContents, *initKey, *fontName;
    NSArray *fileLines, *lineContent;
    NSTextView *currentTextView;
    NSFont *currentFont;
    NSFileManager *fmInit;
    NSNumber *ntFontSize;
    NSColor *ntFgColour;
    NSColor *ntBgColour;
    NSNumber *lxxFontSize;
    NSColor *lxxFgColour;
    NSColor *lxxBgColour;
    NSNumber *parseFontSize;
    NSColor *parseFgColour;
    NSColor *parseBgColour;
    NSNumber *lexFontSize;
    NSColor *lexFgColour;
    NSColor *lexBgColour;
    NSNumber *searchFontSize;
    NSColor *searchFgColour;
    NSColor *searchBgColour;
    NSColor *searchPrimaryColour;
    NSColor *searchSecondaryColour;
    NSNumber *vocabFontSize;
    NSColor *vocabFgColour;
    NSColor *vocabBgColour;
    NSNumber *notesFontSize;
    NSColor *notesFgColour;
    NSColor *notesBgColour;

    if( self = [super init])
    {
        globalVarsReg = passedConfig;
        
        /*----------------------------------------------------------------------*
         *                                                                      *
         *             Initialise key variables with default values             *
         *                                                                      *
         *----------------------------------------------------------------------*/

        // Initialise the init.dat file
        isDir = true;
        fmInit = [NSFileManager defaultManager];
        initFileName = [[NSString alloc] initWithString:[globalVarsReg iniFile]];
        isDir = false;
        mainX = -1;
        mainY = -1;
        mainWidth = -1;
        mainHeight = -1;
        mainDivider = -1;

        /*---------------------------------------------------------------------------------
         *
         *    Create default values *before* getting modified versions from the init file
         *
         */
        
        globalVarsReg.notesFolder = [[NSString alloc] initWithFormat:@"%@/notes", [globalVarsReg iniPath]];
        globalVarsReg.notesName = @"default";
        ntFontSize = @12;
        lxxFontSize = @12;
        parseFontSize = @12;
        lexFontSize = @12;
        searchFontSize = @12;
        vocabFontSize = @12;
        notesFontSize = @12;
        ntFgColour = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
        lxxFgColour = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
        parseFgColour = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
        lexFgColour = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
        searchFgColour = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
        searchPrimaryColour = [NSColor colorWithRed:1 green:0 blue:0 alpha:1];
        searchSecondaryColour = [NSColor colorWithRed:0 green:0 blue:1 alpha:1];
        vocabFgColour = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
        notesFgColour = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
        ntBgColour = [NSColor colorWithRed:1 green:1 blue:1 alpha:1];
        lxxBgColour = [NSColor colorWithRed:1 green:1 blue:1 alpha:1];
        parseBgColour = [NSColor colorWithRed:1 green:1 blue:1 alpha:1];
        lexBgColour = [NSColor colorWithRed:1 green:1 blue:1 alpha:1];
        searchBgColour = [NSColor colorWithRed:1 green:1 blue:1 alpha:1];
        vocabBgColour = [NSColor colorWithRed:1 green:1 blue:1 alpha:1];
        notesBgColour = [NSColor colorWithRed:1 green:1 blue:1 alpha:1];
        
        /*---------------------------------------------------------------------------------
         *
         *    Now modify stored values from the init.dat file
         *
         */
        
        if( [fmInit fileExistsAtPath:initFileName isDirectory:&isDir])
        {
            initContents = [[NSString alloc] initWithContentsOfFile:initFileName encoding:NSUTF8StringEncoding error:nil];
            fileLines = [initContents componentsSeparatedByString:@"\n"];
            for (NSString *actualLine in fileLines)
            {
                if(( actualLine == nil ) || ( [actualLine length] == 0 ) ) continue;
                lineContent = [actualLine componentsSeparatedByString:@"="];
                initKey = [[NSString alloc] initWithString:[lineContent objectAtIndex:0]];
                if( [initKey compare:@"Notes Folder"] == NSOrderedSame ) globalVarsReg.notesFolder = [[NSMutableString alloc] initWithString:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Note Name"] == NSOrderedSame ) globalVarsReg.notesName = [[NSMutableString alloc] initWithString:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"NT Font Size"] == NSOrderedSame ) ntFontSize = [[NSNumber alloc] initWithFloat:[[lineContent objectAtIndex:1] floatValue]];
                if( [initKey compare:@"NT Fg Colour"] == NSOrderedSame ) ntFgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"NT Bg Colour"] == NSOrderedSame ) ntBgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"LXX Font Size"] == NSOrderedSame ) lxxFontSize = [[NSNumber alloc] initWithFloat:[[lineContent objectAtIndex:1] floatValue]];
                if( [initKey compare:@"LXX Fg Colour"] == NSOrderedSame ) lxxFgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"LXX Bg Colour"] == NSOrderedSame ) lxxBgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Parse Font Size"] == NSOrderedSame ) parseFontSize = [[NSNumber alloc] initWithFloat:[[lineContent objectAtIndex:1] floatValue]];
                if( [initKey compare:@"Parse Fg Colour"] == NSOrderedSame ) parseFgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Parse Bg Colour"] == NSOrderedSame ) parseBgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Lex Font Size"] == NSOrderedSame ) lexFontSize = [[NSNumber alloc] initWithFloat:[[lineContent objectAtIndex:1] floatValue]];
                if( [initKey compare:@"Lex Fg Colour"] == NSOrderedSame ) lexFgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Lex Bg Colour"] == NSOrderedSame ) lexBgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Search Font Size"] == NSOrderedSame ) searchFontSize = [[NSNumber alloc] initWithFloat:[[lineContent objectAtIndex:1] floatValue]];
                if( [initKey compare:@"Search Fg Colour"] == NSOrderedSame ) searchFgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Search Primary Colour"] == NSOrderedSame ) searchPrimaryColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Search Secondary Colour"] == NSOrderedSame ) searchSecondaryColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Search Bg Colour"] == NSOrderedSame ) searchBgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Vocab FontSize"] == NSOrderedSame ) vocabFontSize = [[NSNumber alloc] initWithFloat:[[lineContent objectAtIndex:1] floatValue]];
                if( [initKey compare:@"Vocab Fg Colour"] == NSOrderedSame ) vocabFgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Vocab Bg Colour"] == NSOrderedSame ) vocabBgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Notes Font Size"] == NSOrderedSame ) notesFontSize = [[NSNumber alloc] initWithFloat:[[lineContent objectAtIndex:1] floatValue]];
                if( [initKey compare:@"Notes Fg Colour"] == NSOrderedSame ) notesFgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Notes Bg Colour"] == NSOrderedSame ) notesBgColour = [self processColourData:[lineContent objectAtIndex:1]];
                if( [initKey compare:@"Main Window Left"] == NSOrderedSame ) mainX = [[lineContent objectAtIndex:1] integerValue];
                if( [initKey compare:@"Main Window Top"] == NSOrderedSame ) mainY = [[lineContent objectAtIndex:1] integerValue];
                if( [initKey compare:@"Main Window Width"] == NSOrderedSame ) mainWidth = [[lineContent objectAtIndex:1] integerValue];
                if( [initKey compare:@"Main Window Height"] == NSOrderedSame ) mainHeight = [[lineContent objectAtIndex:1] integerValue];
                if( [initKey compare:@"Main Divider Position"] == NSOrderedSame ) mainDivider = [[lineContent objectAtIndex:1] integerValue];
            }
        }
    }
    globalVarsReg.fontSize = [[NSArray alloc] initWithObjects: ntFontSize, lxxFontSize, parseFontSize, lexFontSize, searchFontSize, vocabFontSize, notesFontSize, nil];
    globalVarsReg.fgColour = [[NSArray alloc] initWithObjects: ntFgColour, lxxFgColour, parseFgColour, lexFgColour, searchFgColour, vocabFgColour, notesFgColour, nil];
    globalVarsReg.bgColour = [[NSArray alloc] initWithObjects: ntBgColour, lxxBgColour, parseBgColour, lexBgColour, searchBgColour, vocabBgColour, notesBgColour, nil];
    globalVarsReg.searchPrimaryColour = searchPrimaryColour;
    globalVarsReg.searchSecondaryColour = searchSecondaryColour;
    globalVarsReg.mainX = mainX;
    globalVarsReg.mainY = mainY;
    globalVarsReg.mainWidth = mainWidth;
    globalVarsReg.mainHeight = mainHeight;
    globalVarsReg.mainDividerPosition = mainDivider;

    noOfTextAreas = [[globalVarsReg prefsTextViews] count];
    for( idx = 0; idx < noOfTextAreas; idx++)
    {
        currentTextView = (NSTextView *)[[globalVarsReg prefsTextViews] objectAtIndex:idx];
        currentFont = [currentTextView font];
        fontName = [[NSString alloc] initWithString:[currentFont fontName]];
        [currentTextView setFont:[NSFont fontWithName:fontName size:[[[globalVarsReg fontSize] objectAtIndex:idx] floatValue]]];
        [currentTextView setTextColor:[[globalVarsReg fgColour] objectAtIndex:idx]];
        [currentTextView setBackgroundColor:[[globalVarsReg bgColour] objectAtIndex:idx]];
    }

    return self;
}

/*********************************************************************************
 *                                                                               *
 *                               processColourData                               *
 *                               =================                               *
 *                                                                               *
 *  The purpose of this routine is to convert comma seperated data into an array *
 *    For example: source = "123.0, 346.6, 0.0"                                  *
 *                                                                               *
 *********************************************************************************/

- (NSColor *) processColourData: (NSString *) inputColourString
{
    NSInteger idx, noOfItems;
    CGFloat red, green, blue;
    NSArray *interimResult;
    NSMutableArray *cleanedResult;
    
    interimResult = [inputColourString componentsSeparatedByString:@","];
    cleanedResult = [[NSMutableArray alloc] init];
    noOfItems = [interimResult count];
    for( idx = 0; idx < noOfItems; idx++)
    {
        [cleanedResult addObject:[[[NSString alloc] initWithString:[interimResult objectAtIndex:idx]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    switch (noOfItems)
    {
        case 0: red = 0; green = 0; blue = 0; break;
        case 1: red = [[cleanedResult objectAtIndex:0] floatValue]; green = 0; blue = 0; break;
        case 2: red = [[cleanedResult objectAtIndex:0] floatValue]; green = [[cleanedResult objectAtIndex:1] floatValue]; blue = 0; break;
        case 3:
        case 4: red = [[cleanedResult objectAtIndex:0] floatValue]; green = [[cleanedResult objectAtIndex:1] floatValue]; blue = [[cleanedResult objectAtIndex:2] floatValue]; break;
        default: red = 0; green = 0; blue = 0; break;
    }
    return [NSColor colorWithRed:red green:green blue:blue alpha:1];
}

- (void) saveInitData
{
    BOOL isDir;
    NSInteger mainX, mainY, mainWidth, mainHeight;
    NSString *initFileName;
    NSMutableString *initContents;
    NSFileManager *fmInit;
    NSNumber *ntFontSize;
    NSColor *ntFgColour;
    NSColor *ntBgColour;
    NSNumber *lxxFontSize;
    NSColor *lxxFgColour;
    NSColor *lxxBgColour;
    NSNumber *parseFontSize;
    NSColor *parseFgColour;
    NSColor *parseBgColour;
    NSNumber *lexFontSize;
    NSColor *lexFgColour;
    NSColor *lexBgColour;
    NSNumber *searchFontSize;
    NSColor *searchFgColour;
    NSColor *searchBgColour;
    NSNumber *vocabFontSize;
    NSColor *vocabFgColour;
    NSColor *vocabBgColour;
    NSNumber *notesFontSize;
    NSColor *notesFgColour;
    NSColor *notesBgColour;

    mainX = -1;
    mainY = -1;
    mainWidth = -1;
    mainHeight = -1;
    fmInit = [NSFileManager defaultManager];
    initFileName = [[NSString alloc] initWithString:[globalVarsReg iniFile]];
    isDir = false;
    if( [fmInit fileExistsAtPath:initFileName isDirectory:&isDir]) [fmInit removeItemAtPath:initFileName error:nil];
    initContents = [[NSMutableString alloc] initWithString:@""];
    ntFontSize = [[NSNumber alloc] initWithFloat:[[[globalVarsReg fontSize] objectAtIndex:0] floatValue]];
    lxxFontSize = [[NSNumber alloc] initWithFloat:[[[globalVarsReg fontSize] objectAtIndex:1] floatValue]];
    parseFontSize = [[NSNumber alloc] initWithFloat:[[[globalVarsReg fontSize] objectAtIndex:2] floatValue]];
    lexFontSize = [[NSNumber alloc] initWithFloat:[[[globalVarsReg fontSize] objectAtIndex:3] floatValue]];
    searchFontSize = [[NSNumber alloc] initWithFloat:[[[globalVarsReg fontSize] objectAtIndex:4] floatValue]];
    vocabFontSize = [[NSNumber alloc] initWithFloat:[[[globalVarsReg fontSize] objectAtIndex:5] floatValue]];
    notesFontSize = [[NSNumber alloc] initWithFloat:[[[globalVarsReg fontSize] objectAtIndex:6] floatValue]];
    ntFgColour = [[globalVarsReg fgColour] objectAtIndex:0];
    lxxFgColour = [[globalVarsReg fgColour] objectAtIndex:1];
    parseFgColour = [[globalVarsReg fgColour] objectAtIndex:2];
    lexFgColour = [[globalVarsReg fgColour] objectAtIndex:3];
    searchFgColour = [[globalVarsReg fgColour] objectAtIndex:4];
    vocabFgColour = [[globalVarsReg fgColour] objectAtIndex:5];
    notesFgColour = [[globalVarsReg fgColour] objectAtIndex:6];
    ntBgColour = [[globalVarsReg bgColour] objectAtIndex:0];
    lxxBgColour = [[globalVarsReg bgColour] objectAtIndex:1];
    parseBgColour = [[globalVarsReg bgColour] objectAtIndex:2];
    lexBgColour = [[globalVarsReg bgColour] objectAtIndex:3];
    searchBgColour = [[globalVarsReg bgColour] objectAtIndex:4];
    vocabBgColour = [[globalVarsReg bgColour] objectAtIndex:5];
    notesBgColour = [[globalVarsReg bgColour] objectAtIndex:6];

    [initContents appendFormat:@"Notes Folder=%@\n", [globalVarsReg notesFolder]];
    [initContents appendFormat:@"Note Name=%@\n", [globalVarsReg notesName]];
    [initContents appendFormat:@"NT Font Size=%f\n", [ntFontSize floatValue]];
    [initContents appendFormat:@"NT Fg Colour=%@\n", [self decomposeColourData:ntFgColour]];
    [initContents appendFormat:@"NT Bg Colour=%@\n", [self decomposeColourData:ntBgColour]];
    [initContents appendFormat:@"LXX Font Size=%f\n", [lxxFontSize floatValue]];
    [initContents appendFormat:@"LXX Fg Colour=%@\n", [self decomposeColourData:lxxFgColour]];
    [initContents appendFormat:@"LXX Bg Colour=%@\n", [self decomposeColourData:lxxBgColour]];
    [initContents appendFormat:@"Parse Font Size=%f\n", [parseFontSize floatValue]];
    [initContents appendFormat:@"Parse Fg Colour=%@\n", [self decomposeColourData:parseFgColour]];
    [initContents appendFormat:@"Parse Bg Colour=%@\n", [self decomposeColourData:parseBgColour]];
    [initContents appendFormat:@"Lex Font Size=%f\n", [lexFontSize floatValue]];
    [initContents appendFormat:@"Lex Fg Colour=%@\n", [self decomposeColourData:lexFgColour]];
    [initContents appendFormat:@"Lex Bg Colour=%@\n", [self decomposeColourData:lexBgColour]];
    [initContents appendFormat:@"Search Font Size=%f\n", [searchFontSize floatValue]];
    [initContents appendFormat:@"Search Fg Colour=%@\n", [self decomposeColourData:searchFgColour]];
    [initContents appendFormat:@"Search Bg Colour=%@\n", [self decomposeColourData:searchBgColour]];
    [initContents appendFormat:@"Search Primary Colour=%@\n", [self decomposeColourData:[globalVarsReg searchPrimaryColour]]];
    [initContents appendFormat:@"Search Secondary Colour=%@\n", [self decomposeColourData:[globalVarsReg searchSecondaryColour]]];
    [initContents appendFormat:@"Vocab FontSize=%f\n", [vocabFontSize floatValue]];
    [initContents appendFormat:@"Vocab Fg Colour=%@\n", [self decomposeColourData:vocabFgColour]];
    [initContents appendFormat:@"Vocab Bg Colour=%@\n", [self decomposeColourData:vocabBgColour]];
    [initContents appendFormat:@"Notes Font Size=%f\n", [notesFontSize floatValue]];
    [initContents appendFormat:@"Notes Fg Colour=%@\n", [self decomposeColourData:notesFgColour]];
    [initContents appendFormat:@"Notes Bg Colour=%@\n", [self decomposeColourData:notesBgColour]];
    [initContents appendFormat:@"Main Window Left=%li\n", [globalVarsReg mainX]];
    [initContents appendFormat:@"Main Window Top=%li\n", [globalVarsReg mainY]];
    [initContents appendFormat:@"Main Window Width=%li\n", [globalVarsReg mainWidth]];
    [initContents appendFormat:@"Main Window Height=%li\n", [globalVarsReg mainHeight]];
    [initContents appendFormat:@"Main Divider Position=%f\n", [globalVarsReg mainDividerPosition]];
    [initContents writeToFile:initFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

/*********************************************************************************
 *                                                                               *
 *                               processColourData                               *
 *                               =================                               *
 *                                                                               *
 *  The purpose of this routine is to convert an Objective-C NSColor value into  *
 *    a string composed of comma seperated data: for example: 123.0, 346.6, 0.0  *
 *                                                                               *
 *********************************************************************************/

- (NSString *) decomposeColourData: (NSColor *) sourceColour
{
    CGFloat red, green, blue, alpha;
    
    [sourceColour getRed:&red green:&green blue:&blue alpha:&alpha];
    return [[NSString alloc] initWithFormat:@"%f, %f, %f, 1.0", red, green, blue];
}

@end
