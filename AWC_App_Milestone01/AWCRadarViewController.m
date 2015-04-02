//
//  AWCRadarViewController.m
//  GA Weather
//
//  Created by adsbout on 4/1/15.
//  Copyright (c) 2015 Satish Kumar Baswapuram. All rights reserved.
//

#import "AWCRadarViewController.h"
#import "Grid.h"
#import "GridView.h"
#import <MapKit/MapKit.h>
//@import MapKit;

@interface AWCRadarViewController ()<MKMapViewDelegate>

@end

@implementation AWCRadarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _grid=[[Grid alloc]init];
    //_grid.geometryFlipped=YES;
    _grid.canReplaceMapContent=NO;
    [_mapView addOverlay:_grid level:MKOverlayLevelAboveLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if([overlay isKindOfClass:[MKTileOverlay class]]) {
        
        // MKTileOverlayRenderer *renderer = ;
        //self.grid.geometryFlipped = YES;
        return [[GridView alloc] initWithTileOverlay:overlay];;
    }
    
    return nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
