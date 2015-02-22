//
//  Forecast.h
//  GA Weather
//
//  Created by Syed Mazhar Hussani on 2/9/15.
//  Copyright (c) 2015 Satish Kumar Baswapuram. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForecastDelegate <NSObject>

@required
-(void)selectedForecast:(NSString *)fore;

@end

@interface Forecast : UITableViewController

@property NSMutableArray* forecasts;
@property id<ForecastDelegate> delegate;

@end
