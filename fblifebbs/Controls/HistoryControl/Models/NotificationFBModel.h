//
//  NotificationFBModel.h
//  fblifebbs
//
//  Created by soulnear on 14-10-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationFBModel : NSObject
{
    
}

@property(nonatomic,strong)NSString * fb_oatype;
@property(nonatomic,strong)NSString * fb_atype;
@property(nonatomic,strong)NSString * fb_actid;
///事件id
@property(nonatomic,strong)NSString * fb_id;
///事件时间
@property(nonatomic,strong)NSString * fb_time;
@property(nonatomic,strong)NSString * fb_status;
///事件内容
@property(nonatomic,strong)NSString * fb_content;
///用户uid
@property(nonatomic,strong)NSString * fb_uid;
///小头像
@property(nonatomic,strong)NSString * fb_face_small;
///大头像
@property(nonatomic,strong)NSString * fb_face_orifinal;



-(id)initWithDic:(NSDictionary *)dic;





@end
