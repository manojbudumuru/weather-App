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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.displayMetar.delegate = self;
    self.displayMetar.mapType = MKMapTypeStandard;
    
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
        
        NSDate * now = [NSDate date];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString * updateTime = [dateFormatter stringFromDate:now];
        self.lastUpdate.text = [@"Last updated at: " stringByAppendingString: updateTime];
        
        [self viewMetars];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No internet!!" message:@"Make sure you have a working internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
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
            self.popUp.popoverContentSize = CGSizeMake(400, 350);
            [self.popUp presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
}


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

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self findZoom];
}

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
    
    else if(currentZoomLevel < 5.0 )
    {
        [self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        //[self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        
        //NSLog(@" 2 ");
    }
    
    else if(currentZoomLevel < 7.5 )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        //[self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        //NSLog(@" 3 ");
    }
    
    else if(currentZoomLevel < 10.0 )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        [self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        //[self.displayMetar addAnnotations:self.metarsWithFourPriority];
        
        //NSLog(@" 4 ");
    }
    
    else if(currentZoomLevel < 12.5  )
    {[self.displayMetar removeAnnotations:self.displayMetar.annotations];
        [self.displayMetar addAnnotations:self.metarsWithZeroPriority];
        [self.displayMetar addAnnotations:self.metarsWithOnePriority];
        [self.displayMetar addAnnotations:self.metarsWithTwoPriority];
        [self.displayMetar addAnnotations:self.metarsWithThreePriority];
        
        [self.displayMetar addAnnotations:self.metarsWithFourPriority];
        //[self.displayMetar addAnnotations:self.metarsWithFivePriority];
        
        //NSLog(@" 5 ");
    }
    
    else if(currentZoomLevel < 15.0  )
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
    
    else if(currentZoomLevel < 17.5 )
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
- (IBAction)refreshMetars:(id)sender {
    [self initializeData];
}
@end
