//
//  TimeGroupsVC.h
//  NWMSU_AWC_App
//
//  Created by Satish Kumar Baswapuram on 4/28/14.
//  Copyright (c) 2014 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeGroupDelegate <NSObject>

//Delegate methods to handle when a time group is selected or deselected.
@required
-(void)selectedTimeGroup:(NSString *)timeGroup;
@required
-(void)deselectedTimeGroup:(NSString *)timeGroup;

@end

@interface TimeGroupsVC : UITableViewController

@property NSMutableArray * timeGroups;
@property id<TimeGroupDelegate> delegate;

@end
