//
//  classScanReturn.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface classScanReturn : NSObject

@property (retain) NSString *wordUnderCursor;
@property (nonatomic) NSInteger noOfWords;
@property (nonatomic) NSInteger selectedWordNo;

@end

NS_ASSUME_NONNULL_END
