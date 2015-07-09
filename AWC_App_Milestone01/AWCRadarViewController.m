//
//  AWCRadarViewController.m
//  GA Weather
//
//  Created by adsbout on 4/1/15.
//  Copyright (c) 2015 Manoj Budumuru. All rights reserved.
//

#import "AWCRadarViewController.h"
#import "Grid.h"
#import "GridView.h"
#import <MapKit/MapKit.h>
#import "ControlPanelManager.h"
//@import MapKit;

@interface AWCRadarViewController ()<MKMapViewDelegate>


// Zoom in Functionality
@property MKCoordinateRegion beforeZoom;//edit2014
@property int check;
//Zoom in
@property ControlPanelManager *cp;
@property int trigger;
@end

@implementation AWCRadarViewController
@synthesize seg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _grid=[[Grid alloc]init];
    //_grid.geometryFlipped=YES;
    _grid.canReplaceMapContent=NO;
    [_mapView addOverlay:_grid level:MKOverlayLevelAboveLabels];
    
    // Zoom in Functionality
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    self.button = [UIImage imageNamed:@"zoomingin.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
    [self.zoom addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    
    self.mapView.mapType = MKMapTypeStandard;// edit 2015
    self.mapView.showsUserLocation = YES;
    self.check = 0;
    //Zoom in
    //Control Panel Transperancy
    self.cp = [ControlPanelManager sharedManager];
    self.panel.alpha = 0.6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Change the background of the view and header to reflect the theme of the application. Update the time label.
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    //  Loading control Panel
    [self controlPanelLoad];
    
    self.view.backgroundColor = appDelegate.awcColor;
    [self.header setBarTintColor:appDelegate.awcColor];
    [self.header setBackgroundImage:appDelegate.header forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [self.header setTintColor:[UIColor whiteColor]];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if([overlay isKindOfClass:[MKTileOverlay class]]) {
        
        // MKTileOverlayRenderer *renderer = ;
        //self.grid.geometryFlipped = YES;
        return [[GridView alloc] initWithTileOverlay:overlay];;
    }

    return nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)zoomIn{
    if(self.check==0){
        self.beforeZoom = self.mapView.region;// Setting the region for Map
        self.check++;
    }
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude), MKCoordinateSpanMake(4.347, 4.347));
    self.button = [UIImage imageNamed:@"zoomingout.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
    [self.zoom addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
}
-(void)zoomOut{
    self.mapView.region = MKCoordinateRegionMake(self.beforeZoom.center, self.beforeZoom.span);
    [self.zoom addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    self.button = [UIImage imageNamed:@"zoomingin.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
}

//  Setting Control Panel Properties
- (void)controlPanelLoad{
    self.panel.hidden = YES;
    self.controlUp.hidden = NO;
    if(self.cp.isFlightOn == NO){
        self.flightOn.hidden = NO;
        self.flightOff.hidden = YES;
    }
    else {
        self.flightOn.hidden = YES;
        self.flightOff.hidden = NO;
    }
    
    if (self.cp.isTurbOn) {
        self.turbOff.hidden = NO;
        self.turbOn.hidden = YES;
    }
    else{
        self.turbOff.hidden = YES;
        self.turbOn.hidden = NO;
    }
}
- (IBAction)controlPanel:(id)sender {
    self.panel.hidden = NO;
    self.controlUp.hidden = YES;
    [self updateTimerLabel];
    
}
- (IBAction)flightOnAction:(id)sender {
    
    if(self.flightOn.hidden){
        self.cp.isFlightOn = NO;
        self.flightOff.hidden = YES;
        self.flightOn.hidden = NO;
        
        if (self.turbOn.hidden) {
            self.turbOff.hidden = YES;
            self.turbOn.hidden = NO;
            self.cp.isTurbOn = NO;
        }
        [self.cp.stopWatchTimer invalidate];
        self.cp.stopWatchTimer = nil;
        [self updateTimerLabel];
        self.cp.stoppingRec = NO;

        
    }
    else{
        self.cp.isFlightOn = YES;
        self.flightOff.hidden = NO;
        self.flightOn.hidden = YES;
        self.cp.startDate = [NSDate date];
        [self.cp startTimer];
        [self updateTimerLabel];
        [self.cp startRec];

    }
}

- (IBAction)turbAction:(id)sender {
    
    if (self.cp.isFlightOn) {
        if(self.turbOn.hidden){
            self.cp.isTurbOn = NO;
            self.turbOff.hidden = YES;
            self.turbOn.hidden = NO;
            self.cp.TurbFlag = YES;
        }
        else {
            self.cp.isTurbOn = YES;
            self.turbOn.hidden = YES;
            self.turbOff.hidden = NO;
            self.cp.TurbFlag = YES;
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Turbulence can be only activated if the flight data is being recorded, So switch on Flight Recorder first." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)updateTimerLabel{
    self.stopWatchLBL.text = self.cp.stopwatch;//self.appDelegate.stopWatchCall;//self.appDelegate.stopwatchLabel;
    [self performSelector:@selector(updateTimerLabel) withObject:self afterDelay:0.1];
}

- (IBAction)controlPanelDown:(id)sender {
    self.controlUp.hidden = NO;
    self.panel.hidden = YES;
}


- (IBAction)viewChange:(id)sender {
    if(seg.selectedSegmentIndex == 0)
        
    {
        _grid.canReplaceMapContent=NO;
        [_mapView addOverlay:_grid level:MKOverlayLevelAboveLabels];
        self.mapView.mapType = MKMapTypeStandard;
        
    }
    
    if(seg.selectedSegmentIndex == 1)
        
    {
        
        self.mapView.mapType = MKMapTypeSatellite;
        
    }
}
@end
