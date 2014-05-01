//
//  Metar.h
//  Metars
//
//  Created by SATISH KUMAR BASWAPURAM on 11/11/13.
//  Copyright (c) 2013 Vidhatri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

//This class is used to store the information about Metar objects.
//Each property defines the Metar.

@interface Metar : NSObject<MKAnnotation>

@property NSString * idType;
@property NSString * site;
@property NSString * obsTime;
@property NSString * temp;
@property NSString * dewp;
@property NSString * windspeed;
@property NSString * prior;
@property NSString * windDir;
@property NSString * ceil;
@property NSString * cover;
@property NSString * visib;
@property NSString * fltcat;
@property NSString * wx;
@property NSString * rawOb;
@property NSString * slp;
@property NSString * altim;
@property NSString * geoLatitude;
@property NSString * geoLongitude;

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,assign)CLLocationCoordinate2D  coordinate;

@property NSMutableArray * coordinatePoints;

@end