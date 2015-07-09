//
//  Grid.m
//  GA Weather
//
//  Created by adsbout on 4/1/15.
//  Copyright (c) 2015 Manoj Budumuru. All rights reserved.
//

#import "Grid.h"

@implementation Grid
    -(void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *, NSError *))result {
        
        
        
        //radar tile data.....
        NSDate *date=[NSDate date];
        NSDateFormatter *dateForm1=[[NSDateFormatter alloc]init];
        [dateForm1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateForm1 setDateFormat:@"YYYYMMddHHmmss"];
        NSString *dateString = [dateForm1 stringFromDate:date];
        NSString *urldata=[NSString stringWithFormat:@"http://www.aviationweather.gov/gis/scripts/tc.php?product=rad_rala&date=%@&x=%ld&y=%ld&z=%ld",dateString,(long)path.x,(long)path.y,(long)path.z];
        NSURL *data=[NSURL URLWithString:urldata];
        NSData * url=[NSData dataWithContentsOfURL:data];
        //tile drawing....
        CGSize sz = self.tileSize;
        CGRect rect = CGRectMake(0, 0, sz.width, sz.height);
        UIGraphicsBeginImageContext(sz);
       // CGContextRef ctx = UIGraphicsGetCurrentContext();
        //[[UIColor blackColor] setStroke];
        //CGContextSetLineWidth(ctx,1.0);
       // CGContextStrokeRect(ctx,CGRectMake(0, 0, sz.width, sz.height));
        //NSString *text = [NSString stringWithFormat:@"X=%ld\nY=%ld\nZ=%ld",(long)path.x,(long)path.y,(long)path.z];
        //[text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],
         //                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        
        UIImage *image = [[UIImage alloc] initWithData:url];//UIGraphicsGetImageFromCurrentImageContext();
        [image drawInRect:rect];
        UIImage *tileImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *tileData = UIImagePNGRepresentation(tileImage);
        result(tileData,nil);

}

@end
