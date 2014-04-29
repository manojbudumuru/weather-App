//
//  SettingsVC.h
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/1/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWCAppDelegate.h"

@interface SettingsVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *aircraftType;
@property (strong, nonatomic) IBOutlet UITextField *tailNumber;
@property (strong, nonatomic) IBOutlet UITextField *license;
@property (strong, nonatomic) IBOutlet UILabel *existingInfo;

- (IBAction)saveData:(id)sender;
@property AWCAppDelegate * appDelegate;
@property NSMutableArray * info;

@property (weak, nonatomic) IBOutlet UINavigationBar *header;
@end
