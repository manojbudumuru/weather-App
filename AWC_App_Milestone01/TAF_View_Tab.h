//
//  TAF_View_Tab.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "AWCAppDelegate.h"

@interface TAF_View_Tab : UIViewController <MKMapViewDelegate>

@property (strong,nonatomic) IBOutlet MKMapView * displayTAF;
-(IBAction)refreshTAF:(id)sender;
@property (strong,nonatomic) IBOutlet UILabel * lastUpdateLabel;
@property UIPopoverController * popUp;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityStatus;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;
@end
