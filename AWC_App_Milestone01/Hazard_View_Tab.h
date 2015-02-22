//
//  Hazard_View_Tab.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HazardsParser.h"
#import "Hazards.h"
#import "AppDelegate.h"
#import "Forecast.h"

@interface Hazard_View_Tab : UIViewController <MKMapViewDelegate, ForecastDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *hazardsBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hazardsSegmentedControl;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityStatus;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;

@property (weak, nonatomic) IBOutlet UINavigationBar *header;

@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forecastsBTN;

@property Forecast * forecastVC;
@property UIPopoverController * popOverController;

@end
