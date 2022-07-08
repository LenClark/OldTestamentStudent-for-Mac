//
//  frmPreferences.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 27/01/2021.
//

#import "frmPreferences.h"

@interface frmPreferences ()

@end

@implementation frmPreferences

@synthesize preferencesWindow;
@synthesize preferencesTabView;
@synthesize viewTab1;
@synthesize viewTab2;
@synthesize viewTab3;
@synthesize viewTab4;
@synthesize viewTab5;
@synthesize viewTab6;
@synthesize viewTab7;

@synthesize fontComboBoxes;
@synthesize fgColourWells;
@synthesize bgColourWells;
@synthesize primaryColourWell;
@synthesize secondaryColourWell;
@synthesize exampleTextViews;
@synthesize currentFontSize;
@synthesize currentFgColours;
@synthesize currentBgColours;
@synthesize currentPrimaryColour;
@synthesize currentSecondaryColour;

@synthesize sampleTextAid;
@synthesize sampleParseAid;
@synthesize sampleLexAid;
@synthesize sampleSearchAid;
@synthesize sampleLxxText;
@synthesize sampleVocabAid;
@synthesize sampleNotesAid;

BOOL isInitialSetup;
NSArray *listOfSizes;
classConfig *globalVarsPrefs;

frmPreferences *advisedWindow;

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void) initialiseWindow: (classConfig *) inConfig forWindow: (frmPreferences *) inForm
{
    /***********************************************************************************************
     *                                                                                             *
     *                                      initialiseWindow                                       *
     *                                      ================                                       *
     *                                                                                             *
     *  This initialisation process contains the following steps:                                  *
     *    a) Ensure that the two key parameters passed from the AppDelegate are made global        *
     *    b) Create the controls on the form, viz.:                                                *
     *        i)    the seven tabs,                                                                *
     *        ii)   the labels, combobox, two colour wells and the example text area for each tab  *
     *    c) Populate the comboboxes - including selecting the current font size                   *
     *    d) Set the colour wells to the current colour for each text areas                        *
     *                                                                                             *
     *  Note: the global reference to advisedWindow (<- inForm) is required because of the poor    *
     *        construction of Objective-C.  In effect, there appears to be *two* instances of the  *
     *        window created when showWindow is called, one of which is accessed through self and  *
     *        one which is specific to the sub-Object created by showWindow.  This latter only     *
     *        appears to be accessible by the means used here.                                     *
     *                                                                                             *
     *  Note also that this has meant that we have had to make some variables globally accessible  *
     *        because we can't access them through the instance currently active in the method     *
     *        called.                                                                              *
     *                                                                                             *
     ***********************************************************************************************/
    
    const CGFloat labelLeft = 54, labelTop = 160, labelHeight = 42, textGap = 12, wellLeft = 184;
    
    NSInteger idx, jdx, noOfFontSizes, noOfTabs;
    NSNumber *singleSize;
    NSString *interimValue;
    NSArray *sampleText, *tabViewItemViews;
    NSMutableArray *comboBoxes, *foregroundColourWells, *backgroundColourWells, *exampleTextViews, *fontLabel, *fgLabel, *bgLabel;
    NSColor *singleColour;
    NSTextField *createdLabel;
    NSComboBox *createdCombo;
    NSColorWell *createdWell;
    NSTextView *createTextView;
    NSString *fontName;
    NSFont *currentFont;

    isInitialSetup = true;
    // a) Ensure that the two key parameters passed from the AppDelegate are made global
    advisedWindow = inForm;
    globalVarsPrefs = inConfig;
    
    // Define basic data
    listOfSizes = [[NSArray alloc] initWithObjects:@"6", @"8", @"9", @"10", @"11", @"12", @"14", @"16", @"18", @"20", @"22", @"24", @"26", @"28", @"36", @"48", @"72", nil];
    
    // **** ---- Text for the example text areas ---- ****
    sampleTextAid = @"1: τῇ ἐλευθερίᾳ ἡμᾶς Χριστὸς ἠλευθέρωσεν στήκετε οὖν καὶ μὴ πάλιν ζυγῷ δουλείας ἐνέχεσθε."
    @"\n2: Ἴδε ἐγὼ Παῦλος λέγω ὑμῖν ὅτι ἐὰν περιτέμνησθε Χριστὸς ὑμᾶς οὐδὲν ὠφελήσει."
    @"\n3: μαρτύρομαι δὲ πάλιν παντὶ ἀνθρώπῳ περιτεμνομένῳ ὅτι ὀφειλέτης ἐστὶν ὅλον τὸν νόμον ποιῆσαι."
    @"\n4: κατηργήθητε ἀπὸ Χριστοῦ οἵτινες ἐν νόμῳ δικαιοῦσθε, τῆς χάριτος ἐξεπέσατε."
    @"\n5: ἡμεῖς γὰρ πνεύματι ἐκ πίστεως ἐλπίδα δικαιοσύνης ἀπεκδεχόμεθα."
    @"\n6: ἐν γὰρ Χριστῷ Ἰησοῦ οὔτε περιτομή τι ἰσχύει οὔτε ἀκροβυστία, ἀλλὰ πίστις δι ἀγάπης ἐνεργουμένη."
    @"\n7: Ἐτρέχετε καλῶς τίς ὑμᾶς ἐνέκοψεν τῇ ἀληθείᾳ μὴ πείθεσθαι;"
    @"\n8: ἡ πεισμονὴ οὐκ ἐκ τοῦ καλοῦντος ὑμᾶς."
    @"\n9: μικρὰ ζύμη ὅλον τὸ φύραμα ζυμοῖ.";
    sampleParseAid = @"σαρκὸς\n======\n\nNoun: Genitive Singular Feminine";
    sampleLexAid = @"σαρκὸς\n======\n\nMeaning of: σάρξ\n================\nEtymology: σαρκός"
    @"             I flesh, Lat. caro, Hom., etc.: in pl. the flesh or muscles of the body,  ἔγκατά τε σάρκας τε καὶ ὀστέα Hom.; so in Hes.,"
    @" Aesch., etc.: so sometimes in sg., the flesh, the body,  γέροντα τὸν νοῠν, σάρκα δ ἡβῶσαν φέρει Aesch."
    @"             II the flesh, as opp. to the spirit, NTest.; also for man's nature generally, id=NTest.;   πᾶσα σάρξ all human kind, id=NTest.";
    sampleSearchAid = @"Matthew 1:20 ταῦτα δὲ αὐτοῦ ἐνθυμηθέντος ἰδοὺ *ἄγγελος κυρίου κατ ὄναρ =ἐφάνη αὐτῷ λέγων Ἰωσὴφ υἱὸς Δαυίδ μὴ φοβηθῇς παραλαβεῖν Μαρίαν τὴν γυναῖκά σου τὸ γὰρ ἐν αὐτῇ γεννηθὲν ἐκ πνεύματός ἐστιν ἁγίου\n"
    @"Matthew 2:13 Ἀναχωρησάντων δὲ αὐτῶν ἰδοὺ *ἄγγελος κυρίου =φαίνεται κατ ὄναρ τῷ Ἰωσὴφ λέγων Ἐγερθεὶς παράλαβε τὸ παιδίον καὶ τὴν μητέρα αὐτοῦ καὶ φεῦγε εἰς Αἴγυπτον καὶ ἴσθι ἐκεῖ ἕως ἂν εἴπω σοι μέλλει γὰρ Ἡρῴδης ζητεῖν τὸ παιδίον τοῦ ἀπολέσαι αὐτό\n"
    @"Matthew 2:19 Τελευτήσαντος δὲ τοῦ Ἡρῴδου ἰδοὺ *ἄγγελος κυρίου =φαίνεται κατ ὄναρ τῷ Ἰωσὴφ ἐν Αἰγύπτῳ";
    sampleLxxText = @"7:  καὶ ἐγένετο ὡς ἦλθεν τὸ βιβλίον πρὸς αὐτούς, καὶ ἔλαβον τοὺς υἱοὺς τοῦ βασιλέως καὶ ἔσφαξαν αὐτούς, ἑβδομήκοντα ἄνδρας, καὶ ἔθηκαν τὰς κεφαλὰς "
    @"αὐτῶν ἐν καρτάλλοις καὶ ἀπέστειλαν αὐτὰς πρὸς αὐτὸν εἰς Ιεζραελ.\n8:  καὶ ἦλθεν ὁ ἄγγελος καὶ ἀπήγγειλεν λέγων Ἤνεγκαν τὰς κεφαλὰς τῶν υἱῶν τοῦ βασιλέως· "
    @"καὶ εἶπεν Θέτε αὐτὰς βουνοὺς δύο παρὰ τὴν θύραν τῆς πύλης εἰς πρωί.\n9:  καὶ ἐγένετο πρωῒ καὶ ἐξῆλθεν καὶ ἔστη ἐν τῷ πυλῶνι τῆς πόλεως "
    @"καὶ εἶπεν πρὸς πάντα τὸν λαόν Δίκαιοι ὑμεῖς, ἰδοὺ ἐγώ εἰμι συνεστράφην ἐπὶ τὸν κύριόν μου καὶ ἀπέκτεινα αὐτόν· καὶ τίς ἐπάταξεν πάντας τούτους;\n"
    @"10:  ἴδετε αφφω ὅτι οὐ πεσεῖται ἀπὸ τοῦ ῥήματος κυρίου εἰς τὴν γῆν, οὗ ἐλάλησεν κύριος ἐπὶ τὸν οἶκον Αχααβ· καὶ κύριος ἐποίησεν ὅσα ἐλάλησεν ἐν χειρὶ δούλου αὐτοῦ Ηλιου.";
    sampleVocabAid = @"Nouns\n    ἐξουσίαν\n    ζωὴν\n    σαρκός\nVerbs\n    δέδωκας\n    δώσῃ\n    ἔδωκας";
    sampleNotesAid = @"Notes can contain any text typed by the user, including Greek: εριπατεῖτε καὶ ἐπιθυμίαν σαρκὸς -\n"
    @"or even Hebrew: בָּא עַל בֵּת־לֶחֶם (which, since I just made that up, it could be nonsense!).";
    sampleText = [[NSArray alloc] initWithObjects: sampleTextAid, sampleLxxText, sampleParseAid, sampleLexAid, sampleSearchAid, sampleVocabAid, sampleNotesAid, nil];
    
    // **** The tabView and tabViewItems exist, so make an array of the tabViewItems - don't seem to be used
    // And an array of the view objects, to which objects are added
    tabViewItemViews = [[NSArray alloc] initWithObjects:viewTab1, viewTab2, viewTab3, viewTab4, viewTab5, viewTab6, viewTab7, nil];
    comboBoxes = [[NSMutableArray alloc] init];
    foregroundColourWells = [[NSMutableArray alloc] init];
    backgroundColourWells = [[NSMutableArray alloc] init];
    exampleTextViews = [[NSMutableArray alloc] init];
    fontLabel = [[NSMutableArray alloc] init];
    fgLabel = [[NSMutableArray alloc] init];
    bgLabel = [[NSMutableArray alloc] init];
    noOfFontSizes = [listOfSizes count];
    noOfTabs = [preferencesTabView numberOfTabViewItems];
    fontComboBoxes = [[NSMutableArray alloc] init];
    fgColourWells = [[NSMutableArray alloc] init];
    bgColourWells = [[NSMutableArray alloc] init];
    currentFontSize = [[NSMutableArray alloc] init];
    currentFgColours = [[NSMutableArray alloc] init];
    currentBgColours = [[NSMutableArray alloc] init];

    // b) Now create the actual controls
    for( idx = 0; idx < noOfTabs; idx++)
    {
        // Firstly, simple labels
        createdLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(79, 214, 123, 17)];
        [createdLabel setBordered:NO];
        [createdLabel setDrawsBackground:NO];
        [createdLabel setEditable:NO];
        [createdLabel setStringValue:@"Set the font size to:"];
        [[tabViewItemViews objectAtIndex:idx] addSubview:createdLabel];
        createdLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(labelLeft, labelTop + textGap, 77, 17)];
        [createdLabel setBordered:NO];
        [createdLabel setDrawsBackground:NO];
        [createdLabel setEditable:NO];
        [createdLabel setStringValue:@"Text Colour:"];
        [[tabViewItemViews objectAtIndex:idx] addSubview:createdLabel];
        createdLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(labelLeft, labelTop - labelHeight + textGap, 124, 17)];
        [createdLabel setBordered:NO];
        [createdLabel setDrawsBackground:NO];
        [createdLabel setEditable:NO];
        [createdLabel setStringValue:@"Background Colour:"];
        [[tabViewItemViews objectAtIndex:idx] addSubview:createdLabel];
        // Additional options for SearchResults
        if( idx == 4 )
        {
            createdLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(labelLeft, labelTop - ( 2 * labelHeight ) + textGap, 124, 17)];
            [createdLabel setBordered:NO];
            [createdLabel setDrawsBackground:NO];
            [createdLabel setEditable:NO];
            [createdLabel setStringValue:@"Primary Match Text Colour:"];
            [[tabViewItemViews objectAtIndex:idx] addSubview:createdLabel];
            createdLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(labelLeft, labelTop - ( 3 * labelHeight ) + textGap, 124, 17)];
            [createdLabel setBordered:NO];
            [createdLabel setDrawsBackground:NO];
            [createdLabel setEditable:NO];
            [createdLabel setStringValue:@"Secondary Match Text Colour:"];
            [[tabViewItemViews objectAtIndex:idx] addSubview:createdLabel];
        }
        // Now the font size combo boxes
        createdCombo = [[NSComboBox alloc] initWithFrame:NSMakeRect(208, 209, 54, 26)];
        // Populate
        for( jdx = 0; jdx < noOfFontSizes; jdx++) [createdCombo addItemWithObjectValue:[listOfSizes objectAtIndex:jdx]];
        // Default font size (or size from init.dat) is defined in Registry class
        interimValue = [[NSString alloc] initWithFormat:@"%@", [[globalVarsPrefs fontSize] objectAtIndex:idx]];
        singleSize = [[NSNumber alloc] initWithFloat:[interimValue floatValue]];
        [createdCombo selectItemWithObjectValue:interimValue];
        [currentFontSize addObject:singleSize];
        [createdCombo setTag:idx];
        [createdCombo setDelegate:advisedWindow];
        [fontComboBoxes addObject:createdCombo];
        [[tabViewItemViews objectAtIndex:idx] addSubview:createdCombo];
        // Now the text colour, colour well
        createdWell = [[NSColorWell alloc] initWithFrame:NSMakeRect(wellLeft, labelTop, 59, 38)];
        singleColour = [self decodeColour:idx withColourCode:1];
        [createdWell setColor:singleColour];
        [currentFgColours addObject:singleColour];                       // So, currentFgColours = array of NSColor
        [createdWell setTag:idx];
        [createdWell setAction:@selector(doFgColourWellResponse:)];
        [fgColourWells addObject:createdWell];
        [[tabViewItemViews objectAtIndex:idx] addSubview:createdWell];
        createdWell = [[NSColorWell alloc] initWithFrame:NSMakeRect(wellLeft, labelTop - labelHeight, 59, 38)];
        singleColour = [self decodeColour:idx withColourCode:2];          // Data type: NSColor
        [createdWell setColor: singleColour];
        [currentBgColours addObject:singleColour];                       // So, currentBgColours = array of NSColor
        [createdWell setTag:7 + idx];
        [createdWell setAction:@selector(doBgColourWellResponse:)];
        [bgColourWells addObject:createdWell];
        [[tabViewItemViews objectAtIndex:idx] addSubview:createdWell];
        if( idx == 4 )
        {
            createdWell = [[NSColorWell alloc] initWithFrame:NSMakeRect(wellLeft, labelTop - ( 2 * labelHeight ), 59, 38)];
            singleColour = [self decodeColour:idx withColourCode:3];
            [createdWell setColor:singleColour];
            currentPrimaryColour = singleColour;
            [createdWell setTag:idx];
            [createdWell setAction:@selector(doPrimaryColourWellResponse:)];
            primaryColourWell = createdWell;
            [[tabViewItemViews objectAtIndex:idx] addSubview:createdWell];
            createdWell = [[NSColorWell alloc] initWithFrame:NSMakeRect(wellLeft, labelTop - ( 3 * labelHeight ), 59, 38)];
            singleColour = [self decodeColour:idx withColourCode:4];          // Data type: NSColor
            [createdWell setColor: singleColour];
            currentSecondaryColour = singleColour;
            [createdWell setTag:idx];
            [createdWell setAction:@selector(doSecondaryColourWellResponse:)];
            secondaryColourWell = createdWell;
            [[tabViewItemViews objectAtIndex:idx] addSubview:createdWell];
        }
        createTextView = [[NSTextView alloc] initWithFrame:NSMakeRect(276, 14, 365, 232)];
        [exampleTextViews addObject:createTextView];
        if( idx == 4 )
        {
            createTextView = [self displaySearchExample:createTextView withSampleText:sampleSearchAid];
        }
        else
        {
            currentFont = [createTextView font];
            fontName = [[NSString alloc] initWithString:[currentFont fontName]];
            [createTextView setFont:[NSFont fontWithName:fontName size:[[[globalVarsPrefs fontSize] objectAtIndex:idx] floatValue]]];
            [createTextView setBackgroundColor:[[globalVarsPrefs bgColour] objectAtIndex:idx]];
            [createTextView setTextColor:[[globalVarsPrefs fgColour] objectAtIndex:idx]];
            [createTextView setString:[sampleText objectAtIndex:idx]];
        }
        [[tabViewItemViews objectAtIndex:idx] addSubview:createTextView];
    }
    // Make these ready to receive any changes.  A different array is used so that it can be discarded if Cancel is chosen
    globalVarsPrefs.prefsTextViews = [[NSMutableArray alloc] initWithArray:exampleTextViews];
    globalVarsPrefs.prefsFontSize = [[NSMutableArray alloc] initWithArray:currentFontSize];
    globalVarsPrefs.prefsFgColours = [[NSMutableArray alloc] initWithArray:currentFgColours];  // So, prefs?gColours are arrays of NSColor
    globalVarsPrefs.prefsBgColours = [[NSMutableArray alloc] initWithArray:currentBgColours];
    isInitialSetup = false;
}

- (NSColor *) decodeColour: (NSInteger) index withColourCode: (NSInteger) colourCode
{
    NSColor *displayColour;
    
    switch (colourCode)
    {
        case 1: displayColour = [[globalVarsPrefs fgColour] objectAtIndex:index]; break;
        case 2: displayColour = [[globalVarsPrefs bgColour] objectAtIndex:index]; break;
        case 3: displayColour = [globalVarsPrefs searchPrimaryColour]; break;
        case 4: displayColour = [globalVarsPrefs searchSecondaryColour]; break;
        default: displayColour = nil; break;
    }
    return displayColour;
}

- (void) comboBoxSelectionDidChange:(NSNotification *)notification
{
    /***********************************************************************
     *                                                                     *
     *                     comboBoxSelectionDidChange                      *
     *                     ==========================                      *
     *                                                                     *
     *  This is a NSComboBoxDelegate event, activated when a new item in   *
     *    the comboBox is selected.  Note that this seems to be accessed   *
     *    by a different thread to the main window (which explains some of *
     *    the hoops we have had to jump through).                          *
     *                                                                     *
     ***********************************************************************/
     
    NSInteger tagVal;
    CGFloat actualFontSize;
    NSString *fontSizeString, *fontName;
    NSComboBox *comboBox;
    NSTextView *activeTextView;
    NSFont *currentFont;

    // Identify the combo box that is affected
    comboBox = (NSComboBox *)[notification object];
    tagVal = [comboBox tag];
    fontSizeString = [[NSString alloc] initWithString:[comboBox objectValueOfSelectedItem]];
    actualFontSize = [fontSizeString floatValue];
    [currentFontSize replaceObjectAtIndex:tagVal withObject: fontSizeString];
    activeTextView = [[globalVarsPrefs prefsTextViews] objectAtIndex:tagVal];
    currentFont = [activeTextView font];
    fontName = [[NSString alloc] initWithString:[currentFont fontName]];
    [activeTextView setFont:[NSFont fontWithName:fontName size:actualFontSize]];
    [[globalVarsPrefs prefsFontSize] replaceObjectAtIndex:tagVal withObject:[[NSNumber alloc] initWithFloat:actualFontSize]];
}

- (IBAction)doFgColourWellResponse:(NSColorWell *)sender
{
    NSInteger tagVal;
    NSColorWell *currentColourWell;
    NSTextView *activeTextView;

    currentColourWell = sender;
    tagVal = [currentColourWell tag];
    activeTextView = [[globalVarsPrefs prefsTextViews] objectAtIndex:tagVal];
    [[globalVarsPrefs prefsFgColours] replaceObjectAtIndex:tagVal withObject:[currentColourWell color]];
    if( tagVal == 4 ) [self displaySearchExample:activeTextView withSampleText:sampleSearchAid];
    else [activeTextView setTextColor:[currentColourWell color]];
    [[NSColorPanel sharedColorPanel] close];
}

- (IBAction)doBgColourWellResponse:(NSColorWell *)sender
{
    NSInteger tagVal;
    NSColorWell *currentColourWell;
    NSTextView *activeTextView;
    
    currentColourWell = sender;
    tagVal = [currentColourWell tag];
    activeTextView = [[globalVarsPrefs prefsTextViews] objectAtIndex:tagVal - 7];
    [[globalVarsPrefs prefsBgColours] replaceObjectAtIndex:(tagVal - 7) withObject:[currentColourWell color]];
    if(tagVal - 7 == 4 )[self displaySearchExample:activeTextView withSampleText:sampleSearchAid];
    else [activeTextView setBackgroundColor:[currentColourWell color]];
    [[NSColorPanel sharedColorPanel] close];
}

- (IBAction)doPrimaryColourWellResponse:(NSColorWell *)sender
{
    NSInteger tagVal;
    NSColorWell *currentColourWell;
    NSTextView *activeTextView;

    currentColourWell = sender;
    tagVal = [currentColourWell tag];
    activeTextView = [[globalVarsPrefs prefsTextViews] objectAtIndex:tagVal];
    globalVarsPrefs.prefsPrimaryColour = [currentColourWell color];
    currentPrimaryColour = [currentColourWell color];
    [self displaySearchExample:activeTextView withSampleText:sampleSearchAid];
    [[NSColorPanel sharedColorPanel] close];
}

- (IBAction)doSecondaryColourWellResponse:(NSColorWell *)sender
{
    NSInteger tagVal;
    NSColorWell *currentColourWell;
    NSTextView *activeTextView;

    currentColourWell = sender;
    tagVal = [currentColourWell tag];
    activeTextView = [[globalVarsPrefs prefsTextViews] objectAtIndex:tagVal];
    globalVarsPrefs.prefsSecondaryColour = [currentColourWell color];
    currentSecondaryColour = [currentColourWell color];
    [self displaySearchExample:activeTextView withSampleText:sampleSearchAid];
    [[NSColorPanel sharedColorPanel] close];
}

- (IBAction)doOK:(NSButton *)sender
{
    globalVarsPrefs.fontSize = [[NSArray alloc] initWithArray:[globalVarsPrefs prefsFontSize]];
    globalVarsPrefs.fgColour = [[NSArray alloc] initWithArray:[globalVarsPrefs prefsFgColours]];
    globalVarsPrefs.bgColour = [[NSArray alloc] initWithArray:[globalVarsPrefs prefsBgColours]];
    globalVarsPrefs.searchPrimaryColour = currentPrimaryColour;
    globalVarsPrefs.searchSecondaryColour = currentSecondaryColour;
    globalVarsPrefs.prefsOK = true;
    [self updateTextViews];
    [self close];
}

- (IBAction)doCancel:(NSButton *)sender
{
    globalVarsPrefs.prefsOK = false;
    [self close];
}

- (NSTextView *) displaySearchExample: (NSTextView *) currentTextView withSampleText: (NSString *) sampleText
{
    NSInteger idx, ldx, wdx, colourControl;
    NSString *fontName, *currentLine, *individualWord;
    NSMutableAttributedString *interimText;
    NSArray *lineByLine, *wordByWord;
    NSFont *currentFont;
    NSColor *activeFgColour, *activeBgColour;

    idx = 4;
    currentFont = [currentTextView font];
    fontName = [[NSString alloc] initWithString:[currentFont fontName]];
    [currentTextView setFont:[NSFont fontWithName:fontName size:[[[globalVarsPrefs fontSize] objectAtIndex:idx] floatValue]]];
    if( isInitialSetup)
    {
        activeFgColour = [currentFgColours objectAtIndex:idx];
        activeBgColour = [currentBgColours objectAtIndex:idx];
    }
    else
    {
        activeFgColour = [[globalVarsPrefs prefsFgColours] objectAtIndex:idx];
        activeBgColour = [[globalVarsPrefs prefsBgColours] objectAtIndex:idx];
    }
    [currentTextView setBackgroundColor:activeBgColour];
    // First of all, get to the stage where I'm presenting the text word by word
    lineByLine = [sampleText componentsSeparatedByString:@"\n"];
    for( ldx = 0; ldx < [lineByLine count]; ldx++)
    {
        if( ldx > 0 )
        {
            interimText = [[NSMutableAttributedString alloc] initWithString:@"\n\n"];
            [interimText addAttribute:NSForegroundColorAttributeName value:activeFgColour range:NSMakeRange(0, [interimText length])];
            [[currentTextView textStorage] appendAttributedString:interimText];
        }
        currentLine = [[NSString alloc] initWithString:[lineByLine objectAtIndex:ldx]];
        wordByWord = [currentLine componentsSeparatedByString:@" "];
        for( wdx = 0; wdx < [wordByWord count]; wdx++)
        {
            if( wdx == 0 )
            {
                interimText = [[NSMutableAttributedString alloc] initWithString:[wordByWord objectAtIndex:wdx]];
                [interimText addAttribute:NSForegroundColorAttributeName value:activeFgColour range:NSMakeRange(0, [interimText length])];
            }
            else
            {
                individualWord = [[NSString alloc]initWithFormat:@" %@",[wordByWord objectAtIndex:wdx]];
                colourControl = 1;
                if( [individualWord containsString:@"*"] )
                {
                    colourControl = 2;
                    individualWord = [[NSString alloc] initWithFormat:@" %@",[individualWord substringFromIndex:2]];
                }
                if( [individualWord containsString:@"="] )
                {
                    colourControl = 3;
                    individualWord = [[NSString alloc] initWithFormat:@" %@",[individualWord substringFromIndex:2]];
                }
                interimText = [[NSMutableAttributedString alloc] initWithString:individualWord];
                switch (colourControl)
                {
                    case 1: [interimText addAttribute:NSForegroundColorAttributeName value:activeFgColour range:NSMakeRange(0, [interimText length])]; break;
//                    case 2: [interimText addAttribute:NSForegroundColorAttributeName value:[globalVarsPrefs searchPrimaryColour] range:NSMakeRange(0, [interimText length])]; break;
                    case 2: [interimText addAttribute:NSForegroundColorAttributeName value:currentPrimaryColour range:NSMakeRange(0, [interimText length])]; break;
//                    case 3: [interimText addAttribute:NSForegroundColorAttributeName value:[globalVarsPrefs searchSecondaryColour] range:NSMakeRange(0, [interimText length])]; break;
                    case 3: [interimText addAttribute:NSForegroundColorAttributeName value:currentSecondaryColour range:NSMakeRange(0, [interimText length])]; break;
                    default: break;
                }
            }
            if( ( ldx == 0 ) && ( wdx == 0 ) )
            {
                [[currentTextView textStorage] setAttributedString:interimText];
            }
            else
            {
                [[currentTextView textStorage] appendAttributedString:interimText];
            }
        }
    }
    return currentTextView;
}

- (void) updateTextViews
{
    NSInteger idx;
    NSString *fontName;
    NSTextView *currentTextView;
    NSFont *currentFont;

    for( idx = 0; idx < 7; idx++)
    {
        switch (idx)\
        {
            case 0: currentTextView = [globalVarsPrefs ntTextView]; break;
            case 1: currentTextView = [globalVarsPrefs lxxTextView]; break;
            case 2: currentTextView = [globalVarsPrefs parseTextView]; break;
            case 3: currentTextView = [globalVarsPrefs lexiconTextView]; break;
            case 4: currentTextView = [globalVarsPrefs searchTextView]; break;
            case 5: currentTextView = [globalVarsPrefs vocabTextView]; break;
            case 6: currentTextView = [globalVarsPrefs notesTextView]; break;
            default: break;
        }
        currentFont = [currentTextView font];
        fontName = [[NSString alloc] initWithString:[currentFont fontName]];
        [currentTextView setFont:[NSFont fontWithName:fontName size:[[[globalVarsPrefs fontSize] objectAtIndex:idx] floatValue]]];
        [currentTextView setBackgroundColor:[[globalVarsPrefs bgColour] objectAtIndex:idx]];
        [currentTextView setTextColor:[[globalVarsPrefs fgColour] objectAtIndex:idx]];
        if( idx == 4 ) [currentTextView setString:@""];
    }
}

@end
