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
@property NSMutableArray * timeGroups;
@property NSMutableArray * tafAnnotations;
@property AppDelegate * appDelegate;

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

//Initialize the mapView, the loading activity indicator and the time groups.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    self.displayTAF.mapType = MKMapTypeStandard;
    self.displayTAF.delegate = self;
    
    self.activityStatus.transform = CGAffineTransformMakeScale(2, 2);
    
    self.timeGroups = [[NSMutableArray alloc]initWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
    
    self.timeGroupsVC = [[TimeGroupsVC alloc]initWithStyle:UITableViewStylePlain];
    self.timeGroupsVC.delegate = self;
    
    self.popOverController = [[UIPopoverController alloc]initWithContentViewController:self.timeGroupsVC];
    
    //Assigning target and action for the bar button item
    [self.presentButtons setTarget:self];
    [self.presentButtons setAction:@selector(selectTimeGroups:)];
    
	// Do any additional setup after loading the view.
}

//Set the view background color and header color to reflect the theme of the app.
-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = self.appDelegate.awcColor;
    [self.header setBarTintColor:self.appDelegate.awcColor];
    [self.header setBackgroundImage:self.appDelegate.header forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [self.header setTintColor:[UIColor whiteColor]];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self updateTimeLabel];
}

//Load TAFs after the view has appeared so that the user can switch faster between the tabs.
-(void)viewDidAppear:(BOOL)animated
{
    self.mapLoaded = NO;
    self.annotationsAdded = NO;
    [self initializeData];
}

//Updates the time label by getting the user's local time.
-(void)updateTimeLabel
{
    NSDate * now = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString * updateTime = [dateFormatter stringFromDate:now];
    self.lastUpdateLabel.text = [@"Last updated at: " stringByAppendingString:updateTime];
}

//If the user has no internet connection, display an alert. Else, parse the json from database and add TAFs on the map.
-(void)initializeData
{
    
    //AWCAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.tafAnnotations = [[NSMutableArray alloc]init];
    
    if([self.appDelegate isConnectedToInternet])
    {
    
        
        [self updateTimeLabel];
        
        [self.displayTAF removeAnnotations:self.displayTAF.annotations];
        
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
}

//If the annotations are completely loaded, then set annotationsAdded to yes and check if the loading activity indicator needs to be stopped.
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    self.annotationsAdded = YES;
    [self stopStatusIndicator];
}

//If the map is loaded and all the TAFs are added, then stop and hide the loading activity indicator.
-(void)stopStatusIndicator
{
    if(self.mapLoaded && self.annotationsAdded)
    {
        [self.activityStatus stopAnimating];
        self.activityStatus.hidden = YES;
        self.loadingImage.hidden = YES;
    }
}

//Display a popover when a TAF is clicked. The popover contains the details of the TAF listed in a table format.
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

//Display appropriate pins on the map for each annotation based on the value of fltcat property.
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

//Reload all the pins when this button is clicked.
-(IBAction)refreshTAF:(id)sender
{
    [self initializeData];
    //[self getTafs];
}

//Parse and display the TAFs on the map.
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
        
        [self.tafAnnotations addObject:taf];
        //[self.displayTAF addAnnotation:taf];
    }
    [self updateTAFsOnMap];
}

//Update the pins on the map based on the timegroups selected.
-(void)updateTAFsOnMap
{
    [self updateTimeLabel];
    //[self.displayTAF removeAnnotations:self.displayTAF.annotations];
    
    NSMutableArray * tafsAlreadyOnMap = [[NSMutableArray alloc]initWithArray:self.displayTAF.annotations];
    NSMutableArray * tafsToBeRemoved = [[NSMutableArray alloc]init];
    
    NSMutableArray * timeGroupsAlreadyOnMap = [[NSMutableArray alloc]init];
    
    for(TAF * taf in tafsAlreadyOnMap)
    {
        if(![self.timeGroups containsObject:taf.timeGroup])
            [tafsToBeRemoved addObject:taf];
        else if(![timeGroupsAlreadyOnMap containsObject:taf.timeGroup])
        {
            [timeGroupsAlreadyOnMap addObject:taf.timeGroup];
        }
    }
    
    [self.displayTAF removeAnnotations:tafsToBeRemoved];
    
    for(TAF * taf in self.tafAnnotations)
    {
        if([self.timeGroups containsObject:taf.timeGroup] && ![timeGroupsAlreadyOnMap containsObject:taf.timeGroup])
           [self.displayTAF addAnnotation:taf];
    }
    
}

//Add the selected time group to the enabled timegroups list.
-(void)selectedTimeGroup:(NSString *)timeGroup
{
    [self.timeGroups addObject:timeGroup];
    NSLog(@"Added: %@",self.timeGroups);
    [self updateTAFsOnMap];
}

//Remove the selected time group from the enabled timegroups list.
-(void)deselectedTimeGroup:(NSString *)timeGroup
{
    [self.timeGroups removeObject:timeGroup];
    NSLog(@"Added: %@",self.timeGroups);
    [self updateTAFsOnMap];
}

//Display a popover with all the timegroups enabling the user to select his desired timegroups.
- (IBAction)selectTimeGroups:(id)sender {
    [self.popOverController presentPopoverFromBarButtonItem:self.presentButtons permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
@end