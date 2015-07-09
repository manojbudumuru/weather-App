//
//  GridView.m
//  GA Weather
//
//  Created by adsbout on 4/1/15.
//  Copyright (c) 2015 Manoj Budumuru. All rights reserved.
//

#import "GridView.h"

@implementation GridView

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    NSLog(@"Rendering at (x,y):(%f,%f) with size (w,h):(%f,%f) zoom %f",mapRect.origin.x,mapRect.origin.y,mapRect.size.width,mapRect.size.height,zoomScale);
    CGRect rect = [self rectForMapRect:mapRect];
    //NSLog(@"CGRect: %@",NSStringFromCGRect(rect));
    
    MKTileOverlayPath path;
    MKTileOverlay *tileOverlay = (MKTileOverlay *)self.overlay;
    path.x = mapRect.origin.x*zoomScale/tileOverlay.tileSize.width;
    path.y = mapRect.origin.y*zoomScale/tileOverlay.tileSize.width;
    path.z = log2(zoomScale)+20;
    double q=2;
    long level=(pow(q, path.z))-1;
    NSLog(@"level=%ld",level);
    //CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 1.0/zoomScale);
    //CGContextStrokeRect(context, rect);
    UIGraphicsPushContext(context);
    NSDate *date=[NSDate date];
    NSDateFormatter *dateForm1=[[NSDateFormatter alloc]init];
    [dateForm1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateForm1 setDateFormat:@"YYYYMMddHHmmss"];
    NSString *dateString = [dateForm1 stringFromDate:date];
   // NSString *text = [NSString stringWithFormat:@"X=%ld\nY=%ld\nZ=%ld",(long)path.x,level-((long)path.y),(long)path.z];
//    [text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0/zoomScale],
//                                           NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSString *urldata=[NSString stringWithFormat:@"http://www.aviationweather.gov/gis/scripts/tc.php?product=rad_rala&date=%@&x=%ld&y=%ld&z=%ld",dateString,(long)path.x,level-((long)path.y),(long)path.z];
    NSURL *data=[NSURL URLWithString:urldata];
    NSData * url=[NSData dataWithContentsOfURL:data];
    
    
    UIImage *image = [[UIImage alloc] initWithData:url];//UIGraphicsGetImageFromCurrentImageContext();
    [image drawInRect:rect];
    
    
    UIGraphicsPopContext();
    

    
}


@end
