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

@interface AWCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSMutableArray *flightInformation;

-(BOOL)isConnectedToInternet;

@end
