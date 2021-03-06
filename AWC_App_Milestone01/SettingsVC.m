//
//  SettingsVC.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/1/13.
//  Edited by Syed Mazhar Hussani
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "SettingsVC.h"
#import "UserManualVC.h"

@interface SettingsVC ()

@property NSString * fPath;
@property NSString * fData;
@property int selectedRow;
@property NSString* oldPassword;
@end

@implementation SettingsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Set the view background color and header color to reflect the theme of the app.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = self.appDelegate.awcColor;
//    [self.header setBarTintColor:self.appDelegate.awcColor];
//    [self.header setTintColor:[UIColor whiteColor]];
    self.header.translucent = YES;
    [self.header setBackgroundImage:[UIImage imageNamed:@"tabBar.png"] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.aircraftTypes = self.appDelegate.aircraftTypes;
    
    self.aircraftPicker.delegate = self;
    self.aircraftPicker.dataSource = self;
    self.selectedRow = 0;

    
    self.info = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.fPath = [documentsDirectory stringByAppendingPathComponent:@"Flight_Data.txt"];
    self.fData = [NSString stringWithContentsOfFile:self.fPath encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray * data = [[NSMutableArray alloc]initWithArray:[self.fData componentsSeparatedByString:@"_"]];
    
    self.existingInfo.hidden = NO;
    self.existingInfo.textAlignment = NSTextAlignmentCenter;
    self.existingInfo.numberOfLines = 6;
    self.existingInfo.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.existingInfo.text = [NSString stringWithFormat:@"Existing information:\n\n%@ %@ %@\n%@ %@\n%@ %@",@"Name:",data[0],data[1],@"Aircraft Type:",data[2],@"Tail Number:",data[3]];//,@"License:",data[4]];
    
    self.passwordTF.text = self.oldPassword = data[5];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFName:nil];
    [self setLName:nil];
    [self setAircraftType:nil];
    [self setTailNumber:nil];
    [self setLicense:nil];
    [self setExistingInfo:nil];
    [super viewDidUnload];
}

//Save the pilot information if all the fields are filled and present the tabs. Else, display an alert.
- (IBAction)saveData:(id)sender {
    
    if([self.fName.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"Name cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([self.lName.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"Last Name cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if(self.selectedRow == 0){
        if([self.aircraftType.text isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Enter Information" message:@"Aircraft Type cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
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
        if (self.selectedRow == 0) {
            self.aircraftType.enabled = YES;
            data = self.aircraftType.text;
        }
        else {
            self.aircraftType.enabled = NO;
            self.aircraftType.text = self.aircraftTypes[self.selectedRow];
            data = self.aircraftTypes[self.selectedRow];
        }
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
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Saved" message:@"The given information has been saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self viewDidLoad];
        
    }
}

//Hide the keyboard if the user clicks on the view while editing.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}
/*
//Present user manual to the user when this button is clicked.
- (IBAction)showUserManual:(id)sender {
     UserManualVC * userManualVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userManualVC"];
    [self presentViewController:userManualVC animated:YES completion:nil];
 
}
*/
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//  UI Picker methods
// The number of rows of data

-(int)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
    
}
// The data to return for the row and component (column) that's being passed in


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = self.aircraftTypes[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],}];
    
    return attString;
    
}/*
  -(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  return self.aircraftTypes[row];
  }
  */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return self.aircraftTypes.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    
    self.selectedRow = row;
    if(self.selectedRow != 0)
        self.aircraftType.enabled = NO;
    else self.aircraftType.enabled = YES;
    //NSLog(@"Selected Row %d", row);
}


@end
