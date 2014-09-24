//
//  AWCFirstViewController.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "AppDelegate.h"

//This class is used to display the various PIREPs on the map.

@interface PIREP_View_Tab : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *displayMap;
- (IBAction)refreshPirep:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lastUpdateInfoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityStatus;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;

@property UIPopoverController *popUp;
//- (IBAction)zoomIn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *zoom;
@property UIImage * button;


@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@end