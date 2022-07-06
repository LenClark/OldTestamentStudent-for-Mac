//
//  classDisplayUtilities.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import "classDisplayUtilities.h"

@implementation classDisplayUtilities

@synthesize globalDispUtilsVar;

- (id) init: (classGlobal *) inGlobal
{
    if( self = [super init])
    {
        globalDispUtilsVar = inGlobal;
    }
    return self;
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
        case 0: usedFont = [globalDispUtilsVar bhsTextEngFont]; usedColour = [globalDispUtilsVar bhsTextEngColour]; break;
        case 1: usedFont = [globalDispUtilsVar bhsTextMainFont]; usedColour = [globalDispUtilsVar bhsTextMainColour]; break;
        case 2: usedFont = [globalDispUtilsVar bhsTextVariants]; usedColour = [globalDispUtilsVar bhsTextVariantColour]; break;
        case 3: usedFont = [globalDispUtilsVar lxxTextEngFont]; usedColour = [globalDispUtilsVar lxxTextEngColour]; break;
        case 4: usedFont = [globalDispUtilsVar lxxTextMainFont]; usedColour = [globalDispUtilsVar lxxTextMainColour]; break;
        case 5: usedFont = [globalDispUtilsVar parseTitleFont]; usedColour = [globalDispUtilsVar parseTitleColour]; break;
        case 6: usedFont = [globalDispUtilsVar parseTextFont]; usedColour = [globalDispUtilsVar parseTextColour]; break;
        case 7: usedFont = [globalDispUtilsVar lexTitleFont]; usedColour = [globalDispUtilsVar lexTitleColour]; break;
        case 8: usedFont = [globalDispUtilsVar lexTextFont]; usedColour = [globalDispUtilsVar lexTextColour]; break;
        case 9: usedFont = [globalDispUtilsVar searchEngText]; usedColour = [globalDispUtilsVar searchEngColour]; break;
        case 10: usedFont = [globalDispUtilsVar searchBHSMainText]; usedColour = [globalDispUtilsVar searchBHSMainColour]; break;
        case 11: usedFont = [globalDispUtilsVar searchBHSPrimaryText]; usedColour = [globalDispUtilsVar searchBHSPrimaryColour]; break;
        case 12: usedFont = [globalDispUtilsVar searchBHSSecondaryText]; usedColour = [globalDispUtilsVar searchBHSSecondaryColour]; break;
        case 13: usedFont = [globalDispUtilsVar searchGreekMainText]; usedColour = [globalDispUtilsVar searchGreekMainColour]; break;
        case 14: usedFont = [globalDispUtilsVar searchGreekPrimaryText]; usedColour = [globalDispUtilsVar searchGreekPrimaryColour]; break;
        case 15: usedFont = [globalDispUtilsVar searchGreekSecondaryText]; usedColour = [globalDispUtilsVar searchGreekSecondaryColour]; break;
        case 16: usedFont = [globalDispUtilsVar bhsNotesText]; usedColour = [globalDispUtilsVar bhsNotesColour]; break;
        case 17: usedFont = [globalDispUtilsVar lxxNotesText]; usedColour = [globalDispUtilsVar lxxNotesColour]; break;
            // Added later, hence out of sequence
        case 18: usedFont = [globalDispUtilsVar lexPrimaryFont]; usedColour = [globalDispUtilsVar lexPrimaryColour]; break;
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

@end
