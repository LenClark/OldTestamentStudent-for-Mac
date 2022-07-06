/*==================================================================================*
 *                                                                                  *
 *                           classBDBEntryDetail                                    *
 *                           ===================                                    *
 *                                                                                  *
 *  Stores the text detail in "encoded" form.                                       *
 *                                                                                  *
 *  Variables are described fully in classBDBEntryDetail.m.                         *
 *                                                                                  *
 *  Created by Len Clark                                                            *
 *  May 2022                                                                        *
 *                                                                                  *
 *==================================================================================*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface classBDBEntryDetail : NSObject

@property (nonatomic) NSInteger textStyleCode;
@property (nonatomic) NSInteger lineStyleCode;
@property (nonatomic) NSInteger keyCode;
@property (nonatomic) NSInteger startChapter;
@property (nonatomic) NSInteger endChapter;
@property (nonatomic) NSInteger startVerse;
@property (nonatomic) NSInteger endVerse;
@property (retain) NSString *text;
@property (retain) NSString *bookName;

@end

NS_ASSUME_NONNULL_END
