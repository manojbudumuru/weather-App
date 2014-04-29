//
//  EditFlightInfo.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 11/4/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "EditFlightInfo.h"

@interface EditFlightInfo ()

@property NSString * fPath;
@property NSString * fData;

@end

@implementation EditFlightInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = self.appDelegate.awcColor;
    [self.header setBarTintColor:self.appDelegate.awcColor];
    [self.header setTintColor:[UIColor whiteColor]];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
//    self.view.backgroundColor = self.appDelegate.awcColor;
//    [self.header setBarTintColor:self.appDelegate.awcColor];
//    [self.header setTintColor:[UIColor whiteColor]];
//    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.info = [[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.fPath = [documentsDirectory stringByAppendingPathComponent:@"Flight_Data.txt"];
    self.fData = [NSString stringWithContentsOfFile:self.fPath encoding:NSUTF8StringEncoding error:nil];
    
    //self.existingInfo.hidden = YES;
    
    NSMutableArray * data = [[NSMutableArray alloc]initWithArray:[self.fData componentsSeparatedByString:@"_"]];
    
    self.existingInfo.hidden = NO;
    self.existingInfo.textAlignment = NSTextAlignmentCenter;
    self.existingInfo.numberOfLines = 6;
    self.existingInfo.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.existingInfo.text = [NSString stringWithFormat:@"Existing information:\n\n%@ %@\n%@ %@\n%@ %@\n%@ %@",@"Name:",data[0],@"Aircraft Type:",data[1],@"Tail Number:",data[2],@"License:",data[3]];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setAircraftType:nil];
    [self setTailNumber:nil];
    [self setName:nil];
    [self setLicense:nil];
    [self setExistingInfo:nil];
    [super viewDidUnload];
}

- (IBAction)saveData:(id)sender {
    
    
    
//    NSMutableArray * data = [[NSMutableArray alloc]initWithArray:[self.fData componentsSeparatedByString:@" "]];
//    
//    self.existingInfo.hidden = NO;
//    self.existingInfo.textAlignment = NSTextAlignmentCenter;
//    self.existingInfo.numberOfLines = 6;
//    self.existingInfo.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    self.existingInfo.text = [NSString stringWithFormat:@"Existing information:\n\nName: %@\nAircraft Type: %@\nTail Number: %@\nLicense: %@",data[0],data[1],data[2],data[3]];
    
    if([self.name.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"Name cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    else
    {
        NSString * data = self.name.text;
        [self.info addObject:data];
        data = self.aircraftType.text;
        [self.info addObject:data];
        data = self.tailNumber.text;
        [self.info addObject:data];
        data = self.license.text;
        [self.info addObject:data];
        
        self.fData = [NSString stringWithFormat:@"%@_%@_%@_%@",self.name.text,self.aircraftType.text,self.tailNumber.text,self.license.text];
        [self.fData writeToFile:self.fPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        self.appDelegate.flightInformation = self.info;
        
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
