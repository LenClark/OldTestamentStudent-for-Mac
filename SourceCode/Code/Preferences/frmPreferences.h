//
//  frmPreferences.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 10/06/2022.
//

#import <Cocoa/Cocoa.h>
#import "classGlobal.h"
#import "classBHSBook.h"
#import "classBHSChapter.h"
#import "classBHSVerse.h"
#import "classBHSWord.h"
#import "classLXXBook.h"
#import "classLXXChapter.h"
#import "classLXXVerse.h"
#import "classLXXWord.h"
#import "classDisplayUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface frmPreferences : NSWindowController <NSComboBoxDelegate>

@property (retain) classGlobal *globalVarsPrefs;

// Flag for changes
@property (retain) NSMutableArray *changeRecord;

// Items from the bhsText preferences
@property (retain) IBOutlet NSComboBox *cbFontNameEng01;
@property (retain) IBOutlet NSComboBox *cbFontSizeEng01;
@property (retain) IBOutlet NSComboBox *cbFontStyleEng01;
@property (retain) IBOutlet NSColorWell *colFontColourEng01;

@property (retain) IBOutlet NSComboBox *cbFontNameMain01;
@property (retain) IBOutlet NSComboBox *cbFontSizeMain01;
@property (retain) IBOutlet NSComboBox *cbFontStyleMain01;
@property (retain) IBOutlet NSColorWell *colFontColourMain01;

@property (retain) IBOutlet NSComboBox *cbFontNameVar01;
@property (retain) IBOutlet NSComboBox *cbFontSizeVar01;
@property (retain) IBOutlet NSComboBox *cbFontStyleVar01;
@property (retain) IBOutlet NSColorWell *colFontColourVar01;

@property (retain) IBOutlet NSColorWell *colBackground01;
@property (retain) IBOutlet NSTextView *txtEg01;

// Items from the lxxText preferences
@property (retain) IBOutlet NSComboBox *cbFontNameEng02;
@property (retain) IBOutlet NSComboBox *cbFontSizeEng02;
@property (retain) IBOutlet NSComboBox *cbFontStyleEng02;
@property (retain) IBOutlet NSColorWell *colFontColourEng02;

@property (retain) IBOutlet NSComboBox *cbFontNameMain02;
@property (retain) IBOutlet NSComboBox *cbFontSizeMain02;
@property (retain) IBOutlet NSComboBox *cbFontStyleMain02;
@property (retain) IBOutlet NSColorWell *colFontColourMain02;

@property (retain) IBOutlet NSColorWell *colBackground02;
@property (retain) IBOutlet NSTextView *txtEg02;

// Items from the parse preferences
@property (retain) IBOutlet NSComboBox *cbFontNameEng03;
@property (retain) IBOutlet NSComboBox *cbFontSizeEng03;
@property (retain) IBOutlet NSComboBox *cbFontStyleEng03;
@property (retain) IBOutlet NSColorWell *colFontColourEng03;

@property (retain) IBOutlet NSComboBox *cbFontNameMain03;
@property (retain) IBOutlet NSComboBox *cbFontSizeMain03;
@property (retain) IBOutlet NSComboBox *cbFontStyleMain03;
@property (retain) IBOutlet NSColorWell *colFontColourMain03;

@property (retain) IBOutlet NSColorWell *colBackground03;
@property (retain) IBOutlet NSTextView *txtEg03;

// Items from the lexicon preferences
@property (retain) IBOutlet NSComboBox *cbFontNameEng04;
@property (retain) IBOutlet NSComboBox *cbFontSizeEng04;
@property (retain) IBOutlet NSComboBox *cbFontStyleEng04;
@property (retain) IBOutlet NSColorWell *colFontColourEng04;

@property (retain) IBOutlet NSComboBox *cbFontNameMain04;
@property (retain) IBOutlet NSComboBox *cbFontSizeMain04;
@property (retain) IBOutlet NSComboBox *cbFontStyleMain04;
@property (retain) IBOutlet NSColorWell *colFontColourMain04;

@property (retain) IBOutlet NSComboBox *cbFontNamePrimary04;
@property (retain) IBOutlet NSComboBox *cbFontSizePrimary04;
@property (retain) IBOutlet NSComboBox *cbFontStylePrimary04;
@property (retain) IBOutlet NSColorWell *colFontColourPrimary04;

@property (retain) IBOutlet NSColorWell *colBackground04;
@property (retain) IBOutlet NSTextView *txtEg04;

// Items from the BHS search Results preferences
@property (retain) IBOutlet NSComboBox *cbFontNameEng05;
@property (retain) IBOutlet NSComboBox *cbFontSizeEng05;
@property (retain) IBOutlet NSComboBox *cbFontStyleEng05;
@property (retain) IBOutlet NSColorWell *colFontColourEng05;

@property (retain) IBOutlet NSComboBox *cbFontNameMain05;
@property (retain) IBOutlet NSComboBox *cbFontSizeMain05;
@property (retain) IBOutlet NSComboBox *cbFontStyleMain05;
@property (retain) IBOutlet NSColorWell *colFontColourMain05;

@property (retain) IBOutlet NSComboBox *cbFontNamePrimary05;
@property (retain) IBOutlet NSComboBox *cbFontSizePrimary05;
@property (retain) IBOutlet NSComboBox *cbFontStylePrimary05;
@property (retain) IBOutlet NSColorWell *colFontColourPrimary05;

@property (retain) IBOutlet NSComboBox *cbFontNameSecondary05;
@property (retain) IBOutlet NSComboBox *cbFontSizeSecondary05;
@property (retain) IBOutlet NSComboBox *cbFontStyleSecondary05;
@property (retain) IBOutlet NSColorWell *colFontColourSecondary05;

@property (retain) IBOutlet NSColorWell *colBackground05;
@property (retain) IBOutlet NSTextView *txtEg05;

// Items from the LXX search Results preferences
@property (retain) IBOutlet NSComboBox *cbFontNameEng06;
@property (retain) IBOutlet NSComboBox *cbFontSizeEng06;
@property (retain) IBOutlet NSComboBox *cbFontStyleEng06;
@property (retain) IBOutlet NSColorWell *colFontColourEng06;

@property (retain) IBOutlet NSComboBox *cbFontNameMain06;
@property (retain) IBOutlet NSComboBox *cbFontSizeMain06;
@property (retain) IBOutlet NSComboBox *cbFontStyleMain06;
@property (retain) IBOutlet NSColorWell *colFontColourMain06;

@property (retain) IBOutlet NSComboBox *cbFontNamePrimary06;
@property (retain) IBOutlet NSComboBox *cbFontSizePrimary06;
@property (retain) IBOutlet NSComboBox *cbFontStylePrimary06;
@property (retain) IBOutlet NSColorWell *colFontColourPrimary06;

@property (retain) IBOutlet NSComboBox *cbFontNameSecondary06;
@property (retain) IBOutlet NSComboBox *cbFontSizeSecondary06;
@property (retain) IBOutlet NSComboBox *cbFontStyleSecondary06;
@property (retain) IBOutlet NSColorWell *colFontColourSecondary06;

@property (retain) IBOutlet NSColorWell *colBackground06;
@property (retain) IBOutlet NSTextView *txtEg06;

// Items from the BHS Notes preferences
@property (retain) IBOutlet NSComboBox *cbFontNameEng07;
@property (retain) IBOutlet NSComboBox *cbFontSizeEng07;
@property (retain) IBOutlet NSComboBox *cbFontStyleEng07;
@property (retain) IBOutlet NSColorWell *colFontColourEng07;

@property (retain) IBOutlet NSColorWell *colBackground07;
@property (retain) IBOutlet NSTextView *txtEg07;

// Items from the LXX Notes preferences
@property (retain) IBOutlet NSComboBox *cbFontNameEng08;
@property (retain) IBOutlet NSComboBox *cbFontSizeEng08;
@property (retain) IBOutlet NSComboBox *cbFontStyleEng08;
@property (retain) IBOutlet NSColorWell *colFontColourEng08;

@property (retain) IBOutlet NSColorWell *colBackground08;
@property (retain) IBOutlet NSTextView *txtEg08;

// Arrays of data copied from global
@property (retain) NSMutableArray *allEngFontNames;
@property (retain) NSMutableArray *allEngFontSizes;
@property (retain) NSMutableArray *allEngFontStyles;
@property (retain) NSMutableArray *allEngColours;

@property (retain) NSMutableArray *allMainFontNames;
@property (retain) NSMutableArray *allMainFontSizes;
@property (retain) NSMutableArray *allMainFontStyles;
@property (retain) NSMutableArray *allMainColours;

@property (retain) NSMutableArray *allPrimaryFontNames;
@property (retain) NSMutableArray *allPrimaryFontSizes;
@property (retain) NSMutableArray *allPrimaryFontStyles;
@property (retain) NSMutableArray *allPrimaryColours;

@property (retain) NSMutableArray *allSecondaryFontNames;
@property (retain) NSMutableArray *allSecondaryFontSizes;
@property (retain) NSMutableArray *allSecondaryFontStyles;
@property (retain) NSMutableArray *allSecondaryColours;

@property (retain) NSMutableArray *allBackgroundColours;

// Global values
@property (retain) NSArray *listOfSizes;
@property (retain) NSArray *fontList;
@property (retain) NSFontManager *fontMan;
@property (nonatomic) NSInteger noOfViews;

- (void) initialiseWindow: (classGlobal *) inGlobal;

@end

NS_ASSUME_NONNULL_END
