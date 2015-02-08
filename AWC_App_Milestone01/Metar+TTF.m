//
//  Metar+TTF.m
//  GA Weather
//
//  Created by GA Weather App on 11/19/14.
//  Copyright (c) 2014 Syed Mazhar. All rights reserved.
//

#import "Metar+TTF.h"

@implementation Metar (TTF)

-(NSString*)ttfEquivalent:(NSString*)input{
    
    //For different Metars
        
        if([input isEqualToString:@"-DZ"]){
            return @"X";
        }
        if([input isEqualToString:@"-DZRA"]){
            return @"]";
        }
        if([input isEqualToString:@"-FZDZ"]){
            return @"[";
        }
        if([input isEqualToString:@"-FZRA"]){
            return @"b";
        }
        if([input isEqualToString:@"-GR"]){
            return @"u";
        }
        if([input isEqualToString:@"-GS"]){
            return @"s";
        }
        if([input isEqualToString:@"-RA"]){
            return @"_";
        }
        if([input isEqualToString:@"-RASN"]){
            return @"d";
        }
        if([input isEqualToString:@"-SH"]){
            return @"m";
        }
        if([input isEqualToString:@"-SHGR"]){
            return @"u";
        }
        if([input isEqualToString:@"-SHGS"]){
            return @"s";
        }
        if([input isEqualToString:@"-SHRA"]){
            return @"m";
        }
        if([input isEqualToString:@"-SHRASN"]){
            return @"o";
        }
        if([input isEqualToString:@"-SHSN"]){
            return @"q";
        }
        if([input isEqualToString:@"-SHSNRA"]){
            return @"o";
        }
        if([input isEqualToString:@"-SN"]){
            return @"f";
        }
        if([input isEqualToString:@"-TSRA"]){
            return @"w";
        }
        if([input isEqualToString:@"-TSSN"]){
            return @"w";
        }
        if([input isEqualToString:@"+DZ"]){
            return @"Z";
        }
        if([input isEqualToString:@"+FZDZ"]){
            return @"\\";
        }
        if([input isEqualToString:@"+FZRA"]){
            return @"c";
        }
        if([input isEqualToString:@"+GR"]){
            return @"v";
        }
        if([input isEqualToString:@"+GS"]){
            return @"t";
        }
        if([input isEqualToString:@"+RA"]){
            return @"a";
        }
        if([input isEqualToString:@"+SHGR"]){
            return @"v";
        }
        if([input isEqualToString:@"+SHGS"]){
            return @"t";
        }
        if([input isEqualToString:@"+SHRA"]){
            return @"n";
        }
        if([input isEqualToString:@"+SHRASN"]){
            return @"p";
        }
        if([input isEqualToString:@"+SHSN"]){
            return @"r";
        }
        if([input isEqualToString:@"+SHSNRA"]){
            return @"p";
        }
        if([input isEqualToString:@"+SN"]){
            return @"h";
        }
        if([input isEqualToString:@"+SS"]){
            return @"P";
        }
        if([input isEqualToString:@"+TSGR"]){
            return @"z";
        }
        if([input isEqualToString:@"+TSGRRA"]){
            return @"z";
        }
        if([input isEqualToString:@"+TSGS"]){
            return @"z";
        }
        if([input isEqualToString:@"+TSRA"]){
            return @"y";
        }
        if([input isEqualToString:@"+TSSN"]){
            return @"y";
        }
        
        if([input isEqualToString:@"BCFG"]){
            return @"T";
        }
        if([input isEqualToString:@"BLSN"]){
            return @"Q";
        }
        if([input isEqualToString:@"BR"]){
            return @"G";
        }
        if([input isEqualToString:@"DRSN"]){
            return @"R";
        }
        if([input isEqualToString:@"DU"]){
            return @"D";
        }
        if([input isEqualToString:@"DZ"]){
            return @"Y";
        }
        if([input isEqualToString:@"DZRA"]){
            return @"^";
        }
        if([input isEqualToString:@"FC"]){
            return @"N";
        }
        if([input isEqualToString:@"FG"]){
            return @"V";
        }
        if([input isEqualToString:@"FU"]){
            return @"A";
        }
        if([input isEqualToString:@"FZDZ"]){
            return @"\\";
        }
        if([input isEqualToString:@"FZFG"]){
            return @"W";
        }
        if([input isEqualToString:@"FZRA"]){
            return @"c";
        }
        if([input isEqualToString:@"GR"]){
            return @"v";
        }
        if([input isEqualToString:@"GS"]){
            return @"t";
        }
        if([input isEqualToString:@"HZ"]){
            return @"B";
        }
        if([input isEqualToString:@"IC"]){
            return @"k";
        }
        if([input isEqualToString:@"MIFG"]){
            return @"H";
        }
        if([input isEqualToString:@"PE"]){
            return @"l";
        }
        if([input isEqualToString:@"PL"]){
            return @"l";
        }
        if([input isEqualToString:@"PO"]){
            return @"E";
        }
        if([input isEqualToString:@"PRFG"]){
            return @"H";
        }
        if([input isEqualToString:@"RA"]){
            return @"`";
        }
        if([input isEqualToString:@"RASN"]){
            return @"e";
        }
        
        if([input isEqualToString:@"SA"]){
            return @"C";
        }
        if([input isEqualToString:@"SG"]){
            return @"j";
        }
        if([input isEqualToString:@"SH"]){
            return @"n";
        }
        if([input isEqualToString:@"SHGR"]){
            return @"v";
        }
        if([input isEqualToString:@"SHGS"]){
            return @"t";
        }
        if([input isEqualToString:@"SHRA"]){
            return @"n";
        }
        if([input isEqualToString:@"SHRASN"]){
            return @"p";
        }
        if([input isEqualToString:@"SHSN"]){
            return @"r";
        }
        if([input isEqualToString:@"SHSNRA"]){
            return @"p";
        }
        if([input isEqualToString:@"SN"]){
            return @"g";
        }
        if([input isEqualToString:@"SQ"]){
            return @"M";
        }
        if([input isEqualToString:@"SS"]){
            return @"O";
        }
        if([input isEqualToString:@"TS"]){
            return @"L";
        }
        if([input isEqualToString:@"TSGR"]){
            return @"x";
        }
        if([input isEqualToString:@"TSGS"]){
            return @"x";
        }
        if([input isEqualToString:@"TSRA"]){
            return @"w";
        }
        if([input isEqualToString:@"TSSN"]){
            return @"w";
        }
        if([input isEqualToString:@"UP"]){
            return @"i";
        }
        if([input isEqualToString:@"VCFG"]){
            return @"S";
        }
        if([input isEqualToString:@"VCSH"]){
            return @"K";
        }
        if([input isEqualToString:@"VCSS"]){
            return @"F";
        }
        if([input isEqualToString:@"VCTS"]){
            return @"I";
        }
        if([input isEqualToString:@"VIRGA"]){
            return @"J";
        }
        else return @"asdf";
}

-(NSString*)ttfEquivalentWind:(int)speed{
    

    if(0<speed && speed<=5){
        return @"B";
    }
    if(5<speed && speed<=10){
        return @"C";
    }
    if(10<speed && speed<=15){
        return @"D";
    }
    if(15<speed && speed<=20){
        return @"E";
    }
    if(20<speed && speed<=25){
        return @"F";
    }
    if(25<speed && speed<=30){
        return @"G";
    }
    if(30<speed && speed<=35){
        return @"H";
    }
    if(35<speed && speed<=40){
        return @"I";
    }
    if(40<speed && speed<=45){
        return @"J";
    }
    if(45<speed && speed<=50){
        return @"K";
    }
    if(50<speed && speed<=55){
        return @"L";
    }
    if(55<speed && speed<=60){
        return @"M";
    }
    if(60<speed && speed<=65){
        return @"N";
    }
    if(65<speed && speed<=70){
        return @"O";
    }
    if(70<speed && speed<=75){
        return @"P";
    }
    if(75<speed && speed<=80){
        return @"Q";
    }
    if(80<speed && speed<=85){
        return @"R";
    }
    if(85<speed && speed<=90){
        return @"S";
    }
    if(90<speed && speed<=95){
        return @"T";
    }
    if(95<speed && speed<=100){
        return @"U";
    }
    if(100<speed && speed<=105){
        return @"V";
    }
    if(105<speed && speed<=110){
        return @"W";
    }
    if(110<speed && speed<=115){
        return @"X";
    }
    if(115<speed && speed<=120){
        return @"Y";
    }
    if(120<speed && speed<=125){
        return @"Z";
    }
    if(125<speed && speed<=130){
        return @"[";
    }
    if(130<speed && speed<=135){
        return @"\\";
    }
    if(135<speed && speed<=140){
        return @"]";
    }
    if(140<speed && speed<=145){
        return @"^";
    }
    else return @"_";
}
@end