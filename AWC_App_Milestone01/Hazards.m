//
//  Hazards.m
//  AWCHazards-JSON
//
//  Created by Bandari,Poornima on 12/2/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import "Hazards.h"

@implementation Hazards

-(MKMapRect)boundingMapRect{
    return _polygon.boundingMapRect;
}


-(CLLocationCoordinate2D)coordinate{
    return _polygon.coordinate;
}


// Initializing the Hazards object with hazard, polygon and color parameters and returning
-(id)initWithHazard:(NSString *) type addPolygon:(MKPolygon *)polygon addColor:(UIColor *)color{
    self = [super init];
    if(self){
        _type = type;
        _polygon = polygon;
        _color = color;
    }
    return self;
}


@end



