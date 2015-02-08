//
//  Pirep.h
//  TestingGeoJson
//
//  Created by SATISH KUMAR BASWAPURAM on 10/12/13.
//  Copyright (c) 2013 Satish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

//This class is used to store the information about Pirep objects.
//Each property defines the Pirep.

@interface Pirep : NSObject <MKAnnotation>

@property NSString * icaoId;
@property NSString *obsTime;
@property NSString * acType;
@property NSString * temp;
@property NSString * cloudCvg1;
@property NSString * cloudBas1;
@property NSString * wdir;
@property NSString * wspd;
@property NSString * fltlv1;
@property NSString * tbInt1;
@property NSString * tbFreq1;
@property NSString * rawOb;
@property NSString * point;
@property NSMutableArray * coordinatePoints;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (readwrite) CLLocationDegrees latitude;
@property (readwrite) CLLocationDegrees longitude;
// Edit2014
@property UIColor * ttfColor;

-(CLLocationDegrees) latitude;
-(void)setLatitude:(CLLocationDegrees)val;
-(CLLocationDegrees) longitude;
-(void)setLongitude:(CLLocationDegrees)val;

@end
