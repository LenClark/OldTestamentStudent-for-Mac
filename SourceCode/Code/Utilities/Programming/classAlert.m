/*=====================================================================================*
 *                                                                                     *
 *                                   classAlert.h                                      *
 *                                   ============                                      *
 *                                                                                     *
 *  This is a simple wrapper to provide:                                               *
 *  a) a simple message box (with the only response as "OK", to remove it), and        *
 *  b) a Yes/No dialog for limited response.                                           *
 *                                                                                     *
 *  Created by Len Clark                                                               *
 *  May 2022                                                                           *
 *                                                                                     *
 *=====================================================================================*/

#import "classAlert.h"

@implementation classAlert

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
