//
//  Annotation.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
#import "Pirep.h"


//This class was created initially for testing the annotations. We do not use it now but may need it for the next milestone.

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property Pirep * pirepData;

-(id)initWithLocation:(CLLocationCoordinate2D) locate title:(NSString *)new_title subtitle:(NSString *)new_subtitle pirep:(Pirep *)pirepObj;

@end
