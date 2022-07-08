//
//  classKeyboard.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 10/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classConfig.h"
#import "classGreekProcessing.h"
#import "GBSAlert.h"
#import "classReturnedModifiedText.h"

NS_ASSUME_NONNULL_BEGIN

@interface classKeyboard : NSObject

- (id) init: (classConfig *) inConfig greekInfo: (classGreekProcessing *) inGreek;

@end

NS_ASSUME_NONNULL_END
