//
//  GBSAlert.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import "GBSAlert.h"

@implementation GBSAlert

-(void) messageBox: (NSString *) message title: (NSString *) titleText boxStyle: (NSUInteger) alertStyle
{
    NSAlert *alert;
    
    alert = [[NSAlert alloc] init];
    [alert setInformativeText:message];
    [alert setMessageText:titleText];
    [alert setAlertStyle:alertStyle];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

-(BOOL) yesNoMessage: (NSString *) message title: (NSString *) titleText boxStyle: (NSUInteger) alertStyle YesPrompt: (NSString *) yesPrompt NoPrompt: (NSString *) noPrompt
{
    NSAlert *alert;
    
    alert = [[NSAlert alloc] init];
    [alert setInformativeText:message];
    [alert setMessageText:titleText];
    [alert setAlertStyle:alertStyle];
    [alert addButtonWithTitle:yesPrompt];
    [alert addButtonWithTitle:noPrompt];
    return alert.runModal == NSAlertFirstButtonReturn;
}

@end
