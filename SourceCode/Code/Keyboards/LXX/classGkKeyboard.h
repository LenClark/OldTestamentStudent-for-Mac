//
//  classGkKeyboard.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 23/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classGreekOrthography.h"
#import "classKbCommon.h"
#import "classReturnedModifiedText.h"

NS_ASSUME_NONNULL_BEGIN

@interface classGkKeyboard : NSObject

@property (retain) classGreekOrthography *greekOrthography;
@property (nonatomic) BOOL isGkMiniscule;
@property (nonatomic) BOOL isLXXCarriageReturnDown;
@property (nonatomic) BOOL isLXXShiftDown;
@property (retain) NSView *lxxKeyboardPanel;
@property (retain) NSView *lxxHistoryPanel;
@property (retain) NSArray *gkKeys;
@property (retain) NSDictionary *minisculeGkKeyFace;
@property (retain) NSDictionary *majisculeGkKeyFace;
@property (retain) NSButton *showLXXHideButton;
@property (retain) NSButton *rbtnGkKbNotes;
@property (retain) NSButton *rbtnGkKbPrimary;
@property (retain) NSButton *rbtnGkKbSecondary;

- (id) init: (classGlobal *) inGlobal withGkOthography: (classGreekOrthography *) inGkOrth;
- (void) setupGkKeyboard;

@end

NS_ASSUME_NONNULL_END
