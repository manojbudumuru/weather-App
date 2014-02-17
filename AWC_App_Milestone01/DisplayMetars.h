//
//  tableOfAnnotationViewController.h
//  Metars
//
//  Created by Manoor,Vidhatri on 11/11/13.
//  Copyright (c) 2013 Vidhatri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Metar.h"

@interface DisplayMetars : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style incomingMetar:(Metar *)newMetar;

@end