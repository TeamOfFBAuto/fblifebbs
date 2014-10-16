//
//  NotificationBBSModel.m
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "NotificationBBSModel.h"

@implementation NotificationBBSModel


-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    
    return self;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUdefineKey ----  %@",key);
}


@end
