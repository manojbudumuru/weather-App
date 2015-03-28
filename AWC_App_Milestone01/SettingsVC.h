//
//  SettingsVC.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/1/13.
//  Edited by Syed Mazhar Hussani
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SettingsVC : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *lName;
@property (strong, nonatomic) IBOutlet UITextField *fName;
@property (strong, nonatomic) IBOutlet UITextField *aircraftType;
@property (strong, nonatomic) IBOutlet UITextField *tailNumber;
@property (strong, nonatomic) IBOutlet UITextField *license;
@property (strong, nonatomic) IBOutlet UILabel *existingInfo;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

- (IBAction)saveData:(id)sender;
@property AppDelegate * appDelegate;
@property NSMutableArray * info;
@property NSMutableArray* aircraftTypes;

@property (weak, nonatomic) IBOutlet UINavigationBar *header;

- (IBAction)showUserManual:(id)sender;
- (IBAction)cancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *aircraftPicker;

@end
