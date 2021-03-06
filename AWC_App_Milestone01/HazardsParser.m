//
//  HazardsParser.m
//  AWCHazards-JSON
//
//  Created by Bandari,Poornima on 12/2/13.
//  Edited by Syed Mazhar Hussani
//  Copyright (c) 2013 Student. All rights reserved.
//

#import "HazardsParser.h"
#import "Hazards.h"
#import <CoreLocation/CoreLocation.h>

@implementation HazardsParser

//Fetch Hazards information from the database and parse them.
-(void)fetchData{
    [self fetchData:0];
    //Overloading the method if default value is to be used
}
-(void)fetchData:(int)fore
{
    self.forecastTime = fore;
    NSString * airmetURL = [NSString stringWithFormat:@"http://aviationweather.gov/gis/scripts/GairmetJSON.php?fore=%d",self.forecastTime];///http://csgrad07.nwmissouri.edu/test.php";
    //NSLog(@"Forecast Time: %d",self.forecastTime);
    
    NSURLRequest * urlReq1 = [NSURLRequest requestWithURL:[NSURL URLWithString:airmetURL]];
    
    // Creating the NSData object and assigning the data retrieved by connecting to the URL
    NSData * data1 =[NSURLConnection sendSynchronousRequest:urlReq1 returningResponse:nil error:nil];
    
    // Creating the NSDictionary by passing the data retrieved above to JSONObjectWithData:options:error method
    self.results = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];

    self.airmetPropertiesArray = [self.results valueForKey:@"features"];
        
    NSString * sigmetURL = @"http://aviationweather.gov/gis/scripts/SigmetJSON.php";
  
    NSURLRequest * urlReq2 = [NSURLRequest requestWithURL:[NSURL URLWithString:sigmetURL]];
    
    // Creating the NSData object and assigning the data retrieved by connecting to the URL
    NSData * data2 =[NSURLConnection sendSynchronousRequest:urlReq2 returningResponse:nil error:nil];
    
    // Creating the NSDictionary by passing the data retrieved above to JSONObjectWithData:options:error method
    self.sigmetResults = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
    
    self.sigmetPropertiesArray = [self.sigmetResults valueForKey:@"features"];
    
    self.hazardsArray = [[NSMutableArray alloc]init];
    NSLog(@"Airmet: %d,SIGMET: %d",self.airmetPropertiesArray.count,self.sigmetPropertiesArray.count);
//    for (int i=0; i<self.airmetPropertiesArray.count; i++) {
//        NSLog(@">>>  %@",self.airmetPropertiesArray[i]);
//    }
 

}

//Fetch, parse and returns Harards.
-(NSMutableArray *)GetHazards:(int)fore
{
    [self fetchData:fore];
    [self parseDataAirmet];
    [self parseDataSigmet];
    return self.hazardsArray;
}

//Parse Airmet Hazards and add them to the hazards array.
-(void)parseDataAirmet
{
    for(int i = 0; i < [self.airmetPropertiesArray count]; i++)
    {
        self.airmetCoordsArray = self.results[@"features"][i][@"geometry"][@"coordinates"];
        int count1 = [self.airmetCoordsArray count];
//        for (int i=0; i<self.airmetCoordsArray.count; i++) {
//            NSLog(@"Coords:  %@",self.airmetCoordsArray[i]);
//        }
        for(int j = 0; j < count1 ; j++)
        {
            self.hazard = [NSString stringWithFormat:@"%@",self.results[@"features"][i][@"properties"][@"hazard"]];
            
            if([self.hazard isEqualToString:@"IFR"] || [self.hazard isEqualToString:@"MT_OBSC"] ||  [self.hazard isEqualToString:@"ICE"] || [self.hazard isEqualToString:@"TURB"] || [self.hazard isEqualToString:@"TURB-HI"] || [self.hazard isEqualToString:@"TURB-LO"]){
            self.airmetInternalCoordsArray = self.results[@"features"][i][@"geometry"][@"coordinates"][j];
            }
            int count2 = [self.airmetInternalCoordsArray count];
//            for (int i=0; i<self.airmetInternalCoordsArray.count; i++) {
//                //NSLog(@"InternalCoords:  %@",self.airmetInternalCoordsArray[i]);
//            }
            // Declaring the CLLocationCoordinate2D object
            CLLocationCoordinate2D coords[count2];
            for(int k = 0; k < count2; k++)
            {
                CLLocationDegrees lon,lat;
                // Creating the longitude and latitude properties
                if([self.hazard isEqualToString:@"IFR"] || [self.hazard isEqualToString:@"MT_OBSC"] ||  [self.hazard isEqualToString:@"ICE"] || [self.hazard isEqualToString:@"TURB"] || [self.hazard isEqualToString:@"TURB-HI"] || [self.hazard isEqualToString:@"TURB-LO"]){
                lon = [self.results[@"features"][i][@"geometry"][@"coordinates"][j][k][0] doubleValue];
                lat = [self.results[@"features"][i][@"geometry"][@"coordinates"][j][k][1] doubleValue];
                }
                //NSLog(@"GAIRMET Coords %f,%f",lat,lon);
                // Creating a CLLocationCoordinate2D object by passing the above created lat & lon
                coords[k] = CLLocationCoordinate2DMake(lat, lon);
                
            }
            
            // Creating an MKPolygon object by passing the coordinates array and count value
            MKPolygon * polygon = [MKPolygon polygonWithCoordinates:coords count:count2];
            // Storing the hazard value in NSString "self.hazard"
            
            //NSLog(@"HAZARD: %@",self.hazard);
            self.airSigmetType = @"AIRMET";//[NSString stringWithFormat:@"%@",self.results[@"features"][i][@"properties"][@"airSigmetType"]];
            // Setting the appropriate color to the polygon based on hazard type and calling the method colorToPolygon:
            UIColor * color = [self colorToPolygon:self.hazard airSigmetType:self.airSigmetType];
            // Initializing the Hazards class object by passing the hazard type, polygon created and color of polygon
            Hazards * hazard = [[Hazards alloc]initWithHazard:self.hazard addPolygon:polygon addColor:color];
            [self.hazardsArray addObject:hazard];
        }
    }    

}

//Parse Sigmet Hazards and add them to the hazards array.
-(void)parseDataSigmet
{
    for(int i = 0; i < [self.sigmetPropertiesArray count]; i++)
    {
        self.sigCoordsArray = self.sigmetResults[@"features"][i][@"geometry"][@"coordinates"];
        int count1 = [self.sigCoordsArray count];
        
        for(int j = 0; j < count1 ; j++)
        {
            self.sigmetInternalCoordsArray = self.sigmetResults[@"features"][i][@"geometry"][@"coordinates"][j];
            int count2 = [self.sigmetInternalCoordsArray count];
            // Declaring the CLLocationCoordinate2D object
            CLLocationCoordinate2D coords[count2];
            for(int k = 0; k < count2; k++)
            {
                // Creating the longitude and latitude properties
                CLLocationDegrees lon = [self.sigmetResults[@"features"][i][@"geometry"][@"coordinates"][j][k][0] doubleValue];
                CLLocationDegrees lat = [self.sigmetResults[@"features"][i][@"geometry"][@"coordinates"][j][k][1] doubleValue];
                
                // Creating a CLLocationCoordinate2D object by passing the above created lat & lon
                coords[k] = CLLocationCoordinate2DMake(lat, lon);
                
            }
            
            // Creating an MKPolygon object by passing the coordinates array and count value
            MKPolygon * polygon = [MKPolygon polygonWithCoordinates:coords count:count2];
            // Storing the hazard value in NSString "self.hazard"
            self.hazard = [NSString stringWithFormat:@"%@",self.sigmetResults[@"features"][i][@"properties"][@"hazard"]];
            
            self.airSigmetType = [NSString stringWithFormat:@"%@",self.results[@"features"][i][@"properties"][@"airSigmetType"]];
            // Setting the appropriate color to the polygon based on hazard type and calling the method colorToPolygon:
            UIColor * color = [self colorToPolygon:self.hazard airSigmetType:self.airSigmetType];
            // Initializing the Hazards class object by passing the hazard type, polygon created and color of polygon
            Hazards * hazard = [[Hazards alloc]initWithHazard:self.hazard addPolygon:polygon addColor:color];
            [self.hazardsArray addObject:hazard];
        }
    }

}

//Define a color to the hazard based on its type.
-(UIColor *)colorToPolygon:(NSString *)hazard airSigmetType:(NSString *)airSigmet{
    // Initializing UIColor to nil
    UIColor * color = nil;
    // Checking the hazard type and accordingly assigning corresponding color to UIColor object
    
    if([hazard isEqualToString:@"MTN OBSCN"] || [hazard isEqualToString:@"MT_OBSC"])
    {
        color=[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1];
        
    }
    else if(([hazard isEqualToString:@"TURB"] || [hazard isEqualToString:@"TURB-HI"] || [hazard isEqualToString:@"TURB-LO"]) &&
            [airSigmet isEqualToString:@"AIRMET"])
    {
        color=[[UIColor alloc] initWithRed:192.0/255 green:48.0/255 blue:0 alpha:1];
        
    }
    else if(([hazard isEqualToString:@"TURB"] || [hazard isEqualToString:@"TURB-HI"] || [hazard isEqualToString:@"TURB-LO"]) &&[airSigmet isEqualToString:@"SIGMET"] )
    {
        color =[[UIColor alloc] initWithRed:240.0/255 green:96.0/255 blue:0 alpha:1];
        
    }
    else if([hazard isEqualToString:@"ICE"] &&
            [airSigmet isEqualToString:@"AIRMET"])
    {
        color=[[UIColor alloc] initWithRed:0 green:0 blue:240.0/255 alpha:1];
        
    }
    else if([hazard isEqualToString:@"ICE"] &&
            [airSigmet isEqualToString:@"SIGMET"] )
    {
        color =[[UIColor alloc] initWithRed:0 green:0 blue:128.0/255 alpha:1];
        
    }
    else if([hazard isEqualToString:@"ASH"])
    {
       color =[UIColor grayColor];        
    }
    else if([hazard isEqualToString:@"CONVECTIVE"])
    {
       color = [[UIColor alloc] initWithRed:192.0/255 green:96.0/255 blue:24.0/255 alpha:1];
    }
    else if([hazard isEqualToString:@"IFR"])
    {
       color = [[UIColor alloc] initWithRed:126.0/255 green:48.0/255 blue:126.0/255 alpha:1];
    }
//    else
//    {
//        NSLog(@"hazard: %@",hazard);
//       color = [UIColor blackColor];
//    }
    
    // return color
    return color;
}


@end
