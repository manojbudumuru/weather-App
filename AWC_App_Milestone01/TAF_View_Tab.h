//
//  TAF_View_Tab.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "AppDelegate.h"
#import "TimeGroupsVC.h"

@interface TAF_View_Tab : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, TimeGroupDelegate>

@property (strong,nonatomic) IBOutlet MKMapView * displayTAF;
-(IBAction)refreshTAF:(id)sender;
@property (strong,nonatomic) IBOutlet UILabel * lastUpdateLabel;
@property UIPopoverController * popUp;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityStatus;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;

@property (weak, nonatomic) IBOutlet UINavigationBar *header;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *presentButtons;

@property TimeGroupsVC * timeGroupsVC;
@property UIPopoverController * popOverController;

//Zoom in Functionality
@property (weak, nonatomic) IBOutlet UIButton *zoom;
@property UIImage * button;
@property (strong, nonatomic) CLLocationManager *locationManager;
// Zoom in

//Control Panel Functionality
//  Properties for Control Panel
@property (weak, nonatomic) IBOutlet UIVisualEffectView *panel;
- (IBAction)controlPanel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *controlUp;

// Properties/Action Events for Flight Status
@property (weak, nonatomic) IBOutlet UIButton *flightOn;
- (IBAction)flightOnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *flightOff;

//  Properties/Action Events for Turb Flag
- (IBAction)turbAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *turbOff;
@property (weak, nonatomic) IBOutlet UIButton *turbOn;

@property (weak, nonatomic) IBOutlet UILabel *stopWatchLBL;

- (IBAction)controlPanelDown:(id)sender;
//Control Panel

@end
