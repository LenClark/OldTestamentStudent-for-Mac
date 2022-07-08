//
//  classRegistry.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 06/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"

@interface classRegistry : NSObject

- (id) init: (classConfig *) passedConfig;
- (void) saveInitData;

@end
