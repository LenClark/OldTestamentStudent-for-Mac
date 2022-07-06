//
//  classLXXScanUnit.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 31/05/2022.
//

#import <Foundation/Foundation.h>
#import "classLXXWord.h"

NS_ASSUME_NONNULL_BEGIN

@interface classLXXScanUnit : NSObject

@property (nonatomic) NSInteger chapterSeq;
@property (nonatomic) NSInteger verseSeq;
@property (nonatomic) NSInteger wordSeq;
@property (retain) NSString *chapterRef;
@property (retain) NSString *verseRef;
@property (retain) classLXXWord *scanWord;

@end

NS_ASSUME_NONNULL_END
