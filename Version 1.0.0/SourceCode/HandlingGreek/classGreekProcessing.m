/***************************************************************************
 *                                                                         *
 *                       classGreekProcessing                              *
 *                       ====================                              *
 *                                                                         *
 *  All manipulations of Greek text will, where possible, be handled here. *
 *  Envisaged tasks are:                                                   *
 *                                                                         *
 *  1. Store bare vowels                                                   *
 *  2. Store bare consonants                                               *
 *  3. Store all base letters                                              *
 *  4. Handle the transition from a letter with "furniture" (e.g. accents, *
 *       diaraesis, etc - excluding breathings) to related letters with    *
 *       either no diacritics or with a breathing only;                    *
 *  5. Handle the transition from a letter with breathings to the base     *
 *       equivalent                                                        *
 *  6. Potentially, handle the addition of diacritics (not currently       *
 *       needed)                                                           *
 *  7. Potentially, handle the transition from transliterations to the     *
 *       real Greek character (not currently needed)                       *
 *                                                                         *
 *  Created by Leonard Clark on 25/04/2020                                 *
 *                                                                         *
 ***************************************************************************/

#import "classGreekProcessing.h"

@implementation classGreekProcessing

@synthesize allowedPunctuation;
@synthesize allGkChars;
@synthesize conversionWithBreathings;
@synthesize addRoughBreathing;
@synthesize addSmoothBreathing;
@synthesize addAccute;
@synthesize addGrave;
@synthesize addCirc;
@synthesize addDiaeresis;
@synthesize addIotaSub;

const NSInteger mainCharsStart = 0x0386, mainCharsEnd = 0x03ce, furtherCharsStart = 0x1f00, furtherCharsEnd = 0x1ffc;

classConfig *globalVarsGk;

- (id) init: (classConfig *) inConfig
{
    if( self = [super init] )
    {
        NSNumber *conversionNum;
        globalVarsGk = inConfig;
        allowedPunctuation = [[NSArray alloc] initWithObjects:@".", @";", @",", @"\u00b7", @"\u0387", @"\u037e" , nil];
        allGkChars = [[NSMutableDictionary alloc] init];
        conversionWithBreathings = [[NSMutableDictionary alloc] init];
        addRoughBreathing = [[NSMutableDictionary alloc] init];
        addSmoothBreathing = [[NSMutableDictionary alloc] init];
        addAccute = [[NSMutableDictionary alloc] init];
        addGrave = [[NSMutableDictionary alloc] init];
        addCirc = [[NSMutableDictionary alloc] init];
        addIotaSub = [[NSMutableDictionary alloc] init];
        addDiaeresis = [[NSMutableDictionary alloc] init];

        /**********************************************************************************
         *                                                                                *
         *                          constructGreekLists                                   *
         *                          ===================                                   *
         *                                                                                *
         *  The coding works on the following basis:                                      *
         *    a) Each base vowel has an integer value in ascending order.  So:            *
         *          α = 1                                                                 *
         *          ε = 2                                                                 *
         *          η = 3                                                                 *
         *          ι = 4                                                                 *
         *          ο = 5                                                                 *
         *          υ = 6                                                                 *
         *          ω = 7                                                                 *
         *       This value applies whether it is miniscule or majiscule                  *
         *    b) Add 10 if the vowel has a "grave" accent (varia)                         *
         *    c) Add 20 if the vowel has an "accute" accent (oxia)                        *
         *    d) Add 30 if the vowel has a "circumflex" accent (perispomeni)              *
         *    e) Add 40 if the vowel is in the base table and has an accute accent (oxia) *
         *         i.e. it is an alternative coding - it's actually a tonos, not an oxia  *
         *    f) Add 50 if the vowel has a vrachy (cannot have a breathing or accent)     *
         *    g) Add 60 if the vowel has a macron                                         *
         *    h) Add 100 if the vowel has a smooth breathing (psili)                      *
         *    i) Add 200 if the vowel has a rough breathing (dasia)                       *
         *    j) Add 300 if the vowel has dieresis (dialytika) - only ι and υ             *
         *    k) Add 1000 if the vowel has an iota subscript - only α, η and ω            *
         *    l) Add 10000 if a majuscule                                                 *
         *                                                                                *
         *    charCode1 (a and b):                                                        *
         *      purpose: to indicate whether a char is vowel (and, if so, which), another *
         *      extra character (i.e. rho or final sigma), a simple letter or puntuation. *
         *      Code values are:                                                          *
         *        -1   A null value - to be ignored                                       *
         *       0 - 6 alpha to omega respectively - not simple                           *
         *         7   rho - not simple                                                   *
         *         8   final sigma                                                        *
         *         9   simple alphabet                                                    *
         *        10   punctuation                                                        *
         *                                                                                *
         *    charCode2:                                                                  *
         *      purpose: identify whether char has a smooth breathing, rough breathing or *
         *               none.  All part a chars are without breathing, so only part b    *
         *               characters are coded. (Note, however, that 0x03ca and 0x03cb are *
         *               diereses (code value 3).                                         *
         *      Code values are:                                                          *
         *         0   No breathing                                                       *
         *         1   Smooth breathing                                                   *
         *         2   Rough breathing                                                    *
         *         3   Dieresis                                                           *
         *                                                                                *
         **********************************************************************************/
     
        NSArray *gkTable1 = @[ @0x03b1, @-1, @0x03b5, @0x03b7, @0x03b9, @-1, @0x03bf, @-1, @0x03c5, @0x03c9, @0x03ca,
            @0x03b1, @0x03b2, @0x03b3, @0x03b4, @0x03b5, @0x03b6, @0x03b7, @0x03b8, @0x03b9, @0x03ba, @0x03bb, @0x03bc, @0x03bd, @0x03be, @0x03bf,
            @0x03c0, @0x03c1, @-1, @0x03c3, @0x03c4, @0x03c5, @0x03c6, @0x03c7, @0x03c8, @0x03c9, @0x03ca, @0x03cb, @0x03b1, @0x03b5, @0x03b7, @0x03b9, @0x03cb,
            @0x03b1, @0x03b2, @0x03b3, @0x03b4, @0x03b5, @0x03b6, @0x03b7, @0x03b8, @0x03b9, @0x03ba, @0x03bb, @0x03bc, @0x03bd, @0x03be, @0x03bf,
            @0x03c0, @0x03c1, @0x03c2, @0x03c3, @0x03c4, @0x03c5, @0x03c6, @0x03c7, @0x03c8, @0x03c9, @0x03ca, @0x03cb, @0x03bf, @0x03c5, @0x03c9 ];
        NSArray *gkTable2 = @[ @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01,
            @0x1f10, @0x1f11, @0x1f10, @0x1f11, @0x1f10, @0x1f11, @-1, @-1, @0x1f10, @0x1f11, @0x1f10, @0x1f11, @0x1f10, @0x1f11, @-1, @-1,
            @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21,
            @0x1f30, @0x1f31, @0x1f30, @0x1f31, @0x1f30, @0x1f31, @0x1f30, @0x1f31, @0x1f30, @0x1f31, @0x1f30, @0x1f31, @0x1f30, @0x1f31, @0x1f30, @0x1f31,
            @0x1f40, @0x1f41, @0x1f40, @0x1f41, @0x1f40, @0x1f41, @-1, @-1, @0x1f40, @0x1f41, @0x1f40, @0x1f41, @0x1f40, @0x1f41, @-1, @-1,
            @0x1f50, @0x1f51, @0x1f50, @0x1f51, @0x1f50, @0x1f51, @0x1f50, @0x1f51, @-1, @0x1f51, @-1, @0x1f51, @-1, @0x1f51, @-1, @0x1f51,
            @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61,
            @0x03b1, @0x03b1, @0x03b5, @0x03b5, @0x03b7, @0x03b7, @0x03b9, @0x03b9, @0x03bf, @0x03bf, @0x03c5, @0x03c5, @0x03c9, @0x03c9, @-1, @-1,
            @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01, @0x1f00, @0x1f01,
            @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21, @0x1f20, @0x1f21,
            @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61, @0x1f60, @0x1f61,
            @0x03b1, @0x03b1, @0x03b1, @0x03b1, @0x03b1, @-1, @0x03b1, @0x03b1, @0x03b1, @0x03b1, @0x03b1, @0x03b1, @0x03b1, @-1, @-1, @-1,
            @-1, @-1, @0x03b7, @0x03b7, @0x03b7, @-1, @0x03b7, @0x03b7, @0x03b5, @0x03b5, @0x03b7, @0x03b7, @0x03b7, @-1, @-1, @-1,
            @0x03b9, @0x03b9, @0x03ca, @0x03ca, @-1, @-1, @0x03b9, @0x03ca, @0x03b9, @0x03b9, @0x03b9, @0x03b9, @-1, @-1, @-1, @-1,
            @0x03c5, @0x03c5, @0x03cb, @0x03cb, @0x1fe4, @0x1fe5, @0x03c5, @0x03cb, @0x03c5, @0x03c5, @0x03c5, @0x03c5, @0x1fe5, @-1, @-1, @-1,
            @-1, @-1, @0x03c9, @0x03c9, @0x03c9, @-1, @0x03c9, @0x03c9, @0x03bf, @0x03bf, @0x03c9, @0x03c9, @0x03c9, @-1, @-1, @-1 ];
        NSArray *withRough1 = @[ @0x1f0d, @-1, @0x1f1d, @0x1f2d, @0x1f3d, @-1, @0x1f4d, @-1, @0x1f5d, @0x1f6d, @0x0390,
                               @0x1f09, @0x0392, @0x0393, @0x0394, @0x1f19, @0x0396, @0x1f29, @0x0398, @0x1f39, @0x039a, @0x039b, @0x039c, @0x039d, @0x039e, @0x1f49,
                               @0x03a0, @0x03a1, @-1, @0x03a3, @0x03a4, @0x1f59, @0x03a6, @0x03a7, @0x03a8, @0x1f69, @0x03aa, @0x03ab, @0x1f05, @0x1f15, @0x1f25, @0x1f35, @0x03b0,
                               @0x1f01, @0x03b2, @0x03b3, @0x03b4, @0x1f11, @0x03b6, @0x1f21, @0x03b8, @0x1f31, @0x03ba, @0x03bb, @0x03bc, @0x03bd, @0x03be, @0x1f41,
                               @0x03c0, @0x03c1, @0x03c2, @0x03c3, @0x03c4, @0x1f51, @0x03c6, @0x03c7, @0x03c8, @0x1f61, @0x03ca, @0x03cb, @0x1f45, @0x1f55, @0x1f65 ];
        NSArray *withRough2 = @[ @0x1f00, @0x1f01, @0x1f02, @0x1f03, @0x1f04, @0x1f05, @0x1f06, @0x1f07, @0x1f08, @0x1f09, @0x1f0a, @0x1f0b, @0x1f0c, @0x1f0d, @0x1f0e, @0x1f0f,
                               @0x1f10, @0x1f11, @0x1f12, @0x1f13, @0x1f14, @0x1f15, @-1, @-1, @0x1f18, @0x1f19, @0x1f1a, @0x1f1b, @0x1f1c, @0x1f1d, @-1, @-1,
                               @0x1f20, @0x1f21, @0x1f22, @0x1f23, @0x1f24, @0x1f25, @0x1f26, @0x1f27, @0x1f28, @0x1f29, @0x1f2a, @0x1f2b, @0x1f2c, @0x1f2d, @0x1f2e, @0x1f2f,
                               @0x1f30, @0x1f31, @0x1f32, @0x1f33, @0x1f34, @0x1f35, @0x1f36, @0x1f37, @0x1f38, @0x1f39, @0x1f3a, @0x1f3b, @0x1f3c, @0x1f3d, @0x1f3e, @0x1f3f,
                               @0x1f40, @0x1f41, @0x1f42, @0x1f43, @0x1f44, @0x1f45, @-1, @-1, @0x1f48, @0x1f49, @0x1f4a, @0x1f4b, @0x1f4c, @0x1f4d, @-1, @-1,
                               @0x1f50, @0x1f51, @0x1f52, @0x1f53, @0x1f54, @0x1f55, @0x1f56, @0x1f57, @-1, @0x1f59, @-1, @0x1f5b, @-1, @0x1f5d, @-1, @0x1f5f,
                               @0x1f60, @0x1f61, @0x1f62, @0x1f63, @0x1f64, @0x1f65, @0x1f66, @0x1f67, @0x1f68, @0x1f69, @0x1f6a, @0x1f6b, @0x1f6c, @0x1f6d, @0x1f6e, @0x1f6f,
                               @0x1f03, @0x1f05, @0x1f13, @0x1f15, @0x1f23, @0x1f25, @0x1f33, @0x1f35, @0x1f43, @0x1f45, @0x1f53, @0x1f55, @0x1f63, @0x1f65, @-1, @-1,
                               @0x1f80, @0x1f81, @0x1f82, @0x1f83, @0x1f84, @0x1f85, @0x1f86, @0x1f87, @0x1f88, @0x1f89, @0x1f8a, @0x1f8b, @0x1f8c, @0x1f8d, @0x1f8e, @0x1f8f,
                               @0x1f90, @0x1f91, @0x1f92, @0x1f93, @0x1f94, @0x1f95, @0x1f96, @0x1f97, @0x1f98, @0x1f99, @0x1f9a, @0x1f9b, @0x1f9c, @0x1f9d, @0x1f9e, @0x1f9f,
                               @0x1fa0, @0x1fa1, @0x1fa2, @0x1fa3, @0x1fa4, @0x1fa5, @0x1fa6, @0x1fa7, @0x1fa8, @0x1fa9, @0x1faa, @0x1fab, @0x1fac, @0x1fad, @0x1fae, @0x1faf,
                               @0x1fb0, @0x1fb1, @0x1f83, @0x1f81, @0x1f85, @-1, @0x1f07, @0x1f87, @0x1fb8, @0x1fb9, @0x1f0b, @0x1f0d, @0x1f89, @-1, @-1, @-1,
                               @-1, @-1, @0x1f93, @0x1f91, @0x1f95, @-1, @0x1f27, @0x1f97, @0x1f1b, @0x1f1d, @0x1f2b, @0x1f2d, @0x1f99, @-1, @-1, @-1,
                               @0x1fd0, @0x1fd1, @0x1fd2, @0x1fd3, @-1, @-1, @0x1f37, @0x1fd7, @0x1fd8, @0x1fd9, @0x1f3b, @0x1f3d, @-1, @-1, @-1, @-1,
                               @0x1fe0, @0x1fe1, @0x1fe2, @0x1fe3, @0x1fe4, @0x1fe5, @0x1f57, @0x1fe7, @0x1fe8, @0x1fe9, @0x1f5b, @0x1f5d, @0x1fec, @-1, @-1, @-1,
                               @-1, @-1, @0x1fa3, @0x1fa1, @0x1fa5, @-1, @0x1f67, @0x1fa7, @0x1f4b, @0x1f4d, @0x1f6b, @0x1f6d, @0x1fa9, @-1, @-1, @-1 ];

        NSArray *withSmooth1 = @[ @0x1f0c, @-1, @0x1f1c, @0x1f2c, @0x1f3c, @-1, @0x1f4c, @-1, @0x038e, @0x1f6c, @0x0390,
                                 @0x1f08, @0x0392, @0x0393, @0x0394, @0x1f18, @0x0396, @0x1f28, @0x0398, @0x1f38, @0x039a, @0x039b, @0x039c, @0x039d, @0x039e, @0x1f48,
                                 @0x03a0, @0x03a1, @-1, @0x03a3, @0x03a4, @0x1f58, @0x03a6, @0x03a7, @0x03a8, @0x1f68, @0x03aa, @0x03ab, @0x1f04, @0x1f14, @0x1f24, @0x1f34, @0x03b0,
                                 @0x1f00, @0x03b2, @0x03b3, @0x03b4, @0x1f10, @0x03b6, @0x1f20, @0x03b8, @0x1f30, @0x03ba, @0x03bb, @0x03bc, @0x03bd, @0x03be, @0x1f40,
                                 @0x03c0, @0x03c1, @0x03c2, @0x03c3, @0x03c4, @0x1f50, @0x03c6, @0x03c7, @0x03c8, @0x1f60, @0x03ca, @0x03cb, @0x1f44, @0x1f54, @0x1f64 ];
        NSArray *withSmooth2 = @[ @0x1f00, @0x1f01, @0x1f02, @0x1f03, @0x1f04, @0x1f05, @0x1f06, @0x1f07, @0x1f08, @0x1f09, @0x1f0a, @0x1f0b, @0x1f0c, @0x1f0d, @0x1f0e, @0x1f0f,
                                 @0x1f10, @0x1f11, @0x1f12, @0x1f13, @0x1f14, @0x1f15, @-1, @-1, @0x1f18, @0x1f19, @0x1f1a, @0x1f1b, @0x1f1c, @0x1f1d, @-1, @-1,
                                 @0x1f20, @0x1f21, @0x1f22, @0x1f23, @0x1f24, @0x1f25, @0x1f26, @0x1f27, @0x1f28, @0x1f29, @0x1f2a, @0x1f2b, @0x1f2c, @0x1f2d, @0x1f2e, @0x1f2f,
                                 @0x1f30, @0x1f31, @0x1f32, @0x1f33, @0x1f34, @0x1f35, @0x1f36, @0x1f37, @0x1f38, @0x1f39, @0x1f3a, @0x1f3b, @0x1f3c, @0x1f3d, @0x1f3e, @0x1f3f,
                                 @0x1f40, @0x1f41, @0x1f42, @0x1f43, @0x1f44, @0x1f45, @-1, @-1, @0x1f48, @0x1f49, @0x1f4a, @0x1f4b, @0x1f4c, @0x1f4d, @-1, @-1,
                                 @0x1f50, @0x1f51, @0x1f52, @0x1f53, @0x1f54, @0x1f55, @0x1f56, @0x1f57, @-1, @0x1f59, @-1, @0x1f5b, @-1, @0x1f5d, @-1, @0x1f5f,
                                 @0x1f60, @0x1f61, @0x1f62, @0x1f63, @0x1f64, @0x1f65, @0x1f66, @0x1f67, @0x1f68, @0x1f69, @0x1f6a, @0x1f6b, @0x1f6c, @0x1f6d, @0x1f6e, @0x1f6f,
                                 @0x1f02, @0x1f04, @0x1f12, @0x1f14, @0x1f22, @0x1f24, @0x1f32, @0x1f34, @0x1f42, @0x1f44, @0x1f52, @0x1f54, @0x1f62, @0x1f64, @-1, @-1,
                                 @0x1f80, @0x1f81, @0x1f82, @0x1f83, @0x1f84, @0x1f85, @0x1f86, @0x1f87, @0x1f88, @0x1f89, @0x1f8a, @0x1f8b, @0x1f8c, @0x1f8d, @0x1f8e, @0x1f8f,
                                 @0x1f90, @0x1f91, @0x1f92, @0x1f93, @0x1f94, @0x1f95, @0x1f96, @0x1f97, @0x1f98, @0x1f99, @0x1f9a, @0x1f9b, @0x1f9c, @0x1f9d, @0x1f9e, @0x1f9f,
                                 @0x1fa0, @0x1fa1, @0x1fa2, @0x1fa3, @0x1fa4, @0x1fa5, @0x1fa6, @0x1fa7, @0x1fa8, @0x1fa9, @0x1faa, @0x1fab, @0x1fac, @0x1fad, @0x1fae, @0x1faf,
                                 @0x1fb0, @0x1fb1, @0x1f82, @0x1f80, @0x1f84, @-1, @0x1f06, @0x1f86, @0x1fb8, @0x1fb9, @0x1f0a, @0x1f0c, @0x1f88, @-1, @-1, @-1,
                                 @-1, @-1, @0x1f92, @0x1f90, @0x1f94, @-1, @0x1f26, @0x1f96, @0x1f1a, @0x1f1c, @0x1f2a, @0x1f2c, @0x1f98, @-1, @-1, @-1,
                                 @0x1fd0, @0x1fd1, @0x1fd2, @0x1fd3, @-1, @-1, @0x1f36, @0x1fd6, @0x1fd8, @0x1fd9, @0x1f3a, @0x1f3c, @-1, @-1, @-1, @-1,
                                 @0x1fe0, @0x1fe1, @0x1fe2, @0x1fe3, @0x1fe4, @0x1fe5, @0x1f56, @0x1fe6, @0x1fe8, @0x1fe9, @0x1fea, @0x1feb, @0x1fec, @-1, @-1, @-1,
                                 @-1, @-1, @0x1fa2, @0x1fa0, @0x1fa4, @-1, @0x1f66, @0x1fa6, @0x1f4a, @0x1f4c, @0x1f6a, @0x1f6c, @0x1fa8, @-1, @-1, @-1 ];

        NSArray *withAcute1 = @[ @0x0386, @-1, @0x0388, @0x0389, @0x038a, @-1, @0x038c, @-1, @0x038e, @0x038f, @0x0390,
                                  @0x1fbb, @0x0392, @0x0393, @0x0394, @0x1fc9, @0x0396, @0x1fcb, @0x0398, @0x1fdb, @0x039a, @0x039b, @0x039c, @0x039d, @0x039e, @0x1ff9,
                                  @0x03a0, @0x03a1, @-1, @0x03a3, @0x03a4, @0x1feb, @0x03a6, @0x03a7, @0x03a8, @0x1ffb, @0x03aa, @0x03ab, @0x03ac, @0x03ad, @0x03ae, @0x03af, @0x03b0,
                                  @0x1f71, @0x03b2, @0x03b3, @0x03b4, @0x1f73, @0x03b6, @0x1f75, @0x03b8, @0x1f77, @0x03ba, @0x03bb, @0x03bc, @0x03bd, @0x03be, @0x1f79,
                                  @0x03c0, @0x03c1, @0x03c2, @0x03c3, @0x03c4, @0x1f7b, @0x03c6, @0x03c7, @0x03c8, @0x1f7d, @0x1fd3, @0x1fe3, @0x03cc, @0x03cd, @0x03ce ];
        NSArray *withAcute2 = @[ @0x1f04, @0x1f05, @0x1f02, @0x1f03, @0x1f04, @0x1f05, @0x1f06, @0x1f07, @0x1f0c, @0x1f0d, @0x1f0a, @0x1f0b, @0x1f0c, @0x1f0d, @0x1f0e, @0x1f0f,
                                  @0x1f14, @0x1f15, @0x1f12, @0x1f13, @0x1f14, @0x1f15, @-1, @-1, @0x1f1c, @0x1f1d, @0x1f1a, @0x1f1b, @0x1f1c, @0x1f1d, @-1, @-1,
                                  @0x1f24, @0x1f25, @0x1f22, @0x1f23, @0x1f24, @0x1f25, @0x1f26, @0x1f27, @0x1f2c, @0x1f2d, @0x1f2a, @0x1f2b, @0x1f2c, @0x1f2d, @0x1f2e, @0x1f2f,
                                  @0x1f34, @0x1f35, @0x1f32, @0x1f33, @0x1f34, @0x1f35, @0x1f36, @0x1f37, @0x1f3c, @0x1f3d, @0x1f3a, @0x1f3b, @0x1f3c, @0x1f3d, @0x1f3e, @0x1f3f,
                                  @0x1f44, @0x1f45, @0x1f42, @0x1f43, @0x1f44, @0x1f45, @-1, @-1, @0x1f4c, @0x1f4d, @0x1f4a, @0x1f4b, @0x1f4c, @0x1f4d, @-1, @-1,
                                  @0x1f54, @0x1f55, @0x1f52, @0x1f53, @0x1f54, @0x1f55, @0x1f56, @0x1f57, @-1, @0x1f5d, @-1, @0x1f5b, @-1, @0x1f5d, @-1, @0x1f5f,
                                  @0x1f64, @0x1f65, @0x1f62, @0x1f63, @0x1f64, @0x1f65, @0x1f66, @0x1f67, @0x1f6c, @0x1f6d, @0x1f6a, @0x1f6b, @0x1f6c, @0x1f6d, @0x1f6e, @0x1f6f,
                                  @0x1f70, @0x1f71, @0x1f72, @0x1f73, @0x1f74, @0x1f75, @0x1f76, @0x1f77, @0x1f78, @0x1f79, @0x1f7a, @0x1f7b, @0x1f7c, @0x1f7d, @-1, @-1,
                                  @0x1f84, @0x1f85, @0x1f82, @0x1f83, @0x1f84, @0x1f85, @0x1f86, @0x1f87, @0x1f8c, @0x1f8d, @0x1f8a, @0x1f8b, @0x1f8c, @0x1f8d, @0x1f8e, @0x1f8f,
                                  @0x1f94, @0x1f95, @0x1f92, @0x1f93, @0x1f94, @0x1f95, @0x1f96, @0x1f97, @0x1f9c, @0x1f9d, @0x1f9a, @0x1f9b, @0x1f9c, @0x1f9d, @0x1f9e, @0x1f9f,
                                  @0x1fa4, @0x1fa5, @0x1fa2, @0x1fa3, @0x1fa4, @0x1fa5, @0x1fa6, @0x1fa7, @0x1fac, @0x1fad, @0x1faa, @0x1fab, @0x1fac, @0x1fad, @0x1fae, @0x1faf,
                                  @0x1fb0, @0x1fb1, @0x1fb2, @0x1fb4, @0x1fb4, @-1, @0x1fb6, @0x1fb7, @0x1fb8, @0x1fb9, @0x1fba, @0x1fbb, @0x1fbc, @-1, @-1, @-1,
                                  @-1, @-1, @0x1fc2, @0x1fc4, @0x1fc4, @-1, @0x1fc6, @0x1fc7, @0x1fc8, @0x1fc9, @0x1fca, @0x1fcb, @0x1fcc, @-1, @-1, @-1,
                                  @0x1fd0, @0x1fd1, @0x1fd2, @0x1fd3, @-1, @-1, @0x1fd6, @0x1fd7, @0x1fd8, @0x1fd9, @0x1fda, @0x1fdb, @-1, @-1, @-1, @-1,
                                  @0x1fe0, @0x1fe1, @0x1fe2, @0x1fe3, @0x1fe4, @0x1fe5, @0x1fe6, @0x1fe7, @0x1fe8, @0x1fe9, @0x1fea, @0x1feb, @0x1fec, @-1, @-1, @-1,
                                  @-1, @-1, @0x1ff2, @0x1ff4, @0x1ff4, @-1, @0x1ff6, @0x1ff7, @0x1ff8, @0x1ff9, @0x1ffa, @0x1ffb, @0x1ffc, @-1, @-1, @-1 ];

        NSArray *withGrave1 = @[ @0x0386, @-1, @0x0388, @0x0389, @0x038a, @-1, @0x038c, @-1, @0x038e, @0x038f, @0x0390,
                                 @0x1fba, @0x0392, @0x0393, @0x0394, @0x1fc8, @0x0396, @0x1fca, @0x0398, @0x1fda, @0x039a, @0x039b, @0x039c, @0x039d, @0x039e, @0x1ff8,
                                 @0x03a0, @0x03a1, @-1, @0x03a3, @0x03a4, @0x1fea, @0x03a6, @0x03a7, @0x03a8, @0x1ffa, @0x03aa, @0x03ab, @0x03ac, @0x03ad, @0x03ae, @0x03af, @0x03b0,
                                 @0x1f70, @0x03b2, @0x03b3, @0x03b4, @0x1f72, @0x03b6, @0x1f74, @0x03b8, @0x1f76, @0x03ba, @0x03bb, @0x03bc, @0x03bd, @0x03be, @0x1f78,
                                 @0x03c0, @0x03c1, @0x03c2, @0x03c3, @0x03c4, @0x1f7a, @0x03c6, @0x03c7, @0x03c8, @0x1f7c, @0x1fd2, @0x1fe2, @0x03cc, @0x03cd, @0x03ce ];
        NSArray *withGrave2 = @[ @0x1f02, @0x1f03, @0x1f02, @0x1f03, @0x1f04, @0x1f05, @0x1f06, @0x1f07, @0x1f0a, @0x1f0b, @0x1f0a, @0x1f0b, @0x1f0c, @0x1f0d, @0x1f0e, @0x1f0f,
                                 @0x1f12, @0x1f13, @0x1f12, @0x1f13, @0x1f14, @0x1f15, @-1, @-1, @0x1f1a, @0x1f1b, @0x1f1a, @0x1f1b, @0x1f1c, @0x1f1d, @-1, @-1,
                                 @0x1f22, @0x1f23, @0x1f22, @0x1f23, @0x1f24, @0x1f25, @0x1f26, @0x1f27, @0x1f2a, @0x1f2b, @0x1f2a, @0x1f2b, @0x1f2c, @0x1f2d, @0x1f2e, @0x1f2f,
                                 @0x1f32, @0x1f33, @0x1f32, @0x1f33, @0x1f34, @0x1f35, @0x1f36, @0x1f37, @0x1f3a, @0x1f3b, @0x1f3a, @0x1f3b, @0x1f3c, @0x1f3d, @0x1f3e, @0x1f3f,
                                 @0x1f42, @0x1f43, @0x1f42, @0x1f43, @0x1f44, @0x1f45, @-1, @-1, @0x1f4a, @0x1f4b, @0x1f4a, @0x1f4b, @0x1f4c, @0x1f4d, @-1, @-1,
                                 @0x1f52, @0x1f53, @0x1f52, @0x1f53, @0x1f54, @0x1f55, @0x1f56, @0x1f57, @-1, @0x1f5b, @-1, @0x1f5b, @-1, @0x1f5d, @-1, @0x1f5f,
                                 @0x1f62, @0x1f63, @0x1f62, @0x1f63, @0x1f64, @0x1f65, @0x1f66, @0x1f67, @0x1f6a, @0x1f6b, @0x1f6a, @0x1f6b, @0x1f6c, @0x1f6d, @0x1f6e, @0x1f6f,
                                 @0x1f70, @0x1f71, @0x1f72, @0x1f73, @0x1f74, @0x1f75, @0x1f76, @0x1f77, @0x1f78, @0x1f79, @0x1f7a, @0x1f7b, @0x1f7c, @0x1f7d, @-1, @-1,
                                 @0x1f82, @0x1f83, @0x1f82, @0x1f83, @0x1f84, @0x1f85, @0x1f86, @0x1f87, @0x1f8a, @0x1f8b, @0x1f8a, @0x1f8b, @0x1f8c, @0x1f8d, @0x1f8e, @0x1f8f,
                                 @0x1f92, @0x1f93, @0x1f92, @0x1f93, @0x1f94, @0x1f95, @0x1f96, @0x1f97, @0x1f9a, @0x1f9b, @0x1f9a, @0x1f9b, @0x1f9c, @0x1f9d, @0x1f9e, @0x1f9f,
                                 @0x1fa2, @0x1fa3, @0x1fa2, @0x1fa3, @0x1fa4, @0x1fa5, @0x1fa6, @0x1fa7, @0x1faa, @0x1fab, @0x1faa, @0x1fab, @0x1fac, @0x1fad, @0x1fae, @0x1faf,
                                 @0x1fb0, @0x1fb1, @0x1fb2, @0x1fb2, @0x1fb4, @-1, @0x1fb6, @0x1fb7, @0x1fb8, @0x1fb9, @0x1fba, @0x1fbb, @0x1fbc, @-1, @-1, @-1,
                                 @-1, @-1, @0x1fc2, @0x1fc2, @0x1fc4, @-1, @0x1fc6, @0x1fc7, @0x1fc8, @0x1fc9, @0x1fca, @0x1fcb, @0x1fcc, @-1, @-1, @-1,
                                 @0x1fd0, @0x1fd1, @0x1fd2, @0x1fd3, @-1, @-1, @0x1fd6, @0x1fd7, @0x1fd8, @0x1fd9, @0x1fda, @0x1fdb, @-1, @-1, @-1, @-1,
                                 @0x1fe0, @0x1fe1, @0x1fe2, @0x1fe3, @0x1fe4, @0x1fe5, @0x1fe6, @0x1fe7, @0x1fe8, @0x1fe9, @0x1fea, @0x1feb, @0x1fec, @-1, @-1, @-1,
                                 @-1, @-1, @0x1ff2, @0x1ff2, @0x1ff4, @-1, @0x1ff6, @0x1ff7, @0x1ff8, @0x1ff9, @0x1ffa, @0x1ffb, @0x1ffc, @-1, @-1, @-1 ];

        NSArray *withCirc1 = @[ @0x0386, @-1, @0x0388, @0x0389, @0x038a, @-1, @0x038c, @-1, @0x038e, @0x038f, @0x0390,
                                 @0x0391, @0x0392, @0x0393, @0x0394, @0x0395, @0x0396, @0x0397, @0x0398, @0x0399, @0x039a, @0x039b, @0x039c, @0x039d, @0x039e, @0x039f,
                                 @0x03a0, @0x03a1, @-1, @0x03a3, @0x03a4, @0x03a5, @0x03a6, @0x03a7, @0x03a8, @0x03a9, @0x03aa, @0x03ab, @0x03ac, @0x03ad, @0x03ae, @0x03af, @0x03b0,
                                 @0x1fb6, @0x03b2, @0x03b3, @0x03b4, @0x03b5, @0x03b6, @0x1fc6, @0x03b8, @0x1fd6, @0x03ba, @0x03bb, @0x03bc, @0x03bd, @0x03be, @0x03bf,
                                 @0x03c0, @0x03c1, @0x03c2, @0x03c3, @0x03c4, @0x1fe6, @0x03c6, @0x03c7, @0x03c8, @0x1ff6, @0x03ca, @0x03cb, @0x03cc, @0x03cd, @0x03ce ];
        NSArray *withCirc2 = @[ @0x1f06, @0x1f07, @0x1f02, @0x1f03, @0x1f04, @0x1f05, @0x1f06, @0x1f07, @0x1f0e, @0x1f0f, @0x1f0a, @0x1f0b, @0x1f0c, @0x1f0d, @0x1f0e, @0x1f0f,
                                 @0x1f12, @0x1f13, @0x1f12, @0x1f13, @0x1f14, @0x1f15, @-1, @-1, @0x1f1a, @0x1f1b, @0x1f1a, @0x1f1b, @0x1f1c, @0x1f1d, @-1, @-1,
                                 @0x1f26, @0x1f27, @0x1f22, @0x1f23, @0x1f24, @0x1f25, @0x1f26, @0x1f27, @0x1f2e, @0x1f2f, @0x1f2a, @0x1f2b, @0x1f2c, @0x1f2d, @0x1f2e, @0x1f2f,
                                 @0x1f36, @0x1f37, @0x1f32, @0x1f33, @0x1f34, @0x1f35, @0x1f36, @0x1f37, @0x1f3e, @0x1f3f, @0x1f3a, @0x1f3b, @0x1f3c, @0x1f3d, @0x1f3e, @0x1f3f,
                                 @0x1f42, @0x1f43, @0x1f42, @0x1f43, @0x1f44, @0x1f45, @-1, @-1, @0x1f4a, @0x1f4b, @0x1f4a, @0x1f4b, @0x1f4c, @0x1f4d, @-1, @-1,
                                 @0x1f56, @0x1f57, @0x1f52, @0x1f53, @0x1f54, @0x1f55, @0x1f56, @0x1f57, @-1, @0x1f5f, @-1, @0x1f5b, @-1, @0x1f5d, @-1, @0x1f5f,
                                 @0x1f66, @0x1f67, @0x1f62, @0x1f63, @0x1f64, @0x1f65, @0x1f66, @0x1f67, @0x1f6e, @0x1f6f, @0x1f6a, @0x1f6b, @0x1f6c, @0x1f6d, @0x1f6e, @0x1f6f,
                                 @0x1f70, @0x1f71, @0x1f72, @0x1f73, @0x1f74, @0x1f75, @0x1f76, @0x1f77, @0x1f78, @0x1f79, @0x1f7a, @0x1f7b, @0x1f7c, @0x1f7d, @-1, @-1,
                                 @0x1f86, @0x1f87, @0x1f82, @0x1f83, @0x1f84, @0x1f85, @0x1f86, @0x1f87, @0x1f8e, @0x1f8f, @0x1f8a, @0x1f8b, @0x1f8c, @0x1f8d, @0x1f8e, @0x1f8f,
                                 @0x1f96, @0x1f97, @0x1f92, @0x1f93, @0x1f94, @0x1f95, @0x1f96, @0x1f97, @0x1f9e, @0x1f9f, @0x1f9a, @0x1f9b, @0x1f9c, @0x1f9d, @0x1f9e, @0x1f9f,
                                 @0x1fa6, @0x1fa7, @0x1fa2, @0x1fa3, @0x1fa4, @0x1fa5, @0x1fa6, @0x1fa7, @0x1fae, @0x1faf, @0x1faa, @0x1fab, @0x1fac, @0x1fad, @0x1fae, @0x1faf,
                                 @0x1fb0, @0x1fb1, @0x1fb7, @0x1fb2, @0x1fb4, @-1, @0x1fb6, @0x1fb7, @0x1fb8, @0x1fb9, @0x1fba, @0x1fbb, @0x1fbc, @-1, @-1, @-1,
                                 @-1, @-1, @0x1fc2, @0x1fc7, @0x1fc4, @-1, @0x1fc6, @0x1fc7, @0x1fc8, @0x1fc9, @0x1fca, @0x1fcb, @0x1fcc, @-1, @-1, @-1,
                                 @0x1fd0, @0x1fd1, @0x1fd2, @0x1fd3, @-1, @-1, @0x1fd6, @0x1fd7, @0x1fd8, @0x1fd9, @0x1fda, @0x1fdb, @-1, @-1, @-1, @-1,
                                 @0x1fe0, @0x1fe1, @0x1fe2, @0x1fe3, @0x1fe4, @0x1fe5, @0x1fe6, @0x1fe7, @0x1fe8, @0x1fe9, @0x1fea, @0x1feb, @0x1fec, @-1, @-1, @-1,
                                 @-1, @-1, @0x1ff2, @0x1ff7, @0x1ff4, @-1, @0x1ff6, @0x1ff7, @0x1ff8, @0x1ff9, @0x1ffa, @0x1ffb, @0x1ffc, @-1, @-1, @-1 ];

        NSArray *withIota1 = @[ @0x0386, @-1, @0x0388, @0x0389, @0x038a, @-1, @0x038c, @-1, @0x038e, @0x038f, @0x0390,
                                @0x0391, @0x0392, @0x0393, @0x0394, @0x0395, @0x0396, @0x0397, @0x0398, @0x0399, @0x039a, @0x039b, @0x039c, @0x039d, @0x039e, @0x039f,
                                @0x03a0, @0x03a1, @-1, @0x03a3, @0x03a4, @0x03a5, @0x03a6, @0x03a7, @0x03a8, @0x03a9, @0x03aa, @0x03ab, @0x1fb4, @0x03ad, @0x1fc4, @0x03af, @0x03b0,
                                @0x1fb3, @0x03b2, @0x03b3, @0x03b4, @0x03b5, @0x03b6, @0x1fc3, @0x03b8, @0x1fd6, @0x03ba, @0x03bb, @0x03bc, @0x03bd, @0x03be, @0x03bf,
                                @0x03c0, @0x03c1, @0x03c2, @0x03c3, @0x03c4, @0x03c5, @0x03c6, @0x03c7, @0x03c8, @0x1ff3, @0x03ca, @0x03cb, @0x03cc, @0x03cd, @0x1ff4 ];
        NSArray *withIota2 = @[ @0x1f80, @0x1f81, @0x1f82, @0x1f83, @0x1f84, @0x1f85, @0x1f86, @0x1f87, @0x1f88, @0x1f89, @0x1f8a, @0x1f8b, @0x1f8c, @0x1f8d, @0x1f8e, @0x1f8f,
                                @0x1f12, @0x1f13, @0x1f12, @0x1f13, @0x1f14, @0x1f15, @-1, @-1, @0x1f1a, @0x1f1b, @0x1f1a, @0x1f1b, @0x1f1c, @0x1f1d, @-1, @-1,
                                @0x1f90, @0x1f91, @0x1f92, @0x1f93, @0x1f94, @0x1f95, @0x1f96, @0x1f97, @0x1f98, @0x1f99, @0x1f9a, @0x1f9b, @0x1f9c, @0x1f9d, @0x1f9e, @0x1f9f,
                                @0x1f36, @0x1f37, @0x1f32, @0x1f33, @0x1f34, @0x1f35, @0x1f36, @0x1f37, @0x1f3e, @0x1f3f, @0x1f3a, @0x1f3b, @0x1f3c, @0x1f3d, @0x1f3e, @0x1f3f,
                                @0x1f42, @0x1f43, @0x1f42, @0x1f43, @0x1f44, @0x1f45, @-1, @-1, @0x1f4a, @0x1f4b, @0x1f4a, @0x1f4b, @0x1f4c, @0x1f4d, @-1, @-1,
                                @0x1f56, @0x1f57, @0x1f52, @0x1f53, @0x1f54, @0x1f55, @0x1f56, @0x1f57, @-1, @0x1f5f, @-1, @0x1f5b, @-1, @0x1f5d, @-1, @0x1f5f,
                                @0x1fa0, @0x1fa1, @0x1fa2, @0x1fa3, @0x1fa4, @0x1fa5, @0x1fa6, @0x1fa7, @0x1fa8, @0x1fa9, @0x1faa, @0x1fab, @0x1fac, @0x1fad, @0x1fae, @0x1faf,
                                @0x1fb2, @0x1fb4, @0x1f72, @0x1f73, @0x1fc3, @0x1fc4, @0x1f76, @0x1f77, @0x1f78, @0x1f79, @0x1f7a, @0x1f7b, @0x1ff2, @0x1ff4, @-1, @-1,
                                @0x1f86, @0x1f87, @0x1f82, @0x1f83, @0x1f84, @0x1f85, @0x1f86, @0x1f87, @0x1f8e, @0x1f8f, @0x1f8a, @0x1f8b, @0x1f8c, @0x1f8d, @0x1f8e, @0x1f8f,
                                @0x1f96, @0x1f97, @0x1f92, @0x1f93, @0x1f94, @0x1f95, @0x1f96, @0x1f97, @0x1f9e, @0x1f9f, @0x1f9a, @0x1f9b, @0x1f9c, @0x1f9d, @0x1f9e, @0x1f9f,
                                @0x1fa6, @0x1fa7, @0x1fa2, @0x1fa3, @0x1fa4, @0x1fa5, @0x1fa6, @0x1fa7, @0x1fae, @0x1faf, @0x1faa, @0x1fab, @0x1fac, @0x1fad, @0x1fae, @0x1faf,
                                @0x1fb0, @0x1fb1, @0x1fb7, @0x1fb2, @0x1fb4, @-1, @0x1fb7, @0x1fb7, @0x1fb8, @0x1fb9, @0x1fba, @0x1fbb, @0x1fbc, @-1, @-1, @-1,
                                @-1, @-1, @0x1fc2, @0x1fc7, @0x1fc4, @-1, @0x1fc7, @0x1fc7, @0x1fc8, @0x1fc9, @0x1fca, @0x1fcb, @0x1fcc, @-1, @-1, @-1,
                                @0x1fd0, @0x1fd1, @0x1fd2, @0x1fd3, @-1, @-1, @0x1fd6, @0x1fd7, @0x1fd8, @0x1fd9, @0x1fda, @0x1fdb, @-1, @-1, @-1, @-1,
                                @0x1fe0, @0x1fe1, @0x1fe2, @0x1fe3, @0x1fe4, @0x1fe5, @0x1fe6, @0x1fe7, @0x1fe8, @0x1fe9, @0x1fea, @0x1feb, @0x1fec, @-1, @-1, @-1,
                                @-1, @-1, @0x1ff2, @0x1ff7, @0x1ff4, @-1, @0x1ff7, @0x1ff7, @0x1ff8, @0x1ff9, @0x1ffa, @0x1ffb, @0x1ffc, @-1, @-1, @-1 ];

/*        addDiaeresis = @{ @"ι" : @"ϊ", @"\u1f76" : @"\u1fd2", @"ί" : @"\u1fd3", @"\u1fd6" : @"\u1fd7",
                          @"υ" : @"ϋ", @"\u1f7a" : @"\u1fe2", @"ύ" : @"ΰ", @"\u1fe6" : @"\u1fe7",
                          @"Ι" : @"Ϊ",
                          @"Υ" : @"Ϋ"};  */
        NSInteger idx, mainCharIndex, furtherCharIndex;
        NSString *charRepresentation;
        
        // Load the two Unicode tables into memory.  These are stored as:
        //           - base characters (and a few extras);
        //           - characters with accents, breathings, iota subscript, etc.
        // allGkChars: key = the code value, value = the code converted to a string character
        idx = 0;
        for (mainCharIndex = mainCharsStart; mainCharIndex <= mainCharsEnd; mainCharIndex++)
        {
            charRepresentation = [[NSString alloc] initWithFormat:@"%C",(unichar)mainCharIndex];
            if ( [charRepresentation compare: @"΋"] == 0)
            {
                idx++;
                continue;
            }
            conversionNum = [NSNumber numberWithInteger: mainCharIndex];
            [allGkChars setObject:charRepresentation forKey:conversionNum];
            [conversionWithBreathings setObject:[gkTable1 objectAtIndex:idx] forKey:conversionNum];
            [addRoughBreathing setObject:[withRough1 objectAtIndex:idx] forKey:conversionNum];
            [addSmoothBreathing setObject:[withSmooth1 objectAtIndex:idx] forKey:conversionNum];
            [addAccute setObject:[withAcute1 objectAtIndex:idx] forKey:conversionNum];
            [addGrave setObject:[withGrave1 objectAtIndex:idx] forKey:conversionNum];
            [addCirc setObject:[withCirc1 objectAtIndex:idx] forKey:conversionNum];
            [addIotaSub setObject:[withIota1 objectAtIndex:idx] forKey:conversionNum];
            switch (mainCharIndex)
            {
                case 0x0399: [addDiaeresis setObject:@0x03aa forKey:conversionNum]; break;
                case 0x03a5: [addDiaeresis setObject:@0x03ab forKey:conversionNum]; break;
                case 0x03af: [addDiaeresis setObject:@0x1fd3 forKey:conversionNum]; break;
                case 0x03b9: [addDiaeresis setObject:@0x03ca forKey:conversionNum]; break;
                case 0x03c5: [addDiaeresis setObject:@0x03cb forKey:conversionNum]; break;
                case 0x03cd: [addDiaeresis setObject:@0x1fe3 forKey:conversionNum]; break;
                default: [addDiaeresis setObject:conversionNum forKey:conversionNum]; break;
            }
            idx++;
        }
        idx = 0;
        for (furtherCharIndex = furtherCharsStart; furtherCharIndex <= furtherCharsEnd; furtherCharIndex++)
        {
            charRepresentation = [[NSString alloc] initWithFormat:@"%C",(unichar)furtherCharIndex];
            if ( [charRepresentation compare: @"΋"] == 0)
            {
                idx++;
                continue;
            }
            conversionNum = [NSNumber numberWithInteger: furtherCharIndex];
            [allGkChars setObject:charRepresentation forKey:conversionNum];
            [conversionWithBreathings setObject:[gkTable2 objectAtIndex:idx] forKey:conversionNum];
            [addRoughBreathing setObject:[withRough2 objectAtIndex:idx] forKey:conversionNum];
            [addSmoothBreathing setObject:[withSmooth2 objectAtIndex:idx] forKey:conversionNum];
            [addAccute setObject:[withAcute2 objectAtIndex:idx] forKey:conversionNum];
            [addGrave setObject:[withGrave2 objectAtIndex:idx] forKey:conversionNum];
            [addCirc setObject:[withCirc2 objectAtIndex:idx] forKey:conversionNum];
            [addIotaSub setObject:[withIota2 objectAtIndex:idx] forKey:conversionNum];
            switch (furtherCharIndex)
            {
                case 0x1f76: [addDiaeresis setObject:@0x1fd2 forKey:conversionNum]; break;
                case 0x1f77: [addDiaeresis setObject:@0x1fd3 forKey:conversionNum]; break;
                case 0x1f7a: [addDiaeresis setObject:@0x1fe2 forKey:conversionNum]; break;
                case 0x1f7b: [addDiaeresis setObject:@0x1fe3 forKey:conversionNum]; break;
                case 0x1fd6: [addDiaeresis setObject:@0x1fd7 forKey:conversionNum]; break;
                case 0x1fe6: [addDiaeresis setObject:@0x1fe7 forKey:conversionNum]; break;
                default: [addDiaeresis setObject:conversionNum forKey:conversionNum]; break;
            }
            idx++;
        }
        charRepresentation = [[NSString alloc] initWithFormat:@"%C",(unichar)0x03dc];
        [allGkChars setObject:charRepresentation forKey:[NSNumber numberWithInt: 0x03dd]];
        [conversionWithBreathings setObject:[NSNumber numberWithInt:0x03dc] forKey:[NSNumber numberWithInt:0x03dd]];
        charRepresentation = [[NSString alloc] initWithFormat:@"%C",(unichar)0x03dd];
        [allGkChars setObject:charRepresentation forKey:[NSNumber numberWithInt: 0x03dd]];
        [conversionWithBreathings setObject:[NSNumber numberWithInt: 0x03dd] forKey:[NSNumber numberWithInt: 0x03dd]];
    }
    return self;
}

- (classCleanReturn *) removeNonGkChars: (NSString *) source
{
    /*********************************************************************************
     *                                                                               *
     *                            removeNonGkChars                                   *
     *                            ================                                   *
     *                                                                               *
     *  The text comes with various characters derived from the Bible Society text   *
     *    that identifies variant readings.  Since we have no ability (or copyright  *
     *    agreement) to present these variant readings, they are redundant and even  *
     *    intrusive.  This method will remove them, where they occur.                *
     *                                                                               *
     *  It will allso:                                                               *
     *    a) preserve any ascii text before the Greek word;                          *
     *    b) preserve any ascii non-punctuation after the Greek word;hars and punct. *
     *    c) preserve any punctuation attached to the word.                          *
     *                                                                               *
     *  Returned value is a Tuple with:                                              *
     *      item1 = any ascii text found as in a) above                              *
     *      item2 = any non-punctuation, as in b) above                              *
     *      item3 = any punctuation                                                  *
     *      item4 = the Greek word without these spurious characters                 *
     *                                                                               *
     *********************************************************************************/
    
    NSInteger singleCharValue;
    unichar targetCharacter;
    NSString *preChars = @"", *postChars = @"",*punctuation = @"";
    NSString *copyOfSource, *singleChar;
    classCleanReturn *returnData;
    
    copyOfSource = source;
    preChars = [[NSMutableString alloc] init];
    while ( [copyOfSource length] > 0)
    {
        targetCharacter = [copyOfSource characterAtIndex:0];
        if (( targetCharacter >= 0x0386 ) && (targetCharacter <= 0x03ce)) break;
        if ((targetCharacter == 0x03dc) || (targetCharacter == 0x03dd)) break;
        if ((targetCharacter >= 0x1f00) && (targetCharacter <= 0x1fff)) break;
        if (targetCharacter <= 0x007f)
        {
            preChars = [[NSString alloc] initWithFormat:@"%@%@", preChars, [copyOfSource substringWithRange:NSMakeRange(0, 1)]];
        }
        copyOfSource = [[ NSString alloc] initWithString:[copyOfSource substringFromIndex:1]];
    }
    while ( [copyOfSource length] > 0)
    {
        targetCharacter = [copyOfSource characterAtIndex:([copyOfSource length] - 1)];
        if ( targetCharacter == 0x0386) break;
        if ((targetCharacter >= 0x0388) && (targetCharacter <= 0x03ce)) break;
        if ((targetCharacter == 0x03dc) || (targetCharacter == 0x03dd)) break;
        if ((targetCharacter >= 0x1f00) && (targetCharacter <= 0x1fff)) break;
        singleChar = [[NSString alloc] initWithString:[copyOfSource substringFromIndex:([copyOfSource length] - 1)]];
        if ( [allowedPunctuation containsObject:singleChar])
        {
            punctuation = [[NSString alloc] initWithFormat:@"%@%@", singleChar, punctuation];
        }
        else
        {
            singleCharValue = [singleChar integerValue];
            if (singleCharValue <= 0x007f)
            {
                postChars = [[NSString alloc] initWithFormat:@"%@%@", singleChar, postChars];
            }
        }
        copyOfSource = [[NSString alloc] initWithString:[copyOfSource substringToIndex:([copyOfSource length] -1) ]];
    }
    returnData = [[classCleanReturn alloc] init:copyOfSource preChar:preChars postWord:postChars punctuation:punctuation];
    return returnData;
}

- (NSString *) reduceToBareGreek: (NSString *) source isRemovedAlready: (bool) nonGkIsAlreadyRemoved
{
    /*********************************************************************************
     *                                                                               *
     *                            reduceToBareGreek                                  *
     *                            =================                                  *
     *                                                                               *
     *  This will remove all accents, iota subscripts and length marks (it will      *
     *    retain breathings and diereses).  It will also:                            *
     *    - reduce any capital letters to minuscules (see below, however),           *
     *    - present final sigma as a normal sigma.                                   *
     *                                                                               *
     *  Note that any majuscule will also be reduced to a minuscule.                 *
     *  Care will be taken to ensure that any final sigma *is* a final sigma.        *
     *                                                                               *
     *  Parameters:                                                                  *
     *    source                 The starting text                                   *
     *    nonGkIsAlreadyRemoved  This should be set to true if it has already been   *
     *                           processed by removeNonGkChars                       *
     *                                                                               *
     *  Returned value:                                                              *
     *      String containing the suitably cleaned/stripped word                     *
     *                                                                               *
     *********************************************************************************/
    
    NSInteger idx, lengthOfString, characterValue = -1, characterType;
    NSString *tempWorkArea, *strippedChar;
    NSMutableString *strippedString;
    classCleanReturn *returnedData;
    
    tempWorkArea = [[NSString alloc] initWithString: source];
    lengthOfString = [tempWorkArea length];
    if (lengthOfString == 0) return source;
    strippedString = [[NSMutableString alloc] initWithString: @""];
    if (!nonGkIsAlreadyRemoved)
    {
        returnedData = [self removeNonGkChars:tempWorkArea];
        tempWorkArea = [returnedData cleanedWord];
    }
    lengthOfString = [tempWorkArea length];
    for (idx = 0; idx < lengthOfString; idx++)
    {
        // Get Hex value of character
        NSString *tempString = [[NSString alloc] initWithString:[tempWorkArea substringWithRange:(NSMakeRange(idx, 1))]];
        characterValue = [tempString characterAtIndex:0];
        if (characterValue == 0x2d)
        {
            [strippedString appendString: @"-"];
            continue;
        }
        // What character are we dealing with?
        characterType = -1;
        characterType = [[conversionWithBreathings objectForKey:[NSNumber numberWithInteger: characterValue]] integerValue];
        strippedChar = [[NSString alloc] initWithFormat:@"%C",(unichar)characterType];
        [strippedString appendString:strippedChar];
    }
    // Check for final sigma
    lengthOfString = [strippedString length];
    if ( [[strippedString substringFromIndex:([strippedString length] - 1)] integerValue] == 0x03c3)
    {
        strippedChar = [allGkChars objectForKey:[NSNumber numberWithInteger: 0x03c2]];
        strippedString = [[NSMutableString alloc] initWithString:[strippedString substringToIndex:([strippedString length]-1)]];
        [strippedString appendString:strippedChar];
    }
    return strippedString;
}

@end
