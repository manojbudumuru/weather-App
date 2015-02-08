//
//  Pirep+TTF.m
//  GA Weather
//
//  Using a 3rd party Library/ improvised Classes for Regular Expression.
//  Created by GA Weather App on 11/29/14.
//  Copyright (c) 2014 Satish Kumar Baswapuram. All rights reserved.
//

#import "Pirep+TTF.h"
#import "RegExCategories.h"

@implementation Pirep (TTF)

-(NSString*)ttfEquivalent:(NSString*)input{
    
    Rx * icPattern = RX(@"IC (TRACE|LGT|LGT-MOD|MOD|MOD-SEV|SEV)");
    Rx * tbPattern = RX(@"TB (LGT|LGT-MOD|MOD|MOD-SEV|SEV)");
    Rx * mvPattern = RX(@"RM (LGT|LGT-MOD|MOD|MOD-SEV|SEV)");
    NSString * ttf = @"'";
    UIColor *orange = [UIColor orangeColor];
    UIColor *green = [UIColor greenColor];
    UIColor *red = [UIColor redColor];
    //ttfColor = [UIColor blackColor];
    
    if([input isMatch:icPattern])
    {
        if([input containsString:@"IC LGT"]){
            ttf =  @"2";
            //ttfColor = green;
        } else if([input containsString:@"IC MOD"] || [input containsString:@"IC LGT-MOD"]){
            ttf =  @"4";
            //ttfColor = orange;
        } else if([input containsString:@"IC SEV"] || [input containsString:@"IC MOD-SEV"]){
            ttf =  @"6";
            //ttfColor = red;
        }
    }else if([input isMatch:tbPattern]||[input isMatch:mvPattern])
    {
        if([input containsString:@"TB LGT"]||[input containsString:@"RM LGT"]){
            ttf =  @"8";
            //ttfColor = green;
        } else if([input containsString:@"TB MOD"] || [input containsString:@"RM MOD"] || [input containsString:@"TB LGT-MOD"] || [input containsString:@"RM LGT-MOD"]){
            ttf =  @":";
            //ttfColor = orange;
        } else if([input containsString:@"TB SEV"] || [input containsString:@"RM SEV"] || [input containsString:@"TB MOD-SEV"] || [input containsString:@"RM MOD-SEV"]){
            ttf =  @"<";
            //ttfColor = red;
        }
    }
//    NSLog(@"%@",input);
//    NSLog(@"SYMBOL FOR NOW IS: %@",ttf);
    
    return ttf;
}
@end
