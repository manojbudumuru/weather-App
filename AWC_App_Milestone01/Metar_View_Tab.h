//
//  Metar_View_TabViewController.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 11/17/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "AWCAppDelegate.h"

@interface Metar_View_Tab : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *displayMetar;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdate;
- (IBAction)refreshMetars:(id)sender;
-(float)findZoom;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityStatus;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;
@property UIPopoverController * popUp;

@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@end