//
//  frmPreferences.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 10/06/2022.
//

#import "frmPreferences.h"

@interface frmPreferences ()

@end

@implementation frmPreferences

@synthesize globalVarsPrefs;

/*------------------------------------------------------------------------------------------------*
 *                                                                                                *
 *  changeRecord - Flag for changes                                                               *
 *  ------------                                                                                  *
 *                                                                                                *
 *  This is actually an 8 cell array, each "cell" representing a different Text View in the       *
 *    dialog.  By default, all 8 are set to @"".  If a change occurs in one Text View, then the   *
 *    array element for that area is set to @"Y".  So, changed areas can be identified easily.    *
 *                                                                                                *
 *------------------------------------------------------------------------------------------------*/
// Flag for changes
@synthesize changeRecord;

// Items from the bhsText preferences
@synthesize cbFontNameEng01;
@synthesize cbFontSizeEng01;
@synthesize cbFontStyleEng01;
@synthesize colFontColourEng01;

@synthesize cbFontNameMain01;
@synthesize cbFontSizeMain01;
@synthesize cbFontStyleMain01;
@synthesize colFontColourMain01;

@synthesize cbFontNameVar01;
@synthesize cbFontSizeVar01;
@synthesize cbFontStyleVar01;
@synthesize colFontColourVar01;

@synthesize colBackground01;
@synthesize txtEg01;

// Items from the lxxText preferences
@synthesize cbFontNameEng02;
@synthesize cbFontSizeEng02;
@synthesize cbFontStyleEng02;
@synthesize colFontColourEng02;

@synthesize cbFontNameMain02;
@synthesize cbFontSizeMain02;
@synthesize cbFontStyleMain02;
@synthesize colFontColourMain02;

@synthesize colBackground02;
@synthesize txtEg02;

// Items from the parse preferences
@synthesize cbFontNameEng03;
@synthesize cbFontSizeEng03;
@synthesize cbFontStyleEng03;
@synthesize colFontColourEng03;

@synthesize cbFontNameMain03;
@synthesize cbFontSizeMain03;
@synthesize cbFontStyleMain03;
@synthesize colFontColourMain03;

@synthesize colBackground03;
@synthesize txtEg03;

// Items from the lexicon preferences
@synthesize cbFontNameEng04;
@synthesize cbFontSizeEng04;
@synthesize cbFontStyleEng04;
@synthesize colFontColourEng04;

@synthesize cbFontNameMain04;
@synthesize cbFontSizeMain04;
@synthesize cbFontStyleMain04;
@synthesize colFontColourMain04;

@synthesize cbFontNamePrimary04;
@synthesize cbFontSizePrimary04;
@synthesize cbFontStylePrimary04;
@synthesize colFontColourPrimary04;

@synthesize colBackground04;
@synthesize txtEg04;

// Items from the BHS search Results preferences
@synthesize cbFontNameEng05;
@synthesize cbFontSizeEng05;
@synthesize cbFontStyleEng05;
@synthesize colFontColourEng05;

@synthesize cbFontNameMain05;
@synthesize cbFontSizeMain05;
@synthesize cbFontStyleMain05;
@synthesize colFontColourMain05;

@synthesize cbFontNamePrimary05;
@synthesize cbFontSizePrimary05;
@synthesize cbFontStylePrimary05;
@synthesize colFontColourPrimary05;

@synthesize cbFontNameSecondary05;
@synthesize cbFontSizeSecondary05;
@synthesize cbFontStyleSecondary05;
@synthesize colFontColourSecondary05;

@synthesize colBackground05;
@synthesize txtEg05;

// Items from the LXX search Results preferences
@synthesize cbFontNameEng06;
@synthesize cbFontSizeEng06;
@synthesize cbFontStyleEng06;
@synthesize colFontColourEng06;

@synthesize cbFontNameMain06;
@synthesize cbFontSizeMain06;
@synthesize cbFontStyleMain06;
@synthesize colFontColourMain06;

@synthesize cbFontNamePrimary06;
@synthesize cbFontSizePrimary06;
@synthesize cbFontStylePrimary06;
@synthesize colFontColourPrimary06;

@synthesize cbFontNameSecondary06;
@synthesize cbFontSizeSecondary06;
@synthesize cbFontStyleSecondary06;
@synthesize colFontColourSecondary06;

@synthesize colBackground06;
@synthesize txtEg06;

// Items from the BHS Notes preferences
@synthesize cbFontNameEng07;
@synthesize cbFontSizeEng07;
@synthesize cbFontStyleEng07;
@synthesize colFontColourEng07;

@synthesize colBackground07;
@synthesize txtEg07;

// Items from the LXX Notes preferences
@synthesize cbFontNameEng08;
@synthesize cbFontSizeEng08;
@synthesize cbFontStyleEng08;

@synthesize colFontColourEng08;

@synthesize colBackground08;
@synthesize txtEg08;

// Arrays of data copied from global
@synthesize allEngFontNames;
@synthesize allEngFontSizes;
@synthesize allEngFontStyles;
@synthesize allEngColours;

@synthesize allMainFontNames;
@synthesize allMainFontSizes;
@synthesize allMainFontStyles;
@synthesize allMainColours;

@synthesize allPrimaryFontNames;
@synthesize allPrimaryFontSizes;
@synthesize allPrimaryFontStyles;
@synthesize allPrimaryColours;

@synthesize allSecondaryFontNames;
@synthesize allSecondaryFontSizes;
@synthesize allSecondaryFontStyles;
@synthesize allSecondaryColours;

@synthesize allBackgroundColours;

@synthesize listOfSizes;
@synthesize fontList;
@synthesize fontMan;
@synthesize noOfViews;

BOOL isInitialSetup;
NSArray *preferenceTextViews;
classGlobal *globalVarsPrefs;

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void) initialiseWindow: (classGlobal *) inGlobal
{
    /*===============================================================================================================*
     *                                                                                                               *
     *                                           initialiseWindow                                                    *
     *                                           ================                                                    *
     *                                                                                                               *
     *===============================================================================================================*/

    NSInteger idx;
    CGFloat red, green, blue, alpha;
    
    isInitialSetup = true;
    globalVarsPrefs = inGlobal;
    
    // Define basic data
    fontMan = [[NSFontManager alloc] init];
    fontList = [[NSArray alloc] initWithObjects: @"Arial", @"Century", @"Chalkboard", @"Courier", @"Didot", @"Futura", @"Geneva", @"Helvetica", @"Lucida Grande", @"Monaco", @"Skia",
                                                 @"Times", @"Times New Roman", @"Trebuchet MS", @"Verdana", @"Zapfino", nil];
    listOfSizes = [[NSArray alloc] initWithObjects:@"6", @"8", @"9", @"10", @"11", @"12", @"14", @"16", @"18", @"20", @"22", @"24", @"26", @"28", @"36", @"48", @"72", nil];
    
    // Duplicate the current combobox and colour settings, so we can change them here without affecting the application
    allEngFontNames = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithString:[globalVarsPrefs bhsTextEngName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs lxxTextEngName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs parseTextName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs lexTextName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs searchEngName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs searchEngName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs bhsNotesFontName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs lxxNotesFontName]], nil];
    allEngFontSizes = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs bhsTextEngSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs lxxTextEngSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs parseTextSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs lexTextSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs searchEngSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs searchEngSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs bhsNotesSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs lxxNotesSize]], nil];
    allEngFontStyles = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs bhsTextEngStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs lxxTextEngStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs parseTextStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs lexTextStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs searchEngStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs searchEngStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs bhsNotesStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs lxxNotesStyle]], nil];
    allEngColours =  [[NSMutableArray alloc] init];
    [[globalVarsPrefs bhsTextEngColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allEngColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs lxxTextEngColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allEngColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs parseTextColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allEngColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs lexTextColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allEngColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchEngColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allEngColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchEngColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allEngColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs bhsNotesColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allEngColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs lxxNotesColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allEngColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    allMainFontNames = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithString:[globalVarsPrefs bhsTextMainName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs lxxTextMainName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs parseTitleName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs lexTitleName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs searchBHSMainName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs searchGreekMainName]],
                       @"", @"", nil];
    allMainFontSizes = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs bhsTextMainSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs lxxTextMainSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs parseTitleSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs lexTitleSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs searchBHSMainSize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs searchGreekMainSize]],
                       @"", @"", nil];
    allMainFontStyles = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs bhsTextMainStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs lxxTextMainStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs parseTitleStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs lexTitleStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs searchBHSMainStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs searchGreekMainStyle]],
                       @"", @"", nil];
    allMainColours = [[NSMutableArray alloc] initWithObjects:[[globalVarsPrefs bhsTextMainColour] copy],
                     [[globalVarsPrefs lxxTextMainColour] copy],
                     [[globalVarsPrefs parseTitleColour] copy],
                     [[globalVarsPrefs lexTitleColour] copy],
                     [[globalVarsPrefs searchBHSMainColour] copy],
                     [[globalVarsPrefs searchGreekMainColour] copy],
                     [NSColor clearColor], [NSColor clearColor], nil];
    allMainColours =  [[NSMutableArray alloc] init];
    [[globalVarsPrefs bhsTextMainColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allMainColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs lxxTextMainColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allMainColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs parseTitleColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allMainColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs lexTitleColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allMainColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchBHSMainColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allMainColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchGreekMainColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allMainColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [allMainColours addObject:[NSColor clearColor]];
    [allMainColours addObject:[NSColor clearColor]];
    allPrimaryFontNames = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithString:[globalVarsPrefs bhsTextVariantName]],
                       @"", @"",
                       [[NSString alloc] initWithString:[globalVarsPrefs lexPrimaryName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs searchBHSPrimaryName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs searchGreekPrimaryName]],
                       @"", @"", nil];
    allPrimaryFontSizes = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs bhsTextVariantSize]],
                           @"", @"",
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs lexPrimarySize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs searchBHSPrimarySize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs searchGreekPrimarySize]],
                       @"", @"", nil];
    allPrimaryFontStyles = [[NSMutableArray alloc] initWithObjects:[[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs bhsTextVariantStyle]],
                            @"", @"", @"",
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs lexPrimaryStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs searchBHSPrimaryStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs searchGreekPrimaryStyle]],
                       @"", @"", nil];
    allPrimaryColours =  [[NSMutableArray alloc] init];
    [[globalVarsPrefs bhsTextVariantColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allPrimaryColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [allPrimaryColours addObject:[NSColor clearColor]];
    [allPrimaryColours addObject:[NSColor clearColor]];
    [[globalVarsPrefs lexPrimaryColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allPrimaryColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchBHSPrimaryColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allPrimaryColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchGreekPrimaryColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allPrimaryColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [allPrimaryColours addObject:[NSColor clearColor]];
    [allPrimaryColours addObject:[NSColor clearColor]];
    allSecondaryFontNames = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"",
                       [[NSString alloc] initWithString:[globalVarsPrefs searchBHSSecondaryName]],
                       [[NSString alloc] initWithString:[globalVarsPrefs searchGreekSecondaryName]],
                       @"", @"", nil];
    allSecondaryFontSizes = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"",
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs searchBHSSecondarySize]],
                       [[NSString alloc] initWithFormat:@"%f",[globalVarsPrefs searchGreekSecondarySize]],
                       @"", @"", nil];
    allSecondaryFontStyles = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"",
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs searchBHSSecondaryStyle]],
                       [[NSString alloc] initWithFormat:@"%ld",[globalVarsPrefs searchGreekSecondaryStyle]],
                       @"", @"", nil];
    allSecondaryColours =  [[NSMutableArray alloc] init];
    [allSecondaryColours addObject:[NSColor clearColor]];
    [allSecondaryColours addObject:[NSColor clearColor]];
    [allSecondaryColours addObject:[NSColor clearColor]];
    [allSecondaryColours addObject:[NSColor clearColor]];
    [[globalVarsPrefs searchBHSSecondaryColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allSecondaryColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchGreekSecondaryColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allSecondaryColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [allSecondaryColours addObject:[NSColor clearColor]];
    [allSecondaryColours addObject:[NSColor clearColor]];
    allBackgroundColours =  [[NSMutableArray alloc] init];
    [[globalVarsPrefs bhsTextBackgroundColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allBackgroundColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs lxxTextBackgroundColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allBackgroundColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs parseTextBackgroundColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allBackgroundColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs lexTextBackgroundColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allBackgroundColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchBHSBackgroundColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allBackgroundColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs searchGreekBackgroundColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allBackgroundColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs bhsNotesBackgroundColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allBackgroundColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];
    [[globalVarsPrefs lxxNotesBackgroundColour] getRed:&red green:&green blue:&blue alpha:&alpha];
    [allBackgroundColours addObject:[NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha]];

    [self setupSizeComboBox:cbFontSizeEng01 withSelectedValue:[allEngFontSizes objectAtIndex:0]];
    [self setupNameComboBox:cbFontNameEng01 withSelectedValue:[allEngFontNames objectAtIndex:0]];
    [self setupStyleComboBox:cbFontStyleEng01 withSelectedValue:[allEngFontStyles objectAtIndex:0]];
    [colFontColourEng01 setColor:[allEngColours objectAtIndex:0]];

    [self setupSizeComboBox:cbFontSizeEng02 withSelectedValue:[allEngFontSizes objectAtIndex:1]];
    [self setupNameComboBox:cbFontNameEng02 withSelectedValue:[allEngFontNames objectAtIndex:1]];
    [self setupStyleComboBox:cbFontStyleEng02 withSelectedValue:[allEngFontStyles objectAtIndex:1]];
    [colFontColourEng02 setColor:[allEngColours objectAtIndex:1]];

    [self setupSizeComboBox:cbFontSizeEng03 withSelectedValue:[allEngFontSizes objectAtIndex:2]];
    [self setupNameComboBox:cbFontNameEng03 withSelectedValue:[allEngFontNames objectAtIndex:2]];
    [self setupStyleComboBox:cbFontStyleEng03 withSelectedValue:[allEngFontStyles objectAtIndex:2]];
    [colFontColourEng03 setColor:[allEngColours objectAtIndex:2]];

    [self setupSizeComboBox:cbFontSizeEng04 withSelectedValue:[allEngFontSizes objectAtIndex:3]];
    [self setupNameComboBox:cbFontNameEng04 withSelectedValue:[allEngFontNames objectAtIndex:3]];
    [self setupStyleComboBox:cbFontStyleEng04 withSelectedValue:[allEngFontStyles objectAtIndex:3]];
    [colFontColourEng04 setColor:[allEngColours objectAtIndex:3]];

    [self setupSizeComboBox:cbFontSizeEng05 withSelectedValue:[allEngFontSizes objectAtIndex:4]];
    [self setupNameComboBox:cbFontNameEng05 withSelectedValue:[allEngFontNames objectAtIndex:4]];
    [self setupStyleComboBox:cbFontStyleEng05 withSelectedValue:[allEngFontStyles objectAtIndex:4]];
    [colFontColourEng05 setColor:[allEngColours objectAtIndex:4]];

    [self setupSizeComboBox:cbFontSizeEng06 withSelectedValue:[allEngFontSizes objectAtIndex:5]];
    [self setupNameComboBox:cbFontNameEng06 withSelectedValue:[allEngFontNames objectAtIndex:5]];
    [self setupStyleComboBox:cbFontStyleEng06 withSelectedValue:[allEngFontStyles objectAtIndex:5]];
    [colFontColourEng06 setColor:[allEngColours objectAtIndex:5]];

    [self setupSizeComboBox:cbFontSizeEng07 withSelectedValue:[allEngFontSizes objectAtIndex:6]];
    [self setupNameComboBox:cbFontNameEng07 withSelectedValue:[allEngFontNames objectAtIndex:6]];
    [self setupStyleComboBox:cbFontStyleEng07 withSelectedValue:[allEngFontStyles objectAtIndex:6]];
    [colFontColourEng07 setColor:[allEngColours objectAtIndex:6]];

    [self setupSizeComboBox:cbFontSizeEng08 withSelectedValue:[allEngFontSizes objectAtIndex:7]];
    [self setupNameComboBox:cbFontNameEng08 withSelectedValue:[allEngFontNames objectAtIndex:7]];
    [self setupStyleComboBox:cbFontStyleEng08 withSelectedValue:[allEngFontStyles objectAtIndex:7]];
    [colFontColourEng08 setColor:[allEngColours objectAtIndex:7]];
    
    [self setupSizeComboBox:cbFontSizeMain01 withSelectedValue:[allMainFontSizes objectAtIndex:0]];
    [self setupNameComboBox:cbFontNameMain01 withSelectedValue:[allMainFontNames objectAtIndex:0]];
    [self setupStyleComboBox:cbFontStyleMain01 withSelectedValue:[allMainFontStyles objectAtIndex:0]];
    [colFontColourMain01 setColor:[allMainColours objectAtIndex:0]];

    [self setupSizeComboBox:cbFontSizeMain02 withSelectedValue:[allMainFontSizes objectAtIndex:1]];
    [self setupNameComboBox:cbFontNameMain02 withSelectedValue:[allMainFontNames objectAtIndex:1]];
    [self setupStyleComboBox:cbFontStyleMain02 withSelectedValue:[allMainFontStyles objectAtIndex:1]];
    [colFontColourMain02 setColor:[allMainColours objectAtIndex:1]];

    [self setupSizeComboBox:cbFontSizeMain03 withSelectedValue:[allMainFontSizes objectAtIndex:2]];
    [self setupNameComboBox:cbFontNameMain03 withSelectedValue:[allMainFontNames objectAtIndex:2]];
    [self setupStyleComboBox:cbFontStyleMain03 withSelectedValue:[allMainFontStyles objectAtIndex:2]];
    [colFontColourMain03 setColor:[allMainColours objectAtIndex:2]];

    [self setupSizeComboBox:cbFontSizeMain04 withSelectedValue:[allMainFontSizes objectAtIndex:3]];
    [self setupNameComboBox:cbFontNameMain04 withSelectedValue:[allMainFontNames objectAtIndex:3]];
    [self setupStyleComboBox:cbFontStyleMain04 withSelectedValue:[allMainFontStyles objectAtIndex:3]];
    [colFontColourMain04 setColor:[allMainColours objectAtIndex:3]];

    [self setupSizeComboBox:cbFontSizeMain05 withSelectedValue:[allMainFontSizes objectAtIndex:4]];
    [self setupNameComboBox:cbFontNameMain05 withSelectedValue:[allMainFontNames objectAtIndex:4]];
    [self setupStyleComboBox:cbFontStyleMain05 withSelectedValue:[allMainFontStyles objectAtIndex:4]];
    [colFontColourMain05 setColor:[allMainColours objectAtIndex:4]];

    [self setupSizeComboBox:cbFontSizeMain06 withSelectedValue:[allMainFontSizes objectAtIndex:5]];
    [self setupNameComboBox:cbFontNameMain06 withSelectedValue:[allMainFontNames objectAtIndex:5]];
    [self setupStyleComboBox:cbFontStyleMain06 withSelectedValue:[allMainFontStyles objectAtIndex:5]];
    [colFontColourMain06 setColor:[allMainColours objectAtIndex:5]];
    
    [self setupSizeComboBox:cbFontSizeVar01 withSelectedValue:[allPrimaryFontSizes objectAtIndex:0]];
    [self setupNameComboBox:cbFontNameVar01 withSelectedValue:[allPrimaryFontNames objectAtIndex:0]];
    [self setupStyleComboBox:cbFontStyleVar01 withSelectedValue:[allPrimaryFontStyles objectAtIndex:0]];
    [colFontColourVar01 setColor:[allPrimaryColours objectAtIndex:0]];

    [self setupSizeComboBox:cbFontSizePrimary04 withSelectedValue:[allPrimaryFontSizes objectAtIndex:3]];
    [self setupNameComboBox:cbFontNamePrimary04 withSelectedValue:[allPrimaryFontNames objectAtIndex:3]];
    [self setupStyleComboBox:cbFontStylePrimary04 withSelectedValue:[allPrimaryFontStyles objectAtIndex:3]];
    [colFontColourPrimary04 setColor:[allPrimaryColours objectAtIndex:3]];

    [self setupSizeComboBox:cbFontSizePrimary05 withSelectedValue:[allPrimaryFontSizes objectAtIndex:4]];
    [self setupNameComboBox:cbFontNamePrimary05 withSelectedValue:[allPrimaryFontNames objectAtIndex:4]];
    [self setupStyleComboBox:cbFontStylePrimary05 withSelectedValue:[allPrimaryFontStyles objectAtIndex:4]];
    [colFontColourPrimary05 setColor:[allPrimaryColours objectAtIndex:4]];

    [self setupSizeComboBox:cbFontSizePrimary06 withSelectedValue:[allPrimaryFontSizes objectAtIndex:5]];
    [self setupNameComboBox:cbFontNamePrimary06 withSelectedValue:[allPrimaryFontNames objectAtIndex:5]];
    [self setupStyleComboBox:cbFontStylePrimary06 withSelectedValue:[allPrimaryFontStyles objectAtIndex:5]];
    [colFontColourPrimary06 setColor:[allPrimaryColours objectAtIndex:5]];

    [self setupSizeComboBox:cbFontSizeSecondary05 withSelectedValue:[allSecondaryFontSizes objectAtIndex:4]];
    [self setupNameComboBox:cbFontNameSecondary05 withSelectedValue:[allSecondaryFontNames objectAtIndex:4]];
    [self setupStyleComboBox:cbFontStyleSecondary05 withSelectedValue:[allSecondaryFontStyles objectAtIndex:4]];
    [colFontColourSecondary05 setColor:[allSecondaryColours objectAtIndex:4]];

    [self setupSizeComboBox:cbFontSizeSecondary06 withSelectedValue:[allSecondaryFontSizes objectAtIndex:5]];
    [self setupNameComboBox:cbFontNameSecondary06 withSelectedValue:[allSecondaryFontNames objectAtIndex:5]];
    [self setupStyleComboBox:cbFontStyleSecondary06 withSelectedValue:[allSecondaryFontStyles objectAtIndex:5]];
    [colFontColourSecondary06 setColor:[allSecondaryColours objectAtIndex:5]];
    
    [colBackground01 setColor:[allBackgroundColours objectAtIndex:0]];
    [colBackground02 setColor:[allBackgroundColours objectAtIndex:1]];
    [colBackground03 setColor:[allBackgroundColours objectAtIndex:2]];
    [colBackground04 setColor:[allBackgroundColours objectAtIndex:3]];
    [colBackground05 setColor:[allBackgroundColours objectAtIndex:4]];
    [colBackground06 setColor:[allBackgroundColours objectAtIndex:5]];
    [colBackground07 setColor:[allBackgroundColours objectAtIndex:6]];
    [colBackground08 setColor:[allBackgroundColours objectAtIndex:7]];

    [txtEg01 setBaseWritingDirection:NSWritingDirectionRightToLeft];
    [txtEg05 setBaseWritingDirection:NSWritingDirectionRightToLeft];
    [self populateView:txtEg01 withAttributedText:[self populateBHSTextExample]];
    [self populateView:txtEg02 withAttributedText:[self populateLXXTextExample]];
    [self populateView:txtEg03 withAttributedText:[self populateParseExample]];
    [self populateView:txtEg04 withAttributedText:[self populateLexExample]];
    [self populateView:txtEg05 withAttributedText:[self populateBHSSearchExample]];
    [self populateView:txtEg06 withAttributedText:[self populateLXXSearchExample]];
    [self populateView:txtEg07 withAttributedText:[self populateBHSNotesExample]];
    [self populateView:txtEg08 withAttributedText:[self populateLXXNotesExample]];
    
    noOfViews = [allBackgroundColours count];
    changeRecord = [[NSMutableArray alloc] init];
    for( idx = 0; idx < noOfViews; idx++)
    {
        [changeRecord addObject:@""];
    }
}

- (void) setupSizeComboBox: (NSComboBox *) targetCB withSelectedValue: (NSString *) selectedValue
{
    NSRange decimalRange;
    
    [targetCB removeAllItems];
    [targetCB addItemsWithObjectValues:listOfSizes];
    decimalRange = [selectedValue rangeOfString:@"."];
    if( decimalRange.location == NSNotFound ) [targetCB selectItemWithObjectValue:[globalVarsPrefs convertIntegerToString:[selectedValue integerValue]]];
    else [targetCB selectItemWithObjectValue:[[NSString alloc] initWithString:[selectedValue substringToIndex:decimalRange.location]]];
}

- (void) setupNameComboBox: (NSComboBox *) targetCB withSelectedValue: (NSString *) selectedValue
{
    [targetCB removeAllItems];
    [targetCB addItemsWithObjectValues:fontList];
    [targetCB selectItemWithObjectValue:selectedValue];
}

- (void) setupStyleComboBox: (NSComboBox *) targetCB withSelectedValue: (NSString *) selectedCode
{
    switch ([selectedCode integerValue])
    {
        case 0: [targetCB selectItemWithObjectValue:@"Regular"]; break;
        case 1: [targetCB selectItemWithObjectValue:@"Bold"]; break;
        case 2: [targetCB selectItemWithObjectValue:@"Italic"]; break;
        case 3: [targetCB selectItemWithObjectValue:@"Bold and Italic"]; break;
        default: break;
    }
}

/*==========================================================================================*
 *                                                                                          *
 *                    Methods for Processing the Text View areas                            *
 *                    ==========================================                            *
 *                                                                                          *
 *==========================================================================================*/

- (NSMutableAttributedString *) populateBHSTextExample
{
    NSInteger idx, noOfVerses, wdx, noOfWords;
    NSString *currentVerseRef;
    NSMutableAttributedString *sampleText;
    NSColor *backgroundColour;
    classBHSBook *currentBook;
    classBHSChapter *currentChapter;
    classBHSVerse *currentVerse;
    classBHSWord *currentWord;

    [[txtEg01 textStorage] deleteCharactersInRange:NSMakeRange(0, [[txtEg01 textStorage] length])];
    backgroundColour = [allBackgroundColours objectAtIndex:0];
    [txtEg01 setBackgroundColor:backgroundColour];
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
    currentBook = [[globalVarsPrefs bhsBookList] objectForKey:[globalVarsPrefs convertIntegerToString:23]];
    currentChapter = [currentBook getChapterByChapterNo:@"8"];
    noOfVerses = 8;
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
    for (idx = 0; idx < noOfVerses; idx++)
    {
        if (idx > 0) [sampleText appendAttributedString:[self addAttributedText:@"\n" offsetCode:0 fontId:0 alignment:2 withAdjustmentFor:txtEg01]];
        // At the start of each line, the verse number (in English)
        currentVerse = [currentChapter getVerseBySequence:idx];
        currentVerseRef = [[NSString alloc] initWithString:[currentChapter getVerseNoBySequence:idx]];
        [sampleText appendAttributedString:[self addAttributedText:currentVerseRef offsetCode:0 fontId:0 alignment:2 withAdjustmentFor:txtEg01]];
        [sampleText appendAttributedString:[self addAttributedText:@": " offsetCode:0 fontId:0 alignment:2 withAdjustmentFor:txtEg01]];
        noOfWords = [currentVerse wordCount];
        for (wdx = 0; wdx < noOfWords; wdx++)
        {
            // Each word in Hebrew font and colour
            currentWord = [currentVerse getWord:wdx];
            if( [currentWord hasVariant])
            {
                if( [currentWord isPrefix]) [sampleText appendAttributedString:[self addAttributedText:[currentWord actualWord] offsetCode:0 fontId:2 alignment:2 withAdjustmentFor:txtEg01]];
                else [sampleText appendAttributedString:[self addAttributedText:[[NSString alloc] initWithFormat:@"%@ ",[currentWord actualWord]] offsetCode:0 fontId:2 alignment:2 withAdjustmentFor:txtEg01]];
            }
            else
            {
                if( [currentWord isPrefix]) [sampleText appendAttributedString:[self addAttributedText:[currentWord actualWord] offsetCode:0 fontId:1 alignment:2 withAdjustmentFor:txtEg01]];
                else [sampleText appendAttributedString:[self addAttributedText:[[NSString alloc] initWithFormat:@"%@ ",[currentWord actualWord]] offsetCode:0 fontId:1 alignment:2 withAdjustmentFor:txtEg01]];
            }
        }
    }
    return sampleText;
}

- (NSMutableAttributedString *) populateLXXTextExample
{
    NSInteger idx, noOfVerses, wdx, noOfWords;
    NSString *currentVerseRef;
    NSMutableAttributedString *sampleText;
    NSColor *backgroundColour;
    classLXXBook *currentBook;
    classLXXChapter *currentChapter;
    classLXXVerse *currentVerse;
    classLXXWord *currentWord;

    [[txtEg02 textStorage] deleteCharactersInRange:NSMakeRange(0, [[txtEg02 textStorage] length])];
    backgroundColour = [allBackgroundColours objectAtIndex:1];
    [txtEg02 setBackgroundColor:backgroundColour];
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
    currentBook = [[globalVarsPrefs lxxBookList] objectForKey:[globalVarsPrefs convertIntegerToString:48]];
    currentChapter = [currentBook getChapterByChapterNo:@"8"];
    noOfVerses = 8;
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
    for (idx = 0; idx < noOfVerses; idx++)
    {
        if (idx > 0) [sampleText appendAttributedString:[self addAttributedText:@"\n" offsetCode:0 fontId:4 alignment:0 withAdjustmentFor:txtEg02]];
        // At the start of each line, the verse number (in English)
        currentVerse = [currentChapter getVerseBySequence:idx];
        currentVerseRef = [[NSString alloc] initWithString:[currentChapter getVerseNoBySequence:idx]];
        [sampleText appendAttributedString:[self addAttributedText:currentVerseRef offsetCode:0 fontId:3 alignment:0 withAdjustmentFor:txtEg02]];
        [sampleText appendAttributedString:[self addAttributedText:@": " offsetCode:0 fontId:3 alignment:0 withAdjustmentFor:txtEg02]];
        noOfWords = [currentVerse wordCount];
        for (wdx = 0; wdx < noOfWords; wdx++)
        {
            // Each word in Hebrew font and colour
            currentWord = [currentVerse getWord:wdx];
            [sampleText appendAttributedString:[self addAttributedText:[currentWord preWordChars] offsetCode:0 fontId:4 alignment:0 withAdjustmentFor:txtEg02]];
            [sampleText appendAttributedString:[self addAttributedText:[currentWord textWord] offsetCode:0 fontId:4 alignment:0 withAdjustmentFor:txtEg02]];
            [sampleText appendAttributedString:[self addAttributedText:[[NSString alloc] initWithFormat:@"%@%@ ",[currentWord postWordChars], [currentWord punctuation]] offsetCode:0 fontId:4 alignment:0 withAdjustmentFor:txtEg02]];
        }
    }
    return sampleText;
}

- (NSMutableAttributedString *) populateParseExample
{
    NSString *heading = @"הִתְהַלָּכְתִּי";
    NSString *parseText = @"verb: Hitpa'el perfect first person singular", *interimText;
    NSMutableAttributedString *sampleText;
    NSColor *backgroundColour;

    [[txtEg03 textStorage] deleteCharactersInRange:NSMakeRange(0, [[txtEg03 textStorage] length])];
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
        // Now for the main text
    backgroundColour = [allBackgroundColours objectAtIndex:2];
    [txtEg03 setBackgroundColor:backgroundColour];
    interimText = [[NSString alloc] initWithFormat:@"%@\t\t\n\n", heading];
    [sampleText appendAttributedString:[self addAttributedText:interimText offsetCode:0 fontId:6 alignment:1 withAdjustmentFor:txtEg03]];
    [sampleText appendAttributedString:[self addAttributedText:parseText offsetCode:0 fontId:5 alignment:0 withAdjustmentFor:txtEg03]];
    return sampleText;
}

- (NSMutableAttributedString *) populateLexExample
{
    NSInteger gobbetCode;
    unichar override = 0x202d;
    NSString *heading = @"שְׁלִישִׁי", *interimText;
    /*--------------------------------------------------------------------------------------------------*
     *                                                                                                  *
     *  Decoding the following text:                                                                    *
     *  ---------------------------                                                                     *
     *                                                                                                  *
     *  We want to be able to identify:                                                                 *
     *    a) Hebrew or Aramaic text                                                                     *
     *    b) subscripted and superscripted text (including verse numbers in references).                *
     *  In order to do this, we have adopted the following approach:                                    *
     *    a) Text gobbets of the same type (i.e. normal text, Hebrew/Aramaic, subscript or superscript) *
     *       are delimited by the bar symbol ('|');                                                     *
     *    b) The first character of each gobbet is an integer with the following values and meaning:    *
     *                                                                                                  *
     *       Code                                   Meaning                                             *
     *       ----                                   -------                                             *
     *        0       Normal text                                                                       *
     *        1       Hebrew and/or Aramaic text                                                        *
     *        2       Subscripted text                                                                  *
     *        3       Superscripted text                                                                *
     *                                                                                                  *
     *--------------------------------------------------------------------------------------------------*/
    NSString *lexText = @"1שְׁלִישִׁי|0 masculine |1שְׁלִישִׁית|0 feminine adjective ordinal number|2108|0 third; — |1יוֺם שְׁלִישִׁי|0 Gen 1|313|0 + 31 t., etc. (64 t., rarely |1שְׁלִשִׁי|0); plural |1שְׁלִשִׁים|0 (third 50, set of messengers, etc.) 1Sam 19|321|0; 2Kgs 1|313|0 + 4 t.; בַּ|1שָּׁנָה הַשְּׁלִישִׁית |01Kgs 18|31|0 + 4 t., etc. (33 t.; sometimes |1שְׁלִשִׁית, שְׁלִשִׁת|0, etc.); = third part, a third 2Sam 18|32|0 (3 t. in verse) + 13 t., + (construct) Num 15|36|0 + 4 t., + |1שְׁלִשִׁתֵיךְ|0 (Ges|3«GKC:91l»§ 91l|0) Ezek 5|312|0 third part of thee; = third time 1Sam 3|38|0 also |1שְׁלִישִׁיָּה|0 Isa 19|324|0 third (on par with other two); |1בַּשְּׁלִישִׁים|0 Ezek 42|33|0 in the thirds, i.e. third story; — |1׳עֶגְלַת שׁ|0 Ezek 15|35|0; Jer 48|334|0, see |1׳ע|0 p. 722. — |1שְׁלִישִׁ֫תָה|0 Ezek 21|319|0 is corrupt and doubtful; Krae proposes |1וְשֻׁלְּשָׁה|0 the sword shall be doubled and trebled; other conjectures in Co Toy. 1Sam 20|35|0 strike out |1׳הַשּׁ|0 𝔊 We Dr and others, so v1Sam 20|312|0. 2Sam 23|318|0 read |1הַשְּׁלשִׁם|0 𝔖 We Dr and others";
    NSMutableAttributedString *sampleText;
    NSArray *splitText;
    NSColor *backgroundColour;

    [[txtEg04 textStorage] deleteCharactersInRange:NSMakeRange(0, [[txtEg04 textStorage] length])];
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
        // Now for the main text
    backgroundColour = [allBackgroundColours objectAtIndex:3];
    [txtEg04 setBackgroundColor:backgroundColour];
    interimText = [[NSString alloc] initWithFormat:@"%@\n", heading];
    [sampleText appendAttributedString:[self addAttributedText:interimText offsetCode:0 fontId:8 alignment:1 withAdjustmentFor:txtEg04]];
    [sampleText appendAttributedString:[self addAttributedText:[[NSString alloc] initWithFormat:@"%C", override] offsetCode:0 fontId:7 alignment:0 withAdjustmentFor:txtEg04]];
    splitText = [[NSArray alloc] initWithArray:[lexText componentsSeparatedByString:@"|"]];
    for( NSString *splitBit in splitText)
    {
        gobbetCode = [[[NSString alloc] initWithString:[splitBit substringToIndex:1]] integerValue];
        switch (gobbetCode)
        {
            case 0: [sampleText appendAttributedString:[self addAttributedText:[[NSString alloc] initWithString:[splitBit substringFromIndex:1]] offsetCode:0 fontId:7 alignment:0 withAdjustmentFor:txtEg04]]; break;
            case 1: [sampleText appendAttributedString:[self addAttributedText:[[NSString alloc] initWithString:[splitBit substringFromIndex:1]] offsetCode:0 fontId:19 alignment:0 withAdjustmentFor:txtEg04]]; break;
            case 2: [sampleText appendAttributedString:[self addAttributedText:[[NSString alloc] initWithString:[splitBit substringFromIndex:1]] offsetCode:2 fontId:7 alignment:0 withAdjustmentFor:txtEg04]]; break;
            case 3: [sampleText appendAttributedString:[self addAttributedText:[[NSString alloc] initWithString:[splitBit substringFromIndex:1]] offsetCode:1 fontId:7 alignment:0 withAdjustmentFor:txtEg04]]; break;
            default: break;
        }
    }
    return sampleText;
}

- (NSMutableAttributedString *) populateBHSSearchExample
{
    NSString *ref1, *ref2, *base11, *base12, *base21, *base22, *base23, *blue1, *blue2, *red1, *red2;
    NSMutableAttributedString *sampleText;
    NSColor *backgroundColour;
    
    ref1 = @"Isaiah 38.14: ​";
    base11 = @"​כְּ​";
    blue1 = @"ס֤וּס ";
    red1 = @"עָגוּר֙ ";
    base12 = @"כֵּ֣ן ​אֲצַפְצֵ֔ף ​אֶהְגֶּ֖ה ​כַּ​​יֹּונָ֑ה ​דַּלּ֤וּ ​עֵינַי֙ ​לַ​​מָּרֹ֔ום ​אֲדֹנָ֖י ​עָֽשְׁקָה‍־​לִּ֥י ​עָרְבֵֽנִי‍";
    ref2 = @"Jeremiah 8.7: ";
    base21 = @"גַּם‍־​חֲסִידָ֣ה ​בַ​​שָּׁמַ֗יִם ​יָֽדְעָה֙ ​מֹֽועֲדֶ֔יהָ ​וְ​תֹ֤ר ​וְ";
    blue2 = @"סִיס֙ ";
    base22 = @"​וְ​";
    red2 = @"עָג֗וּר ";
    base23 = @"​שָׁמְר֖וּ ​אֶת‍־​עֵ֣ת ​בֹּאָ֑נָה ​וְ​עַמִּ֕י ​לֹ֣א ​יָֽדְע֔וּ ​אֵ֖ת ​מִשְׁפַּ֥ט ​יְהוָֽה‍׃";

    [[txtEg05 textStorage] deleteCharactersInRange:NSMakeRange(0, [[txtEg05 textStorage] length])];
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
        // Now for the main text
    backgroundColour = [allBackgroundColours objectAtIndex:4];
    [txtEg05 setBackgroundColor:backgroundColour];

    [sampleText appendAttributedString:[self addAttributedText:ref1 offsetCode:0 fontId:9 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:base11 offsetCode:0 fontId:10 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:blue1 offsetCode:0 fontId:11 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:red1 offsetCode:0 fontId:12 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:base12 offsetCode:0 fontId:10 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:@"\n\n" offsetCode:0 fontId:10 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:ref2 offsetCode:0 fontId:9 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:base21 offsetCode:0 fontId:10 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:blue2 offsetCode:0 fontId:11 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:base22 offsetCode:0 fontId:10 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:red2 offsetCode:0 fontId:12 alignment:2 withAdjustmentFor:txtEg05]];
    [sampleText appendAttributedString:[self addAttributedText:base23 offsetCode:0 fontId:10 alignment:2 withAdjustmentFor:txtEg05]];
    return sampleText;
}

- (NSMutableAttributedString *) populateLXXSearchExample
{
    NSString *ref1, *ref2, *ref3, *base11, *base12, *base21, *base22, *base31, *base32, *base33, *blue1, *blue2, *blue3, *red1, *red2, *red3;
    NSMutableAttributedString *sampleText;
    NSColor *backgroundColour;
    
    ref1 = @"Genesis 1.11: ​";
    base11 = @"καὶ‍ ​εἶπεν‍ ​ὁ‍ ​θεός‍ ​Βλαστησάτω‍ ​ἡ‍ ​γῆ‍ ";
    red1 = @"​βοτάνην‍ ";
    blue1 = @"​χόρτου‍";
    base12 = @", ​σπεῖρον‍ ​σπέρμα‍ ​κατὰ‍ ​γένος‍ ​καὶ‍ ​καθ‍ ​ὁμοιότητα‍, ​καὶ‍ ​ξύλον‍ ​κάρπιμον‍ ​ποιοῦν‍ ​καρπόν‍, ​οὗ‍ ​τὸ‍ ​σπέρμα‍ ​αὐτοῦ‍ ​ἐν‍ ​αὐτῷ‍ ​κατὰ‍ ​γένος‍ ​ἐπὶ‍ ​τῆς‍ ​γῆς‍. ​καὶ‍ ​ἐγένετο‍ ​οὕτως‍.";
    ref2 = @"Genesis 1.12: ​";
    base21 = @"καὶ‍ ​ἐξήνεγκεν‍ ​ἡ‍ ​γῆ‍ ";
    red2 = @"​βοτάνην‍ ";
    blue2 = @"​χόρτου‍";
    base22 = @", ​σπεῖρον‍ ​σπέρμα‍ ​κατὰ‍ ​γένος‍ ​καὶ‍ ​καθ‍ ​ὁμοιότητα‍, ​καὶ‍ ​ξύλον‍ ​κάρπιμον‍ ​ποιοῦν‍ ​καρπόν‍, ​οὗ‍ ​τὸ‍ ​σπέρμα‍ ​αὐτοῦ‍ ​ἐν‍ ​αὐτῷ‍ ​κατὰ‍ ​γένος‍ ​ἐπὶ‍ ​τῆς‍ ​γῆς‍. ​καὶ‍ ​εἶδεν‍ ​ὁ‍ ​θεὸς‍ ​ὅτι‍ ​καλόν‍.";
    ref3 = @"2　Kings 19.26: ​";
    base31 = @"καὶ‍ ​οἱ‍ ​ἐνοικοῦντες‍ ​ἐν‍ ​αὐταῖς‍ ​ἠσθένησαν‍ ​τῇ‍ ​χειρί‍, ​ἔπτηξαν‍ ​καὶ‍ ​κατῃσχύνθησαν‍, ​ἐγένοντο‍ ";
    blue3 = @"χόρτος‍ ";
    base32 = @"ἀγροῦ‍ ​ἢ‍ ​χλωρὰ‍ ";
    red3 = @"βοτάνη‍";
    base33 = @", ​χλόη‍ ​δωμάτων‍ ​καὶ‍ ​πάτημα‍ ​ἀπέναντι‍ ​ἑστηκότος‍.";

    [[txtEg06 textStorage] deleteCharactersInRange:NSMakeRange(0, [[txtEg06 textStorage] length])];
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
        // Now for the main text
    backgroundColour = [allBackgroundColours objectAtIndex:4];
    [txtEg05 setBackgroundColor:backgroundColour];

    [sampleText appendAttributedString:[self addAttributedText:ref1 offsetCode:0 fontId:13 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:base11 offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:red1 offsetCode:0 fontId:16 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:blue1 offsetCode:0 fontId:15 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:base12 offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:@"\n\n" offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:ref2 offsetCode:0 fontId:13 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:base21 offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:red2 offsetCode:0 fontId:16 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:blue2 offsetCode:0 fontId:15 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:base22 offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:@"\n\n" offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:ref3 offsetCode:0 fontId:13 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:base31 offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:blue3 offsetCode:0 fontId:15 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:base32 offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:red3 offsetCode:0 fontId:16 alignment:0 withAdjustmentFor:txtEg06]];
    [sampleText appendAttributedString:[self addAttributedText:base33 offsetCode:0 fontId:14 alignment:0 withAdjustmentFor:txtEg06]];
    return sampleText;
}

- (NSMutableAttributedString *) populateBHSNotesExample
{
    NSString *exampleMessage = @"Ewald and other commentators take this to mean, I had a narrow escape from incurring the extreme penalty which the law of Moses prescribes for this sin (Lev. xx. 10): I almost, or well nigh, was convicted and stoned to death in public, \"in the midst of the congregation and the assembly.\"";
    NSMutableAttributedString *sampleText;
    NSColor *backgroundColour;

    [[txtEg07 textStorage] deleteCharactersInRange:NSMakeRange(0, [[txtEg07 textStorage] length])];
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
        // Now for the main text
    backgroundColour = [allBackgroundColours objectAtIndex:6];
    [txtEg07 setBackgroundColor:backgroundColour];
    [sampleText appendAttributedString:[self addAttributedText:exampleMessage offsetCode:0 fontId:17 alignment:0 withAdjustmentFor:txtEg07]];
    return sampleText;
}

- (NSMutableAttributedString *) populateLXXNotesExample
{
    NSString *exampleMessage = @"βοτάνη comes from the base word, βόσκω, and means \"grass\" or \"fodder\".  Note the phrase: ἐκ βοτάνης, \"from feeding\"";
    NSMutableAttributedString *sampleText;
    NSColor *backgroundColour;

    [[txtEg08 textStorage] deleteCharactersInRange:NSMakeRange(0, [[txtEg08 textStorage] length])];
    sampleText = [[NSMutableAttributedString alloc] initWithString:@""];
        // Now for the main text
    backgroundColour = [allBackgroundColours objectAtIndex:7];
    [txtEg08 setBackgroundColor:backgroundColour];
    [sampleText appendAttributedString:[self addAttributedText:exampleMessage offsetCode:0 fontId:18 alignment:0 withAdjustmentFor:txtEg08]];
    return sampleText;
}

- (NSInteger) getStyleDiscriminator: (NSString *) fontName
{
    NSInteger discriminator = -1;

    if( [fontName compare:@"Arial"] == NSOrderedSame ) discriminator = 0;
    if( [fontName compare:@"Century"] == NSOrderedSame ) discriminator = 1;
    if( [fontName compare:@"Chalkboard"] == NSOrderedSame ) discriminator = 2;
    if( [fontName compare:@"Courier"] == NSOrderedSame ) discriminator = 2;
    if( [fontName compare:@"Didot"] == NSOrderedSame ) discriminator = 3;
    if( [fontName compare:@"Futura"] == NSOrderedSame ) discriminator = 2;
    if( [fontName compare:@"Geneva"] == NSOrderedSame ) discriminator = 1;
    if( [fontName compare:@"Helvetica"] == NSOrderedSame ) discriminator = 2;
    if( [fontName compare:@"Lucida Grande"] == NSOrderedSame ) discriminator = 2;
    if( [fontName compare:@"Monaco"] == NSOrderedSame ) discriminator = 1;
    if( [fontName compare:@"Skia"] == NSOrderedSame ) discriminator = 2;
    if( [fontName compare:@"Times"] == NSOrderedSame ) discriminator = 0;
    if( [fontName compare:@"Times New Roman"] == NSOrderedSame ) discriminator = 0;
    if( [fontName compare:@"Trebuchet MS"] == NSOrderedSame ) discriminator = 0;
    if( [fontName compare:@"Verdana"] == NSOrderedSame ) discriminator = 0;
    if( [fontName compare:@"Zapfino"] == NSOrderedSame ) discriminator = 1;
    return discriminator;
}

- (NSInteger) getStyleCode: (NSInteger) fontStyleNameValue withDiscriminator: (NSInteger) discriminator
{
    NSInteger styleCode = -1;
    
    if( fontStyleNameValue == 0 ) styleCode = 0;
    if( fontStyleNameValue == 1 )
    {
        if( discriminator != 1) styleCode = 1;
        else styleCode = 0;
    }
    if( fontStyleNameValue == 2 )
    {
        if((discriminator == 0) || ( discriminator == 3 ) ) styleCode = 2;
        else styleCode = 0;
    }
    if( fontStyleNameValue == 3 )
    {
        if( discriminator == 0 ) styleCode = 3;
        else styleCode = 0;
    }
    return styleCode;
}

- (NSFont *) createFontForAreaType: (NSInteger) areaCode ofIndex: (NSInteger) index
{
    /*==========================================================================================*
     *                                                                                          *
     *                             createFontForAreaType                                        *
     *                             =====================                                        *
     *                                                                                          *
     *  areaCode   Whether we want eng, main, primary (or variant) or secondary                 *
     *  index      0 = bhsText                                                                  *
     *             1 = lxxText                                                                  *
     *             2 = parse, etc                                                               *
     *                                                                                          *
     *  styleDiscriminator:                                                                     *
     *  ------------------                                                                      *
     *                                                                                          *
     *  Some fonts only support a regular style.  Others support some styles but not others.    *
     *    The initial part of this method will allocate a discriminator on the following basis: *
     *                                                                                          *
     *   Value                               Significance                                       *
     *   -----                               ------------                                       *
     *     0      All given styles are available                                                *
     *     1      This font only supports a Regular style                                       *
     *     2      This font supports Regular and Bold styles                                    *
     *     3      This font supports Regular, Bold and Italic styles but not Bold + Italic      *
     *                                                                                          *
     *==========================================================================================*/
    
    NSInteger styleCode = 0, styleDiscriminator, fontStyleCode;
    CGFloat size = 0.0;
    NSString *fontName, *finalName;
    
    switch (areaCode)
    {
        case 1:
            fontName = [allEngFontNames objectAtIndex:index];
            styleDiscriminator = [self getStyleDiscriminator:fontName];
            fontStyleCode = [[[NSString alloc] initWithString:[allEngFontStyles objectAtIndex:index]] integerValue];
            styleCode = [self getStyleCode:fontStyleCode withDiscriminator:styleDiscriminator];
            size = [[allEngFontSizes objectAtIndex:index] floatValue];
            break;
        case 2:
            fontName = [allMainFontNames objectAtIndex:index];
            if( [fontName length] > 0)
            {
                styleDiscriminator = [self getStyleDiscriminator:fontName];
                fontStyleCode = [[[NSString alloc] initWithString:[allMainFontStyles objectAtIndex:index]] integerValue];
                styleCode = [self getStyleCode:fontStyleCode withDiscriminator:styleDiscriminator];
                size = [[allMainFontSizes objectAtIndex:index] floatValue];
            }
            break;
        case 3:
            fontName = [allPrimaryFontNames objectAtIndex:index];
            if( [fontName length] > 0)
            {
                styleDiscriminator = [self getStyleDiscriminator:fontName];
                fontStyleCode = [[[NSString alloc] initWithString:[allPrimaryFontStyles objectAtIndex:index]] integerValue];
                styleCode = [self getStyleCode:fontStyleCode withDiscriminator:styleDiscriminator];
                size = [[allPrimaryFontSizes objectAtIndex:index] floatValue];
            }
            break;
        case 4:
            fontName = [allSecondaryFontNames objectAtIndex:index];
            if( [fontName length] > 0)
            {
                styleDiscriminator = [self getStyleDiscriminator:fontName];
                fontStyleCode = [[[NSString alloc] initWithString:[allSecondaryFontStyles objectAtIndex:index]] integerValue];
                styleCode = [self getStyleCode:fontStyleCode withDiscriminator:styleDiscriminator];
                size = [[allSecondaryFontSizes objectAtIndex:index] floatValue];
            }
            break;
        default: break;
    }
    switch (styleCode)
    {
        case 0: finalName = [[NSString alloc] initWithString:fontName]; break;
        case 1: finalName = [[NSString alloc] initWithFormat:@"%@ Bold", fontName]; break;
        case 2: finalName = [[NSString alloc] initWithFormat:@"%@ Italic", fontName]; break;
        case 3: finalName = [[NSString alloc] initWithFormat:@"%@ Bold Italic", fontName]; break;
        default: break;
    }
    return [NSFont fontWithName:finalName size:size];
}

- (NSMutableAttributedString *) addAttributedText: (NSString *) mainText
                                       offsetCode: (NSInteger) offsetCode
                                           fontId: (NSInteger) fontId
                                        alignment: (NSInteger) alignment
                                withAdjustmentFor: (NSTextView *) baseView
{
    NSString *textToBeUsed;
    NSMutableAttributedString *thisPortion;
    NSFont *usedFont;
    NSColor *usedColour;
    NSMutableParagraphStyle *paragraphStyleLeft, *paragraphStyleCentred, *paragraphStyleRight;

    paragraphStyleLeft = NSMutableParagraphStyle.new;
    paragraphStyleLeft.alignment = NSTextAlignmentLeft;
    paragraphStyleCentred = NSMutableParagraphStyle.new;
    paragraphStyleCentred.alignment = NSTextAlignmentCenter;
    paragraphStyleRight = NSMutableParagraphStyle.new;
    paragraphStyleRight.alignment = NSTextAlignmentRight;

    if( [mainText length] == 0) return [[NSMutableAttributedString alloc] initWithString:@""];
    if( baseView == nil) textToBeUsed = [[NSString alloc] initWithString:mainText];
    else
    {
        if( [[[baseView textStorage] string] length] == 0) textToBeUsed = [[NSString alloc] initWithString:mainText];
        else textToBeUsed = [[NSString alloc] initWithString:mainText];
    }
    switch (fontId)
    {
        case 0: usedFont = [self createFontForAreaType:1 ofIndex:0]; usedColour = [allEngColours objectAtIndex:0]; break;
        case 1: usedFont = [self createFontForAreaType:2 ofIndex:0]; usedColour = [allMainColours objectAtIndex:0]; break;
        case 2: usedFont = [self createFontForAreaType:3 ofIndex:0]; usedColour = [allPrimaryColours objectAtIndex:0]; break;

        case 3: usedFont = [self createFontForAreaType:1 ofIndex:1]; usedColour = [allEngColours objectAtIndex:1]; break;
        case 4: usedFont = [self createFontForAreaType:2 ofIndex:1]; usedColour = [allMainColours objectAtIndex:1]; break;

        case 5: usedFont = [self createFontForAreaType:1 ofIndex:2]; usedColour = [allEngColours objectAtIndex:2]; break;
        case 6: usedFont = [self createFontForAreaType:2 ofIndex:2]; usedColour = [allMainColours objectAtIndex:2]; break;

        case 7: usedFont = [self createFontForAreaType:1 ofIndex:3]; usedColour = [allEngColours objectAtIndex:3]; break;
        case 8: usedFont = [self createFontForAreaType:2 ofIndex:3]; usedColour = [allMainColours objectAtIndex:3]; break;

        case 9: usedFont = [self createFontForAreaType:1 ofIndex:4]; usedColour = [allEngColours objectAtIndex:4]; break;
        case 10: usedFont = [self createFontForAreaType:2 ofIndex:4]; usedColour = [allMainColours objectAtIndex:4]; break;
        case 11: usedFont = [self createFontForAreaType:3 ofIndex:4]; usedColour = [allPrimaryColours objectAtIndex:4]; break;
        case 12: usedFont = [self createFontForAreaType:4 ofIndex:4]; usedColour = [allSecondaryColours objectAtIndex:4]; break;

        case 13: usedFont = [self createFontForAreaType:1 ofIndex:4]; usedColour = [allEngColours objectAtIndex:4]; break;
        case 14: usedFont = [self createFontForAreaType:2 ofIndex:5]; usedColour = [allMainColours objectAtIndex:5]; break;
        case 15: usedFont = [self createFontForAreaType:3 ofIndex:5]; usedColour = [allPrimaryColours objectAtIndex:5]; break;
        case 16: usedFont = [self createFontForAreaType:4 ofIndex:5]; usedColour = [allSecondaryColours objectAtIndex:5]; break;

        case 17: usedFont = [self createFontForAreaType:1 ofIndex:5]; usedColour = [allEngColours objectAtIndex:5]; break;

        case 18: usedFont = [self createFontForAreaType:1 ofIndex:6]; usedColour = [allEngColours objectAtIndex:6]; break;

            // Added later, so out of sequence
        case 19: usedFont = [self createFontForAreaType:3 ofIndex:3]; usedColour = [allPrimaryColours objectAtIndex:3]; break;
        default: break;
    }
    thisPortion = [[NSMutableAttributedString alloc] initWithString: textToBeUsed];
    [thisPortion addAttribute:NSFontAttributeName value:usedFont range:NSMakeRange(0, [thisPortion length])];
    [thisPortion addAttribute:NSForegroundColorAttributeName value:usedColour range:NSMakeRange(0, [thisPortion length])];
    switch (offsetCode)
    {
        case 0: [thisPortion addAttribute:(NSString*)NSSuperscriptAttributeName value:@0 range:NSMakeRange(0, [thisPortion length])]; break;
        case 1: [thisPortion addAttribute:(NSString*)NSSuperscriptAttributeName value:@1 range:NSMakeRange(0, [thisPortion length])]; break;
        case 2: [thisPortion addAttribute:(NSString*)NSSuperscriptAttributeName value:@-1 range:NSMakeRange(0, [thisPortion length])]; break;
        default: break;
    }
    switch (alignment) {
        case 0: [thisPortion addAttribute:NSParagraphStyleAttributeName value:paragraphStyleLeft range:NSMakeRange(0, [thisPortion length])]; break;
        case 1: [thisPortion addAttribute:NSParagraphStyleAttributeName value:paragraphStyleCentred range:NSMakeRange(0, [thisPortion length])]; break;
        case 2: [thisPortion addAttribute:NSParagraphStyleAttributeName value:paragraphStyleRight range:NSMakeRange(0, [thisPortion length])]; break;
        default: break;
    }
    return thisPortion;
}

- (void) populateView: (NSTextView *) targetView withAttributedText: (NSMutableAttributedString *) displayedText
{
    [targetView selectAll:self];
    [targetView delete:self];
    [[targetView textStorage] appendAttributedString:displayedText];
}

- (void) comboBoxSelectionDidChange:(NSNotification *)notification
{
    /*==================================================================================*
     *                                                                                  *
     *                         comboBoxSelectionDidChange                               *
     *                         ==========================                               *
     *                                                                                  *
     *  A value in one of the combo boxes has changed.  The tag value has to be decoded *
     *    in order for us to know exactly which one has been changed.  This works as    *
     *    follows:                                                                      *
     *                                                                                  *
     *    tag < 100      A name combo box has changed         (i.e comboTypeIndicator)  *
     *    tag > 99 < 200 A size combo box has changed                                   *
     *    tag > 199      A style combo box has changed                                  *
     *                                                                                  *
     *    (tag % 100) / 10 gives a value (areaIndicator):                               *
     *     0      BHS Text area is impacted                                             *
     *     1      LXX Text area is impacted                                             *
     *     2      Parse area                                                            *
     *     3      Lexicon area                                                          *
     *     4      BHS Search Result                                                     *
     *     5      LXX Search Result                                                     *
     *     6      BHS Notes                                                             *
     *     7      LXX Notes                                                             *
     *                                                                                  *
     *     tag % 10 gives a value (levelIndicator)                                      *
     *     1      English text section                                                  *
     *     2      Main section                                                          *
     *     3      Kethib/Qere or Primary section                                        *
     *     4      Secondary section                                                     *
     *                                                                                  *
     *==================================================================================*/
    NSUInteger tagVal, levelIndicator, comboTypeIndicator, areaIndicator, styleCode = -1;
    NSString *styleName;
    NSComboBox *cbResult;

    cbResult = (NSComboBox *) [notification object];
    tagVal = [cbResult tag];
    comboTypeIndicator = tagVal / 100;
    areaIndicator = (tagVal % 100) / 10;
    levelIndicator = tagVal % 10;
    switch (areaIndicator)
    {
        case 0:
            switch (levelIndicator)
            {
                case 1:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allEngFontNames replaceObjectAtIndex:0 withObject:[cbFontNameEng01 objectValueOfSelectedItem]]; break;
                        case 1: [allEngFontSizes replaceObjectAtIndex:0 withObject:[cbFontSizeEng01 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleEng01 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allEngFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 2:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allMainFontNames replaceObjectAtIndex:0 withObject:[cbFontNameMain01 objectValueOfSelectedItem]]; break;
                        case 1: [allMainFontSizes replaceObjectAtIndex:0 withObject:[cbFontSizeMain01 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleMain01 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allMainFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 3:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allPrimaryFontNames replaceObjectAtIndex:0 withObject:[cbFontNameVar01 objectValueOfSelectedItem]]; break;
                        case 1: [allPrimaryFontSizes replaceObjectAtIndex:0 withObject:[cbFontSizeVar01 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleVar01 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allPrimaryFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:0 withObject:@"Y"];
            [self populateView:txtEg01 withAttributedText:[self populateBHSTextExample]];
            break;
        case 1:
            switch (levelIndicator)
            {
                case 1:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allEngFontNames replaceObjectAtIndex:1 withObject:[cbFontNameEng02 objectValueOfSelectedItem]]; break;
                        case 1: [allEngFontSizes replaceObjectAtIndex:1 withObject:[cbFontSizeEng02 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleEng02 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allEngFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 2:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allMainFontNames replaceObjectAtIndex:1 withObject:[cbFontNameMain02 objectValueOfSelectedItem]]; break;
                        case 1: [allMainFontSizes replaceObjectAtIndex:1 withObject:[cbFontSizeMain02 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleMain02 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allMainFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:1 withObject:@"Y"];
            [self populateView:txtEg02 withAttributedText:[self populateLXXTextExample]];
            break;
        case 2:
            switch (levelIndicator)
            {
                case 1:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allEngFontNames replaceObjectAtIndex:2 withObject:[cbFontNameEng03 objectValueOfSelectedItem]]; break;
                        case 1: [allEngFontSizes replaceObjectAtIndex:2 withObject:[cbFontSizeEng03 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleEng03 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allEngFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 2:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allMainFontNames replaceObjectAtIndex:2 withObject:[cbFontNameMain03 objectValueOfSelectedItem]]; break;
                        case 1: [allMainFontSizes replaceObjectAtIndex:2 withObject:[cbFontSizeMain03 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleMain03 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allMainFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:2 withObject:@"Y"];
            [self populateView:txtEg03 withAttributedText:[self populateParseExample]];
            break;
        case 3:
            switch (levelIndicator)
            {
                case 1:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allEngFontNames replaceObjectAtIndex:3 withObject:[cbFontNameEng04 objectValueOfSelectedItem]]; break;
                        case 1: [allEngFontSizes replaceObjectAtIndex:3 withObject:[cbFontSizeEng04 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleEng04 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allEngFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 2:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allMainFontNames replaceObjectAtIndex:3 withObject:[cbFontNameMain04 objectValueOfSelectedItem]]; break;
                        case 1: [allMainFontSizes replaceObjectAtIndex:3 withObject:[cbFontSizeMain04 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleMain04 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allMainFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 3:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allPrimaryFontNames replaceObjectAtIndex:3 withObject:[cbFontNamePrimary04 objectValueOfSelectedItem]]; break;
                        case 1: [allPrimaryFontSizes replaceObjectAtIndex:3 withObject:[cbFontSizePrimary04 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStylePrimary04 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allPrimaryFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:3 withObject:@"Y"];
            [self populateView:txtEg04 withAttributedText:[self populateLexExample]];
            break;
        case 4:
            switch (levelIndicator)
            {
                case 1:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allEngFontNames replaceObjectAtIndex:4 withObject:[cbFontNameEng05 objectValueOfSelectedItem]]; break;
                        case 1: [allEngFontSizes replaceObjectAtIndex:4 withObject:[cbFontSizeEng05 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleEng05 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allEngFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 2:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allMainFontNames replaceObjectAtIndex:4 withObject:[cbFontNameMain05 objectValueOfSelectedItem]]; break;
                        case 1: [allMainFontSizes replaceObjectAtIndex:4 withObject:[cbFontSizeMain05 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleMain05 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allMainFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 3:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allPrimaryFontNames replaceObjectAtIndex:4 withObject:[cbFontNamePrimary05 objectValueOfSelectedItem]]; break;
                        case 1: [allPrimaryFontSizes replaceObjectAtIndex:4 withObject:[cbFontSizePrimary05 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStylePrimary05 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allPrimaryFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 4:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allSecondaryFontNames replaceObjectAtIndex:4 withObject:[cbFontNameSecondary05 objectValueOfSelectedItem]]; break;
                        case 1: [allSecondaryFontSizes replaceObjectAtIndex:4 withObject:[cbFontSizeSecondary05 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleSecondary05 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allSecondaryFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:4 withObject:@"Y"];
            [self populateView:txtEg05 withAttributedText:[self populateBHSSearchExample]];
            break;
        case 5:
            switch (levelIndicator)
            {
                case 1:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allEngFontNames replaceObjectAtIndex:5 withObject:[cbFontNameEng06 objectValueOfSelectedItem]]; break;
                        case 1: [allEngFontSizes replaceObjectAtIndex:5 withObject:[cbFontSizeEng06 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleEng06 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allEngFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 2:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allMainFontNames replaceObjectAtIndex:5 withObject:[cbFontNameMain06 objectValueOfSelectedItem]]; break;
                        case 1: [allMainFontSizes replaceObjectAtIndex:5 withObject:[cbFontSizeMain06 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleMain06 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allMainFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 3:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allPrimaryFontNames replaceObjectAtIndex:5 withObject:[cbFontNamePrimary06 objectValueOfSelectedItem]]; break;
                        case 1: [allPrimaryFontSizes replaceObjectAtIndex:5 withObject:[cbFontSizePrimary06 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStylePrimary06 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allPrimaryFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                case 4:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allSecondaryFontNames replaceObjectAtIndex:5 withObject:[cbFontNameSecondary06 objectValueOfSelectedItem]]; break;
                        case 1: [allSecondaryFontSizes replaceObjectAtIndex:5 withObject:[cbFontSizeSecondary06 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleSecondary06 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allSecondaryFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:5 withObject:@"Y"];
            [self populateView:txtEg06 withAttributedText:[self populateLXXSearchExample]];
            break;
        case 6:
            switch (levelIndicator)
            {
                case 1:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allEngFontNames replaceObjectAtIndex:6 withObject:[cbFontNameEng07 objectValueOfSelectedItem]]; break;
                        case 1: [allEngFontSizes replaceObjectAtIndex:6 withObject:[cbFontSizeEng07 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleEng07 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allEngFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:6 withObject:@"Y"];
            [self populateView:txtEg07 withAttributedText:[self populateBHSNotesExample]];
            break;
        case 7:
            switch (levelIndicator)
            {
                case 1:
                    switch (comboTypeIndicator)
                    {
                        case 0: [allEngFontNames replaceObjectAtIndex:7 withObject:[cbFontNameEng08 objectValueOfSelectedItem]]; break;
                        case 1: [allEngFontSizes replaceObjectAtIndex:7 withObject:[cbFontSizeEng08 objectValueOfSelectedItem]]; break;
                        case 2:
                            styleName = [[NSString alloc] initWithString:[cbFontStyleEng08 objectValueOfSelectedItem]];
                            if( [styleName compare: @"Regular"] == NSOrderedSame ) styleCode = 0;
                            if( [styleName compare: @"Bold"] == NSOrderedSame ) styleCode = 1;
                            if( [styleName compare: @"Italic"] == NSOrderedSame ) styleCode = 2;
                            if( [styleName compare: @"Bold and Italic"] == NSOrderedSame ) styleCode = 3;
                            [allEngFontStyles replaceObjectAtIndex:0 withObject:[globalVarsPrefs convertIntegerToString:styleCode]]; break;
                        default: break;
                    }
                    break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:7 withObject:@"Y"];
            [self populateView:txtEg08 withAttributedText:[self populateLXXNotesExample]];
            break;
        default: break;
    }
}

-(IBAction)doHandleColourWell:(id)sender
{
    NSInteger tagVal, areaIndicator, levelIndicator;
    NSColorWell *currentWell;
    
    currentWell = (NSColorWell *) sender;
    tagVal = [currentWell tag];
    areaIndicator = (tagVal % 100) / 10;
    levelIndicator = tagVal % 10;
    switch (areaIndicator)
    {
        case 0:
            switch (levelIndicator)
            {
                case 1: [allEngColours replaceObjectAtIndex:0 withObject:(NSColor *)[currentWell color]]; break;
                case 2: [allMainColours replaceObjectAtIndex:0 withObject:(NSColor *)[currentWell color]]; break;
                case 3: [allPrimaryColours replaceObjectAtIndex:0 withObject:(NSColor *)[currentWell color]]; break;
                case 5: [allBackgroundColours replaceObjectAtIndex:0 withObject:(NSColor *)[currentWell color]]; break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:0 withObject:@"Y"];
            [self populateView:txtEg01 withAttributedText:[self populateBHSTextExample]];
            break;
        case 1:
            switch (levelIndicator)
            {
                case 1: [allEngColours replaceObjectAtIndex:1 withObject:[currentWell color]]; break;
                case 2: [allMainColours replaceObjectAtIndex:1 withObject:[currentWell color]]; break;
                case 5: [allBackgroundColours replaceObjectAtIndex:1 withObject:[currentWell color]]; break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:1 withObject:@"Y"];
            [self populateView:txtEg02 withAttributedText:[self populateLXXTextExample]];
            break;
        case 2:
            switch (levelIndicator)
            {
                case 1: [allEngColours replaceObjectAtIndex:2 withObject:[currentWell color]]; break;
                case 2: [allMainColours replaceObjectAtIndex:2 withObject:[currentWell color]]; break;
                case 5: [allBackgroundColours replaceObjectAtIndex:2 withObject:[currentWell color]]; break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:2 withObject:@"Y"];
            [self populateView:txtEg03 withAttributedText:[self populateParseExample]];
            break;
        case 3:
            switch (levelIndicator)
            {
                case 1: [allEngColours replaceObjectAtIndex:3 withObject:[currentWell color]]; break;
                case 2: [allMainColours replaceObjectAtIndex:3 withObject:[currentWell color]]; break;
                case 3: [allPrimaryColours replaceObjectAtIndex:3 withObject:[currentWell color]]; break;
                case 5: [allBackgroundColours replaceObjectAtIndex:3 withObject:[currentWell color]]; break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:3 withObject:@"Y"];
            [self populateView:txtEg04 withAttributedText:[self populateLexExample]];
            break;
        case 4:
            switch (levelIndicator)
            {
                case 1: [allEngColours replaceObjectAtIndex:4 withObject:[currentWell color]]; break;
                case 2: [allMainColours replaceObjectAtIndex:4 withObject:[currentWell color]]; break;
                case 3: [allPrimaryColours replaceObjectAtIndex:4 withObject:[currentWell color]]; break;
                case 4: [allSecondaryColours replaceObjectAtIndex:4 withObject:[currentWell color]]; break;
                case 5: [allBackgroundColours replaceObjectAtIndex:4 withObject:[currentWell color]]; break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:4 withObject:@"Y"];
            [self populateView:txtEg05 withAttributedText:[self populateBHSSearchExample]];
            break;
        case 5:
            switch (levelIndicator)
            {
                case 1: [allEngColours replaceObjectAtIndex:5 withObject:[currentWell color]]; break;
                case 2: [allMainColours replaceObjectAtIndex:5 withObject:[currentWell color]]; break;
                case 3: [allPrimaryColours replaceObjectAtIndex:5 withObject:[currentWell color]]; break;
                case 4: [allSecondaryColours replaceObjectAtIndex:5 withObject:[currentWell color]]; break;
                case 5: [allBackgroundColours replaceObjectAtIndex:5 withObject:[currentWell color]]; break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:5 withObject:@"Y"];
            [self populateView:txtEg06 withAttributedText:[self populateLXXSearchExample]];
            break;
        case 6:
            switch (levelIndicator)
            {
                case 1: [allEngColours replaceObjectAtIndex:6 withObject:[currentWell color]]; break;
                case 5: [allBackgroundColours replaceObjectAtIndex:6 withObject:[currentWell color]]; break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:6 withObject:@"Y"];
            [self populateView:txtEg07 withAttributedText:[self populateBHSNotesExample]];
            break;
        case 7:
            switch (levelIndicator)
            {
                case 1: [allEngColours replaceObjectAtIndex:7 withObject:[currentWell color]]; break;
                case 5: [allBackgroundColours replaceObjectAtIndex:7 withObject:[currentWell color]]; break;
                default: break;
            }
            [changeRecord replaceObjectAtIndex:7 withObject:@"Y"];
            [self populateView:txtEg08 withAttributedText:[self populateLXXNotesExample]];
            break;
        default: break;
    }
//    [currentWell deactivate];
}

- (IBAction)doCancel:(id)sender
{
    [NSApp stopModalWithCode:NSModalResponseCancel];
    [self close];
}

- (NSInteger) finalFontCheck: (NSString *) fontName showingStyleCode: (NSInteger) styleCode
{
    NSInteger fontIndex = -1;

    fontIndex = [fontList indexOfObject:fontName];
    switch (fontIndex)
    {
        case 0:
        case 11:
        case 12:
        case 13:
        case 14:
            return styleCode;
        case 1:
        case 6:
        case 9:
        case 15:
            return 0;
        case 2:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
            if( styleCode > 1) return 0;
            else return styleCode;
        case 4:
            if( styleCode > 2) return 0;
            else return styleCode;
       default:
            break;
    }
    return -1;
}
- (IBAction)doOk:(id)sender
{
    NSInteger idx;
    
    for( idx = 0; idx < noOfViews; idx++)
    {
        if([[changeRecord objectAtIndex:idx] length] > 0)
        {
            switch (idx)
            {
                case 0:
                    [globalVarsPrefs setBhsTextEngName:[allEngFontNames objectAtIndex:0]];
                    [globalVarsPrefs setBhsTextEngSize:[[allEngFontSizes objectAtIndex:0] floatValue]];
                    [globalVarsPrefs setBhsTextEngStyle:[self finalFontCheck:[allEngFontNames objectAtIndex:0] showingStyleCode:[[allEngFontStyles objectAtIndex:0] integerValue]]];
//                    [globalVarsPrefs setBhsTextEngStyle:[[allEngFontStyles objectAtIndex:0] integerValue]];
                    [globalVarsPrefs setBhsTextEngColour:[[allEngColours objectAtIndex:0] copy]];
                    [globalVarsPrefs setBhsTextMainName:[allMainFontNames objectAtIndex:0]];
                    [globalVarsPrefs setBhsTextMainSize:[[allMainFontSizes objectAtIndex:0] floatValue]];
                    [globalVarsPrefs setBhsTextMainStyle:[self finalFontCheck:[allMainFontNames objectAtIndex:0] showingStyleCode:[[allMainFontStyles objectAtIndex:0] integerValue]]];
//                    [globalVarsPrefs setBhsTextMainStyle:[[allMainFontStyles objectAtIndex:0] integerValue]];
                    [globalVarsPrefs setBhsTextMainColour:[[allMainColours objectAtIndex:0] copy]];
                    [globalVarsPrefs setBhsTextVariantName:[allPrimaryFontNames objectAtIndex:0]];
                    [globalVarsPrefs setBhsTextVariantSize:[[allPrimaryFontSizes objectAtIndex:0] floatValue]];
                    [globalVarsPrefs setBhsTextVariantStyle:[self finalFontCheck:[allPrimaryFontNames objectAtIndex:0] showingStyleCode:[[allPrimaryFontStyles objectAtIndex:0] integerValue]]];
//                    [globalVarsPrefs setBhsTextVariantStyle:[[allPrimaryFontStyles objectAtIndex:0] integerValue]];
                    [globalVarsPrefs setBhsTextVariantColour:[[allPrimaryColours objectAtIndex:0] copy]];
                    [globalVarsPrefs setBhsTextBackgroundColour:[allBackgroundColours objectAtIndex:0]];
                    break;
                case 1:
                    [globalVarsPrefs setLxxTextEngName:[allEngFontNames objectAtIndex:1]];
                    [globalVarsPrefs setLxxTextEngSize:[[allEngFontSizes objectAtIndex:1] floatValue]];
                    [globalVarsPrefs setLxxTextEngStyle:[self finalFontCheck:[allEngFontNames objectAtIndex:1] showingStyleCode:[[allEngFontStyles objectAtIndex:1] integerValue]]];
//                    [globalVarsPrefs setLxxTextEngStyle:[[allEngFontStyles objectAtIndex:1] integerValue]];
                    [globalVarsPrefs setLxxTextEngColour:[[allEngColours objectAtIndex:1] copy]];
                    [globalVarsPrefs setLxxTextMainName:[allMainFontNames objectAtIndex:1]];
                    [globalVarsPrefs setLxxTextMainSize:[[allMainFontSizes objectAtIndex:1] floatValue]];
                    [globalVarsPrefs setLxxTextMainStyle:[self finalFontCheck:[allMainFontNames objectAtIndex:1] showingStyleCode:[[allMainFontStyles objectAtIndex:1] integerValue]]];
//                    [globalVarsPrefs setLxxTextMainStyle:[[allMainFontStyles objectAtIndex:1] integerValue]];
                    [globalVarsPrefs setLxxTextMainColour:[[allMainColours objectAtIndex:1] copy]];
                    [globalVarsPrefs setLxxTextBackgroundColour:[allBackgroundColours objectAtIndex:1]];
                    break;
                case 2:
                    [globalVarsPrefs setParseTextName:[allEngFontNames objectAtIndex:2]];
                    [globalVarsPrefs setParseTextSize:[[allEngFontSizes objectAtIndex:2] floatValue]];
                    [globalVarsPrefs setParseTextStyle:[self finalFontCheck:[allEngFontNames objectAtIndex:2] showingStyleCode:[[allEngFontStyles objectAtIndex:2] integerValue]]];
//                    [globalVarsPrefs setParseTextStyle:[[allEngFontStyles objectAtIndex:2] integerValue]];
                    [globalVarsPrefs setParseTextColour:[[allEngColours objectAtIndex:2] copy]];
                    [globalVarsPrefs setParseTitleName:[allMainFontNames objectAtIndex:2]];
                    [globalVarsPrefs setParseTitleSize:[[allMainFontSizes objectAtIndex:2] floatValue]];
                    [globalVarsPrefs setParseTitleStyle:[self finalFontCheck:[allMainFontNames objectAtIndex:2] showingStyleCode:[[allMainFontStyles objectAtIndex:2] integerValue]]];
//                    [globalVarsPrefs setParseTitleStyle:[[allMainFontStyles objectAtIndex:2] integerValue]];
                    [globalVarsPrefs setParseTitleColour:[[allMainColours objectAtIndex:2] copy]];
                    [globalVarsPrefs setParseTextBackgroundColour:[allBackgroundColours objectAtIndex:2]];
                    break;
                case 3:
                    [globalVarsPrefs setLexTextName:[allEngFontNames objectAtIndex:3]];
                    [globalVarsPrefs setLexTextSize:[[allEngFontSizes objectAtIndex:3] floatValue]];
                    [globalVarsPrefs setLexTextStyle:[self finalFontCheck:[allEngFontNames objectAtIndex:3] showingStyleCode:[[allEngFontStyles objectAtIndex:3] integerValue]]];
//                    [globalVarsPrefs setLexTextStyle:[[allEngFontStyles objectAtIndex:3] integerValue]];
                    [globalVarsPrefs setLexTextColour:[[allEngColours objectAtIndex:3] copy]];
                    [globalVarsPrefs setLexTitleName:[allMainFontNames objectAtIndex:3]];
                    [globalVarsPrefs setLexTitleSize:[[allMainFontSizes objectAtIndex:3] floatValue]];
                    [globalVarsPrefs setLexTitleStyle:[self finalFontCheck:[allMainFontNames objectAtIndex:3] showingStyleCode:[[allMainFontStyles objectAtIndex:3] integerValue]]];
//                    [globalVarsPrefs setLexTitleStyle:[[allMainFontStyles objectAtIndex:3] integerValue]];
                    [globalVarsPrefs setLexTitleColour:[[allMainColours objectAtIndex:3] copy]];
                    [globalVarsPrefs setLexPrimaryName:[allPrimaryFontNames objectAtIndex:3]];
                    [globalVarsPrefs setLexPrimarySize:[[allPrimaryFontSizes objectAtIndex:3] floatValue]];
                    [globalVarsPrefs setLexPrimaryStyle:[self finalFontCheck:[allPrimaryFontNames objectAtIndex:3] showingStyleCode:[[allPrimaryFontStyles objectAtIndex:3] integerValue]]];
//                    [globalVarsPrefs setLexPrimaryStyle:[[allPrimaryFontStyles objectAtIndex:3] integerValue]];
                    [globalVarsPrefs setLexPrimaryColour:[[allPrimaryColours objectAtIndex:3] copy]];
                    [globalVarsPrefs setLexTextBackgroundColour:[allBackgroundColours objectAtIndex:3]];
                    break;
                case 4:
                    [globalVarsPrefs setSearchEngName:[allEngFontNames objectAtIndex:4]];
                    [globalVarsPrefs setSearchEngSize:[[allEngFontSizes objectAtIndex:4] floatValue]];
                    [globalVarsPrefs setSearchEngStyle:[self finalFontCheck:[allEngFontNames objectAtIndex:4] showingStyleCode:[[allEngFontStyles objectAtIndex:4] integerValue]]];
//                    [globalVarsPrefs setSearchEngStyle:[[allEngFontStyles objectAtIndex:4] integerValue]];
                    [globalVarsPrefs setSearchEngColour:[[allEngColours objectAtIndex:4] copy]];
                    [globalVarsPrefs setSearchBHSMainName:[allMainFontNames objectAtIndex:4]];
                    [globalVarsPrefs setSearchBHSMainSize:[[allMainFontSizes objectAtIndex:4] floatValue]];
                    [globalVarsPrefs setSearchBHSMainStyle:[self finalFontCheck:[allMainFontNames objectAtIndex:4] showingStyleCode:[[allMainFontStyles objectAtIndex:4] integerValue]]];
//                    [globalVarsPrefs setSearchBHSMainStyle:[[allMainFontStyles objectAtIndex:4] integerValue]];
                    [globalVarsPrefs setSearchBHSMainColour:[[allMainColours objectAtIndex:4] copy]];
                    [globalVarsPrefs setSearchBHSPrimaryName:[allPrimaryFontNames objectAtIndex:4]];
                    [globalVarsPrefs setSearchBHSPrimarySize:[[allPrimaryFontSizes objectAtIndex:4] floatValue]];
                    [globalVarsPrefs setSearchBHSPrimaryStyle:[self finalFontCheck:[allPrimaryFontNames objectAtIndex:4] showingStyleCode:[[allPrimaryFontStyles objectAtIndex:4] integerValue]]];
//                    [globalVarsPrefs setSearchBHSPrimaryStyle:[[allPrimaryFontStyles objectAtIndex:4] integerValue]];
                    [globalVarsPrefs setSearchBHSPrimaryColour:[[allPrimaryColours objectAtIndex:4] copy]];
                    [globalVarsPrefs setSearchBHSSecondaryName:[allSecondaryFontNames objectAtIndex:4]];
                    [globalVarsPrefs setSearchBHSSecondarySize:[[allSecondaryFontSizes objectAtIndex:4] floatValue]];
                    [globalVarsPrefs setSearchBHSSecondaryStyle:[self finalFontCheck:[allSecondaryFontNames objectAtIndex:4] showingStyleCode:[[allSecondaryFontStyles objectAtIndex:4] integerValue]]];
//                    [globalVarsPrefs setSearchBHSSecondaryStyle:[[allSecondaryFontStyles objectAtIndex:4] integerValue]];
                    [globalVarsPrefs setSearchBHSSecondaryColour:[[allSecondaryColours objectAtIndex:4] copy]];
                    [globalVarsPrefs setSearchBHSBackgroundColour:[allBackgroundColours objectAtIndex:4]];
                    break;
                case 5:
                    [globalVarsPrefs setSearchGreekMainName:[allMainFontNames objectAtIndex:5]];
                    [globalVarsPrefs setSearchGreekMainSize:[[allMainFontSizes objectAtIndex:5] floatValue]];
                    [globalVarsPrefs setSearchGreekMainStyle:[self finalFontCheck:[allMainFontNames objectAtIndex:5] showingStyleCode:[[allMainFontStyles objectAtIndex:5] integerValue]]];
//                    [globalVarsPrefs setSearchGreekMainStyle:[[allMainFontStyles objectAtIndex:5] integerValue]];
                    [globalVarsPrefs setSearchGreekMainColour:[[allMainColours objectAtIndex:5] copy]];
                    [globalVarsPrefs setSearchGreekPrimaryName:[allPrimaryFontNames objectAtIndex:5]];
                    [globalVarsPrefs setSearchGreekPrimarySize:[[allPrimaryFontSizes objectAtIndex:5] floatValue]];
                    [globalVarsPrefs setSearchGreekPrimaryStyle:[self finalFontCheck:[allPrimaryFontNames objectAtIndex:5] showingStyleCode:[[allPrimaryFontStyles objectAtIndex:5] integerValue]]];
//                    [globalVarsPrefs setSearchGreekPrimaryStyle:[[allPrimaryFontStyles objectAtIndex:5] integerValue]];
                    [globalVarsPrefs setSearchGreekPrimaryColour:[[allPrimaryColours objectAtIndex:5] copy]];
                    [globalVarsPrefs setSearchGreekSecondaryName:[allSecondaryFontNames objectAtIndex:5]];
                    [globalVarsPrefs setSearchGreekSecondarySize:[[allSecondaryFontSizes objectAtIndex:5] floatValue]];
                    [globalVarsPrefs setSearchGreekSecondaryStyle:[self finalFontCheck:[allSecondaryFontNames objectAtIndex:5] showingStyleCode:[[allSecondaryFontStyles objectAtIndex:5] integerValue]]];
//                    [globalVarsPrefs setSearchGreekSecondaryStyle:[[allSecondaryFontStyles objectAtIndex:5] integerValue]];
                    [globalVarsPrefs setSearchGreekSecondaryColour:[[allSecondaryColours objectAtIndex:5] copy]];
                    [globalVarsPrefs setSearchGreekBackgroundColour:[allBackgroundColours objectAtIndex:5]];
                    break;
                case 6:
                    [globalVarsPrefs setBhsNotesName:[allEngFontNames objectAtIndex:6]];
                    [globalVarsPrefs setBhsNotesSize:[[allEngFontSizes objectAtIndex:6] floatValue]];
                    [globalVarsPrefs setBhsNotesStyle:[self finalFontCheck:[allEngFontNames objectAtIndex:6] showingStyleCode:[[allEngFontStyles objectAtIndex:6] integerValue]]];
//                    [globalVarsPrefs setBhsNotesStyle:[[allEngFontStyles objectAtIndex:6] integerValue]];
                    [globalVarsPrefs setBhsNotesColour:[[allEngColours objectAtIndex:6] copy]];
                    [globalVarsPrefs setBhsNotesBackgroundColour:[allBackgroundColours objectAtIndex:6]];
                    break;
                case 7:
                    [globalVarsPrefs setLxxNotesName:[allEngFontNames objectAtIndex:7]];
                    [globalVarsPrefs setLxxNotesSize:[[allEngFontSizes objectAtIndex:7] floatValue]];
                    [globalVarsPrefs setLxxNotesStyle:[self finalFontCheck:[allEngFontNames objectAtIndex:7] showingStyleCode:[[allEngFontStyles objectAtIndex:7] integerValue]]];
//                    [globalVarsPrefs setLxxNotesStyle:[[allEngFontStyles objectAtIndex:7] integerValue]];
                    [globalVarsPrefs setLxxNotesColour:[[allEngColours objectAtIndex:7] copy]];
                    [globalVarsPrefs setLxxNotesBackgroundColour:[allBackgroundColours objectAtIndex:7]];
                    break;
                default: break;
            }
        }
    }
    [NSApp stopModalWithCode:NSModalResponseOK];
    [self close];
}
@end
