//
//  AWCAppDelegate.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 9/29/13.
//  Edited by Syed Mazhar Hussani
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

static  NSString* stopwatchLabel;
@synthesize flightInformation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // #42D4FE - older
    // #018490
    self.awcColor = [UIColor colorWithRed:1/255.0 green:132/255.0 blue:144/255.0 alpha:1.0];
    self.header = [UIImage imageNamed:@"header.png"];
    self.footer = [UIImage imageNamed:@"footer.png"];
    
    //  Control Panel variables/prperties
    
    //  Aircraft Types to be loaded once
     self.aircraftTypes = [[NSMutableArray alloc]initWithArray:@[@"Other",@"A306",@"A30B",@"A310",@"A318",@"A319",@"A320",@"A321",@"A332",@"A333",@"A343",@"A345",@"A346",@"A388",@"A3ST",@"AT43",@"AT45",@"AT72",@"AT73",@"AT75",@"ATP",@"B462",@"B703",@"B712",@"B722",@"B732",@"B733",@"B734",@"B735",@"B736",@"B737",@"B738",@"B739",@"B742",@"B743",@"B744",@"B752",@"B753",@"B762",@"B763",@"B764",@"B772",@"B773",@"B77L",@"B77W",@"",@"BA11",@"BE20",@"BE58",@"BE99",@"BE9L",@"C130",@"C160",@"C172",@"182",@"C421",@"C510",@"C550",@"C560",@"C56X",@"C750",@"CL60",@"CRJ1",@"CRJ2",@"CRJ9",@"D228",@"D328",@"DA42",@"DC10",@"DC87",@"DC94",@"DH8A",@"DH8C",@"DH8D",@"E120",@"E135",@"E145",@"E170",@"E190",@"E50P",@"E55P",@"EA50",@"F100",@"F27",@"F28",@"F2TH",@"F50",@"F70",@"F900",@"FA10",@"FA20",@"FA50",@"FA7X",@"FGTH",@"FGTL",@"FGTN",@"H25A",@"JS32",@"JS41",@"L101",@"LJ35",@"LJ45",@"MD11",@"MD82",@"MD83",@"MU2",@"P28A",@"PA27",@"PA31",@"PA34",@"PAY2",@"PAY3",@"RJ85",@"SB20",@"SF34",@"SH36",@"SW4",@"T134",@"T154",@"TBM7",@"TRIN"]];
    
    //Initialize time groups
    self.timeGroups = [[NSMutableArray alloc]initWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
    [self loadTimeGroups];
    
    return YES;
}

//This method checks if the user has internet connection to his iPad. If yes, it retuns yes, else returns no.
-(BOOL)isConnectedToInternet
{
    //        http://aviationweather.gov/
    NSString * replyFromURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://aviationweather.gov/"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    return (replyFromURL!=NULL)?YES:NO;
}

//This method converts the report time which is in GMT +0 to the user's local time.
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

//This method loads the time groups which the user has selected in his previous use of the application
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
//edit2014
//This method obselete.. i.e. This functinality is no more required.
//This method will retrieve the application password that each user must enter to access this app.
//-(NSString *)getApplicationPassword
//{
//    //NSURL * passwordURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/y7gxs251cuvaw3h/password.json?dl=1&token_hash=AAHhKQBFtwG2OsSId3ROpEQsc_zZGCeTGbHQRwX4bVCi0g"];
//    
//    NSURL * passwordURL = [NSURL URLWithString:@"https://docs.google.com/document/d/1hoKxvD-7gNkUGVj0nzOeJbCEDDoYvRc59GSrmj84SPg/export?format=txt&id=1hoKxvD-7gNkUGVj0nzOeJbCEDDoYvRc59GSrmj84SPg"];
//    NSData * passwordData = [NSData dataWithContentsOfURL:passwordURL];
//    NSError * error = nil;
//    NSDictionary * passwordDictionary = [NSJSONSerialization JSONObjectWithData:passwordData options:0 error:&error];
//    
//    NSString * password = passwordDictionary[@"password"];
//    
//    NSLog(@"Password: %@",password);
//    
//    return password;
//}

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
