//
//  classBHSScanUnit.h
//  OldTestamentStudent
//
//  Created by Leonard Clark on 29/05/2022.
//

#import <Foundation/Foundation.h>
#import "classBHSWord.h"

NS_ASSUME_NONNULL_BEGIN

@interface classBHSScanUnit : NSObject

@property (nonatomic) NSInteger chapterSeq;
@property (nonatomic) NSInteger verseSeq;
@property (nonatomic) NSInteger wordSeq;
@property (retain) NSString *chapterRef;
@property (retain) NSString *verseRef;
@property (retain) classBHSWord *scanWord;

@end

NS_ASSUME_NONNULL_END
