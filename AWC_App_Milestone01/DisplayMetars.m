//
//  tableOfAnnotationViewController.m
//  Metars
//
//  Created by Manoor,Vidhatri on 11/11/13.
//  Copyright (c) 2013 Vidhatri. All rights reserved.
//

#import "DisplayMetars.h"
#import "Metar.h"


@interface DisplayMetars ()

@property Metar * myMetar;
@property NSMutableArray * key;
@property NSMutableArray * value;

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
    
    if(self.myMetar.idType!=nil)
    {
        [self.key addObject:@"Id"];
        [self.value addObject:self.myMetar.idType];
        
    }
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
        [self.value addObject:date];
        
    }
    
    if(self.myMetar.prior!=nil)
    {
        [self.key addObject:@"Prior"];
        [self.value addObject:self.myMetar.prior];
        
    }
    
    if(self.myMetar.rawOb!=nil)
    {
        [self.key addObject:@"RawOb"];
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
        [self.value addObject:self.myMetar.windspeed];
        
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
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
    if(indexPath.row == 4)
        return 76;
    return 40;
}

@end