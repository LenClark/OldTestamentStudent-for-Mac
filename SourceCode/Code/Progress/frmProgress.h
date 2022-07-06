//
//  frmProgress.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface frmProgress : NSWindowController

@property (retain) IBOutlet NSProgressIndicator *initialisationProgress;
@property (retain) IBOutlet NSTextField *labProgress1;
@property (retain) IBOutlet NSTextField *labProgress2;

- (void) updateProgressMain: (NSString *) mainMessage withSecondMsg: (NSString *) secondMessage;

@end

NS_ASSUME_NONNULL_END
