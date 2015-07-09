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
        self.everythingExceptEDR = YES;
        self.TurbFlag = NO;
        self.stoppingRec = YES;
        self.trigger = 0;
        
        self.file = YES;
        
        self.motionManager = [[CMMotionManager alloc] init];
        [self.motionManager startAccelerometerUpdates];
        [self.motionManager startGyroUpdates];
        self.locationmanager = [[CLLocationManager alloc] init];
        
        self.locationmanager.delegate = self;
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        //self.locationmanager.distanceFilter = 500; // meters
        [self.locationmanager startUpdatingLocation];
        
        
        self.location = [self.locationmanager location];
        
        self.queue = [[NSOperationQueue alloc] init];
        
        //experimenting
        self.dictionary = [[NSMutableDictionary alloc] init];
        self.array = [[NSMutableArray alloc] init];
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

//  No more required
//-(NSString*)stopWatchCall{
//    return stopwatch;
//}



- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(void)addingEverythingExceptEDR:(NSString *)LicenceNumber firstName:(NSString *)firstName lastName:(NSString *)lastName
{
    self.everythingExceptEDR = NO;
    
    [self.dictionary setObject:LicenceNumber forKey:@"licensenumber"];
    [self.dictionary setObject:firstName forKey:@"firstName"];
    [self.dictionary setObject:lastName forKey:@"lastName"];
    
}


-(void)addingOnlyEDR
{
    [self.dictionary setObject:self.array forKey:@"EDR"];
}

-(void)generatingData
{
    if (self.everythingExceptEDR)
    {    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.fPath = [documentsDirectory stringByAppendingPathComponent:@"Flight_Data.txt"];
        self.fData = [NSString stringWithContentsOfFile:self.fPath encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray * data1 = [[NSMutableArray alloc]initWithArray:[self.fData componentsSeparatedByString:@"_"]];
        [self addingEverythingExceptEDR:data1[4] firstName:data1[0] lastName:data1[1]];
    }
    
    
    NSMutableDictionary *addArray = [[NSMutableDictionary alloc] init];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.motionManager.accelerometerData.acceleration.x] forKey:@"accX"];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.motionManager.accelerometerData.acceleration.y] forKey:@"accY"];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.motionManager.accelerometerData.acceleration.z] forKey:@"accZ"];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.motionManager.gyroData.rotationRate.x] forKey:@"gyroX"];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.motionManager.gyroData.rotationRate.y] forKey:@"gyroY"];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.motionManager.gyroData.rotationRate.z] forKey:@"gyroZ"];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"latitude"];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude] forKey:@"longitude"];
    [addArray setObject:[NSString stringWithFormat:@"%f",self.location.altitude] forKey:@"altitude"];
    
    NSDate *date=[NSDate date];
    NSDateFormatter *dateForm1=[[NSDateFormatter alloc]init];
    //[dateForm1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateForm1 setDateFormat:@"YYYYMMddHHmmss.SSS"];
    NSString *dateString = [dateForm1 stringFromDate:date];
    [addArray setObject:[NSString stringWithFormat:@"%@",dateString] forKey:@"timestamp"];
    [addArray setObject:[NSString stringWithFormat:@"%@",self.TurbFlag ? @"true":@"false"] forKey:@"turbulence"];
    [addArray setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"flightnum"];
    
    
    [self.array addObject:addArray];
    
    
}

-(void)saveJsonToFile:(NSData *)data name:(NSString *)name time:(NSString *)time
{
    
    //creating the file path
    if (self.file)
    {
        
        self.documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.filePath = [[self.documentPath objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@[%@].json",name,time]];
        
        //self.filePath = @"/Users/adsbout/Desktop/JunkJSON2/JSON.json";
        NSLog(@"%@",self.filePath);
        self.file = NO;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.filePath])
    { //the path should be /Users/s516517/Desktop...
        bool Success = [[NSFileManager defaultManager] createFileAtPath:self.filePath contents:data /*NSData*/ attributes:nil /*NSDictionary*/];
        
        if ( Success )
        {
            NSLog( @"Successfully created file at: %@",self.filePath);
            [data writeToFile:self.filePath/*jsonPath*/ atomically:YES];
        }
        else
        {
            NSLog( @"Failed to create file: %@ %s", self.filePath, strerror(errno) );
        }
        
    }
    
    else
    {
        //[self creatingJSON];
        [data writeToFile:self.filePath atomically:YES];
//        [self.array removeAllObjects];
//        [self.dictionary removeAllObjects];
    }
    
}

//The code to send the JSON
-(void)sendingJSONFile:(NSString *)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.fPath = [documentsDirectory stringByAppendingPathComponent:@"Flight_Data.txt"];
    self.fData = [NSString stringWithContentsOfFile:self.fPath encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray * data1 = [[NSMutableArray alloc]initWithArray:[self.fData componentsSeparatedByString:@"_"]];
    
    NSString * fileName=[NSString stringWithFormat:@"%@%@%@",data1[0],data1[1],file];
    
    NSData * data = [NSData dataWithContentsOfFile:self.filePath];
    
    NSMutableString *strUrl =[[NSMutableString alloc] initWithFormat:@"name=%@&&filename=%@&&data=",fileName,fileName];
    
    [strUrl appendFormat:@"%@", [self base64StringFromData:data length:[data length]]];
    
    NSData * postData = [strUrl dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    
    NSString * postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSString * baseUrl = @"http://csgrad07.nwmissouri.edu/EDRData.php";
    
    NSURL * url = [NSURL URLWithString:baseUrl];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [connection start];
    NSLog(@"Connection started!");
    
    
    
}


-(BOOL)deleteFile:(NSString *)filename
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"[deleteFile] about to delete file");
    //delete file
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:self.filePath error:&error];
    NSLog(@"Success: %@", success ? @"YES" : @"NO");
    
    return success;
    
}

- (NSString *) base64StringFromData: (NSData *)data length: (int)length {
    char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

-(void)sendJSON{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.fPath = [documentsDirectory stringByAppendingPathComponent:@"Flight_Data.txt"];
    self.fData = [NSString stringWithContentsOfFile:self.fPath encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray * data1 = [[NSMutableArray alloc]initWithArray:[self.fData componentsSeparatedByString:@"_"]];
    
    
    NSDate *date=[NSDate date];
    NSDateFormatter *dateForm1=[[NSDateFormatter alloc]init];
    //[dateForm1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateForm1 setDateFormat:@"YYYYMMddHHmmss"];
    NSString *dateString = [dateForm1 stringFromDate:date];
    
    [self saveJsonToFile:_jsonData name:[NSString stringWithFormat:@"%@%@",data1[0],data1[1]] time:dateString];
    
    
    
    //[self postFilePath];
    [self sendingJSONFile:dateString];
    
    if ([self deleteFile:self.filePath])
    {
        NSLog(@"File Deleted Successfully");
    }
    else
    {
        NSLog(@"File Not Deleted");
    }
    
}
-(void)turbFlag{
    if (!self.TurbFlag) {
        self.TurbFlag = YES;
    }
    else
        self.TurbFlag = NO;
}
-(void)startRec{
    
    [self.queue addOperationWithBlock:^(void){
        while (self.stoppingRec)
        {
            [self generatingData];
            
            //0.05 is in milliseconds which gives us 20 values per seconds
            [NSThread sleepForTimeInterval:0.05f];  //Time interval of 8 seconds for 8.0f
            //[self addingOnlyEDR];
            //NSLog(@"Hello");
        }
        [self addingOnlyEDR];
        NSError *error;
        
        _jsonData=[NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"%@",[[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding]);
        
        [self sendJSON];
    }];

}

-(void)rec{
    
    }

@end
