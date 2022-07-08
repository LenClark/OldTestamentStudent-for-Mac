//
//  classVerse.m
//  GreekBibleStudent
//
//  Created by Leonard Clark on 05/01/2021.
//

#import "classVerse.h"

@implementation classVerse

@synthesize wordCount;
@synthesize bookId;
@synthesize noteText;
@synthesize bibleReference;
@synthesize previousVerse;
@synthesize nextVerse;
@synthesize wordIndex;

-(void) initialise: (NSInteger) inputBookId
{
        wordCount = 0;
        bookId = inputBookId;
    wordIndex = [[NSMutableDictionary alloc] init];
}

- (NSUInteger) WordCount
{
    return wordCount;
}

- (NSInteger) getBookId
{
    return bookId;
}

- (void) setBookId: (NSInteger) inBookId
{
    bookId = inBookId;
}

- (classWord *) getwordBySeqNo: (NSInteger) seqNo
{
    return [wordIndex objectForKey:[[NSString alloc] initWithFormat:@"%li", seqNo]];
}

- (NSString *) getWholeText
{
    NSInteger idx;
    NSString *singleWord, *punctuationItem, *preWord, *postWord;
    NSMutableString *wholeText;
    classWord *currentWord;
    
    wholeText = [[NSMutableString alloc] initWithString:@""];
    for( idx = 0; idx < wordCount; idx++)
    {
        currentWord = nil;
        currentWord = [wordIndex objectForKey:[[NSString alloc] initWithFormat:@"%li", idx]];
        if( currentWord == nil) continue;
        singleWord = [currentWord textWord];
        preWord = [currentWord preWordChars];
        postWord = [currentWord postWordChars];
        punctuationItem = [currentWord punctuation];
        if( ( singleWord != nil) && ( [singleWord length] > 0 ) )
        {
            if( [wholeText length] == 0 ) [wholeText appendFormat:@"%@%@%@%@", preWord, singleWord, postWord, punctuationItem];
            else [wholeText appendFormat:@" %@%@%@%@", preWord, singleWord, postWord, punctuationItem];
        }
    }
    return [wholeText copy];
}

@end
