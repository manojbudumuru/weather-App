//
//  Hazards.h
//  AWCHazards-JSON
//
//  Created by Bandari,Poornima on 12/2/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Hazards : NSObject<MKOverlay>

// Declaration of Hazard properties
@property UIColor * color;
@property MKPolygon * polygon;
@property NSString * type;

// Initializing the Hazard object with hazard, polygon and color
-(id)initWithHazard:(NSString *) hazard addPolygon:(MKPolygon *)polygon addColor:(UIColor *)color;


@end