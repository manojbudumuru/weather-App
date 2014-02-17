//
//  DisplayTAF.m
//  AWC_App_Milestone01
//
//  Created by SATISH KUMAR BASWAPURAM on 12/2/13.
//  Copyright (c) 2013 Satish Kumar Baswapuram. All rights reserved.
//

#import "DisplayTAF.h"

@interface DisplayTAF ()

@property NSMutableArray * titles;
@property NSMutableArray * values;

@end

@implementation DisplayTAF

- (id)initWithStyle:(UITableViewStyle)style taf:(TAF *)tafObj
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.taf = tafObj;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titles = [[NSMutableArray alloc]init];
    self.values = [[NSMutableArray alloc]init];
    
    if(self.taf.idType!=nil)
    {
        [self.titles addObject:@"Id"];
        [self.values addObject:self.taf.idType];
    }
    
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
        [self.titles addObject:@"Raw TAF"];
        [self.values addObject:self.taf.rawTAF];
    }
    
    if(self.taf.issueTime!=nil)
    {
        [self.titles addObject:@"Issue Time"];
        NSInteger length = [self.taf.issueTime length]-9;
        
        NSString * date = [self.taf.issueTime substringToIndex:(length-1)];
        
        NSString * time = [self.taf.issueTime substringFromIndex:length];
        time = [time substringToIndex:[time length]-1];
        
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
        
        NSString * info = [NSString stringWithFormat:@"%@ %@",date,time];
        
        [self.values addObject:info];

    }
    
    if(self.taf.validTime!=nil)
    {
        [self.titles addObject:@"Valid Time"];
        NSInteger length = [self.taf.validTime length]-9;
        
        NSString * time = [self.taf.validTime substringFromIndex:length];
        time = [time substringToIndex:[time length]-1];
        
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
        [self.values addObject:self.taf.wspd];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.titles[indexPath.row];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.values[indexPath.row]];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 4;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
        return 90;
    return 40;
}

@end
