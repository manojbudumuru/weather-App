//
//  ControlPanelManager.h
//  GA Weather
//
//  Created by Syed Mazhar Hussani on 3/2/15.
//  Copyright (c) 2015 Satish Kumar Baswapuram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlPanelManager : NSObject{
    NSString *stopwatch;
    bool isFlightOn;
    bool isTurbOn;
}

@property (nonatomic, retain) NSString *stopwatch;
@property bool isFlightOn;
@property bool isTurbOn;
@property (strong, nonatomic) NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
@property (strong, nonatomic) NSDate *startDate; // Stores the date of the click on the start button
- (void)updateTimer;
-(void)startTimer;
-(NSString*)stopWatchCall;
+ (id)sharedManager;

@end
