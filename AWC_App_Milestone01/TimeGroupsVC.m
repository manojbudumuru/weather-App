//
//  TimeGroupsVC.m
//  NWMSU_AWC_App
//
//  Created by Satish Kumar Baswapuram on 4/28/14.
//  Copyright (c) 2014 Satish Kumar Baswapuram. All rights reserved.
//

#import "TimeGroupsVC.h"
#import "AWCAppDelegate.h"

@interface TimeGroupsVC ()

@property AWCAppDelegate * appDelegate;

@end

@implementation TimeGroupsVC

//Initialize the appDelegate and the timegroups array.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    self.timeGroups = [[NSMutableArray alloc]initWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Set the number of sections to 1.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//Set the number of rows to the size of the timegroups array.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.timeGroups.count;
}

//Each is displayed with a timegroup number ranging from 0 to 7.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeGroup"];
    
    if(cell==nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeGroup"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Time Group: %@",self.timeGroups[indexPath.row]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//When an unselected timegroup is selected, trigger the delegate method to add this timegroup to the list of enabled timegroups.
//When a selected timegroup is selected, trigger the delegate method to remove this timegroup from the list of enabled timegroups.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"TimeGroup: %@",self.timeGroups[indexPath.row]);
    
    UITableViewCell * selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if(selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.delegate selectedTimeGroup:self.timeGroups[indexPath.row]];
    }
    else
    {
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [self.delegate deselectedTimeGroup:self.timeGroups[indexPath.row]];
    }
    
}

@end