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

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface classAlert : NSObject

-(void) messageBox: (NSString *) message title: (NSString *) titleText boxStyle: (NSUInteger) alertStyle;
-(BOOL) yesNoMessage: (NSString *) message title: (NSString *) titleText boxStyle: (NSUInteger) alertStyle YesPrompt: (NSString *) yesPrompt NoPrompt: (NSString *) noPrompt;

@end

NS_ASSUME_NONNULL_END
