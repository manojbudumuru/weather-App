//
//  UserPirep.h
//  NWMSU_AWC_App
//
//  Created by Satish Kumar Baswapuram on 2/10/14.
//  Copyright (c) 2014 Satish Kumar Baswapuram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface UserPirep : NSObject <MKAnnotation>

//{"LicenseNum":"AB524","TimeOfReport":"12:45:00","AircraftType":"Boeing 777","TailNumber":"SD 12345","SkyCondition":"UNKNWN","WeatherCondition":"UNKNWN","LocationLatitude":"40.34","LocationLongitude":"-94.87","PilotReport":"CHOP MOD\/TURB LGT\/MTN WAVE LGT\/ICE CLEAR TRACE"}

//To get the data from a server
@property NSString * lisenceNum;
@property NSString * timeOfReport;
@property NSString * aircraftType;
@property NSString * tailNumber;
@property NSString * skyCondition;
@property NSString * weatherCondition;
@property NSString * locationLatitude;
@property NSString * locationLongitude;
@property NSString * pilotReport;
@property NSString * pageURL;

@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
