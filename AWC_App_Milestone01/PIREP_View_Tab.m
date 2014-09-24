//
//  AWCFirstViewController.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//  This is a change.

#import "PIREP_View_Tab.h"
#import "Pirep.h"
#import "DisplayPIREP.h"
#import "UserPirep.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface PIREP_View_Tab ()

@property NSMutableArray * pireps;

@property BOOL mapLoaded;
@property BOOL annotationsAdded;
@property AppDelegate * appDelegate;
@property double latIn;
@property double longIn;
@property MKCoordinateRegion beforeZoom;//edit2014
@property int check;


@end

@implementation PIREP_View_Tab

//Initialize the appDelegate, mapView and the loading activity indicator.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setting map type and delegate
    _displayMap.mapType = MKMapTypeStandard;
    _displayMap.delegate = self;
    
    self.appDelegate = [UIApplication sharedApplication].delegate;

    
    self.activityStatus.transform = CGAffineTransformMakeScale(2, 2);
    //edit2014
    
    self.button = [UIImage imageNamed:@"zoomIn.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
    [self.zoom addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    
    self.check = 0;
    //edit2014 end
}

//Change the background of the view and header to reflect the theme of the application. Update the time label.
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    self.view.backgroundColor = appDelegate.awcColor;
    [self.header setBarTintColor:appDelegate.awcColor];
    [self.header setTintColor:[UIColor whiteColor]];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self updateTimeLabel];
}

//Load PIREPs after the view has appeared so that the user can switch faster between the tabs.
-(void)viewDidAppear:(BOOL)animated
{
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
    
    if([annotation isKindOfClass:[Pirep class]])
        identifier = @"PIREP";
    else if([annotation isKindOfClass:[UserPirep class]])
        identifier = @"UserPIREP";
    
    MKPinAnnotationView * annotView = (MKPinAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if([annotation isKindOfClass:[Pirep class]])
    {
        if(annotView == nil)
        {
            annotView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            annotView.image = [UIImage imageNamed:@"PIREP_05.png"];
        }
    }
    else if([annotation isKindOfClass:[UserPirep class]])
    {
        if(annotView == nil)
        {
            annotView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            annotView.image = [UIImage imageNamed:@"User.png"];
        }
    }
    
    annotView.annotation = annotation;
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
        pirep.tbInt1 = properties[@"tbInt1"];
        pirep.tbFreq1 = properties[@"tbFreq1"];
        pirep.rawOb = properties[@"rawOb"];
        
        //  NSLog(@"Here = %@",properties[@"icaoId"]);
        
        NSDictionary *geometries = [feature objectForKey:@"geometry"];
        
        
        pirep.coordinatePoints = geometries[@"coordinates"];
        
        pirep.coordinate = CLLocationCoordinate2DMake([pirep.coordinatePoints[1] doubleValue], [pirep.coordinatePoints[0] doubleValue]);
        
        [self.pireps addObject:pirep];
        
    }
    
    
    //NSLog(@"Show: %c",pirepShow);
    
    //User generated PIREPs will be handled here
    URL = [NSURL URLWithString:@"http://csgrad06.nwmissouri.edu/GetDataFromServer.php"];
    
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
        self.latIn = pirep.coordinate.latitude;
        self.longIn = pirep.coordinate.longitude;
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
    self.displayMap.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.latIn,self.longIn), MKCoordinateSpanMake(0.04504504504, 0.04504504504));
    self.button = [UIImage imageNamed:@"zoomOut.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
    //[self.zoom setTitle:@"Zoom Out" forState:UIControlStateNormal];
    [self.zoom addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
}
-(void)zoomOut{
    NSLog(@"zoomOut");
    self.displayMap.region = MKCoordinateRegionMake(self.beforeZoom.center, self.beforeZoom.span);
    //[self viewDidLoad];
    [self.zoom addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    //[self.zoom setTitle:@"Zoom In" forState:UIControlStateNormal];
    self.button = [UIImage imageNamed:@"zoomIn.png"];
    [self.zoom setBackgroundImage:self.button forState:UIControlStateNormal];
    NSLog(@"%f,%f",self.displayMap.region.span.latitudeDelta,self.displayMap.region.span.longitudeDelta);
}
//edit2014 End
@end
