//
//  FlightInfo.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 10/21/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "FlightInfo.h"
#import "PIREP_View_Tab.h"
#import "TabBarVC.h"

@interface FlightInfo ()

@property NSString * fPath;
@property NSString * fData;
@property BOOL hasPilotInfo;
@property NSString * actualPassword;
@property NSString * savedPassword;
@property NSString * loginURL;
@property BOOL fileLoaded;


@end

@implementation FlightInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Initialize the properties to figure out what needs to be displayed on the screen
//based on who the user is: a new user or a returning user
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.info = [[NSMutableArray alloc]init];
    self.hasPilotInfo = NO;
    
    self.view.backgroundColor = self.appDelegate.awcColor;
    //[self.header setBarTintColor:self.appDelegate.awcColor];
    //[self.header setTintColor:[UIColor whiteColor]];
    [self.header setBackgroundImage:[UIImage imageNamed:@"tabBar.png"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    
    self.welcomeText.numberOfLines = 10;
    self.welcomeText.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.headerProvideInfo.hidden = YES;
    
    self.infoName.hidden = YES;
    self.infoAircraftType.hidden = YES;
    self.infoTailNumber.hidden = YES;
    self.infoLicense.hidden = YES;
    
    self.fName.hidden = YES;
    self.lName.hidden = YES;
    self.aircraftType.hidden = YES;
    self.tailNumber.hidden = YES;
    self.license.hidden = YES;
    
    self.saveData.hidden = YES;
    self.changeData.hidden = YES;
    self.cancel.hidden = YES;
    self.enterData.hidden = YES;
    self.cancelDataCollection.hidden = YES;
    
    [self.saveData addTarget:self action:@selector(saveData:) forControlEvents:UIControlEventTouchUpInside];
    [self.enterData addTarget:self action:@selector(displayButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self.changeData addTarget:self action:@selector(displayButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancel addTarget:self action:@selector(validatePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelDataCollection addTarget:self action:@selector(viewDidLoad) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.existingInfo.hidden = YES;
    
    self.loginURL = @"http://csgrad07.nwmissouri.edu/login.php";
    
    [self checkData];
    
	// Do any additional setup after loading the view.
}

//Check if the app has any exisiting data. If yes, present him with the options to change or continue with the same.
//Else, ask him to enter the information.
-(void)checkData
{
    self.welcomeText.hidden = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.fPath = [documentsDirectory stringByAppendingPathComponent:@"Flight_Data.txt"];
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.fPath])
       [[NSFileManager defaultManager] createFileAtPath:self.fPath contents:nil attributes:nil] ;
//    if([[NSFileManager defaultManager] fileExistsAtPath:self.fPath])
//        NSLog(@"File exists now.");
    
    self.fData = [NSString stringWithContentsOfFile:self.fPath encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray * data = [[NSMutableArray alloc]initWithArray:[self.fData componentsSeparatedByString:@"_"]];
    
    //NSLog(@"Present Info: %@\n Splitd:\n%@\n%@\n%@\n%@",self.fData,data[0],data[1],data[2],data[3]);
    
    NSLog(@"Present Info: *%@*",self.fData);
    NSLog(@"File Path: %@",self.fPath);
    
    if([self.fData isEqualToString:@"(null)"] || [self.fData isEqualToString:@""])
    {
        self.welcomeText.text = @"This is the first time you are using this application. This application needs some information from you inorder to send reports to the ground station. Please press 'OK' to fill in the required information and start using the application.";
        self.enterData.hidden = NO;
        self.passwordTF.hidden = YES;
        self.fileLoaded = NO;
    }
    else
    {
        self.welcomeText.text = @"This application currently has your information which you entered on your previous journey. If you want to continue with the same information, press 'Continue'. If you want to enter new information, press 'Change'";
        self.appDelegate.flightInformation = data;
        self.changeData.hidden = NO;
        self.cancel.hidden = NO;
        self.hasPilotInfo = YES;
        
        self.existingInfo.hidden = NO;
        self.existingInfo.textAlignment = NSTextAlignmentCenter;
        self.existingInfo.numberOfLines = 6;
        self.existingInfo.lineBreakMode = NSLineBreakByWordWrapping;
        //edit2014
        
        NSMutableArray * displayData = [[NSMutableArray alloc]init];
        NSString * temp;
        NSString * temp1;
        NSMutableString * str;
        NSString *s = @"\u2022";
        for(int i=0;i<self.appDelegate.flightInformation.count;i++){
            temp = self.appDelegate.flightInformation[i];
            temp1 = [temp substringWithRange:NSMakeRange(0, 1)];
            str = [NSMutableString stringWithString:temp1];
            for(int j=1;j<temp.length-1;j++)
            {
                //[str appendFormat:s];
                [str appendFormat:@"*"];
            }
            temp1 = [temp substringWithRange:NSMakeRange(temp.length-1, 1)];
            [str appendFormat:temp1];
            [displayData addObject:str];
        }
        NSLog(@"%@",str);
        self.existingInfo.text = [NSString stringWithFormat:@"Existing information:\n\n%@ %@ %@\n%@ %@\n%@ %@\n%@ %@",@"Name:",displayData[0],displayData[1],@"Aircraft Type:",displayData[2],@"Tail Number:",displayData[3],@"License:",displayData[4]];
        self.fileLoaded = YES;
        
        
        
    }
}

//-(void)saveToFile:(NSString *)level
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"AWC_Data.txt"];
//    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    
//    self.pirepSend = [self.pirepSend stringByAppendingString:level];
//    
//    if([str isEqualToString:@"(null)"])
//    {
//        str = @"";
//    }
//    
//    NSString * addData = [NSString stringWithFormat:@"%@%@\n",str,self.pirepSend];
//    
//    
//    [addData writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
//    
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"PIREP Sent" message:self.presentPirep delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    
//    NSLog(@"PIREP:\n%@",addData);
//    
//    [self setPirep];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Save the pilot information if all the fields are filled and present the tabs. Else, display an alert.
- (void)saveData:(id)sender {
    
    if([self.fName.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"First Name cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    if([self.lName.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"Last Name cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([self.aircraftType.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"Aircraft Type cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([self.tailNumber.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"Tail Number cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([self.license.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"License cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([self.passwordTF.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"Please enter correct password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString * data = self.fName.text;
        [self.info addObject:data];
        data = self.lName.text;
        [self.info addObject:data];
        data = self.aircraftType.text;
        [self.info addObject:data];
        data = self.tailNumber.text;
        [self.info addObject:data];
        data = self.license.text;
        [self.info addObject:data];
        data = self.passwordTF.text;
        [self.info addObject:data];
        
        self.fData = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@",self.fName.text,self.lName.text,self.aircraftType.text,self.tailNumber.text,self.license.text,self.passwordTF.text];
        [self.fData writeToFile:self.fPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        self.appDelegate.flightInformation = self.info;
//        NSLog(@"\nFROM SAVEDATA()\n%@, %@, %@\n>>>>>>>>>COUNT : %d",self.appDelegate.flightInformation[0],self.appDelegate.flightInformation[1],self.appDelegate.flightInformation[4],self.appDelegate.flightInformation.count);
//        NSLog(@"\nFROM SAVEDATA()\nself.info\n%@, %@, %@",self.info[0],self.info[1],self.info[4]);
        
        [self validateUser];
        
    }
}

//If the device has internet, present tabs. Else, prompt the user to connect to internet.
-(void)presentTabs
{

    if([self.appDelegate isConnectedToInternet])
    {
    
        TabBarVC * mainView = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        
        [self presentViewController:mainView animated:YES completion:nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No internet!!" message:@"Make sure you have a working internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

//Display a specific set of buttons based on the state of the user.
- (void)displayButtons:(id)sender {
    self.headerProvideInfo.hidden = NO;
    self.welcomeText.hidden = YES;
    
    self.infoName.hidden = NO;
    self.infoAircraftType.hidden = NO;
    self.infoTailNumber.hidden = NO;
    self.infoLicense.hidden = NO;
    
    self.fName.hidden = NO;
    self.lName.hidden = NO;
    self.aircraftType.hidden = NO;
    self.tailNumber.hidden = NO;
    self.license.hidden = NO;
    
    self.passwordTF.hidden = NO;
    
    self.changeData.hidden = YES;
    self.cancel.hidden = YES;
    self.enterData.hidden = YES;
    self.saveData.hidden = NO;
    self.existingInfo.hidden = YES;
    
    if(self.hasPilotInfo)
        self.cancelDataCollection.hidden = NO;
}

//Validate if the user is listed in the database
-(void)validateUser
{
    //edit2014
    if([self.appDelegate isConnectedToInternet])
    {
        NSMutableString * credentials = [NSMutableString stringWithString:self.loginURL];
        if(self.fileLoaded){
            [credentials appendFormat:@"?fname=%@",self.appDelegate.flightInformation[0]];
            [credentials appendFormat:@"&lname=%@",self.appDelegate.flightInformation[1]];
            [credentials appendFormat:@"&licnum=%@",self.appDelegate.flightInformation[4]];
            NSLog(@"%@\n*****",credentials);
            //
            NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:credentials]];
            NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString * reply = [[NSString alloc]initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"Reply: %@",reply);
            int returnValue = [reply intValue];
            if (returnValue == 1) {
                [self presentTabs];
            }
            else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error!!!" message:@"Boo Hoo!!! Get a valid License First.." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                self.info = [[NSMutableArray alloc]init];
            }
            
            
        }
//        static BOOL passwordObtained = NO;
//        
//        if(!passwordObtained)
//        {
//            self.actualPassword = [self.appDelegate getApplicationPassword];
//            passwordObtained = YES;
//        }
//        
//        NSString * userPassword = self.passwordTF.text;
//        if([self. isEqualToString:userPassword])
//           [self presentTabs];
//        else
//        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Login failed!!" message:@"Please enter correct password to access the application" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//      [self presentTabs];
    
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"No internet!!" message:@"Make sure you have a working internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)viewDidUnload {
    [self setHeaderProvideInfo:nil];
    [self setHeaderWelcome:nil];
    [self setInfoName:nil];
    [self setInfoAircraftType:nil];
    [self setInfoTailNumber:nil];
    [self setInfoLicense:nil];
    [self setLicense:nil];
    [self setFName:nil];
    [self setAircraftType:nil];
    [self setWelcomeText:nil];
    [self setSaveData:nil];
    [self setEnterData:nil];
    [self setTailNumber:nil];
    [self setChangeData:nil];
    [self setCancel:nil];
    [self setExistingInfo:nil];
    [super viewDidUnload];
}
//Validate the information of the user already stored on the app after he/she provides a correct passkey
-(void)validatePassword {
    if([self.passwordTF.text isEqualToString:self.appDelegate.flightInformation[self.appDelegate.flightInformation.count-1]])
    {
        [self validateUser];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Incorrect password!!" message:@"Please enter the correct password to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end
