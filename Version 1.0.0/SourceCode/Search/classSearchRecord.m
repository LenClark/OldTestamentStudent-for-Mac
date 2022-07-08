/****************************************************************
 *                                                              *
 *                     classSearchRecord                        *
 *                     =================                        *
 *                                                              *
 *  This class will store a single record that will be retained *
 *    for the life of the application session.  Each time the   *
 *    menu option to copy a word from the NT or LXX text to the *
 *    primary search field is activated, the details of where   *
 *    the word has come from will be retained (over-writing any *
 *    previous record) and stored in the first four variables.  *
 *    Similarly, use of the secondary copy functions will store *
 *    details in the last four variables.                       *
 *                                                              *
 *  If either text field is populated in any other way, old     *
 *    variable values will be left in place.  This will         *
 ^    probably mean that an attempt to identify the current     *
 *    word with the stored values will fail, but the code will  *
 *    then proceed to a global scan through both texts, so      *
 *    little will be lost.                                      *
 *                                                              *
 *  Created by Leonard Clark on 06/05/2020.                     *
 *                                                              *
 ****************************************************************/

#import "classSearchRecord.h"

@implementation classSearchRecord

@synthesize primaryTestament;
@synthesize primaryBookId;
@synthesize primaryChapterCode;
@synthesize primaryVerseCode;
@synthesize secondaryTestament;
@synthesize secondaryBookId;
@synthesize secondaryChapterCode;
@synthesize secondaryVerseCode;

- (id) init
{
    if( self = [super init] )
    {
        primaryTestament = 0;
        primaryBookId = -1;
        primaryChapterCode = @"";
        primaryVerseCode = @"";
        secondaryTestament = 0;
        secondaryBookId = -1;
        secondaryChapterCode = @"";
        secondaryVerseCode = @"";
    }
    return self;
}

@end
