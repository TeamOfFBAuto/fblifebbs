//
//  ChangshiModel.m
//  car361
//
//  Created by szk on 14-10-16.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "ChangshiModel.h"

@implementation ChangshiModel


/*
 
 
 */


-(ChangshiModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        
        self.fid=[NSString stringWithFormat:@"%@",[dic objectForKey:@"fid"]];
        
        self.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        self.issub=[NSString stringWithFormat:@"%@",[dic objectForKey:@"issub"]];
        self.postcount=[NSString stringWithFormat:@"%@",[dic objectForKey:@"postcount"]];
        self.icon=[NSString stringWithFormat:@"%@",[dic objectForKey:@"icon"]];
        

    }
    
    return self;
}




@end
