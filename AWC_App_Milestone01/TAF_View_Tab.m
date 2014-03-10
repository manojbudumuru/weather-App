//
//  TAF_View_Tab.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "TAF_View_Tab.h"
#import "TAF.h"
#import "DisplayTAF.h"
#import "CoreLocation/CoreLocation.h"

@interface TAF_View_Tab ()

@property BOOL mapLoaded;
@property BOOL annotationsAdded;

@end

@implementation TAF_View_Tab

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayTAF.mapType = MKMapTypeStandard;
    self.displayTAF.delegate = self;
    
    self.activityStatus.transform = CGAffineTransformMakeScale(2, 2);
    
    
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.mapLoaded = NO;
    self.annotationsAdded = NO;
    [self initializeData];
}

-(void)initializeData
{
    
    AWCAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    if([appDelegate isConnectedToInternet])
    {
    
        [self.displayTAF removeAnnotations:self.displayTAF.annotations];
        
        NSDate * now = [NSDate date];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString * updateTime = [dateFormatter stringFromDate:now];
        self.lastUpdateLabel.text = [@"Last updated at: " stringByAppendingString:updateTime];
        
        [self getTafs];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No internet!!" message:@"Make sure you have a working internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    self.mapLoaded = NO;
    [self.activityStatus startAnimating];
    self.activityStatus.hidden = NO;
    self.loadingImage.hidden = NO;
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    self.mapLoaded = YES;
    [self stopStatusIndicator];
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    self.annotationsAdded = YES;
    [self stopStatusIndicator];
}

-(void)stopStatusIndicator
{
    if(self.mapLoaded && self.annotationsAdded)
    {
        [self.activityStatus stopAnimating];
        self.activityStatus.hidden = YES;
        self.loadingImage.hidden = YES;
    }
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[TAF class]])
    {
        [self.displayTAF deselectAnnotation:view.annotation animated:YES];
        TAF * tafObj = (TAF *)view.annotation;
        if(![self.popUp isPopoverVisible])
        {
            DisplayTAF * tafPin = [[DisplayTAF alloc]initWithStyle:UITableViewStylePlain taf:tafObj];
            self.popUp = [[UIPopoverController alloc]initWithContentViewController:tafPin];
            self.popUp.popoverContentSize = CGSizeMake(400, 400);
            [self.popUp presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString * identifier = @"Annotation";
    MKPinAnnotationView * annotView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if([annotation isKindOfClass:[TAF class]])
    {
        if(annotView == nil)
        {
            annotView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            TAF * presentTAF = (TAF *)annotation;
            if([presentTAF.fltcat isEqualToString:@"LIFR"]) //pink
            {
                annotView.image = [UIImage imageNamed:@"PinkPin.png"];
            }
            else if([presentTAF.fltcat isEqualToString:@"IFR"]) //red
            {
                annotView.image = [UIImage imageNamed:@"RedPin.png"];
            }
            else if([presentTAF.fltcat isEqualToString:@"MVFR"]) //blue
            {
                annotView.image = [UIImage imageNamed:@"BluePin.png"];
            }
            else //black
            {
                annotView.image = [UIImage imageNamed:@"BlackPin.png"];
            }
            //annotView.pinColor = ];
        }
    }
    annotView.annotation = annotation;
    return annotView;
}

-(IBAction)refreshTAF:(id)sender
{
    [self initializeData];
}

-(void)getTafs
{
    NSURL * URL = [NSURL URLWithString:@"http://new.aviationweather.gov/gis/scripts/TafJSON.php"];
    NSData * data = [NSData dataWithContentsOfURL:URL];
    NSError * error = nil;
    NSDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    results = results[@"features"];
    
    for(NSDictionary * feature in results)
    {
        TAF * taf = [[TAF alloc]init];
        
        taf.idType = feature[@"properties"][@"id"];
        taf.site = feature[@"properties"][@"site"];
        taf.issueTime = feature[@"properties"][@"issueTime"];
        taf.validTimeFrom = feature[@"properties"][@"validTimeFrom"];
        taf.validTimeTo = feature[@"properties"][@"validTimeTo"];
        taf.validTime = feature[@"properties"][@"validTime"];
        taf.timeGroup = feature[@"properties"][@"timeGroup"];
        taf.fcstType = feature[@"properties"][@"fcstType"];
        taf.wspd = feature[@"properties"][@"wspd"];
        taf.wdir = feature[@"properties"][@"wdir"];
        taf.visib = feature[@"properties"][@"visib"];
        taf.cover = feature[@"properties"][@"cover"];
        taf.fltcat = feature[@"properties"][@"fltcat"];
        taf.rawTAF = feature[@"properties"][@"rawTAF"];
        
        taf.coordinatePoints = feature[@"geometry"][@"coordinates"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([taf.coordinatePoints[1] doubleValue], [taf.coordinatePoints[0] doubleValue]);
        taf.coordinate = coord;
        
        [self.displayTAF addAnnotation:taf];
    }
}

@end
