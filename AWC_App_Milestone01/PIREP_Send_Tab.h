//
//  AWCSecondViewController.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "FlightInfo.h"
#import "AWCAppDelegate.h"

@interface PIREP_Send_Tab : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

// Display the title for Pirep Send
@property (strong, nonatomic) IBOutlet UILabel *titleInfo;

// Buttons for CHOP
@property (strong, nonatomic) IBOutlet UIButton *chop;
@property (strong, nonatomic) IBOutlet UIButton *lightChop;
@property (strong, nonatomic) IBOutlet UIButton *modChop;
@property (strong, nonatomic) IBOutlet UIButton *greaterChop;
@property (weak, nonatomic) IBOutlet UIButton *noChop;


// Buttons for TURB
@property (strong, nonatomic) IBOutlet UIButton *turb;
@property (strong, nonatomic) IBOutlet UIButton *lightTurb;
@property (strong, nonatomic) IBOutlet UIButton *modTurb;
@property (strong, nonatomic) IBOutlet UIButton *greaterTurb;
@property (weak, nonatomic) IBOutlet UIButton *noTurb;

// Buttons for MTN WAVE
@property (strong, nonatomic) IBOutlet UIButton *mtn;
@property (strong, nonatomic) IBOutlet UIButton *lightMtn;
@property (strong, nonatomic) IBOutlet UIButton *modMtn;
@property (strong, nonatomic) IBOutlet UIButton *greaterMtn;
@property (weak, nonatomic) IBOutlet UIButton *noMtn;


// Buttons for ICE
@property (strong, nonatomic) IBOutlet UIButton *ice;
@property (strong, nonatomic) IBOutlet UIButton *clear;
@property (strong, nonatomic) IBOutlet UIButton *rime;
@property (strong, nonatomic) IBOutlet UIButton *mixed;
@property (strong, nonatomic) IBOutlet UIButton *trace;
@property (strong, nonatomic) IBOutlet UIButton *lightIce;
@property (strong, nonatomic) IBOutlet UIButton *modIce;
@property (strong, nonatomic) IBOutlet UIButton *greaterIce;
@property (weak, nonatomic) IBOutlet UIButton *noIce;

// Properties to send data to the ground station
@property (strong, nonatomic) IBOutlet UILabel *pirepSelected;
@property NSMutableArray * pirepData;
//- (IBAction)sendPirep:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendPirep;
-(void)saveToFile;


// Property to get the location
@property (nonatomic,strong) CLLocationManager * myLoc;
@property AWCAppDelegate * appDelegate;





@end
