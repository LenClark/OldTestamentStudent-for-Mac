//
//  classRegistry.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 21/05/2022.
//

#import <Foundation/Foundation.h>
#import "classGlobal.h"
#import "classAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface classRegistry : NSObject

- (void) initialiseRegistry: (classGlobal *) passedConfig;
- (void) saveIniValues;

@end

NS_ASSUME_NONNULL_END
