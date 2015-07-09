//
//  AWCRadarViewController.h
//  GA Weather
//
//  Created by adsbout on 4/1/15.
//  Copyright (c) 2015 Manoj Budumuru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Grid.h"
#import "AppDelegate.h"

@interface AWCRadarViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(strong,nonatomic) MKTileOverlay *tiles;
@property(strong,nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
- (IBAction)viewChange:(id)sender;


@property (weak, nonatomic) IBOutlet UINavigationBar *header;
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
