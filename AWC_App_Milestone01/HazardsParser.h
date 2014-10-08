//
//  HazardsParser.h
//  AWCHazards-JSON
//
//  Created by Bandari,Poornima on 12/2/13.
//  Copyright (c) 2013 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hazards.h"

@interface HazardsParser : NSObject

@property NSArray * airmetPropertiesArray;
@property NSArray * sigmetPropertiesArray;
@property NSMutableArray * hazardsArray;
@property NSArray * airmetCoordsArray;
@property NSArray * sigCoordsArray;
// Declaration of NSArray to store the Hazards internal coordinates like [@"features"][@"geometry"][@"coordinates"][n] in airmetInternalCoordsArray
@property NSArray * airmetInternalCoordsArray;
@property NSArray * sigmetInternalCoordsArray;
// Declaration of NSString to store hazard value
@property NSString * hazard;
@property NSString * airSigmetType;
@property NSDictionary * results;
@property NSDictionary * sigmetResults;

-(void)fetchData;
-(NSMutableArray *)GetHazards;


@end
