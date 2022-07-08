//
//  GBSAlert.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBSAlert : NSObject

-(void) messageBox: (NSString *) message title: (NSString *) titleText boxStyle: (NSUInteger) alertStyle;
-(BOOL) yesNoMessage: (NSString *) message title: (NSString *) titleText boxStyle: (NSUInteger) alertStyle YesPrompt: (NSString *) yesPrompt NoPrompt: (NSString *) noPrompt;

@end

NS_ASSUME_NONNULL_END
