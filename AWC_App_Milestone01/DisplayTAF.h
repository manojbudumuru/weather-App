//
//  DisplayTAF.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAF.h"

@interface DisplayTAF : UITableViewController

@property TAF * taf;
- (id)initWithStyle:(UITableViewStyle)style taf:(TAF *)tafObj;

@end
