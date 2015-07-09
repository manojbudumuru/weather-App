//
//  AWCFirstViewController.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Edited by Syed Mazhar Hussani
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//  This is a change.

#import "PIREP_View_Tab.h"
#import "Pirep.h"
#import "DisplayPIREP.h"
#import "UserPirep.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "ControlPanelManager.h"

@interface PIREP_View_Tab ()

@property NSMutableArray * pireps;

@property BOOL mapLoaded;
@property BOOL annotationsAdded;
@property AppDelegate * appDelegate;
@property double latIn;
@property double longIn;
@property MKCoordinateRegion beforeZoom;//edit2014
@property int check;
@property ControlPanelManager *cp;
@property int trigger;


@end

@implementation PIREP_View_Tab

//Initialize the appDelegate, mapView and the loading activity indicator.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setting map type and delegate
    
    self.displayMap.delegate = self;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.trigger = 0;
    
    self.appDelegate = [UIApplication sharedApplication].delegate;

    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    self.activityStatus.transform = CGAffineTransformMakeScale(2, 2);
    //edit2014

    
    
    self.button = [UIImage imageNamed:@"zoomingin.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
    [self.zoom addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    
    _displayMap.mapType = MKMapTypeStandard;
    self.displayMap.showsUserLocation = YES;
    
    self.check = 0;
    //Control Panel Transperancy
    self.cp = [ControlPanelManager sharedManager];
    self.panel.alpha = 0.6;
    
    
    //edit2014 end
}

//Change the background of the view and header to reflect the theme of the application. Update the time label.
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    //self.view.backgroundColor = [UIColor colorWithRed:1/255.0 green:132/255.0 blue:144/255.0 alpha:1.0];
    
    //  Loading control Panel
    [self controlPanelLoad];
    
    [self.header setBackgroundImage:appDelegate.header forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = appDelegate.awcColor;
    [self.header setBarTintColor:appDelegate.awcColor];
    [self.header setTintColor:[UIColor whiteColor]];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self updateTimeLabel];
}

//Load PIREPs after the view has appeared so that the user can switch faster between the tabs.
-(void)viewDidAppear:(BOOL)animated
{
    //Location Update code edit2014
    //edit2014 end
    self.mapLoaded = NO;
    self.annotationsAdded = NO;
    [self initializeData];
}

//If the user has no internet connection, display an alert. Else, parse the json from database and add PIREPs on the map.
-(void)initializeData
{
   
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    if([appDelegate isConnectedToInternet])
    {
        [self.displayMap removeAnnotations:self.displayMap.annotations];
        
        //Initializing the arrays that store the annotation data
        self.pireps = [[NSMutableArray alloc]init];
        //self.metars = [[NSMutableArray alloc]init];
        // Do any additional setup after loading the view, typically from a nib.
        
        [self updateTimeLabel];
        [self viewPireps];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No internet!!" message:@"Make sure you have a working internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

//Updates the time label by getting the user's local time.
-(void)updateTimeLabel
{
    NSDate * now = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString * updateTime = [dateFormatter stringFromDate:now];
    self.lastUpdateInfoLabel.text = [@"Last updated at: " stringByAppendingString: updateTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//This will start the loading activity indicator when the map loads.
-(void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    self.mapLoaded = NO;
    [self.activityStatus startAnimating];
    self.activityStatus.hidden = NO;
    self.loadingImage.hidden = NO;
    
}

//If the map is completely loaded, then set mapLoaded to yes and check if the loading activity indicator needs to be stopped.
-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    self.mapLoaded = YES;
    [self stopStatusIndicator];
    //edit2014
    if(self.check==0){
    self.beforeZoom = self.displayMap.region;// Setting the region for Map
        NSLog(@"LATITUDE : %f",self.displayMap.userLocation.location.coordinate.latitude);
    NSLog(@"Before Zoom In:          %f,%f",self.beforeZoom.span.latitudeDelta,self.beforeZoom.span.longitudeDelta);
        self.check++;
    }
    //edit2014 end
}

//If the annotations are completely loaded, then set annotationsAdded to yes and check if the loading activity indicator needs to be stopped.
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    self.annotationsAdded = YES;
    [self stopStatusIndicator];
}

//If the map is loaded and all the PIREPs are added, then stop and hide the loading activity indicator.
-(void)stopStatusIndicator
{
    if(self.mapLoaded && self.annotationsAdded)
    {
        [self.activityStatus stopAnimating];
        self.activityStatus.hidden = YES;
        self.loadingImage.hidden = YES;
    }
}

//Display a popover when a PIREP is clicked. The popover contains the details of the PIREP listed in a table format.
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if([view.annotation isKindOfClass:[Pirep class]])
    {
        [self.displayMap deselectAnnotation:view.annotation animated:YES];
        NSLog(@"Clicked PIREP");
        Pirep * annotObj = (Pirep *)view.annotation;
        if(![self.popUp isPopoverVisible])
        {
            DisplayPIREP *pinDetails = [[DisplayPIREP alloc]initWithStyle:UITableViewStylePlain pirep:annotObj userPirep:nil];
            self.popUp = [[UIPopoverController alloc]initWithContentViewController:pinDetails];
            self.popUp.popoverContentSize = CGSizeMake(400, 400);
            [self.popUp presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
    else if([view.annotation isKindOfClass:[UserPirep class]])
    {
        [self.displayMap deselectAnnotation:view.annotation animated:YES];
        NSLog(@"Clicked USERPIREP");
        UserPirep * annotObj = (UserPirep *)view.annotation;
        if(![self.popUp isPopoverVisible])
        {
            DisplayPIREP *pinDetails = [[DisplayPIREP alloc]initWithStyle:UITableViewStylePlain pirep:nil userPirep:annotObj];
            self.popUp = [[UIPopoverController alloc]initWithContentViewController:pinDetails];
            self.popUp.popoverContentSize = CGSizeMake(400, 400);
            [self.popUp presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

//Display appropriate pins on the map for each annotation. If the annotation if of a PIREP from the database, display a symbol.
//Else, if the annotation is of a UserPIREP, dispay a user icon.
-(MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString * identifier = @"Annotation";
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;  //return nil to use default blue dot view
    
    if([annotation isKindOfClass:[Pirep class]])
        identifier = @"PIREP";
    else if([annotation isKindOfClass:[UserPirep class]])
        identifier = @"UserPIREP";
    
    MKPinAnnotationView * annotView = (MKPinAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if([annotation isKindOfClass:[Pirep class]])
    {
//        if(annotView == nil)
//        {
            //NSLog(@"******************INSIDE");
        Pirep *pirep = (Pirep*)annotation;
            annotView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            //UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            UILabel * lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        
//            lbl.font = [UIFont fontWithName:@"Weather" size:35.0f];//lbl.backgroundColor = [UIColor blackColor];
        
//            lbl.text = @"4";
        
        lbl2.font = [UIFont fontWithName:@"Weather" size:32.0f];
        lbl2.text =  [pirep ttfEquivalent:pirep.icgInt1 tbLvl:pirep.tbInt1];
        if([lbl2.text  isEqual: @"2"] || [lbl2.text  isEqual: @"8"])
            lbl2.textColor = [UIColor colorWithRed:43/255.0 green:172/255.0 blue:49/255.0 alpha:1.0]; //Hex Color #2BAC31
        if([lbl2.text  isEqual: @"4"] || [lbl2.text  isEqual: @":"])
           lbl2.textColor = [UIColor orangeColor];
        if([lbl2.text  isEqual: @"6"] || [lbl2.text  isEqual: @"<"])
            lbl2.textColor = [UIColor redColor];
        
        //self.displayMap.delegate = self;
        //if(pirep.icgInt1 != NULL && pirep.tbInt1 != NULL)
            [annotView addSubview:lbl2];
        
        
            //Following lets the callout still work if you tap on the label...
        
            //annotView.canShowCallout = YES;
            //annotView.frame = lbl.frame;
            annotView.image = [UIImage imageNamed:@"asd"];
  //      }
    }
    else if([annotation isKindOfClass:[UserPirep class]])
    {
        if(annotView == nil)
        {
            annotView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            
            
            UserPirep * user = (UserPirep*)annotation;
            UILabel * lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
            lbl2.font = [UIFont fontWithName:@"Weather" size:32.0f];
            lbl2.text = [user ttfEquivalent:user.pilotReport];
            if([lbl2.text  isEqual: @"2"] || [lbl2.text  isEqual: @"8"])
                lbl2.textColor = [UIColor colorWithRed:43/255.0 green:172/255.0 blue:49/255.0 alpha:1.0]; //Hex Color #2BAC31
            if([lbl2.text  isEqual: @"4"] || [lbl2.text  isEqual: @":"])
                lbl2.textColor = [UIColor orangeColor];
            if([lbl2.text  isEqual: @"6"] || [lbl2.text  isEqual: @"<"])
                lbl2.textColor = [UIColor redColor];
            //NSLog(@"USE REPORT: %@",user.pilotReport);
            [annotView addSubview:lbl2];
            annotView.image = [UIImage imageNamed:@"User.pngg"];
        }
    }
    annotView.annotation = annotation;
    //annotation.title;
    return annotView;
}

//Reload the entire data on the map when the refresh button is tapped.
- (IBAction)refreshPirep:(id)sender {
    [self initializeData];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

//Parse and display the PIREPs on the map.
- (void)viewPireps{
    
    NSURL *URL = [NSURL URLWithString:@"http://new.aviationweather.gov/gis/scripts/PirepJSON.php"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:URL];
    
    NSError *error = nil;
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSDictionary * features = [dataDictionary objectForKey:@"features"];
    
    
    for (NSDictionary *feature in features)
    {
        NSDictionary *properties = [feature objectForKey:@"properties"];
        Pirep * pirep = [[Pirep alloc]init];
        
        pirep.icaoId = properties[@"icaoId"];
        pirep.obsTime = properties[@"obsTime"];
        pirep.acType = properties[@"acType"];
        pirep.temp = properties[@"temp"];
        pirep.cloudCvg1 = properties[@"cloudCvg1"];
        pirep.cloudBas1 = properties[@"cloudBas1"];
        pirep.wdir = properties[@"wdir"];
        pirep.wspd = properties[@"wspd"];
        pirep.fltlv1 = properties[@"fltlv1"];
        pirep.icgInt1 = properties[@"icgInt1"];
        pirep.tbInt1 = properties[@"tbInt1"];
        pirep.tbFreq1 = properties[@"tbFreq1"];
        pirep.rawOb = properties[@"rawOb"];
        
        //NSLog(@"*************Here = %@",properties[@"icgInt1"]);
        
        NSDictionary *geometries = [feature objectForKey:@"geometry"];
        
        
        pirep.coordinatePoints = geometries[@"coordinates"];
        
        pirep.coordinate = CLLocationCoordinate2DMake([pirep.coordinatePoints[1] doubleValue], [pirep.coordinatePoints[0] doubleValue]);
        
        [self.pireps addObject:pirep];
        
    }
    
    
    //NSLog(@"Show: %c",pirepShow);
    
    //User generated PIREPs will be handled here
    URL = [NSURL URLWithString:@"http://csgrad07.nwmissouri.edu/GetDataFromServer.php"];
    
    jsonData = [NSData dataWithContentsOfURL:URL];
    
    error = nil;
    
    features = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    for (NSDictionary *feature in features)
    {
        UserPirep * pirep = [[UserPirep alloc]init];
        
        pirep.lisenceNum = feature[@"LicenseNum"];
        pirep.timeOfReport = feature[@"TimeOfReport"];
        pirep.aircraftType = feature[@"AircraftType"];
        pirep.tailNumber = feature[@"TailNumber"];
        pirep.skyCondition = feature[@"SkyCondition"];
        pirep.weatherCondition = feature[@"WeatherCondition"];
        pirep.locationLatitude = feature[@"LocationLatitude"];
        pirep.locationLongitude = feature[@"LocationLongitude"];
        pirep.pilotReport = feature[@"PilotReport"];
        
        //  NSLog(@"Here = %@",properties[@"icaoId"]);
        
        pirep.coordinate = CLLocationCoordinate2DMake([pirep.locationLatitude doubleValue], [pirep.locationLongitude doubleValue]);
        
        [self.pireps addObject:pirep];
        self.latIn = self.displayMap.userLocation.location.coordinate.latitude;
        self.longIn = self.displayMap.userLocation.location.coordinate.longitude;
        //NSLog(@"I am at location : [%f,%f]",pirep.coordinate.latitude,pirep.coordinate.longitude);
        
    }
    
    [self.displayMap addAnnotations:self.pireps];
}
//edit2014
//- (IBAction)zoomIn:(id)sender {
//    
//    NSLog(@"I am at location : [%f,%f]",self.latIn,self.longIn);
//    self.displayMap.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.latIn,self.longIn), MKCoordinateSpanMake(0.04504504504, 0.04504504504));
//    
//}
- (void)zoomIn{
    
//    NSLog(@"Before Zoom In:          %f,%f",self.beforeZoom.span.latitudeDelta,self.beforeZoom.span.longitudeDelta);
//    NSLog(@"Before Zoom In(Region):  %f,%f",self.displayMap.region.span.latitudeDelta,self.displayMap.region.span.longitudeDelta);
    self.displayMap.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.displayMap.userLocation.location.coordinate.latitude,self.displayMap.userLocation.location.coordinate.longitude), MKCoordinateSpanMake(4.347, 4.347));
    self.button = [UIImage imageNamed:@"zoomingout.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
    //[self.zoom setTitle:@"Zoom Out" forState:UIControlStateNormal];
    [self.zoom addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
}
-(void)zoomOut{
    //NSLog(@"zoomOut");
    self.displayMap.region = MKCoordinateRegionMake(self.beforeZoom.center, self.beforeZoom.span);
    //[self viewDidLoad];
    [self.zoom addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    //[self.zoom setTitle:@"Zoom In" forState:UIControlStateNormal];
    self.button = [UIImage imageNamed:@"zoomingin.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
    //NSLog(@"%f,%f",self.displayMap.userLocation.coordinate.latitude,self.displayMap.userLocation.coordinate.longitude);//self.displayMap.region.span.longitudeDelta);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.appDelegate.userLocTAF = self.displayMap.userLocation.coordinate;
    //self.displayMap.center = CGPointMake(self.displayMap.userLocation.coordinate.latitude, self.displayMap.userLocation.coordinate.longitude);//self.displayMap.userLocation.coordinate
    //MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
//    region.center.latitude = self.locationManager.location.coordinate.latitude;
//    region.center.longitude = self.locationManager.location.coordinate.longitude;
//    region.span.latitudeDelta = 0.0187f;
//    region.span.longitudeDelta = 0.0137f;
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.displayMap.userLocation.coordinate, 600.0f, 600.0f);
//    //[self.mapView setRegion:region animated:YES];
//    region.span.latitudeDelta = 0.5f;
//    region.span.longitudeDelta = 0.5f;
//    [self.displayMap setRegion:region animated:YES];
    
    //_initialPosition = NO;
}
//edit2014 End

//updating user location on map
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1600.0f, 1600.0f);
//    [self.displayMap setRegion:region animated:YES];//[self.displayMap regionThatFits:region] animated:YES];
}
- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
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

@end
