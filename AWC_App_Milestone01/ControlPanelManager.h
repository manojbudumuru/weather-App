//
//  ControlPanelManager.h
//  GA Weather
//
//  Created by Syed Mazhar Hussani on 3/2/15.
//  Copyright (c) 2015 Satish Kumar Baswapuram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <Foundation/NSString.h>
#import <CoreLocation/CoreLocation.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface ControlPanelManager : NSObject<CLLocationManagerDelegate>{
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
//-(NSString*)stopWatchCall;
+ (id)sharedManager;
@property NSMutableDictionary *dictionary;
@property NSMutableArray *array;
@property NSData *jsonData;
@property CMMotionManager *motionManager;
@property CLLocationManager *locationmanager;
@property CLLocation *location;
@property CMGyroData *data;
@property NSArray *documentPath;
@property NSString *filePath;
@property bool TurbFlag;
@property bool stoppingRec;
@property bool file;
@property NSString *time;
@property NSOperationQueue *queue;
@property NSString * fPath;
@property NSString * fData;
@property int trigger;


-(void)addingEverythingExceptEDR:(NSString *)LicenceNumber firstName:(NSString *)firstName lastName:(NSString *)lastName;
@property bool everythingExceptEDR;

-(void)addingOnlyEDR;
-(void)generatingData;
-(void)saveJsonToFile:(NSData *)data name:(NSString *)name time:(NSString *)time;
-(void)sendingJSONFile:(NSString *)file;
-(BOOL)deleteFile:(NSString *)filename;

-(NSString *) base64StringFromData:(NSData *)data length:(int)length;
-(void)sendJSON;
-(void)turbFlag;
-(void)startRec;
-(void)rec;
@end
