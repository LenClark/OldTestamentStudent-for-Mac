//
//  classHebKeyboard.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classKbCommon.h"
#import "classDisplayUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface classHebKeyboard : NSObject

@property (nonatomic) BOOL isBHSCarriageReturnDown;
@property (nonatomic) BOOL isBHSShiftDown;
@property (retain) NSView *bhsKeyboardPanel;
@property (retain) NSView *bhsHistoryPanel;
@property (retain) NSArray *hebKeys;
@property (retain) NSDictionary *hebKeyFace;
@property (retain) NSButton *showBHSHideButon;
@property (retain) NSButton *showBHSHideButton;
@property (retain) NSButton *rbtnBHSKbNotes;
@property (retain) NSButton *rbtnBHSKbPrimary;
@property (retain) NSButton *rbtnBHSKbSecondary;
@property (retain) NSMutableString *inFlightText;
@property (nonatomic) NSInteger inFlightCursorPstn;
@property (retain) NSTextView *editView;
@property (retain) NSButton *btnUse;

- (id) init: (classGlobal *) inGlobal;
- (void) setupHebKeyboard;
- (NSString *) removeAccents: (NSString *) sourceWord;

@end

NS_ASSUME_NONNULL_END
