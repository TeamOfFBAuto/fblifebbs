//
//  BBSInfoModel.m
//  fblifebbs
//
//  Created by soulnear on 15-2-9.
//  Copyright (c) 2015年 szk. All rights reserved.
//

#import "BBSInfoModel.h"

@implementation BBSInfoModel


-(void)setRegdate:(NSString *)regdate{
    _regdate = [zsnApi dateFromString:@"yyyy-MM-dd HH:mm" WithDate:regdate];
}


-(void)setLastpost:(NSString *)lastpost
{
    _lastpost = [zsnApi dateFromString:@"yyyy-MM-dd HH:mm" WithDate:lastpost];
}

-(void)setLastvisit:(NSString *)lastvisit
{
    _lastvisit = [zsnApi dateFromString:@"yyyy-MM-dd HH:mm" WithDate:lastvisit];
}

-(void)setGender:(NSString *)gender
{

    
    if ([gender intValue] == 0) {
        _gender = @"保密";
    }else if ([gender intValue] == 1)
    {
        _gender = @"男";
    }else if ([gender intValue] == 2)
    {
        _gender = @"女";
    }
}

-(void)setField_3:(NSString *)field_3
{
    if ([field_3 intValue] == 1) {
        _field_3 = @"学生";
    }else if ([field_3 intValue] == 2)
    {
        _field_3 = @"职员";
    }else if ([field_3 intValue] == 3)
    {
        _field_3 = @"经理";
    }else if ([field_3 intValue] == 4)
    {
        _field_3 = @"专业人士";
    }else if ([field_3 intValue] == 5)
    {
        _field_3 = @"公务员";
    }else if ([field_3 intValue] == 6)
    {
        _field_3 = @"私营主";
    }else if ([field_3 intValue] == 7)
    {
        _field_3 = @"待业";
    }else if ([field_3 intValue] == 8)
    {
        _field_3 = @"退休";
    }else if ([field_3 intValue] == 9)
    {
        _field_3 = @"其他";
    }
}

-(void)setField_4:(NSString *)field_4
{
    if ([field_4 intValue] == 1) {
        _field_4 = @"已婚";
    }else if ([field_4 intValue] == 2) {
        _field_4 = @"未婚";
    }
}



@end











