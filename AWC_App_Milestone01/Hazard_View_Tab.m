//
//  Hazard_View_Tab.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "Hazard_View_Tab.h"

@interface Hazard_View_Tab ()

@property HazardsParser * myHazardsParser;
@property UIBarButtonItem * mtnObsn;
@property UIBarButtonItem * icing;
@property UIBarButtonItem * turbulence;
@property UIBarButtonItem * generic;
@property UIBarButtonItem * ifr;
@property UIBarButtonItem * ash;
@property UIBarButtonItem * convective;
@property BOOL mtnValidate;
@property BOOL turbValidate;
@property BOOL icingValidate;
@property BOOL ashValidate;
@property BOOL ifrValidate;
@property BOOL convectiveValidate;
@property BOOL genericValidate;
@property NSMutableArray * hazardOverlays;

@property BOOL mapLoaded;
@property BOOL annotationsAdded;
@property BOOL overlaysAdded;

@end

@implementation Hazard_View_Tab

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
    
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    
    self.activityStatus.transform = CGAffineTransformMakeScale(2, 2);
}

-(void)viewWillAppear:(BOOL)animated
{
    AWCAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.view.backgroundColor = appDelegate.awcColor;
    [self.header setBarTintColor:appDelegate.awcColor];
    [self.header setTintColor:[UIColor whiteColor]];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self updateTimeLabel];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.mapLoaded = NO;
    self.annotationsAdded = NO;
    self.overlaysAdded = NO;
    [self initializeData];
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

-(void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    self.overlaysAdded = YES;
    [self stopStatusIndicator];
}

-(void)stopStatusIndicator
{
    if(self.mapLoaded && self.annotationsAdded && self.overlaysAdded)
    {
        [self.activityStatus stopAnimating];
        self.activityStatus.hidden = YES;
        self.loadingImage.hidden = YES;
    }
}

-(void)initializeData
{

    AWCAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    if([appDelegate isConnectedToInternet])
    
    {
        
        [self updateTimeLabel];
    
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        
        _myHazardsParser = [[HazardsParser alloc]init];
        
        self.hazardOverlays = [_myHazardsParser GetHazards];
        
        
        
        [self showHazards];
        
        _mtnObsn = [[UIBarButtonItem alloc] initWithTitle:@"mtn obscn" style:UIBarButtonItemStyleBordered target:self action:@selector(mtnObsnButton:)];
        
        
        _turbulence = [[UIBarButtonItem alloc] initWithTitle:@"turbulence" style:UIBarButtonItemStyleBordered target:self action:@selector(turbulenceButton:)];
        
        
        _icing = [[UIBarButtonItem alloc] initWithTitle:@"icing" style:UIBarButtonItemStyleBordered target:self action:@selector(icingButton:)];
        
        
        _convective = [[UIBarButtonItem alloc] initWithTitle:@"convective" style:UIBarButtonItemStyleBordered target:self action:@selector(convectiveButton:)];
        
        
        _ash = [[UIBarButtonItem alloc] initWithTitle:@"ash" style:UIBarButtonItemStyleBordered target:self action:@selector(ashButton:)];
        
        _ifr = [[UIBarButtonItem alloc] initWithTitle:@"ifr" style:UIBarButtonItemStyleBordered target:self action:@selector(ifrButton:)];
        
        _generic = [[UIBarButtonItem alloc] initWithTitle:@"all" style:UIBarButtonItemStyleBordered target:self action:@selector(genericButton:)];
        
        
        NSArray * Hazarditems = [NSArray arrayWithObjects:_generic, _mtnObsn,_turbulence,_icing,_convective,_ash,_ifr,nil];
        
        self.hazardsBar.items = Hazarditems;
        
        [self.hazardsSegmentedControl addTarget:self action:@selector(segmentActions:) forControlEvents:UIControlEventValueChanged];
        [self.hazardsSegmentedControl setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.72]];
    
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No internet!!" message:@"Make sure you have a working internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
	// Do any additional setup after loading the view.
}

-(void)updateTimeLabel
{
    NSDate * now = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString * updateTime = [dateFormatter stringFromDate:now];
    self.lastUpdateLabel.text = [@"Last updated at: " stringByAppendingString:updateTime];
}

-(IBAction)segmentActions:(id)sender
{
    int selectedIndex = self.hazardsSegmentedControl.selectedSegmentIndex;
    NSLog(@"Selected: %d",selectedIndex);
    switch (selectedIndex) {
        case 0: [self genericButton:nil];
                break;
            
        case 1: [self mtnObsnButton:nil];
                break;
            
        case 2: [self turbulenceButton:nil];
                break;
            
        case 3: [self icingButton:nil];
                break;
            
        case 4: [self convectiveButton:nil];
                break;
            
        case 5: [self ashButton:nil];
                break;
            
        case 6: [self ifrButton:nil];
                break;
            
        default:
                break;
    }
    
}

-(void)showHazards
{
    _mtnObsn.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
    _icing.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
    _turbulence.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
    _ifr.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
    _convective.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
    _generic.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
    _ash.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
    
    self.genericValidate = NO;
    self.turbValidate = NO;
    self.mtnValidate = NO;
    self.ifrValidate = NO;
    self.ashValidate = NO;
    self.convectiveValidate = NO;
    
    self.icingValidate = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [self.mapView addAnnotations:self.hazardOverlays];
//    [self.mapView addOverlays:self.hazardOverlays];
    [self genericButton:self];
}

-(void)mtnObsnButton:(id)sender
{
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.mtnValidate == NO) {
        if(self.genericValidate==YES)
        {
            _generic.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
            [self genericButton:sender];
        }
        _mtnObsn.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        
        
        for( int i=0;i< [self.hazardOverlays count];i++)
        {
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"MTN OBSCN"])
            {
                [self.mapView addAnnotation:myHazard];
                [self.mapView addOverlay:myHazard];
            }
            
        }
        
        self.mtnValidate = YES;
        
    }
    else
    {
        _mtnObsn.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        self.mtnValidate = NO;
        for (int i =0; i < [self.hazardOverlays count]; i++) {
            
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"MTN OBSCN"])
            {
                [self.mapView removeAnnotation:[self.hazardOverlays objectAtIndex:i]];
                [self.mapView removeOverlay:[self.hazardOverlays objectAtIndex:i]];
            }
        }
    }
}

-(void)turbulenceButton:(id)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.turbValidate == NO) {
        if(self.genericValidate==YES)
        {
            _generic.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
            [self genericButton:sender];
        }
        _turbulence.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        
        for( int i=0;i< [self.hazardOverlays count];i++)
        {
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"TURB"])
            {
                [self.mapView addAnnotation:myHazard];
                [self.mapView addOverlay:myHazard];
            }
        }
        self.turbValidate = YES;
        
        
    }
    else
    {
        _turbulence.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        self.turbValidate = NO;
        for (int i =0; i < [self.hazardOverlays count]; i++) {
            
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"TURB"])
            {
                [self.mapView removeAnnotation:[self.hazardOverlays objectAtIndex:i]];
                [self.mapView removeOverlay:[self.hazardOverlays objectAtIndex:i]];
            }
            
        }
        
    }
    
}

-(void)icingButton:(id)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.icingValidate == NO) {
        if(self.genericValidate==YES)
        {
            _generic.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
            [self genericButton:sender];
        }
        _icing.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        
        
        
        for( int i=0;i< [self.hazardOverlays count];i++)
        {
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"ICE"])
            {
                [self.mapView addAnnotation:myHazard];
                [self.mapView addOverlay:myHazard];
            }
            
        }
        self.icingValidate = YES;
        
        
        
        
    }
    else
    {
        _icing.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        self.icingValidate = NO;
        for (int i =0; i < [self.hazardOverlays count]; i++) {
            
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"ICE"])
            {
                [self.mapView removeAnnotation:[self.hazardOverlays objectAtIndex:i]];
                [self.mapView removeOverlay:[self.hazardOverlays objectAtIndex:i]];
            }
            
            
        }
        
    }
    
}


-(void)convectiveButton:(id)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.convectiveValidate == NO) {
        if(self.genericValidate==YES)
        {
            _generic.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
            [self genericButton:sender];
        }
        _convective.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        
        for( int i=0;i< [self.hazardOverlays count];i++)
        {
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"CONVECTIVE"])
            {
                [self.mapView addAnnotation:myHazard];
                [self.mapView addOverlay:myHazard];
            }
            
        }
        self.convectiveValidate = YES;
        
        
    }
    else
    {
        _convective.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        self.convectiveValidate = NO;
        for (int i =0; i < [self.hazardOverlays count]; i++) {
            
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"CONVECTIVE"])
            {
                [self.mapView removeAnnotation:[self.hazardOverlays objectAtIndex:i]];
                [self.mapView removeOverlay:[self.hazardOverlays objectAtIndex:i]];
            }
            
            
        }
        
    }
}


-(void)ashButton:(id)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.ashValidate == NO) {
        if(self.genericValidate==YES)
        {
            _generic.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
            [self genericButton:sender];
        }
        _ash.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        
        
        for( int i=0;i< [self.hazardOverlays count];i++)
        {
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"ASH"])
            {
                [self.mapView addAnnotation:myHazard];
                [self.mapView addOverlay:myHazard];
            }
            
        }
        self.ashValidate = YES;
        
    }
    else
    {
        _ash.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        self.ashValidate = NO;
        for (int i =0; i < [self.hazardOverlays count]; i++) {
            
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"ASH"])
            {
                [self.mapView removeAnnotation:[self.hazardOverlays objectAtIndex:i]];
                [self.mapView removeOverlay:[self.hazardOverlays objectAtIndex:i]];
            }
            
            
        }
        
    }
}


-(void)ifrButton:(id)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.ifrValidate == NO) {
        if(self.genericValidate==YES)
        {
            _generic.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
            [self genericButton:sender];
        }
        _ifr.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        
        
        for( int i=0;i< [self.hazardOverlays count];i++)
        {
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"IFR"])
            {
                [self.mapView addAnnotation:myHazard];
                [self.mapView addOverlay:myHazard];
            }
            
        }
        self.ifrValidate = YES;
        
    }
    else
    {
        _ifr.tintColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        self.ifrValidate = NO;
        for (int i =0; i < [self.hazardOverlays count]; i++) {
            
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            if([myHazard.type isEqualToString:@"IFR"])
            {
                [self.mapView removeAnnotation:[self.hazardOverlays objectAtIndex:i]];
                [self.mapView removeOverlay:[self.hazardOverlays objectAtIndex:i]];
            }
            
            
        }
        
    }
}



-(void)genericButton:(id)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (self.genericValidate == NO) {
        _generic.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        _mtnObsn.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        _icing.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        _convective.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        _ifr.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        _ash.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        _turbulence.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        for( int i=0;i< [self.hazardOverlays count];i++)
        {
            Hazards * myHazard = [self.hazardOverlays objectAtIndex:i];
            
            
            [self.mapView addAnnotation:myHazard];
            [self.mapView addOverlay:myHazard];
            
            
        }
        self.genericValidate = YES;
        self.icingValidate=NO;
        self.mtnValidate=NO;
        self.turbValidate=NO;
        self.convectiveValidate=NO;
        self.ashValidate=NO;
        self.ifrValidate=NO;
        
    }
    else
    {
        _generic.tintColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:1.0];
        
        self.genericValidate = NO;
        [self.mapView removeOverlays:_hazardOverlays];
        [self.mapView removeAnnotations:_hazardOverlays];
        
    }
    
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
    if([overlay isKindOfClass:[Hazards class]]){
        MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:((Hazards *)overlay).polygon] ;
        view.lineWidth=3;
        view.strokeColor = ((Hazards *)overlay).color;
        view.fillColor = [((Hazards *)overlay).color colorWithAlphaComponent:0.25];
        return view;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHazardsBar:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
