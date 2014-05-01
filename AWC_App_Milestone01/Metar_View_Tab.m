//
//  Metar_View_TabViewController.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 11/17/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "Metar_View_Tab.h"
#import "Metar.h"
#import "DisplayMetars.h"
#define MERCATOR_RADIUS 85445659.44705395
@interface Metar_View_Tab ()

@property NSMutableArray * metars;
@property NSMutableArray * metarsWithZeroPriority;
@property NSMutableArray * metarsWithOnePriority;
@property NSMutableArray * metarsWithTwoPriority;
@property NSMutableArray * metarsWithThreePriority;
@property NSMutableArray * metarsWithFourPriority;
@property NSMutableArray * metarsWithFivePriority;
@property NSMutableArray * metarsWithSixPriority;
@property NSMutableArray * metarsWithSevenPriority;

@property BOOL mapLoaded;
@property BOOL annotationsAdded;

@end

@implementation Metar_View_Tab

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Initialize the mapView and the loading activity indicator.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayMetar.delegate = self;
    self.displayMetar.mapType = MKMapTypeStandard;
    
    self.activityStatus.transform = CGAffineTransformMakeScale(2, 2);
    

    
    
	// Do any additional setup after loading the view.
}

//Change the background of the view and header to reflect the theme of the application. Update the time label.
-(void)viewWillAppear:(BOOL)animated
{
    AWCAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.view.backgroundColor = appDelegate.awcColor;
    [self.header setBarTintColor:appDelegate.awcColor];
    [self.header setTintColor:[UIColor whiteColor]];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self updateTimeLabel];
}

//Load Metars after the view has appeared so that the user can switch faster between the tabs.
-(void)viewDidAppear:(BOOL)animated
{
    self.mapLoaded = NO;
    self.annotationsAdded = NO;
    [self initializeData];
}

//If the user has no internet connection, display an alert. Else, parse the json from database and add Metars on the map.
-(void)initializeData
{
    AWCAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    if([appDelegate isConnectedToInternet])
    {
    
    
        [self.displayMetar removeAnnotations:self.displayMetar.annotations];
        
        self.metars = [[NSMutableArray alloc]init];
        self.metarsWithZeroPriority = [[NSMutableArray alloc]init];
        self.metarsWithOnePriority = [[NSMutableArray alloc]init];
        self.metarsWithTwoPriority = [[NSMutableArray alloc]init];
        self.metarsWithThreePriority = [[NSMutableArray alloc]init];
        self.metarsWithFourPriority = [[NSMutableArray alloc]init];
        self.metarsWithFivePriority = [[NSMutableArray alloc]init];
        self.metarsWithSixPriority = [[NSMutableArray alloc]init];
        self.metarsWithSevenPriority = [[NSMutableArray alloc]init];
        
        [self updateTimeLabel];
        
        [self viewMetars];
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
    self.lastUpdate.text = [@"Last updated at: " stringByAppendingString: updateTime];
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

//If the map is loaded and all the Metars are added, then stop and hide the loading activity indicator.
-(void)stopStatusIndicator
{
    if(self.mapLoaded && self.annotationsAdded)
    {
        [self.activityStatus stopAnimating];
        self.activityStatus.hidden = YES;
        self.loadingImage.hidden = YES;
    }
}

//Parse and display the Metars on the map.
-(void)viewMetars
{
    NSURL * myURL = [NSURL URLWithString:@"http://new.aviationweather.gov/gis/scripts/MetarJSON.php?priority=7"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:myURL];
    
    NSError *error = nil;
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    results = results[@"features"];
    
    
    for(NSDictionary *feature in results)
    {
        
        //NSDictionary * feature = oneFeature;
        Metar * metar = [[Metar alloc]init];
        
        metar = [[Metar alloc]init];
        metar.site = feature[@"properties"][@"site"];
        metar.idType = feature[@"properties"][@"id"];
        metar.obsTime = feature[@"properties"][@"obsTime"];
        metar.windspeed = feature[@"properties"][@"wspd"];
        metar.prior = feature[@"properties"][@"prior"];
        metar.windDir = feature[@"properties"][@"wdir"];
        metar.ceil = feature[@"properties"][@"ceil"];
        metar.cover = feature[@"properties"][@"cover"];
        metar.visib = feature[@"properties"][@"visib"];
        metar.fltcat = feature[@"properties"][@"fltcat"];
        metar.wx = feature[@"properties"][@"wx"];
        metar.rawOb = feature[@"properties"][@"rawOb"];
        metar.slp = feature[@"properties"][@"slp"];
        metar.altim = feature[@"properties"][@"altim"];
        metar.temp = feature[@"properties"][@"temp"];
        metar.dewp = feature[@"properties"][@"dewp"];
        
        
        metar.coordinatePoints = feature[@"geometry"][@"coordinates"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([metar.coordinatePoints[1] doubleValue], [metar.coordinatePoints[0] doubleValue]);
        metar.coordinate = coord;
        
        //[self.metars addObject:metar];
        if([metar.prior integerValue] == 0)
        {
            
            [self.metarsWithZeroPriority addObject:metar];
            
        }
        
        else if([metar.prior integerValue] == 1 )
        {
            [self.metarsWithOnePriority addObject:metar];
            //NSLog(@" 1 ");
        }
        
        else if([metar.prior integerValue] == 2 )
        {
            [self.metarsWithTwoPriority addObject:metar];
            //NSLog(@" 2 ");
        }
        
        else if([metar.prior integerValue] == 3 )
        {
            [self.metarsWithThreePriority addObject:metar];
            //NSLog(@" 3 ");
        }
        
        else if( [metar.prior integerValue] == 4 )
        {
            [self.metarsWithFourPriority addObject:metar];
            // NSLog(@" 4 ");
        }
        
        else if([metar.prior integerValue] == 5 )
        {
            [self.metarsWithFivePriority addObject:metar];
            //NSLog(@" 5 ");
        }
        
        else if([metar.prior integerValue] == 6 )
        {
            [self.metarsWithSixPriority addObject:metar];
            //NSLog(@" 6 ");
        }
        
        else if([metar.prior integerValue] == 7)
        {
            [self.metarsWithSevenPriority addObject:metar];
            //NSLog(@" 7 ");
        }
    }
    
    [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
    [self findZoom];
}

//Display a popover when a Metar is clicked. The popover contains the details of the Metar listed in a table format.
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass : [Metar class]])
    {
        
        [self.displayMetar deselectAnnotation:view.annotation animated:YES];
        
        
        Metar * metarObject = (Metar *)view.annotation;
        if(![self.popUp isPopoverVisible])
        {
            DisplayMetars * myTable = [[DisplayMetars alloc]initWithStyle:UITableViewStylePlain incomingMetar:metarObject];
            
            self.popUp = [[UIPopoverController alloc]initWithContentViewController:myTable];
            self.popUp.popoverContentSize = CGSizeMake(400, 400);
            [self.popUp presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
}

//Display appropriate pins on the map for each annotation based on the value of WX property.
//If there is no WX property for a Metar, it indicates that the weather over there is clear and is indicated with a hollow circle.
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    Metar * thisMetar = (Metar *)annotation;
    NSString * metarWX = @"NULL.png";
    if(thisMetar.wx!=nil)
    {
        NSMutableArray * words = [[NSMutableArray alloc]initWithArray:[thisMetar.wx componentsSeparatedByString:@" "]];
        metarWX = [NSString stringWithFormat:@"%@.png",words[0]];
    }

    MKPinAnnotationView * annotView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:metarWX];
    if(annotView == nil)
    {
        annotView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:metarWX];
        
        if([annotation isKindOfClass:[Metar class]])
        {
            
            
                annotView.image = [UIImage imageNamed:metarWX];
           
        }
        //annotView.image = [UIImage imageNamed:@"+TSRA.png"];
        
    }
    annotView.annotation = annotation;
    return annotView;
}

//Previous method used to display the views for annotation.
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation_Working:(id<MKAnnotation>)annotation
{
    static NSString * identifier = @"Annotation";
    MKPinAnnotationView * annotView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(annotView == nil)
    {
        annotView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        
        if([annotation isKindOfClass:[Metar class]])
        {
            static int count = 0;
            Metar * thisMetar = (Metar *)annotation;
            
            if(thisMetar.wx!=nil)
            {
                NSMutableArray * words = [[NSMutableArray alloc]initWithArray:[thisMetar.wx componentsSeparatedByString:@" "]];
                NSString * name = [NSString stringWithFormat:@"%@.png",words[0]];
                annotView.image = [UIImage imageNamed:name];
            }
            else
            {
                NSLog(@"++++++++++ %d",++count);
            }
        }
        //annotView.image = [UIImage imageNamed:@"+TSRA.png"];
            
    }
    annotView.annotation = annotation;
    return annotView;
}

//Dynamically change the pins on the map when the user zooms in/out.
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self findZoom];
}

//Find the current zoom level based on the amount the user has zoomed in.
-(float)findZoom {
    
    float currentZoomLevel = 21 - (log2(self.displayMetar.region.span.longitudeDelta *
                                        MERCATOR_RADIUS * M_PI / (180.0 * self.displayMetar.bounds.size.width)));
    
    
    
    
    if(currentZoomLevel < 3.5 )
    {
        [self.displayMetar removeAnnotations:self.displayMetar.annotations];
        
        //[self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        
        
        //NSLog(@" 1 ");
    }
    
    else if(currentZoomLevel < 4.5 )
    {
        [self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        //[self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        
        //NSLog(@" 2 ");
    }
    
    else if(currentZoomLevel < 5.5 )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        //[self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        //NSLog(@" 3 ");
    }
    
    else if(currentZoomLevel < 6.5 )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        [self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        //[self.displayMetar addAnnotations:self.metarsWithFourPriority];
        
        //NSLog(@" 4 ");
    }
    
    else if(currentZoomLevel < 7.0  )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        [self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        [self.displayMetar addAnnotations:self.metarsWithFourPriority];
        //[self.displayMetar addAnnotations:self.metarsWithFivePriority];
        
        //NSLog(@" 5 ");
    }
    
    else if(currentZoomLevel < 7.5  )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        [self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        [self.displayMetar addAnnotations:self.metarsWithFourPriority];
        [self.displayMetar addAnnotations:self.metarsWithFivePriority];
        // [self.displayMetar addAnnotations:self.metarsWithSixPriority];
        
        //NSLog(@" 6 ");
    }
    
    else if(currentZoomLevel < 8.0 )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        [self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        [self.displayMetar addAnnotations:self.metarsWithFourPriority];
        [self.displayMetar addAnnotations:self.metarsWithFivePriority];
        [self.displayMetar addAnnotations:self.metarsWithSixPriority];
        //[self.displayMetar addAnnotations:self.metarsWithSevenPriority];
        
        //NSLog(@" 7 ");
    }
    else if(currentZoomLevel <=20 )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        [self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        [self.displayMetar addAnnotations:self.metarsWithFourPriority];
        [self.displayMetar addAnnotations:self.metarsWithFivePriority];
        [self.displayMetar addAnnotations:self.metarsWithSixPriority];
        [self.displayMetar addAnnotations:self.metarsWithSevenPriority];
        
        //NSLog(@" 7 ");
    }
    
    
    
    
    
    //[self.displayMetar reloadInputViews];
    
    
    //NSLog(@"Zoom level = %f",21 - (log2(self.displayMetar.region.span.longitudeDelta *
                                        //MERCATOR_RADIUS * M_PI / (180.0 * self.displayMetar.bounds.size.width))));
    
    return 21 - (log2(self.displayMetar.region.span.longitudeDelta *
                      MERCATOR_RADIUS * M_PI / (180.0 * self.displayMetar.bounds.size.width)));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDisplayMetar:nil];
    [self setLastUpdate:nil];
    [super viewDidUnload];
}

//Reload the pins on the map.
- (IBAction)refreshMetars:(id)sender {
    [self initializeData];
}
@end
