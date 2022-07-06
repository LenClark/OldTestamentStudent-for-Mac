//
//  frmProgress.m
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import "frmProgress.h"

@interface frmProgress ()

@end

@implementation frmProgress

@synthesize initialisationProgress;
@synthesize labProgress1;
@synthesize labProgress2;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void) updateProgressMain: (NSString *) mainMessage withSecondMsg: (NSString *) secondMessage
{
    [labProgress1 setStringValue:mainMessage];
    if( [secondMessage length] > 0 )
    {
        [labProgress2 setStringValue:secondMessage];
        [labProgress2 setHidden:false];
    }
    else [labProgress2 setHidden:true];
    [initialisationProgress incrementBy:1.0];
}

@end
