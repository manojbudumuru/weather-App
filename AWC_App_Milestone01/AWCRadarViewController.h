//
//  AWCRadarViewController.h
//  GA Weather
//
//  Created by adsbout on 4/1/15.
//  Copyright (c) 2015 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Grid.h"

@interface AWCRadarViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(strong,nonatomic) MKTileOverlay *tiles;
@property(strong,nonatomic) Grid *grid;
@end
