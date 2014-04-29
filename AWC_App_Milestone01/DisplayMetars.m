//
//  tableOfAnnotationViewController.m
//  Metars
//
//  Created by Manoor,Vidhatri on 11/11/13.
//  Copyright (c) 2013 Vidhatri. All rights reserved.
//

#import "DisplayMetars.h"
#import "Metar.h"
#import "AWCAppDelegate.h"

#define CELL_HEIGHT 45
#define RAWDATACELL_HEIGHT 90
#define SECTIONHEADER_HEIGHT 50

@interface DisplayMetars ()

@property Metar * myMetar;
@property NSMutableArray * key;
@property NSMutableArray * value;
@property AWCAppDelegate * appDelegate;
@property NSString * metarId;

@end

@implementation DisplayMetars

- (id)initWithStyle:(UITableViewStyle)style incomingMetar : (Metar *)newMetar
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.myMetar = newMetar;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.key = [[NSMutableArray alloc]init];
    self.value = [[NSMutableArray alloc]init];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    if(self.myMetar.idType!=nil)
    {
        self.metarId = self.myMetar.idType;
//        [self.key addObject:@"Id"];
//        [self.value addObject:self.myMetar.idType];
        
    }
    else
        self.myMetar.idType = @"Unknown";
    
    if(self.myMetar.site!=nil)
    {
        [self.key addObject:@"Site"];
        [self.value addObject:self.myMetar.site];
        
    }
    
//    if(![self.myMetar.state isEqualToString:@"--"])
//    {
//        [self.key addObject:@"State : "];
//        [self.value addObject:self.myMetar.state];
//        
//    }
    if(self.myMetar.obsTime!=nil)
    {
        [self.key addObject:@"Observed Time"];
        NSInteger length = [self.myMetar.obsTime length]-9;
        NSString * date = [self.myMetar.obsTime substringFromIndex:length];
        date = [date substringToIndex:[date length]-1];
        [self.value addObject:[self.appDelegate convertToLocalTime:date]];
        
    }
    
    if(self.myMetar.prior!=nil)
    {
        [self.key addObject:@"Prior"];
        [self.value addObject:self.myMetar.prior];
        
    }
    
    if(self.myMetar.rawOb!=nil)
    {
        [self.key addObject:@"Raw Data"];
        [self.value addObject:self.myMetar.rawOb];
        
    }
    
    if(self.myMetar.temp!=nil)
    {
        [self.key addObject:@"Temperature"];
        NSString * temp = [NSString stringWithFormat:@"%@°C",self.myMetar.temp];
        [self.value addObject:temp];
        
    }
    
    {
        [self.key addObject:@"Location"];
        NSString * coord  = [NSString stringWithFormat:@"%0.2fN %0.2fW",[self.myMetar.coordinatePoints[1] doubleValue],[self.myMetar.coordinatePoints[0] doubleValue]];
        [self.value addObject:coord];
    }
    
    if(self.myMetar.windspeed!=nil)
    {
        [self.key addObject:@"Wind Speed"];
        [self.value addObject:[NSString stringWithFormat:@"%@ Kts",self.myMetar.windspeed]];
        
    }
    if(self.myMetar.windDir!=nil)
    {
        double dir = [self.myMetar.windDir doubleValue];
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
        
        [self.key addObject:@"Wind Direction"];
        [self.value addObject:windDir];
        
    }
    
    if(self.myMetar.ceil!=nil)
    {
        [self.key addObject:@"Ceil"];
        [self.value addObject:self.myMetar.ceil];
        
    }
    
    if(self.myMetar.cover!=nil)
    {
        [self.key addObject:@"Cover"];
        [self.value addObject:self.myMetar.cover];
        
    }
    
    if(self.myMetar.visib!=nil)
    {
        [self.key addObject:@"Visib"];
        [self.value addObject:self.myMetar.visib];
        
    }
    
    if(self.myMetar.fltcat!=nil)
    {
        [self.key addObject:@"Fltcat"];
        [self.value addObject:self.myMetar.fltcat];
        
    }
    
    if(self.myMetar.wx!=nil)
    {
        [self.key addObject:@"WX"];
        [self.value addObject:self.myMetar.wx];
        
    }
    
    
    
    if(self.myMetar.slp!=nil)
    {
        [self.key addObject:@"Slp"];
        [self.value addObject:self.myMetar.slp];
        
    }
    
    if(self.myMetar.altim!=nil)
    {
        [self.key addObject:@"Altim"];
        [self.value addObject:self.myMetar.altim];
        
    }
    

    
    if(self.myMetar.dewp!=nil)
    {
        [self.key addObject:@"Dewp"];
        [self.value addObject:self.myMetar.dewp];
        
    }
    
    //if(self.myMetar.coordinatePoints!=nil)
    
    
    
    //NSLog(@"Values: %@",self.value);
    
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
    
    return [self.key count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    //NSLog(@"reached here");
//    NSLog(@"%@: %@",self.key[indexPath.row],self.value[indexPath.row]);

    //NSLog(@"Values = %@",self.value[indexPath.row]);
    cell.textLabel.text = self.key[indexPath.row];
    [cell.textLabel sizeToFit];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.value[indexPath.row]];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 4;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
        return RAWDATACELL_HEIGHT;
    return CELL_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTIONHEADER_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 50)];
    sectionHeader.backgroundColor = self.appDelegate.awcColor;
    
    UILabel * sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    sectionTitle.text = self.metarId;
    sectionTitle.textColor = [UIColor whiteColor];
    sectionTitle.textAlignment = NSTextAlignmentCenter;
    
    [sectionHeader addSubview:sectionTitle];
    sectionTitle.center = sectionHeader.center;
    
    return sectionHeader;
}

@end