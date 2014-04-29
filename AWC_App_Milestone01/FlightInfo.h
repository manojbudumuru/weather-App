//
//  FlightInfo.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 10/21/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWCAppDelegate.h"

//This class accepts the flight information which is required before giving, the pilot, access to the PIREP and PIREP Send Tab.

@interface FlightInfo : UIViewController


//Info Labels
@property (strong, nonatomic) IBOutlet UILabel *headerProvideInfo;
@property (strong, nonatomic) IBOutlet UILabel *headerWelcome;
@property (strong, nonatomic) IBOutlet UILabel *welcomeText;


//Input Information
@property (strong, nonatomic) IBOutlet UILabel *infoName;
@property (strong, nonatomic) IBOutlet UILabel *infoAircraftType;
@property (strong, nonatomic) IBOutlet UILabel *infoTailNumber;
@property (strong, nonatomic) IBOutlet UILabel *infoLicense;

//Show if the information is entered before
@property (strong, nonatomic) IBOutlet UILabel *existingInfo;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *aircraftType;
@property (strong, nonatomic) IBOutlet UITextField *tailNumber;
@property (strong, nonatomic) IBOutlet UITextField *license;


@property AWCAppDelegate * appDelegate;
@property NSMutableArray * info;

@property (strong, nonatomic) IBOutlet UIButton *saveData;
@property (strong, nonatomic) IBOutlet UIButton *enterData;
@property (strong, nonatomic) IBOutlet UIButton *changeData;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *cancelDataCollection;

- (void)saveData:(id)sender;
- (void)displayButtons:(id)sender;
-(void)checkData;
-(void)presentTabs;


@property (weak, nonatomic) IBOutlet UINavigationBar *header;

@end
