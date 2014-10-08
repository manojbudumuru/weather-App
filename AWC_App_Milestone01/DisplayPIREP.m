//
//  DisplayPIREP.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 10/19/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "DisplayPIREP.h"
#import "AppDelegate.h"

#define CELL_HEIGHT 45
#define RAWDATA_CELL_HEIGHT 90
#define SECTIONHEADER_HEIGHT 50

@interface DisplayPIREP ()

@property NSMutableArray * titles;
@property NSMutableArray * values;
@property NSString * pirepType;
@property AppDelegate * appDelegate;
@property NSString * icaoId;

@end

@implementation DisplayPIREP

//Here, we will check if the PIREP to be displayed is an actual PIREP or a UserPIREP.
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

//Initialize the titles and values arrays which display the properties of the PIREP.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titles = [[NSMutableArray alloc]init];
    self.values = [[NSMutableArray alloc]init];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    if([self.pirepType isEqualToString:@"Pirep"])
    {
        if(self.pirep.icaoId!=nil)
        {
            self.icaoId = self.pirep.icaoId;
            //[self.titles addObject:@"ICAO Id"];
            //[self.values addObject:self.pirep.icaoId];
        }
        else
            self.icaoId = @"Unknown";
        
        NSString * location = [NSString stringWithFormat:@"%0.2fN %0.2fW",
                               [self.pirep.coordinatePoints[1] doubleValue], [self.pirep.coordinatePoints[0]doubleValue]];
        [self.titles addObject:@"Location"];
        [self.values addObject:location];
        
        if(self.pirep.rawOb!=nil)
        {
            [self.titles addObject:@"Raw Data"];
            [self.values addObject:self.pirep.rawOb];
        }
        
        if(self.pirep.obsTime!=nil)
        {
            [self.titles addObject:@"Observed Time"];
            NSInteger length = [self.pirep.obsTime length]-9;
            NSString * date = [self.pirep.obsTime substringFromIndex:length];
            date = [date substringToIndex:[date length]-1];
            [self.values addObject:[self.appDelegate convertToLocalTime:date]];
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
            [self.values addObject:[NSString stringWithFormat:@"%@ Kts",self.pirep.wspd]];
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
            self.icaoId = self.userPirep.lisenceNum;
            //[self.titles addObject:@"License Number"];
            //[self.values addObject:self.userPirep.lisenceNum];
        }
        else
            self.icaoId = @"Unknown";
        
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

//Set number of sections to 1.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//Set number of rows depending upon the number of properties valid for this PIREP.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

//Configure each cell by setting the name of the property to text label and the information contained in the property to detail text label.
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

//If the current row contains raw data, display height pertaining to it, else display normal cell height.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row == 1) {
        return RAWDATA_CELL_HEIGHT;
    }
    
    return CELL_HEIGHT;
}

//Set the height for the section header.
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTIONHEADER_HEIGHT;
}

//Configure a view for the section header and display the id of the station in the header.
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 50)];
    sectionHeader.backgroundColor = self.appDelegate.awcColor;
    
    UILabel * sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    sectionTitle.text = self.icaoId;
    sectionTitle.textColor = [UIColor whiteColor];
    sectionTitle.textAlignment = NSTextAlignmentCenter;
    
    [sectionHeader addSubview:sectionTitle];
    sectionTitle.center = sectionHeader.center;
    
    return sectionHeader;
}

@end
