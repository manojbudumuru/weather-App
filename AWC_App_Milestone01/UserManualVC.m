//
//  UserManualVC.m
//  NWMSU_AWC_App
//
//  Created by Satish Kumar Baswapuram on 4/30/14.
//  Copyright (c) 2014 Satish Kumar Baswapuram. All rights reserved.
//

#import "UserManualVC.h"
#import "AWCAppDelegate.h"

@interface UserManualVC ()

@property AWCAppDelegate * appDelegate;

@end

@implementation UserManualVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Set the view background color and the header color to reflect the theme of the app.
//Load the user manual if the user is connected to internet. Else, display an alert that there is no internet available.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.webView.delegate = self;
    
    self.view.backgroundColor = self.appDelegate.awcColor;
    [self.header setBarTintColor:self.appDelegate.awcColor];
    [self.header setTintColor:[UIColor whiteColor]];
    self.header.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //This will allow the user to zoom in and out on the web page
    self.webView.scalesPageToFit = YES;
    
    NSURL * blogURL = [NSURL URLWithString:@"http://ga-user-manual.blogspot.com/2014/04/user-manual.html"];
    
    if([NSString stringWithContentsOfURL:blogURL encoding:NSUTF8StringEncoding error:nil]==nil)
    {
        UIAlertView * noInternetAlert = [[UIAlertView alloc]initWithTitle:@"No internet!!" message:@"Please connect to the internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noInternetAlert show];
    }
    else
    {
        NSLog(@"Internet available");
        NSURLRequest * request = [NSURLRequest requestWithURL:blogURL];
        
        [self.webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Dismiss the user manual and get back to the tabs.
- (IBAction)closeManual:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
