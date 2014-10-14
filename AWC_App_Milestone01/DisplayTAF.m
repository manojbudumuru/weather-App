//
//  DisplayTAF.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "DisplayTAF.h"
#import "AppDelegate.h"

#define CELL_HEIGHT 45
#define RAWDATACELL_HEIGHT 90
#define SECTIONHEADER_HEIGHT 50

@interface DisplayTAF ()

@property NSMutableArray * titles;
@property NSMutableArray * values;
@property AppDelegate * appDelegate;
@property NSString * tafId;

@end

@implementation DisplayTAF

//Initialize the TAF.
- (id)initWithStyle:(UITableViewStyle)style taf:(TAF *)tafObj
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.taf = tafObj;
    }
    return self;
}

//Initialize the titles and values arrays which display the properties of the TAF.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titles = [[NSMutableArray alloc]init];
    self.values = [[NSMutableArray alloc]init];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    if(self.taf.idType!=nil)
    {
        self.tafId = self.taf.idType;
        //[self.titles addObject:@"Id"];
        //[self.values addObject:self.taf.idType];
    }
    else
        self.tafId = @"Unknown";
    
    NSString * location = [NSString stringWithFormat:@"%0.2fN %0.2fW",[self.taf.coordinatePoints[1] doubleValue], [self.taf.coordinatePoints[0] doubleValue]];
    [self.titles addObject:@"Location"];
    [self.values addObject:location];
    
    if(self.taf.site!=nil)
    {
        [self.titles addObject:@"Site"];
        [self.values addObject:self.taf.site];
    }
    
    if(self.taf.rawTAF!=nil)
    {
        [self.titles addObject:@"Raw Data"];
        [self.values addObject:self.taf.rawTAF];
    }
    
    if(self.taf.issueTime!=nil)
    {
        [self.titles addObject:@"Issue Time"];
        NSInteger length = [self.taf.issueTime length]-9;
        
        NSString * date = [self.taf.issueTime substringToIndex:(length-1)];
        
        NSString * time = [self.taf.issueTime substringFromIndex:length];
        time = [time substringToIndex:[time length]-1];
        time = [self.appDelegate convertToLocalTime:time];
        
        NSString * info = [NSString stringWithFormat:@"%@ %@",date,time];
        
        [self.values addObject:info];
        
    }
    
    
    if(self.taf.validTimeFrom!=nil)
    {
        [self.titles addObject:@"Valid Time From"];
        NSInteger length = [self.taf.validTimeFrom length]-9;
        
        NSString * date = [self.taf.validTimeFrom substringToIndex:(length-1)];
        
        NSString * time = [self.taf.validTimeFrom substringFromIndex:length];
        time = [time substringToIndex:[time length]-1];
        time = [self.appDelegate convertToLocalTime:time];
        
        NSString * info = [NSString stringWithFormat:@"%@ %@",date,time];
        
        [self.values addObject:info];

    }
    
    if(self.taf.validTimeTo!=nil)
    {
        [self.titles addObject:@"Valid Time To"];
        NSInteger length = [self.taf.validTimeTo length]-9;
        
        NSString * date = [self.taf.validTimeTo substringToIndex:(length-1)];
        
        NSString * time = [self.taf.validTimeTo substringFromIndex:length];
        time = [time substringToIndex:[time length]-1];
        time = [self.appDelegate convertToLocalTime:time];
        
        NSString * info = [NSString stringWithFormat:@"%@ %@",date,time];
        
        [self.values addObject:info];

    }
    
    if(self.taf.validTime!=nil)
    {
        [self.titles addObject:@"Valid Time"];
        NSInteger length = [self.taf.validTime length]-9;
        
        NSString * time = [self.taf.validTime substringFromIndex:length];
        time = [time substringToIndex:[time length]-1];
        //time = [self.appDelegate convertToLocalTime:time];
        
        NSString * info = [NSString stringWithFormat:@"%@",time];
        
        [self.values addObject:info];

    }
    
    if(self.taf.timeGroup!=nil)
    {
        [self.titles addObject:@"Time Group"];
        [self.values addObject:self.taf.timeGroup];
    }
    
    if(self.taf.fcstType!=nil)
    {
        [self.titles addObject:@"Forecast Type"];
        [self.values addObject:self.taf.fcstType];
    }
    
    if(self.taf.wspd!=nil)
    {
        [self.titles addObject:@"Wind Speed"];
        [self.values addObject:[NSString stringWithFormat:@"%@ Kts",self.taf.wspd]];
    }
    
    if(self.taf.wdir!=nil)
    {
        [self.titles addObject:@"Wind Direction"];
        
        double dir = [self.taf.wdir doubleValue];
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
    
    if(self.taf.visib!=nil)
    {
        [self.titles addObject:@"Visib"];
        [self.values addObject:self.taf.visib];
    }
    
    if(self.taf.cover!=nil)
    {
        [self.titles addObject:@"Cover"];
        [self.values addObject:self.taf.cover];
    }
    
    if(self.taf.fltcat!=nil)
    {
        [self.titles addObject:@"Fltcat"];
        [self.values addObject:self.taf.fltcat];
    }
    
    
        

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Set number of sections to 1.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//Set number of rows depending upon the number of properties valid for this TAF.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.titles count];
}

//Configure each cell by setting the name of the property to text label and the information contained in the property to detail text label.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.titles[indexPath.row];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.values[indexPath.row]];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 4;
    
    
    return cell;
}

//If the current row contains raw data, display height pertaining to it, else display normal cell height.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2)
        return RAWDATACELL_HEIGHT;
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
    sectionTitle.text = self.tafId;
    sectionTitle.textColor = [UIColor whiteColor];
    sectionTitle.textAlignment = NSTextAlignmentCenter;
    
    [sectionHeader addSubview:sectionTitle];
    sectionTitle.center = sectionHeader.center;
    
    return sectionHeader;
}

@end
