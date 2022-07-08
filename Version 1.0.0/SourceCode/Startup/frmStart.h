//
//  frmStart.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 24/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface frmStart : NSWindowController

/*************************************************
 *
 *           Progress Window - Initialisation
 *           ======== ======   ==============
 *
 */

@property (retain) IBOutlet NSProgressIndicator *initialisationProgress;
@property (retain) IBOutlet NSTextField *labProgress1;
@property (retain) IBOutlet NSTextField *labProgress2;

@end

NS_ASSUME_NONNULL_END
