//
//  frmHelp.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 20/06/2022.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface frmHelp : NSWindowController

@property (retain)IBOutlet NSWindow *helpWindow;
@property (retain) IBOutlet WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
