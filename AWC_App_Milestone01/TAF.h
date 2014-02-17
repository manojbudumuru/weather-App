//
//  TAF.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface TAF : NSObject <MKAnnotation>

@property NSString * idType;
@property NSString * site;
@property NSString * issueTime;
@property NSString * validTimeFrom;
@property NSString * validTimeTo;
@property NSString * validTime;
@property NSString * timeGroup;
@property NSString * fcstType;
@property NSString * wspd;
@property NSString * wdir;
@property NSString * visib;
@property NSString * cover;
@property NSString * fltcat;
@property NSString * rawTAF;

@property NSMutableArray * coordinatePoints;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) UIColor * color;


@end
