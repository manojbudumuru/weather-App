//
//  DisplayPIREP.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 10/19/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pirep.h"
#import "UserPirep.h"

//This class is used to display the information related to each Pirep object

@interface DisplayPIREP : UITableViewController

@property Pirep * pirep;
@property UserPirep * userPirep;
-(id)initWithStyle:(UITableViewStyle)style pirep:(Pirep *)pirepObj userPirep:(UserPirep *)userPirepObj;

@end
