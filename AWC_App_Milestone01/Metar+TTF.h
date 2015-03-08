//
//  Metar+TTF.h
//  GA Weather
//
//  Created by Syed Mazhar Hussani on 11/19/14.
//  Copyright (c) 2014 Syed Mazhar. All rights reserved.
//

#import "Metar.h"

@interface Metar (TTF)

-(NSString*)ttfEquivalent:(NSString*)input;
-(NSString*)ttfEquivalentWind:(int)speed;

@end
