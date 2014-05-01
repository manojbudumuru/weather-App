//
//  TabBarVC.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 11/28/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "TabBarVC.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Set the tab bar background image and selection indicator image to reflect the theme of the app.
-(void)viewWillAppear:(BOOL)animated
{
    AWCAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;

    //[self.tabBar setTranslucent:NO];
    
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setBarTintColor:appDelegate.awcColor];
    
    self.tabBar.itemWidth = 120;
    self.tabBar.backgroundImage = [UIImage imageNamed:@"TabBarBackground.png"];
    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"SelectedTab.png"];
    
    //CGRect tabFrame = self.tabBar.frame;
    //NSLog(@"Tab Bar: (%f,%f)",tabFrame.size.width,tabFrame.size.height);

//    CGFloat tabItemWidth = self.tabBar.selectionIndicatorImage.size.width;
//    CGFloat tabItemHeight = self.tabBar.selectionIndicatorImage.size.height;
//    NSLog(@"Tab Bar Item Size: (%f,%f)",tabItemWidth,tabItemHeight);
    
//    UITabBarItem * tabBarItem1 = [self.tabBar.items objectAtIndex:0];
//    UITabBarItem * tabBarItem2 = [self.tabBar.items objectAtIndex:1];
//    UITabBarItem * tabBarItem3 = [self.tabBar.items objectAtIndex:2];
//    UITabBarItem * tabBarItem4 = [self.tabBar.items objectAtIndex:3];
//    UITabBarItem * tabBarItem5 = [self.tabBar.items objectAtIndex:4];
//    
//    [tabBarItem1 setImage:[[UIImage imageNamed:@"Songs_NS.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem2 setImage:[[UIImage imageNamed:@"Album_NS.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem3 setImage:[[UIImage imageNamed:@"Artist_NS.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem4 setImage:[[UIImage imageNamed:@"Playlist_NS.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem5 setImage:[[UIImage imageNamed:@"Settings_NS.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    
//    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"Songs_S.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"Album_S.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"Artist_S.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"Playlist_S.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem5 setSelectedImage:[[UIImage imageNamed:@"Settings_S.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
