//
//  Annotation.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "Annotation.h"
#import "Pirep.h"
@implementation Annotation

-(id)initWithLocation:(CLLocationCoordinate2D) locate title:(NSString *)new_title subtitle:(NSString *)new_subtitle pirep:(Pirep *)pirepObj
{
    self = [super init];
    if(self)
    {
        self.coordinate = locate;
        self.title = new_title;
        self.subtitle = new_subtitle;
        self.pirepData = pirepObj;
        
    }
    return self;
}

@end
