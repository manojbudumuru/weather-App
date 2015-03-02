//
//  AWCAppDelegate.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//  Goodbye all changes!
//  Just to make sure how it works actually.
//  An edit by Vidhatri.

#import <UIKit/UIKit.h>

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
@property bool isFilghtOn;
@property bool isTurbOn;
@property (strong, nonatomic) NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
@property (strong, nonatomic) NSDate *startDate; // Stores the date of the click on the start button
- (void)updateTimer;
-(void)startTimer;
@property NSString* stopwatchLabel;



//To convert a given time to local time
-(NSString *)convertToLocalTime:(NSString *)serverTime;

@property NSMutableArray * timeGroups;

//To get the application password which will validate a user
//-(NSString *)getApplicationPassword;

@end
