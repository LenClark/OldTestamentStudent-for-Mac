//
//  classReference.h
//  GreekBibleStudent
//
//  Created by Leonard Clark on 13/01/2021.
//

#import <Cocoa/Cocoa.h>
#import "classVerse.h"

NS_ASSUME_NONNULL_BEGIN

@interface classReference : NSObject

@property (nonatomic) NSInteger testamentCode;
@property (nonatomic) NSInteger bookIdx;
@property (nonatomic) NSInteger chapIdx;
@property (nonatomic) NSInteger verseIdx;
@property (nonatomic) NSInteger noOfMatches;
@property (retain) classVerse *currentLine;
@property (retain) classVerse *lineBeforeThis;
@property (retain) classVerse *twoLinesBefore;
@property (retain) classVerse *lineAfterThis;
@property (retain) classVerse *twoLinesAfter;

@end

NS_ASSUME_NONNULL_END
