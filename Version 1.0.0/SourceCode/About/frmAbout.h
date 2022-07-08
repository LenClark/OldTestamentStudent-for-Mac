//
//  frmAbout.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 31/01/2021.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface frmAbout : NSWindowController

- (void) simpleInitialisation: (frmAbout *) inSelf;
- (IBAction)doClose:(id)sender;

@end

NS_ASSUME_NONNULL_END
