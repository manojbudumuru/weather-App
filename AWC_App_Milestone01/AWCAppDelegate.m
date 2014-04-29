//
//  AWCAppDelegate.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "AWCAppDelegate.h"

@implementation AWCAppDelegate

@synthesize flightInformation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // #42D4FE
    self.awcColor = [UIColor colorWithRed:66/255.0 green:212/255.0 blue:254/255.0 alpha:1.0];
    
    //Initialize time groups
    self.timeGroups = [[NSMutableArray alloc]initWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
    [self loadTimeGroups];
    
    return YES;
}

-(BOOL)isConnectedToInternet
{
    //        http://aviationweather.gov/
    NSString * replyFromURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://aviationweather.gov/"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    return (replyFromURL!=NULL)?YES:NO;
}

-(NSString *)convertToLocalTime:(NSString *)serverTime
{
    double timeZoneHours = ([[NSTimeZone localTimeZone] secondsFromGMT])/3600.0;
    
    double localTime = [[[serverTime substringWithRange:NSMakeRange(0, 5)] stringByReplacingOccurrencesOfString:@":" withString:@"."] doubleValue];
    //NSLog(@"Server Time: %.2f",localTime);
    
    int quotient = timeZoneHours/0.5;
    
    double extraSeconds = 0;
    
    if(abs(quotient%2)==1)
    {
        if(timeZoneHours>=0)
            timeZoneHours -= 0.2;
        else
        {
            timeZoneHours += 0.2;
            extraSeconds = 0.40;
        }
    }

    
    localTime += timeZoneHours-extraSeconds;
    if(localTime<0)
        localTime = 24 + localTime;
    else if(localTime>=24)
        localTime = localTime - 24;
    
    if((localTime-(int)localTime)*100>=60)
    {
        localTime -= 0.60;
        localTime++;
    }

    return [NSString stringWithFormat:@"%0.2f.00",localTime];
}

-(void)loadTimeGroups
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentsDirectory stringByAppendingPathComponent:@"TAF_TimeGroups.txt"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    else
        self.timeGroups = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
}
				
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //Save selected time groups when the application exits
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentsDirectory stringByAppendingPathComponent:@"TAF_TimeGroups.txt"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];

    [self.timeGroups writeToFile:filePath atomically:YES];
}

@end
