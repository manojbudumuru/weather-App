//
//  UserManualVC.h
//  NWMSU_AWC_App
//
//  Created by Satish Kumar Baswapuram on 4/30/14.
//  Copyright (c) 2014 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserManualVC : UIViewController <UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)closeManual:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *header;

@end
