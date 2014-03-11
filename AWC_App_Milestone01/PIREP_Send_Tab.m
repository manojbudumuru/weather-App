//
//  AWCSecondViewController.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "PIREP_Send_Tab.h"

#define PIREP_CONFIRMATION_TAG 524

@interface PIREP_Send_Tab ()

@property NSMutableArray * flightData;
@property NSString * pirepSend;
@property NSString * pirepInit;
@property NSString * presentPirep;
@property NSString * chopLevel;
@property NSString * turbLevel;
@property NSString * mtnLevel;
@property NSString * iceLevel;
@property UIAlertView * alert;
@property NSString * filePath;
@property NSString * addData;
@property int chopPosition;
@property int turbPosition;
@property int mtnPosition;
@property int icePosition;

//To save the data on a server
@property NSString * lisenceNum;
@property NSString * timeOfReport;
@property NSString * aircraftType;
@property NSString * tailNumber;
@property NSString * skyCondition;
@property NSString * weatherCondition;
@property NSString * locationLatitude;
@property NSString * locationLongitude;
@property NSString * pilotReport;
@property NSString * pageURL;


@end

@implementation PIREP_Send_Tab

@synthesize myLoc,flightData,alert,filePath,addData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initializeData];
}

-(void)initializeData
{
    //[self setDefaults];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.flightData = self.appDelegate.flightInformation;
    
    self.presentPirep = @"";
    self.pirepSelected.textAlignment = NSTextAlignmentCenter;
    self.pirepData = [[NSMutableArray alloc]init];
    //self.pirepSelected.delegate = self;
    //[self.pirepSelected addTarget:self action:@selector(changePirep:) forControlEvents:UIControlEventTouchDown];
    
    self.alert.delegate = self;
    [self.alert setTag:0];
    
    //NSLog(@"Al T = %d",self.alert.tag);
    
    self.filePath = @"";
    self.addData = @"";
    
    self.chopPosition = -1;
    self.turbPosition = -1;
    self.mtnPosition = -1;
    self.icePosition = -1;
    
    //PIREP types initialization
    
    self.chopLevel = @"";
    self.turbLevel = @"";
    self.mtnLevel = @"";
    self.iceLevel = @"";
    
    self.pirepSelected.text = @"";
        
        //Show heading
        
        self.titleInfo.hidden = NO;
        
        //Show main categories
        
        self.chop.enabled = YES;
        self.turb.enabled = YES;
        self.mtn.enabled = YES;
        self.ice.enabled = YES;
        
        //Getting the location
        self.myLoc = [[CLLocationManager alloc]init];
        self.myLoc.delegate = self;
        self.myLoc.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.myLoc startUpdatingLocation];
    
        //NSLog(@"Lat: %f, Long: %f",self.myLoc.location.coordinate.latitude,
              //self.myLoc.location.coordinate.longitude);
        
    
    
        //Initializing the server variables' values
    self.lisenceNum = self.flightData[3];
    self.aircraftType = self.flightData[1];
    self.tailNumber = self.flightData[2];
    self.skyCondition = @"UNKNWN";
    self.weatherCondition = @"UNKNWN";
    self.pageURL = @"http://csgrad06.nwmissouri.edu/SaveDataToServer.php";
    
    
        //Target methods for Chop
        [self.chop addTarget:self action:@selector(Chop) forControlEvents:UIControlEventTouchUpInside];
        [self.lightChop addTarget:self action:@selector(lChop) forControlEvents:UIControlEventTouchUpInside];
        [self.modChop addTarget:self action:@selector(mChop) forControlEvents:UIControlEventTouchUpInside];
        [self.greaterChop addTarget:self action:@selector(gChop) forControlEvents:UIControlEventTouchUpInside];
        [self.noChop addTarget:self action:@selector(nChop) forControlEvents:UIControlEventTouchUpInside];
    
        //Target methods for Turbulence
        [self.turb addTarget:self action:@selector(Turb) forControlEvents:UIControlEventTouchUpInside];
        [self.lightTurb addTarget:self action : @selector(lTurb) forControlEvents:UIControlEventTouchUpInside];
        [self.modTurb addTarget:self action:@selector(mTurb) forControlEvents:UIControlEventTouchUpInside];
        [self.greaterTurb addTarget:self action:@selector(gTurb) forControlEvents:UIControlEventTouchUpInside];
        [self.noTurb addTarget:self action:@selector(nTurb) forControlEvents:UIControlEventTouchUpInside];
    
        //Target methods for Mtn Wave
        [self.mtn addTarget:self action:@selector(mtnWave) forControlEvents:UIControlEventTouchUpInside];
        [self.lightMtn addTarget:self action:@selector(lMtn) forControlEvents:UIControlEventTouchUpInside];
        [self.modMtn addTarget:self action:@selector(mMtn) forControlEvents:UIControlEventTouchUpInside];
        [self.greaterMtn addTarget:self action:@selector(gMtn) forControlEvents:UIControlEventTouchUpInside];
        [self.noMtn addTarget:self action:@selector(nMtn) forControlEvents:UIControlEventTouchUpInside];
    
        //Target methods for Ice
    
        [self.ice addTarget:self action:@selector(Ice) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.clear addTarget:self action:@selector(clearIce) forControlEvents:UIControlEventTouchUpInside];
        [self.rime addTarget:self action:@selector(rimeIce) forControlEvents:UIControlEventTouchUpInside];
        [self.mixed addTarget:self action:@selector(mixedIce) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.trace addTarget:self action:@selector(traceIce) forControlEvents:UIControlEventTouchUpInside];
        [self.lightIce addTarget:self action:@selector(lIce) forControlEvents:UIControlEventTouchUpInside];
        [self.modIce addTarget:self action:@selector(mIce) forControlEvents:UIControlEventTouchUpInside];
        [self.greaterIce addTarget:self action:@selector(gIce) forControlEvents:UIControlEventTouchUpInside];
        [self.noIce addTarget:self action:@selector(nIce) forControlEvents:UIControlEventTouchUpInside];
    
        [self.sendPirep addTarget:self action:@selector(sendPirep:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
        
        // Do any additional setup after loading the view, typically from a nib.
    
}

-(NSString *)updateTime
{
    //Getting system time
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss MM-dd-YYYY"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *presentTime = [dateFormatter stringFromDate:date];
    
    
    
    self.pirepInit = [NSString stringWithFormat:@"%@/TM %@/FL %@/TP %@/SK UNKN/WX UNKN/[%0.2f,%0.2f]/",
                      [self.flightData objectAtIndex:3], presentTime,
                      [self.flightData objectAtIndex:2],
                      [self.flightData objectAtIndex:1],
                      self.myLoc.location.coordinate.latitude,
                      self.myLoc.location.coordinate.longitude];
    [self setPirep];
    
    return presentTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPirep
{
    self.pirepSend = self.pirepInit;
}

-(void)setPresentPirepData
{
    if([self.pirepData count]>0)
    {
        self.presentPirep = self.pirepData[0];
        for(int i=1;i<[self.pirepData count];i++)
        {
            self.presentPirep = [self.presentPirep stringByAppendingFormat:@"/%@",self.pirepData[i]];
        }
    }
    else
        self.presentPirep = @"";
}

- (void)Chop {

//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@"/CHOP"];
    
//    if(![self.presentPirep isEqualToString:@""])
//        self.presentPirep = [self.presentPirep stringByAppendingString:@"/"];
//    
//    self.presentPirep = [self.presentPirep stringByAppendingString:@"CHOP"];
    
    if(self.chopPosition==-1)
    {
        [self.pirepData addObject:@"CHOP"];
        self.chopPosition = [self.pirepData count]-1;
    }
    else
    {
        [self.pirepData setObject:@"CHOP" atIndexedSubscript:self.chopPosition];
    }
    [self setPresentPirepData];
    
    self.pirepSelected.text = self.presentPirep;
    
    //[self.chop setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
    
    //self.chopLevel = @"/CHOP ";
    
    //self.checkChop = NO;
    
//    self.chop.enabled = NO;
//    self.turb.enabled = NO;
//    self.mtn.enabled = NO;
//    self.ice.enabled = NO;
//    
//    [self.lightChop setBackgroundImage:[UIImage imageNamed:@"CHOP_LGT.png"] forState:UIControlStateNormal];
//    [self.modChop setBackgroundImage:[UIImage imageNamed:@"CHOP_MOD.png"] forState:UIControlStateNormal];
//    [self.greaterChop setBackgroundImage:[UIImage imageNamed:@"CHOP_GRT.png"] forState:UIControlStateNormal];
//
//    self.lightChop.enabled = YES;
//    self.modChop.enabled = YES;
//    self.greaterChop.enabled = YES;
//    self.noChop.enabled = YES;
    
    //self.sendPirep.enabled = NO;
}

-(void)lChop
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" LGT"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" LGT"];
    
    if(self.chopPosition==-1)
    {
        [self.pirepData addObject:@"CHOP LGT"];
        self.chopPosition = [self.pirepData count]-1;
    }
    else
    {
        [self.pirepData setObject:@"CHOP LGT" atIndexedSubscript:self.chopPosition];
    }
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
    //[self saveToFile:@" LGT"];
    
    //[self.lightChop setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
    
//    self.lightChop.enabled = NO;
//    self.modChop.enabled = NO;
//    self.greaterChop.enabled = NO;
//    self.noChop.enabled = NO;
    
    //self.chopLevel = @"/CHOP LGT";
    
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    self.chop.enabled = YES;
//    [self.chop setBackgroundImage:[UIImage imageNamed:@"GreenBack.png"] forState:UIControlStateNormal];
    
    //self.sendPirep.enabled = YES;
}

-(void)mChop
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" MOD"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" MOD"];
    
    if(self.chopPosition==-1)
    {
        [self.pirepData addObject:@"CHOP MOD"];
        self.chopPosition = [self.pirepData count]-1;
    }
    else
    {
        [self.pirepData setObject:@"CHOP MOD" atIndexedSubscript:self.chopPosition];
    }
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
    //[self saveToFile:@" MOD"];
    
//    self.lightChop.enabled = NO;
//    self.modChop.enabled = NO;
//    self.greaterChop.enabled = NO;
//    self.noChop.enabled = NO;
//    
//    [self.modChop setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //self.chopLevel = @"/CHOP MOD";
//
//    
//    
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    self.chop.enabled = YES;
//    [self.chop setBackgroundImage:[UIImage imageNamed:@"GreenBack.png"] forState:UIControlStateNormal];
    
    //self.sendPirep.enabled = YES;
}

-(void)gChop
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" GRT"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" GRT"];
    
    if(self.chopPosition==-1)
    {
        [self.pirepData addObject:@"CHOP GRT"];
        self.chopPosition = [self.pirepData count]-1;
    }
    else
    {
        [self.pirepData setObject:@"CHOP GRT" atIndexedSubscript:self.chopPosition];
    }
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
//    self.lightChop.enabled = NO;
//    self.modChop.enabled = NO;
//    self.greaterChop.enabled = NO;
//    self.noChop.enabled = NO;
//    
//    //self.chopLevel = @"/CHOP GRT";
//
//    
//    [self.greaterChop setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    self.chop.enabled = YES;
//    [self.chop setBackgroundImage:[UIImage imageNamed:@"GreenBack.png"] forState:UIControlStateNormal];
//    
//    self.sendPirep.enabled = YES;
    //[self saveToFile:@" GRT"];
}

-(void)nChop
{
    if(self.chopPosition!=-1)
    {
        if(self.turbPosition>self.chopPosition)
            self.turbPosition--;
        if(self.mtnPosition>self.chopPosition)
            self.mtnPosition--;
        if(self.icePosition>self.chopPosition)
            self.icePosition--;
        
        [self.pirepData removeObjectAtIndex:self.chopPosition];
        self.chopPosition = -1;
        
        [self setPresentPirepData];
        self.pirepSelected.text = self.presentPirep;
        
//        self.lightChop.enabled = NO;
//        self.modChop.enabled = NO;
//        self.greaterChop.enabled = NO;
//        self.noChop.enabled = NO;
//        
//        //if(self.checkTurb)
//        self.turb.enabled = YES;
//        //if(self.checkMtn)
//        self.mtn.enabled = YES;
//        //if(self.checkIce)
//        self.ice.enabled = YES;
//        self.chop.enabled = YES;
//        [self.chop setBackgroundImage:[UIImage imageNamed:@"GreenBack.png"] forState:UIControlStateNormal];
//        
//        self.sendPirep.enabled = YES;
    }
}

- (void)Turb
{
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@"/TURB"];
//    
//    if(![self.presentPirep isEqualToString:@""])
//        self.presentPirep = [self.presentPirep stringByAppendingString:@"/"];
//    
//    self.presentPirep = [self.presentPirep stringByAppendingString:@"TURB"];
    if(self.turbPosition==-1)
    {
        [self.pirepData addObject:@"TURB"];
        self.turbPosition = [self.pirepData count]-1;
    }
    else
    {
        [self.pirepData setObject:@"TURB" atIndexedSubscript:self.turbPosition];
    }
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
    //self.presentPirep = @"Turbulence ";
    
    //[self.turb setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
    
    //self.checkTurb = NO;
    
//    self.turb.enabled = NO;
//    self.chop.enabled = NO;
//    self.mtn.enabled = NO;
//    self.ice.enabled = NO;
//    
//    [self.lightTurb setBackgroundImage:[UIImage imageNamed:@"TURB_LGT.png"] forState:UIControlStateNormal];
//    [self.modTurb setBackgroundImage:[UIImage imageNamed:@"TURB_MOD.png"] forState:UIControlStateNormal];
//    [self.greaterTurb setBackgroundImage:[UIImage imageNamed:@"TURB_GRT.png"] forState:UIControlStateNormal];
//    
//    self.lightTurb.enabled = YES;
//    self.modTurb.enabled = YES;
//    self.greaterTurb.enabled = YES;
//    self.noTurb.enabled = YES;
//    
//    self.sendPirep.enabled = NO;
}

- (void) lTurb
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" LGT"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" LGT"];
    
    if(self.turbPosition==-1)
    {
        [self.pirepData addObject:@"TURB LGT"];
        self.turbPosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:@"TURB LGT" atIndexedSubscript:self.turbPosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
    //[self saveToFile:@" LGT"];
    
//    [self.lightTurb setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    self.lightTurb.enabled = NO;
//    self.modTurb.enabled = NO;
//    self.greaterTurb.enabled = NO;
//    self.noTurb.enabled = NO;
//    
//    //self.turbLevel = @"/TURB LGT";
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    
//    self.turb.enabled = YES;
//    [self.turb setBackgroundImage:[UIImage imageNamed:@"YelloBack.png"] forState:UIControlStateNormal];
//    
//    self.sendPirep.enabled = YES;
}

-(void) mTurb
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" MOD"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" MOD"];
    
    if(self.turbPosition==-1)
    {
        [self.pirepData addObject:@"TURB MOD"];
        self.turbPosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:@"TURB MOD" atIndexedSubscript:self.turbPosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
    //[self saveToFile:@" MOD"];
    
//    [self.modTurb setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    self.lightTurb.enabled = NO;
//    self.modTurb.enabled = NO;
//    self.greaterTurb.enabled = NO;
//    self.noTurb.enabled = NO;
//    
//    //self.turbLevel = @"/TURB MOD";
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    self.turb.enabled = YES;
//    [self.turb setBackgroundImage:[UIImage imageNamed:@"YelloBack.png"] forState:UIControlStateNormal];
//    
//    self.sendPirep.enabled = YES;
}

- (void) gTurb
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" GRT"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" GRT"];
    
    if(self.turbPosition==-1)
    {
        [self.pirepData addObject:@"TURB GRT"];
        self.turbPosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:@"TURB GRT" atIndexedSubscript:self.turbPosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
    //[self saveToFile:@" GRT"];
    
//    [self.greaterTurb setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    self.lightTurb.enabled = NO;
//    self.modTurb.enabled = NO;
//    self.greaterTurb.enabled = NO;
//    self.noTurb.enabled = NO;
//    
//    //self.turbLevel = @"/TURB GRT";
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    self.turb.enabled = YES;
//    [self.turb setBackgroundImage:[UIImage imageNamed:@"YelloBack.png"] forState:UIControlStateNormal];
//    
//    self.sendPirep.enabled = YES;
}

-(void)nTurb
{
    if(self.turbPosition!=-1)
    {
        if(self.chopPosition>self.turbPosition)
            self.chopPosition--;
        if(self.mtnPosition>self.turbPosition)
            self.mtnPosition--;
        if(self.icePosition>self.turbPosition)
            self.icePosition--;
        
        [self.pirepData removeObjectAtIndex:self.turbPosition];
        self.turbPosition = -1;

        [self setPresentPirepData];
        self.pirepSelected.text = self.presentPirep;
        
//        self.lightTurb.enabled = NO;
//        self.modTurb.enabled = NO;
//        self.greaterTurb.enabled = NO;
//        self.noTurb.enabled = NO;
//        
//        //if(self.checkChop)
//        self.chop.enabled = YES;
//        //if(self.checkMtn)
//        self.mtn.enabled = YES;
//        //if(self.checkIce)
//        self.ice.enabled = YES;
//        self.turb.enabled = YES;
//        [self.turb setBackgroundImage:[UIImage imageNamed:@"YelloBack.png"] forState:UIControlStateNormal];
//        
//        self.sendPirep.enabled = YES;
    }
}


-(void)mtnWave
{
//    if(![self.presentPirep isEqualToString:@""])
//        self.presentPirep = [self.presentPirep stringByAppendingString:@"/"];
//    
//    self.presentPirep = [self.presentPirep stringByAppendingString:@"MTN WAVE"];
    if(self.mtnPosition==-1)
    {
        [self.pirepData addObject:@"MTN WAVE"];
        self.mtnPosition = [self.pirepData count]-1;
    }
    else
    {
        [self.pirepData setObject:@"MTN WAVE" atIndexedSubscript:self.mtnPosition];
    }
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
//    [self.mtn setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //self.checkMtn = NO;
//    
//    self.mtn.enabled = NO;
//    self.chop.enabled = NO;
//    self.turb.enabled = NO;
//    self.ice.enabled = NO;
//    
//    [self.lightMtn setBackgroundImage:[UIImage imageNamed:@"MTNWV_LGT.png"] forState:UIControlStateNormal];
//    [self.modMtn setBackgroundImage:[UIImage imageNamed:@"MTNWV_MOD.png"] forState:UIControlStateNormal];
//    [self.greaterMtn setBackgroundImage:[UIImage imageNamed:@"MTNWV_GRT.png"] forState:UIControlStateNormal];
//    
//    self.lightMtn.enabled = YES;
//    self.modMtn.enabled = YES;
//    self.greaterMtn.enabled = YES;
//    self.noMtn.enabled = YES;
//    
//    self.sendPirep.enabled = NO;
}

-(void)lMtn
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" LGT"];
    
    if(self.mtnPosition==-1)
    {
        [self.pirepData addObject:@"MTN WAVE LGT"];
        self.mtnPosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:@"MTN WAVE LGT" atIndexedSubscript:self.mtnPosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
//    [self.lightMtn setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    self.lightMtn.enabled = NO;
//    self.modMtn.enabled = NO;
//    self.greaterMtn.enabled = NO;
//    self.noMtn.enabled = NO;
//    
//    //self.mtnLevel = @"/MTN WAVE LGT";
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    self.mtn.enabled = YES;
//    [self.mtn setBackgroundImage:[UIImage imageNamed:@"OrangeBack.png"] forState:UIControlStateNormal];
//    
//    self.sendPirep.enabled = YES;
}

-(void)mMtn
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" MOD"];
    
    if(self.mtnPosition==-1)
    {
        [self.pirepData addObject:@"MTN WAVE MOD"];
        self.mtnPosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:@"MTN WAVE MOD" atIndexedSubscript:self.mtnPosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
//    [self.modMtn setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    self.lightMtn.enabled = NO;
//    self.modMtn.enabled = NO;
//    self.greaterMtn.enabled = NO;
//    self.noMtn.enabled = NO;
//    
//    //self.mtnLevel = @"/MTN WAVE MOD";
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    self.mtn.enabled = YES;
//    [self.mtn setBackgroundImage:[UIImage imageNamed:@"OrangeBack.png"] forState:UIControlStateNormal];
//
//    self.sendPirep.enabled = YES;
}

-(void)gMtn
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" GRT"];
    
    if(self.mtnPosition==-1)
    {
        [self.pirepData addObject:@"MTN WAVE GRT"];
        self.mtnPosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:@"MTN WAVE GRT" atIndexedSubscript:self.mtnPosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
//    [self.greaterMtn setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    self.lightMtn.enabled = NO;
//    self.modMtn.enabled = NO;
//    self.greaterMtn.enabled = NO;
//    self.noMtn.enabled = NO;
//    
//    //self.mtnLevel = @"/MTN WAVE GRT";
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkIce)
//        self.ice.enabled = YES;
//    self.mtn.enabled = YES;
//    [self.mtn setBackgroundImage:[UIImage imageNamed:@"OrangeBack.png"] forState:UIControlStateNormal];
//    
//    self.sendPirep.enabled = YES;
}

-(void)nMtn
{
    if(self.mtnPosition!=-1)
    {
        if(self.chopPosition>self.mtnPosition)
            self.chopPosition--;
        if(self.turbPosition>self.mtnPosition)
            self.turbPosition--;
        if(self.icePosition>self.mtnPosition)
            self.icePosition--;
        
        [self.pirepData removeObjectAtIndex:self.mtnPosition];
        self.mtnPosition = -1;
        
        [self setPresentPirepData];
        self.pirepSelected.text = self.presentPirep;
        
//        self.lightMtn.enabled = NO;
//        self.modMtn.enabled = NO;
//        self.greaterMtn.enabled = NO;
//        self.noMtn.enabled = NO;
//        
//        //if(self.checkChop)
//        self.chop.enabled = YES;
//        //if(self.checkTurb)
//        self.turb.enabled = YES;
//        //if(self.checkIce)
//        self.ice.enabled = YES;
//        self.mtn.enabled = YES;
//        [self.mtn setBackgroundImage:[UIImage imageNamed:@"OrangeBack.png"] forState:UIControlStateNormal];
//        
//        self.sendPirep.enabled = YES;
    }
}




- (void)Ice
{
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@"/ICE"];
//    
//    if(![self.presentPirep isEqualToString:@""])
//        self.presentPirep = [self.presentPirep stringByAppendingString:@"/"];
//    
//    self.presentPirep = [self.presentPirep stringByAppendingString:@"ICE"];
    if(self.icePosition==-1)
    {
        [self.pirepData addObject:@"ICE"];
        self.icePosition = [self.pirepData count]-1;
    }
    else
    {
        [self.pirepData setObject:@"ICE" atIndexedSubscript:self.icePosition];
    }
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;

    //self.presentPirep = @"Ice ";
    
//    [self.ice setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //self.checkIce = NO;
//    
//    self.ice.enabled = NO;
//    self.chop.enabled = NO;
//    self.turb.enabled = NO;
//    self.mtn.enabled = NO;
//    
//    [self.clear setBackgroundImage:[UIImage imageNamed:@"ICING_CLEAR.png"] forState:UIControlStateNormal];
//    [self.rime setBackgroundImage:[UIImage imageNamed:@"ICING_RIME.png"] forState:UIControlStateNormal];
//    [self.mixed setBackgroundImage:[UIImage imageNamed:@"ICING_MIXED.png"] forState:UIControlStateNormal];
//    
//    self.clear.enabled = YES;
//    self.rime.enabled = YES;
//    self.mixed.enabled = YES;
//    self.noIce.enabled = YES;
//    //    self.trace.enabled = NO;
//    //    self.lightIce.enabled = NO;
//    //    self.modIce.enabled = NO;
//    //    self.greaterIce.enabled = NO;
//    
//    self.sendPirep.enabled = NO;
}

- (void)clearIce
{
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" CLEAR"];
//    
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" CLEAR"];

    self.iceLevel = @"ICE CLEAR";

    if(self.icePosition==-1)
    {
        [self.pirepData addObject:@"ICE CLEAR"];
        self.icePosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:self.iceLevel atIndexedSubscript:self.icePosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;

//
//    [self.clear setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    
//    
//    self.clear.enabled = NO;
//    self.rime.enabled = NO;
//    self.mixed.enabled = NO;
//    self.trace.enabled = YES;
//    self.lightIce.enabled = YES;
//    self.modIce.enabled = YES;
//    self.greaterIce.enabled = YES;
//    
//    [self.trace setBackgroundImage:[UIImage imageNamed:@"ICING_TRACE.png"] forState:UIControlStateNormal];
//    [self.lightIce setBackgroundImage:[UIImage imageNamed:@"ICING_LGT.png"] forState:UIControlStateNormal];
//    [self.modIce setBackgroundImage:[UIImage imageNamed:@"ICING_MOD.png"] forState:UIControlStateNormal];
//    [self.greaterIce setBackgroundImage:[UIImage imageNamed:@"ICING_GRT.png"] forState:UIControlStateNormal];
    
    
    
}

- (void)rimeIce
{
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" RIME"];
//    
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" RIME"];
    self.iceLevel = @"ICE RIME";
    
    if(self.icePosition==-1)
    {
        [self.pirepData addObject:@"ICE RIME"];
        self.icePosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:self.iceLevel atIndexedSubscript:self.icePosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
//    [self.rime setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //self.iceLevel = @"ICE RIME";
//    
//    self.clear.enabled = NO;
//    self.rime.enabled = NO;
//    self.mixed.enabled = NO;
//    self.trace.enabled = YES;
//    self.lightIce.enabled = YES;
//    self.modIce.enabled = YES;
//    self.greaterIce.enabled = YES;
//    
//    [self.trace setBackgroundImage:[UIImage imageNamed:@"ICING_TRACE.png"] forState:UIControlStateNormal];
//    [self.lightIce setBackgroundImage:[UIImage imageNamed:@"ICING_LGT.png"] forState:UIControlStateNormal];
//    [self.modIce setBackgroundImage:[UIImage imageNamed:@"ICING_MOD.png"] forState:UIControlStateNormal];
//    [self.greaterIce setBackgroundImage:[UIImage imageNamed:@"ICING_GRT.png"] forState:UIControlStateNormal];
    
    
}

- (void)mixedIce
{
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" MIXED"];
//    
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" MIXED"];
    self.iceLevel = @"ICE MIXED";

    if(self.icePosition==-1)
    {
        [self.pirepData addObject:@"ICE MIXED"];
        self.icePosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:self.iceLevel atIndexedSubscript:self.icePosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
//    [self.mixed setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //self.iceLevel = @"ICE MIXED";
//    
//    self.clear.enabled = NO;
//    self.rime.enabled = NO;
//    self.mixed.enabled = NO;
//    self.trace.enabled = YES;
//    self.lightIce.enabled = YES;
//    self.modIce.enabled = YES;
//    self.greaterIce.enabled = YES;
//    
//    [self.trace setBackgroundImage:[UIImage imageNamed:@"ICING_TRACE.png"] forState:UIControlStateNormal];
//    [self.lightIce setBackgroundImage:[UIImage imageNamed:@"ICING_LGT.png"] forState:UIControlStateNormal];
//    [self.modIce setBackgroundImage:[UIImage imageNamed:@"ICING_MOD.png"] forState:UIControlStateNormal];
//    [self.greaterIce setBackgroundImage:[UIImage imageNamed:@"ICING_GRT.png"] forState:UIControlStateNormal];
    
    
}

- (void)traceIce
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" TRACE"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" TRACE"];
//    self.iceLevel = @"ICE CLEAR";
    
    NSString * iceInfo = nil;
    
    if(![self.iceLevel isEqualToString:@""])
        iceInfo = [NSString stringWithFormat:@"%@ TRACE",self.iceLevel];
    else
        iceInfo = @"ICE TRACE";

    if(self.icePosition==-1)
    {
        [self.pirepData addObject:iceInfo];
        self.icePosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:iceInfo atIndexedSubscript:self.icePosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;

    //[self saveToFile:@" TRACE"];
    
//    [self.trace setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
////    self.iceLevel = [self.iceLevel stringByAppendingString:@" TRACE"];
//    
//    self.clear.enabled = NO;
//    self.rime.enabled = NO;
//    self.mixed.enabled = NO;
//    self.trace.enabled = NO;
//    self.lightIce.enabled = NO;
//    self.modIce.enabled = NO;
//    self.greaterIce.enabled = NO;
//    self.noIce.enabled = NO;
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    self.ice.enabled = YES;
//    [self.ice setBackgroundImage:[UIImage imageNamed:@"RedBack.png"] forState:UIControlStateNormal];
//
//    self.sendPirep.enabled = YES;
}

- (void)lIce
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" LGT"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" LGT"];
    
    NSString * iceInfo = nil;
    
    if(![self.iceLevel isEqualToString:@""])
        iceInfo = [NSString stringWithFormat:@"%@ LGT",self.iceLevel];
    else
        iceInfo = @"ICE LGT";
    
    if(self.icePosition==-1)
    {
        [self.pirepData addObject:iceInfo];
        self.icePosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:iceInfo atIndexedSubscript:self.icePosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;

    //[self saveToFile:@" LGT"];
    
//    [self.lightIce setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //self.iceLevel = [self.iceLevel stringByAppendingString:@" LGT"];
//    
//    self.clear.enabled = NO;
//    self.rime.enabled = NO;
//    self.mixed.enabled = NO;
//    self.trace.enabled = NO;
//    self.lightIce.enabled = NO;
//    self.modIce.enabled = NO;
//    self.greaterIce.enabled = NO;
//    self.noIce.enabled = NO;
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    
//    self.ice.enabled = YES;
//    [self.ice setBackgroundImage:[UIImage imageNamed:@"RedBack.png"] forState:UIControlStateNormal];
//    
//    self.sendPirep.enabled = YES;
}

- (void)mIce
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" MOD"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" MOD"];
    
    NSString * iceInfo = nil;
    
    if(![self.iceLevel isEqualToString:@""])
        iceInfo = [NSString stringWithFormat:@"%@ MOD",self.iceLevel];
    else
        iceInfo = @"ICE MOD";
    
    if(self.icePosition==-1)
    {
        [self.pirepData addObject:iceInfo];
        self.icePosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:iceInfo atIndexedSubscript:self.icePosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
    //[self saveToFile:@" MOD"];
    
//    [self.modIce setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //self.iceLevel = [self.iceLevel stringByAppendingString:@" MOD"];
//    
//    self.clear.enabled = NO;
//    self.rime.enabled = NO;
//    self.mixed.enabled = NO;
//    self.trace.enabled = NO;
//    self.lightIce.enabled = NO;
//    self.modIce.enabled = NO;
//    self.greaterIce.enabled = NO;
//    self.noIce.enabled = NO;
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    self.ice.enabled = YES;
//    [self.ice setBackgroundImage:[UIImage imageNamed:@"RedBack.png"] forState:UIControlStateNormal];
//
//    self.sendPirep.enabled = YES;
}

-(void)gIce
{
//    self.presentPirep = [self.presentPirep stringByAppendingString:@" GRT"];
//    self.pirepSend = [self.pirepSend stringByAppendingFormat:@" GRT"];
    
    NSString * iceInfo = nil;
    
    if(![self.iceLevel isEqualToString:@""])
        iceInfo = [NSString stringWithFormat:@"%@ GRT",self.iceLevel];
    else
        iceInfo = @"ICE GRT";
    
    if(self.icePosition==-1)
    {
        [self.pirepData addObject:iceInfo];
        self.icePosition = [self.pirepData count]-1;
    }
    else
        [self.pirepData setObject:iceInfo atIndexedSubscript:self.icePosition];
    [self setPresentPirepData];
    self.pirepSelected.text = self.presentPirep;
    
    //[self saveToFile:@" GRT"];
    
//    [self.greaterIce setBackgroundImage:[UIImage imageNamed:@"SHButton.png"] forState:UIControlStateNormal];
//    
//    //self.iceLevel = [self.iceLevel stringByAppendingString:@" GRT"];
//    
//    self.clear.enabled = NO;
//    self.rime.enabled = NO;
//    self.mixed.enabled = NO;
//    self.trace.enabled = NO;
//    self.lightIce.enabled = NO;
//    self.modIce.enabled = NO;
//    self.greaterIce.enabled = NO;
//    self.noIce.enabled = NO;
//    
//    //if(self.checkChop)
//        self.chop.enabled = YES;
//    //if(self.checkTurb)
//        self.turb.enabled = YES;
//    //if(self.checkMtn)
//        self.mtn.enabled = YES;
//    self.ice.enabled = YES;
//    [self.ice setBackgroundImage:[UIImage imageNamed:@"RedBack.png"] forState:UIControlStateNormal];
//    
//    self.sendPirep.enabled = YES;
}

-(void)nIce
{
    if(self.icePosition!=-1)
    {
        if(self.chopPosition>self.icePosition)
            self.chopPosition--;
        if(self.turbPosition>self.icePosition)
            self.turbPosition--;
        if(self.mtnPosition>self.icePosition)
            self.mtnPosition--;
        
        [self.pirepData removeObjectAtIndex:self.icePosition];
        self.icePosition = -1;
        self.iceLevel = @"";
        
        [self setPresentPirepData];
        self.pirepSelected.text = self.presentPirep;
        
//        self.clear.enabled = NO;
//        self.rime.enabled = NO;
//        self.mixed.enabled = NO;
//        self.trace.enabled = NO;
//        self.lightIce.enabled = NO;
//        self.modIce.enabled = NO;
//        self.greaterIce.enabled = NO;
//        self.noIce.enabled = NO;
//        
//        //if(self.checkChop)
//        self.chop.enabled = YES;
//        //if(self.checkTurb)
//        self.turb.enabled = YES;
//        //if(self.checkMtn)
//        self.mtn.enabled = YES;
//        self.ice.enabled = YES;
//        [self.ice setBackgroundImage:[UIImage imageNamed:@"RedBack.png"] forState:UIControlStateNormal];
//        [self.clear setBackgroundImage:[UIImage imageNamed:@"ICING_CLEAR.png"] forState:UIControlStateNormal];
//        [self.rime setBackgroundImage:[UIImage imageNamed:@"ICING_RIME.png"] forState:UIControlStateNormal];
//        [self.mixed setBackgroundImage:[UIImage imageNamed:@"ICING_MIXED.png"] forState:UIControlStateNormal];
//        [self.trace setBackgroundImage:[UIImage imageNamed:@"ICING_TRACE.png"] forState:UIControlStateNormal];
//        [self.lightIce setBackgroundImage:[UIImage imageNamed:@"ICING_LGT.png"] forState:UIControlStateNormal];
//        [self.modIce setBackgroundImage:[UIImage imageNamed:@"ICING_MOD.png"] forState:UIControlStateNormal];
//        [self.greaterIce setBackgroundImage:[UIImage imageNamed:@"ICING_GRT.png"] forState:UIControlStateNormal];
//        
//        self.sendPirep.enabled = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)saveToFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:@"AWC_Data.txt"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil] ;
    
    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    //self.pirepSend = [self.pirepSend stringByAppendingString:level];
    
    if([str isEqualToString:@"(null)"] || [str isEqualToString:@""])
    {
        str = @"";
    }
    
//    self.timeOfReport = [self updateTime];
//    
//    self.pirepSend = [self.pirepInit stringByAppendingString:self.presentPirep];
//    
    addData = [NSString stringWithFormat:@"%@",str];
    
    
    
    
    alert = [[UIAlertView alloc]initWithTitle:@"Send PIREP?" message:self.presentPirep delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alert setTag:PIREP_CONFIRMATION_TAG];
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int tag = alertView.tag;
    
    //NSLog(@"Tag = %d",tag);
    if(tag == PIREP_CONFIRMATION_TAG)
    {
        if(buttonIndex == 0)
        {
            self.timeOfReport = [self updateTime];
            self.pirepSend = [self.pirepInit stringByAppendingString:self.presentPirep];
            self.locationLatitude = [NSString stringWithFormat:@"%.4f",self.myLoc.location.coordinate.latitude];
            self.locationLongitude =[NSString stringWithFormat:@"%.4f",self.myLoc.location.coordinate.longitude];
            
            addData = [NSString stringWithFormat:@"%@%@\n",addData,self.pirepSend];
            [addData writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
            
            
            self.pilotReport = self.presentPirep;
            NSMutableString * sendURL = [NSMutableString stringWithString:self.pageURL];
            [sendURL appendFormat:@"?LicenseNum=%@",self.lisenceNum];
            [sendURL appendFormat:@"&TimeOfReport=%@",self.timeOfReport];
            [sendURL appendFormat:@"&AircraftType=%@",self.aircraftType];
            [sendURL appendFormat:@"&TailNumber=%@",self.tailNumber];
            [sendURL appendFormat:@"&SkyCondition=%@",self.skyCondition];
            [sendURL appendFormat:@"&WeatherCondition=%@",self.weatherCondition];
            [sendURL appendFormat:@"&LocationLatitude=%@",self.locationLatitude];
            [sendURL appendFormat:@"&LocationLongitude=%@",self.locationLongitude];
            [sendURL appendFormat:@"&PilotReport=%@",self.pilotReport];
            [sendURL setString:[sendURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:sendURL]];
            //NSURLConnection * connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
            
            NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString * reply = [[NSString alloc]initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"Reply: %@",reply);
            
            UIAlertView * sentAlert = [[UIAlertView alloc]initWithTitle:@"PIREP Sent" message:self.presentPirep delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [sentAlert show];
            [self performSelector:@selector(remAlert:) withObject:sentAlert afterDelay:2];
            
        }
        if(buttonIndex == 1)
        {
            UIAlertView * canclAlert = [[UIAlertView alloc]initWithTitle:@"PIREP Cancelled" message:@"PIREP Not Sent" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [canclAlert show];
            [self performSelector:@selector(remAlert:) withObject:canclAlert afterDelay:2];
        }
        [self resetButtons];
    }
}

-(void)resetButtons
{

        self.presentPirep = @"";
        self.pirepSelected.text = @"";
        
        self.pirepData = [[NSMutableArray alloc]init];
        self.chopPosition = -1;
        self.turbPosition = -1;
        self.mtnPosition = -1;
        self.icePosition = -1;
        self.iceLevel = @"";
        
        NSLog(@"PIREP:\n%@",addData);
        
        [self setPirep];
        
        //Set button backgrounds to actual color
    [self setDefaults];
    
        [self initializeData];
    
}

//Set button backgrounds to actual color
-(void)setDefaults
{
    [self.chop setBackgroundImage:[UIImage imageNamed:@"CHOP.png"] forState:UIControlStateNormal];
    [self.lightChop setBackgroundImage:[UIImage imageNamed:@"CHOP_LGT.png"] forState:UIControlStateNormal];
    [self.modChop setBackgroundImage:[UIImage imageNamed:@"CHOP_MOD.png"] forState:UIControlStateNormal];
    [self.greaterChop setBackgroundImage:[UIImage imageNamed:@"CHOP_GRT.png"] forState:UIControlStateNormal];
    
    [self.turb setBackgroundImage:[UIImage imageNamed:@"TURB.png"] forState:UIControlStateNormal];
    [self.lightTurb setBackgroundImage:[UIImage imageNamed:@"TURB_LGT.png"] forState:UIControlStateNormal];
    [self.modTurb setBackgroundImage:[UIImage imageNamed:@"TURB_MOD.png"] forState:UIControlStateNormal];
    [self.greaterTurb setBackgroundImage:[UIImage imageNamed:@"TURB_GRT.png"] forState:UIControlStateNormal];
    
    [self.mtn setBackgroundImage:[UIImage imageNamed:@"MTNWV.png"] forState:UIControlStateNormal];
    [self.lightMtn setBackgroundImage:[UIImage imageNamed:@"MTNWV_LGT.png"] forState:UIControlStateNormal];
    [self.modMtn setBackgroundImage:[UIImage imageNamed:@"MTNWV_MOD.png"] forState:UIControlStateNormal];
    [self.greaterMtn setBackgroundImage:[UIImage imageNamed:@"MTNWV_GRT.png"] forState:UIControlStateNormal];
    
    [self.ice setBackgroundImage:[UIImage imageNamed:@"ICING.png"] forState:UIControlStateNormal];
    [self.clear setBackgroundImage:[UIImage imageNamed:@"ICING_CLEAR.png"] forState:UIControlStateNormal];
    [self.rime setBackgroundImage:[UIImage imageNamed:@"ICING_RIME.png"] forState:UIControlStateNormal];
    [self.mixed setBackgroundImage:[UIImage imageNamed:@"ICING_MIXED.png"] forState:UIControlStateNormal];
    [self.trace setBackgroundImage:[UIImage imageNamed:@"ICING_TRACE.png"] forState:UIControlStateNormal];
    [self.lightIce setBackgroundImage:[UIImage imageNamed:@"ICING_LGT.png"] forState:UIControlStateNormal];
    [self.modIce setBackgroundImage:[UIImage imageNamed:@"ICING_MOD.png"] forState:UIControlStateNormal];
    [self.greaterIce setBackgroundImage:[UIImage imageNamed:@"ICING_GRT.png"] forState:UIControlStateNormal];
}

-(void)remAlert:(UIAlertView *)alertV
{
    [alertV dismissWithClickedButtonIndex:-1 animated:YES];
}

- (void)viewDidUnload {
    [self setPirepSelected:nil];
    [self setPirepSelected:nil];
    [self setMtn:nil];
    [self setLightMtn:nil];
    [self setModMtn:nil];
    [self setGreaterMtn:nil];
    [super viewDidUnload];
}

- (void)sendPirep:(id)sender {
    
    self.chop.enabled = YES;
    self.turb.enabled = YES;
    self.mtn.enabled = YES;
    self.ice.enabled = YES;
    
    self.chopPosition = YES;
    self.turbPosition = YES;
    self.mtnPosition = YES;
    self.icePosition = YES;
    
    //NSLog(@"Present: %@\nSelected: %@",self.presentPirep,self.pirepSelected.text);
    
    if(![self.pirepSelected.text isEqualToString:@""])
    {
        self.presentPirep = self.pirepSelected.text;
        [self saveToFile];
    }
    else
    {
        UIAlertView * alertEmptyPIREP = [[UIAlertView alloc]initWithTitle:@"NO PIREP" message:@"Please enter a PIREP" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertEmptyPIREP setTag:2];
        [alertEmptyPIREP show];
        [self resetButtons];
    }
}

//-(void)changePirep:(id)sender
//{
//    self.presentPirep = self.pirepSelected.text;
//}
@end
