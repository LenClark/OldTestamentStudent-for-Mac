/*==================================================================================*
 *                                                                                  *
 *                           classBDBEntryDetail                                    *
 *                           ===================                                    *
 *                                                                                  *
 *  Stores the text detail in "encoded" form.                                       *
 *                                                                                  *
 *  Variables:                                                                      *
 *  =========                                                                       *
 *                                                                                  *
 *  textStyleCode    A code as follows:                                             *
 *                          0   text is regular                                     *
 *                          1   text is bold                                        *
 *                          2   text is italic                                      *
 *                          3   text is bold and italic                             *
 *                                                                                  *
 *  lineStyleCode    A code as follows                                              *
 *                          0   text is not offset                                  *
 *                          1   text is superscript                                 *
 *                          2   text is subscript                                   *
 *                                                                                  *
 *  keyCode          Code values are                                                *
 *                          0   simple text (no other significance)                 *
 *                          1   Hebrew defining word (BDB Entry)                    *
 *                          2   Aramaic defining word (BDB Entry)                   *
 *                          3   Biblical Reference (see later)                      *
 *                          4   An academic reference: normal sized text            *
 *                          5   Text is designated as "Big": large sized text       *
 *                          6   Greek text: normal sized text                       *
 *                          7   Hebrew text (not initial word): large sized text    *
 *                          8   Aramaic text (not initial word): large sized text   *
 *                                                                                  *
 *  text             Any text associated with the specific field                    *
 *                                                                                  *
 *  The following fields are only populated for Biblical references:                *
 *  startChapter     The first chapter participating in a biblical reference        *
 *  endChapter       The final chapter participating in a biblical reference        *
 *                     If the endChapter = startChapter, the reference is in that   *
 *                     chapter alone                                                *
 *  startVerse       The first verse participating in a biblical reference          *
 *  endVerse         The final verse participating in a biblical reference          *
 *                     If endVerse = startVerse it is a single verse reference      *
 *  bookName         The (formatted) name of the book                               *
 *                                                                                  *
 *  Created by Len Clark                                                            *
 *  May 2022                                                                        *
 *                                                                                  *
 *==================================================================================*/

#import "classBDBEntryDetail.h"

@implementation classBDBEntryDetail

@synthesize textStyleCode;
@synthesize lineStyleCode;
@synthesize keyCode;
@synthesize startChapter;
@synthesize endChapter;
@synthesize startVerse;
@synthesize endVerse;
@synthesize text;
@synthesize bookName;

- (id) init
{
    if( self = [super init])
    {
        startChapter = -1;
        endChapter = -1;
        startVerse = -1;
        endVerse = -1;
        text = @"";
        bookName = @"";
    }
    return self;
}

@end
