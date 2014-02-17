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
    
    _myHazardsParser = [[HazardsParser alloc]init];
    
    self.hazardOverlays = [_myHazardsParser GetHazards];
    
    _mapView.delegate = self;
    
    
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
    
	// Do any additional setup after loading the view.
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
