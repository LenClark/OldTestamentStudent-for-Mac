/*================================================================================*
 *                                                                                *
 *                              classWordEntry                                    *
 *                              ==============                                    *
 *                                                                                *
 *  Because different instances of Hebrew and Aramaic words may have the same     *
 *    root form we must enable multiple BDB entries for a given word.  Since the  *
 *    Word will be the key of our dictionary, we need this class to resolve the   *
 *    one-to-many relationship.                                                   *
 *                                                                                *
 *  In brief, each distinct word form (as identified using the Strong Reference)  *
 *    will be stored in a single instance of this class.  However, that "word"    *
 *    may relate to more than one actual BDB entry.  So, this class will maintain *
 *    a one-to-many relationship between classWordEntry and classBDBEntry.        *
 *                                                                                *
 *  Created by Len Clark                                                          *
 *  May 2022                                                                      *
 *                                                                                *
 *================================================================================*/

#import "classWordEntry.h"

@implementation classWordEntry

@synthesize noOfEntries;
@synthesize relatedBDBEntries;

- (id) init
{
    if( self = [super init])
    {
        noOfEntries = 0;
        relatedBDBEntries = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) addEntry: (classBDBEntry *) bdbEntry
{
    [relatedBDBEntries setObject:bdbEntry forKey:[[NSString alloc] initWithFormat:@"%ld", noOfEntries++]];
}

- (classBDBEntry *) getCodeForSequence: (NSInteger) seqNo
{
    classBDBEntry *newBDBEntry;

    newBDBEntry = nil;
    if( seqNo < noOfEntries)
    {
        newBDBEntry = [relatedBDBEntries objectForKey:[[NSString alloc] initWithFormat:@"%ld", seqNo]];
    }
    return newBDBEntry;
}

@end
