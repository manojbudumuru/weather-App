//
//  DisplayPIREP.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 10/19/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "DisplayPIREP.h"

@interface DisplayPIREP ()

@property NSMutableArray * titles;
@property NSMutableArray * values;
@property NSString * pirepType;

@end

@implementation DisplayPIREP

- (id)initWithStyle:(UITableViewStyle)style pirep:(Pirep *)pirepObj userPirep:(UserPirep *)userPirepObj
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.pirep = pirepObj;
        self.userPirep = userPirepObj;
        
        if(self.pirep == nil)
            self.pirepType = @"UserPirep";
        else
            self.pirepType = @"Pirep";
        
        //NSLog(@"I am %@",self.pirepType);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titles = [[NSMutableArray alloc]init];
    self.values = [[NSMutableArray alloc]init];
    
    if([self.pirepType isEqualToString:@"Pirep"])
    {
        if(self.pirep.icaoId!=nil)
        {
            [self.titles addObject:@"ICAO Id"];
            [self.values addObject:self.pirep.icaoId];
        }
        
        NSString * location = [NSString stringWithFormat:@"%0.2fN %0.2fW",
                               [self.pirep.coordinatePoints[1] doubleValue], [self.pirep.coordinatePoints[0]doubleValue]];
        [self.titles addObject:@"Location"];
        [self.values addObject:location];
        
        if(self.pirep.rawOb!=nil)
        {
            [self.titles addObject:@"Raw Text"];
            [self.values addObject:self.pirep.rawOb];
        }
        
        if(self.pirep.obsTime!=nil)
        {
            [self.titles addObject:@"Observed Time"];
            NSInteger length = [self.pirep.obsTime length]-9;
            NSString * date = [self.pirep.obsTime substringFromIndex:length];
            date = [date substringToIndex:[date length]-1];
            [self.values addObject:date];
        }
        if(self.pirep.acType!=nil)
        {
            [self.titles addObject:@"Aircraft Type"];
            [self.values addObject:self.pirep.acType];
        }
        
        if(self.pirep.temp!=nil)
        {
            [self.titles addObject:@"Temperature"];
            NSString *temp = [NSString stringWithFormat:@"%@°C",self.pirep.temp];
            [self.values addObject:temp];
        }
        if(self.pirep.cloudBas1!=nil)
        {
            [self.titles addObject:@"Cloud Base"];
            [self.values addObject:self.pirep.cloudBas1];
        }
        
        if(self.pirep.cloudCvg1!=nil)
        {
            [self.titles addObject:@"Cloud Coverage"];
            [self.values addObject:self.pirep.cloudCvg1];
        }
        if(self.pirep.wdir!=nil)
        {
            [self.titles addObject:@"Wind Direction"];
            
            double dir = [self.pirep.wdir doubleValue];
            NSString * direction = @"";
            
            if(dir>0 && dir<90)
                direction = @"NE";
            else if(dir>90 && dir<180)
                direction = @"SE";
            else if(dir>180 && dir<270)
                direction = @"SW";
            else if(dir>270 && dir<360)
                direction = @"NW";
            else if(dir==0)
                direction = @"N";
            else if(dir==90)
                direction = @"E";
            else if(dir==180)
                direction = @"S";
            else if(dir==270)
                direction = @"W";
            
            NSString * windDir = [NSString stringWithFormat:@"%0.0f° %@",dir,direction];
            
            [self.values addObject:windDir];
        }
        
        if(self.pirep.wspd!=nil)
        {
            [self.titles addObject:@"Wind Speed"];
            [self.values addObject:self.pirep.wspd];
        }
        if(self.pirep.fltlv1!=nil)
        {
            [self.titles addObject:@"Flight Level"];
            [self.values addObject:self.pirep.fltlv1];
        }
        
        if(self.pirep.tbFreq1!=nil)
        {
            [self.titles addObject:@"Turbulence Frequency"];
            [self.values addObject:self.pirep.tbFreq1];
        }
    }
    else
    {
        //NSLog(@"Pirep Type: %@",self.pirepType);
        
        if(self.userPirep.lisenceNum!=nil)
        {
            [self.titles addObject:@"License Number"];
            [self.values addObject:self.userPirep.lisenceNum];
        }
        
        if(self.userPirep.timeOfReport!=nil)
        {
            [self.titles addObject:@"Time Of Report"];
            [self.values addObject:self.userPirep.timeOfReport];
        }
        
        if(self.userPirep.pilotReport!=nil)
        {
            [self.titles addObject:@"Pilot Report"];
            [self.values addObject:self.userPirep.pilotReport];
        }
        
        if(self.userPirep.aircraftType!=nil)
        {
            [self.titles addObject:@"Aircraft Type"];
            [self.values addObject:self.userPirep.aircraftType];
        }
        
        if(self.userPirep.tailNumber!=nil)
        {
            [self.titles addObject:@"Tail Number"];
            [self.values addObject:self.userPirep.tailNumber];
        }
        
        if(self.userPirep.skyCondition!=nil)
        {
            [self.titles addObject:@"Sky Condition"];
            [self.values addObject:self.userPirep.skyCondition];
        }
        
        if(self.userPirep.weatherCondition!=nil)
        {
            [self.titles addObject:@"Weather Condition"];
            [self.values addObject:self.userPirep.weatherCondition];
        }
        
        if(self.userPirep.locationLatitude!=nil && self.userPirep.locationLongitude!=nil)
        {
            NSString * location = [NSString stringWithFormat:@"%0.2fN %0.2fW",
                                   [self.userPirep.locationLatitude doubleValue], [self.userPirep.locationLongitude doubleValue]];
            [self.titles addObject:@"Location"];
            [self.values addObject:location];
        }
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    NSString * identifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    UIFont * categoryFont = [UIFont fontWithName:@"Helvetica" size:20];
    cell.textLabel.font = categoryFont;
    cell.detailTextLabel.text = self.values[indexPath.row];
    cell.detailTextLabel.lineBreakMode=NSLineBreakByCharWrapping;
    cell.detailTextLabel.numberOfLines=4;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row == 2) {
        return 90;
    }
    
    return 45;
}

@end
