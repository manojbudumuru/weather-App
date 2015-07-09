//
//  AWCAppDelegate.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//  Goodbye all changes!
//  Just to make sure how it works actually.
//  An edit by Vidhatri.
//  Edited by Syed Mazhar Hussani

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSMutableArray *flightInformation;

-(BOOL)isConnectedToInternet;

//Color for headers and tab bar
@property UIColor * awcColor;
//Images for Header and Tab Bar
@property UIImage * header;
@property UIImage * footer;

//  Properties for EDR/ General Control Panel
//  All the methods and properties are moved to Singleton class ControlPanelManager


//@property NSString* stopwatchLabel;
@property NSMutableArray* aircraftTypes;



//To convert a given time to local time
-(NSString *)convertToLocalTime:(NSString *)serverTime;

@property NSMutableArray * timeGroups;

//To get the application password which will validate a user
//-(NSString *)getApplicationPassword;

//User Location
@property CLLocationCoordinate2D userLocTAF;

@end
