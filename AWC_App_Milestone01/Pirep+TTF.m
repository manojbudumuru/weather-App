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

-(NSString*)ttfEquivalent:(NSString*)icLvl tbLvl:(NSString*)tbLvl{
    NSString * ttf = @"";
    
    if(icLvl != NULL)
    {
        if([icLvl containsString:@"LGT"] || [icLvl containsString:@"TRC"]){
            ttf =  @"2";
            //ttfColor = green;
        } else if([icLvl containsString:@"MOD"] || [icLvl containsString:@"LGT-MOD"]){
            ttf =  @"4";
            //ttfColor = orange;
        } else if([icLvl containsString:@"SEV"] || [icLvl containsString:@"MOD-SEV"]){
            ttf =  @"6";
            //ttfColor = red;
        }
    }
    else if(tbLvl != NULL){
        
        if([tbLvl containsString:@"LGT"]){
                ttf =  @"8";
                //ttfColor = green;
            } else if([tbLvl containsString:@"MOD"] || [tbLvl containsString:@"LGT-MOD"]){
                ttf =  @":";
                //ttfColor = orange;
            } else if([tbLvl containsString:@"SEV"] || [tbLvl containsString:@"MOD-SEV"]){
                ttf =  @"<";
                //ttfColor = red;
            }
    }
    
    return ttf;
}
@end
