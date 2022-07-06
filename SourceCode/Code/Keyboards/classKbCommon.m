//
//  classKbCommon.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import "classKbCommon.h"

@implementation classKbCommon

- (NSArray *) loadKeyWidths: (NSString *) fileName withNoOfRows: (NSInteger) noOfRows andNoOfColumns: (NSInteger) noOfCols
{
    /*=============================================================================================================*
     *                                                                                                             *
     *                                               loadKeyWidths                                                 *
     *                                               =============                                                 *
     *                                                                                                             *
     *  An integral part of the method, setupHebKeyboard (above).  Much as loadFileData (above) but it has to be   *
     *    a different method because the values stored are of a different data type (integer rather than string).  *
     *                                                                                                             *
     *=============================================================================================================*/
    NSInteger idx, jdx;
    NSString *buffer, *sourceFileName;
    NSArray *textByLine;
    NSMutableArray *targetArray, *arrayLine;

    sourceFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
    buffer = [[NSString alloc] initWithContentsOfFile:sourceFileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[buffer componentsSeparatedByString:@"\n"]];
    idx = 0; jdx = 0;
    arrayLine = [[NSMutableArray alloc] init];
    targetArray = [[NSMutableArray alloc] init];
    for (NSString *lineOfText in textByLine)
    {
        [arrayLine addObject:lineOfText];
        if (++jdx == noOfCols)
        {
            jdx = 0;
            [targetArray addObject:arrayLine];
            arrayLine = [[NSMutableArray alloc] init];
            if (++idx == noOfRows) break;
        }
    }
    return [targetArray copy];
}

- (NSArray *) loadFileData: (NSString *) fileName withNoOfRows: (NSInteger) noOfRows andNoOfColumns: (NSInteger) noOfCols
{
    /*=============================================================================================================*
     *                                                                                                             *
     *                                                loadFileData                                                 *
     *                                                ============                                                 *
     *                                                                                                             *
     *  An integral part of the method, setupHebKeyboard (above).  Used as a somewhat generic mechanism for        *
     *    loading:                                                                                                 *
     *                                                                                                             *
     *    a) Gk and Heb characters;                                                                                *
     *    b) Information for key hints                                                                             *
     *    c) Heb accents                                                                                           *
     *                                                                                                             *
     *  It can be used in a number of files (hence the parameter, fileName).                                       *
     *                                                                                                             *
     *=============================================================================================================*/
    NSInteger idx, jdx;
    uint endValue;
    NSString *buffer, *sourceFileName;
    NSArray *textByLine;
    NSMutableArray *targetArray, *arrayLine;
    NSScanner *scanSrce;

    sourceFileName = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
    buffer = [[NSString alloc] initWithContentsOfFile:sourceFileName encoding:NSUTF8StringEncoding error:nil];
    textByLine = [[NSArray alloc] initWithArray:[buffer componentsSeparatedByString:@"\n"]];
    idx = 0; jdx = 0;
    arrayLine = [[NSMutableArray alloc] init];
    targetArray = [[NSMutableArray alloc] init];
    for (NSString *lineOfText in textByLine)
    {
        if (([lineOfText length] > 0) && ([lineOfText characterAtIndex:0] == '\\'))
        {
            scanSrce = [NSScanner scannerWithString:[[NSString alloc] initWithString:[lineOfText substringFromIndex:2]]];
            [scanSrce scanHexInt:&endValue];
            buffer = [[NSString alloc] initWithFormat:@"%C", (unichar)endValue ];
        }
        else
        {
            buffer = [[NSString alloc] initWithString:lineOfText];
        }
        [arrayLine addObject:buffer];
        if (++jdx == noOfCols)
        {
            jdx = 0;
            [targetArray addObject:arrayLine];
            arrayLine = [[NSMutableArray alloc] init];
            if (++idx == noOfRows) break;
        }
    }
    if( jdx < noOfCols)[targetArray addObject:arrayLine];
    return [targetArray copy];
}

- (NSInteger) getKeyWidth: (NSArray *) arrayOfWidths fromRow: (NSInteger) rowNum andColumn: (NSInteger) colNum
{
    NSMutableArray *arrayLine;
    
    arrayLine = [arrayOfWidths objectAtIndex:rowNum];
    return [[arrayLine objectAtIndex:colNum] integerValue];
}

- (NSString *) getLoadedData: (NSArray *) arrayOfData fromRow: (NSInteger) rowNum andColumn: (NSInteger) colNum
{
    NSMutableArray *arrayLine;
    
    arrayLine = [arrayOfData objectAtIndex:rowNum];
    return [[NSString alloc] initWithString:[arrayLine objectAtIndex:colNum]];
}

-(classReturnedModifiedText *) reviseSearchString: (NSString *) sourceString atCursorPosition: (NSUInteger) Pstn forAction: (NSMutableDictionary *) actionArray addChar: (NSString *) addChar
{
    /*==================================================================================================================================*
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
     *==================================================================================================================================*/
    
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

@end
