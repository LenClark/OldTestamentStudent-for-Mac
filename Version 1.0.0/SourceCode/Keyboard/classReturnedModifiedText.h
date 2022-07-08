//
//  classReturnedModifiedText.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 10/01/2021.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface classReturnedModifiedText : NSObject

@property (retain) NSString *returnedText;
@property (nonatomic) NSInteger newCursorPosition;

@end

NS_ASSUME_NONNULL_END
