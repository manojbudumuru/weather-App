//
//  ControlPanelManager.m
//  GA Weather
//
//  Created by Syed Mazhar Hussani on 3/2/15.
//  Copyright (c) 2015 Satish Kumar Baswapuram. All rights reserved.
//

#import "ControlPanelManager.h"

@implementation ControlPanelManager

@synthesize stopwatch;
@synthesize isFlightOn;
@synthesize isTurbOn;

+(id)sharedManager{
    static ControlPanelManager *controlPanelManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controlPanelManager = [[self alloc] init];
    });
    return controlPanelManager;
}

-(id)init{
    if (self = [super init]) {
        stopwatch = @"00:00:00.000";
        isFlightOn = NO;
        isTurbOn = NO;
    }
    return self;
}

- (void)updateTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and set it to the label
    stopwatch = [dateFormatter stringFromDate:timerDate];
    
}

-(void)startTimer{
    self.stopWatchTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(NSString*)stopWatchCall{
    return stopwatch;
}


- (void)dealloc {
    // Should never be called, but just here for clarity really.
}



@end
