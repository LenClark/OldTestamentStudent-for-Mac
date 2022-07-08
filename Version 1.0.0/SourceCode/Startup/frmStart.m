//
//  frmStart.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 24/01/2021.
//

#import "frmStart.h"

@interface frmStart ()

@end

@implementation frmStart

/*************************************************
 *
 *           Progress Window - Initialisation
 *           ======== ======   ==============
 *
 */

@synthesize initialisationProgress;
@synthesize labProgress1;
@synthesize labProgress2;

AppDelegate *mainAppDelegate;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    mainAppDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    mainAppDelegate.initialisationProgress = initialisationProgress;
    mainAppDelegate.labProgress1 = labProgress1;
    mainAppDelegate.labProgress2 = labProgress2;
}

- (void) updateProgressMain: (NSString *) mainMessage
{
    
}

@end
