//
//  Metar_View_TabViewController.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 11/17/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "AppDelegate.h"

@interface Metar_View_Tab : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *displayMetar;
@property (weak, nonatomic) IBOutlet MKMapView *displayWind;//edit2014 map for wind barbs
@property (strong, nonatomic) IBOutlet UILabel *lastUpdate;
- (IBAction)refreshMetars:(id)sender;
-(float)findZoom;
//edit2014 adding Segment controller
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)viewChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityStatus;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;
@property UIPopoverController * popUp;

@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@end