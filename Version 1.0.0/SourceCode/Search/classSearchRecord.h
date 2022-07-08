//
//  classSearchRecord.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 13/01/2021.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface classSearchRecord : NSObject

@property (nonatomic) NSInteger primaryTestament;
@property (nonatomic) NSInteger primaryBookId;
@property (retain) NSString *primaryChapterCode;
@property (retain) NSString *primaryVerseCode;
@property (nonatomic) NSInteger secondaryTestament;
@property (nonatomic) NSInteger secondaryBookId;
@property (retain) NSString *secondaryChapterCode;
@property (retain) NSString *secondaryVerseCode;

@end

NS_ASSUME_NONNULL_END
